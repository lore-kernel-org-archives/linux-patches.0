Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161DF282F1F;
	Sat, 12 Sep 2026 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227571; cv=none; b=gugT1/N2HVTiN02OE5LNLgfMfK1YZwGa241YFFRK1FfrePgmja73RTUKWs1Cvyaw/EJs/kfIRfcSnQixkf5hK7DjSc+1TuUDeWoWyg2LG2jveyAMA77r808BYHHFYyDUI5KQpXJgSGc7tzJBCsa1D24sOr0vYqFLnXeRfauovYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227571; c=relaxed/simple;
	bh=sDfTMODw/HqQ7HpGnbhh+zvN0xz0AGxWHiAxcZ1gmLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqZy5Qd97qpeszYiqy74IlKrD0kElRUHfOcgzVaaUZ8ymgB+w+EaczX/Wn6/GjshsIYDNNr0wpNoFE/mE/BeUoxt/4r65UWwBecJfMZN3PHTrQBCpSipchUIPNl8uQfV2ZyE7OTnVBfKZzT3bzs0rDdLuywjCf8jG9nWTJy2QfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGslkDp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGslkDp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBF01F00893;
	Sat, 12 Sep 2026 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227569;
	bh=anK6QHvt7aUn73LFzz7aiRpvajWBu4xWWcyRVLI5CWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGslkDp37KCGhHaDsNsUXFktGjtlSZ/lFaXDr1a6o6esgfaKSp36CTto+yH9j/b23
	 /9bAkUyZ15sBGQi4Eib/VZa8kOXM0AxumgRND5Ikd0rjaHMoE6/Mf2rTWS0ZfP1URN
	 86XVQxRP5Fda57h6lN9X95HmvGEi7vAEfWdM8N6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0209/1191] NTB: ntb_transport: Recycle TX entries before client callbacks
Date: Sat, 12 Sep 2026 08:48:57 +0200
Message-ID: <20260912065552.905063336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1745,9 +1745,16 @@ static void ntb_transport_rxc_db(unsigne
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
@@ -1787,15 +1794,13 @@ static void ntb_tx_copy_callback(void *d
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


