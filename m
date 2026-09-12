Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B47039FCC5;
	Sat, 12 Sep 2026 18:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237045; cv=none; b=HVmJcE6IOaK0Mo1EvbACqigSjO1ZRpIZaNzuwwcpUc7kIerjz1N8gxPbi+ri0bvfuQigxsP5LeOjyT8qt7jXBXE+3IgT4f1bY95w/GV42YluOxoW5ocn+KzbuQ1QD9B4AIvxaWEt2sGYG7arIMdl3o6zgaN6lk5/U0EKm/5SfEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237045; c=relaxed/simple;
	bh=4TSsBdUfD7sfEy4cPa56pFyPzFJ+E/i6Ujilkec4jOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HB5pn1Bk1j+FNYu4a40ZjfnWMvJnjuqetNE902jTgv3gcSK0Z1UG47N3562YiGZaQO4xOJ51f96mbsY6cHfWFavtrI22tpeyUT5/ILN9GEgSDwVbqGZvCVMBZsPpROdFvQikgJpvGpQMEPGWFsF3k5QyHyLYag7BV4c/LX7Sr44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlTdE5hV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlTdE5hV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DC31F000FF;
	Sat, 12 Sep 2026 18:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237044;
	bh=saJ/gHy4jeUOHbJmQ1OlSGvxj9shf1iFQ9H2Mu0ffKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlTdE5hVXOm/bFN+xxgUp2pT1zEebRD++z5Y4CKNJ1BMJv1dTq2fXcSblvUuaLmjo
	 +IlzaVuXgfFPCxruu7ZwXdOsAONLPE5gQeSBZeht+TW7Fe+9P+bvM/O8/LZBW6aWzc
	 ruVCRY8P6YK0JeUG50zP5qD1C9marYdcl4IpuKto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 180/935] NTB: ntb_transport: Recycle TX entries before client callbacks
Date: Sat, 12 Sep 2026 08:53:30 +0200
Message-ID: <20260912065530.945935007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1732,9 +1732,16 @@ static void ntb_transport_rxc_db(unsigne
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
@@ -1774,15 +1781,13 @@ static void ntb_tx_copy_callback(void *d
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


