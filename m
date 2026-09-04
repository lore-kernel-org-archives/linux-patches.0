Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF2C4156F9;
	Fri,  4 Sep 2026 05:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501599; cv=none; b=qcDcb96R9rmJ+UBnEicQPgM6beLap7tMb8rtEcFh7SgLuL3jc/e9M7AdUYDq7JjW6uRiRMV9X3VHN998KSFCUedbkeMevqIqTJMV1V+wEiUBoOpWFvIsqCJr3ePFVXnHVpjiaExp4L7oTBhBO8qFPUrYo8+fZ16d8qVCdMdDiPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501599; c=relaxed/simple;
	bh=qxT4L2qVJIOXKSlZPwg4cb4XYsxt0lXER4xa+rekySE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRJ339lQJnR+iCT/2VFJElNhUOeM7My1J3ReJ8XBhmqon3GGOA1QUsd/LoiaQiGQH4scojzZl4K3/mMhDwjjHrVUDWlen8sLYHirz0sIEVIklYSsvm8uhW9DlCsWBGs/dQJVmDqU00laLQtWIex/tsoSHwQmisuHyDPUVikipbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wy2XF1wa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wy2XF1wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39541F00A3D;
	Fri,  4 Sep 2026 05:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501598;
	bh=2XK6x8nhn1vI/LRdxy96IZn5VZLr5Wq1fOMqQ1o8d6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wy2XF1waNe6kBuIKL1z4mU8m9oS72701AlBG38DL2G4h/bng8WWTCG5JrYHTI5HKw
	 9PkSXncWwFvdewK7OACMatoFLXKtKEIZqGS6aXrKgCGWaFk1xPDCTnsNGIVLAXfM4a
	 gI3TzGXglh7HhGBbcMAOeo06Gc8DRwvH+gzkwjMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 466/552] NTB: ntb_transport: Recycle TX entries before client callbacks
Date: Fri,  4 Sep 2026 07:00:23 +0200
Message-ID: <20260904045801.261822894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 256496397287334a19ed80ec7be92bffcae76b9d upstream.

ntb_tx_copy_callback() invokes the client callback before returning the
entry to tx_free_q. The callback may wake a stopped client queue, only
for the next enqueue to find no local entry and return -EBUSY. The window
is narrow, but the retry is unnecessary.

Save the callback data and length, then return the entry to tx_free_q
before invoking the client. A completion callback then means both the
client buffer and transport entry are ready for reuse.

Fixes: fce8a7bb5b4b ("PCI-Express Non-Transparent Bridge Support")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260817053519.4135287-2-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1755,9 +1755,16 @@ static void ntb_transport_rxc_db(unsigne
 static void ntb_tx_copy_callback(void *data,
 				 const struct dmaengine_result *res)
 {
+	struct ntb_payload_header __iomem *hdr;
 	struct ntb_queue_entry *entry = data;
-	struct ntb_transport_qp *qp = entry->qp;
-	struct ntb_payload_header __iomem *hdr = entry->tx_hdr;
+	struct ntb_transport_qp *qp;
+	unsigned int len;
+	void *cb_data;
+
+	qp = entry->qp;
+	hdr = entry->tx_hdr;
+	cb_data = entry->cb_data;
+	len = entry->len;
 
 	/* we need to check DMA results if we are using DMA */
 	if (res) {
@@ -1797,15 +1804,13 @@ static void ntb_tx_copy_callback(void *d
 	 * "link down" or similar.  Since no payload is being sent in these
 	 * cases, there is nothing to add to the completion queue.
 	 */
-	if (entry->len > 0) {
-		qp->tx_bytes += entry->len;
-
-		if (qp->tx_handler)
-			qp->tx_handler(qp, qp->cb_data, entry->cb_data,
-				       entry->len);
-	}
+	if (len > 0)
+		qp->tx_bytes += len;
 
 	ntb_list_add(&qp->ntb_tx_free_q_lock, &entry->entry, &qp->tx_free_q);
+
+	if (len > 0 && qp->tx_handler)
+		qp->tx_handler(qp, qp->cb_data, cb_data, len);
 }
 
 static void ntb_memcpy_tx(struct ntb_queue_entry *entry, void __iomem *offset)


