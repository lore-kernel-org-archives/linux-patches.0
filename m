Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB3F282F1F;
	Sat, 12 Sep 2026 15:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227586; cv=none; b=paihgLJgExwMUa3WC23yw+2Tf6busSRMWWuWinxw7XIHTMOOSnM2g6iGA9i77iay/oVm6jSIAk92e9YL8teALWDkuiPFeUrVfd7ZrsKvv0o6bjRzGHTRz1prv6yzrcnnm8Y31VnPb+GqW0Mrd1ZO7NWxrOhhZbces/cBI8PIHzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227586; c=relaxed/simple;
	bh=FTptnRdEQ6zOmEjQdy5JtvSvLQPoNmmiRA5J5jKXXZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REuRf0KJwsDRd3jP4cGWQRnhaPEpP14AUeBtfpfC9dC/xS+Ep/2HEGV8lQpzF86MIiVpzaWmr4MNUR5vOC2ttQ0CGIuENbTIhLxJ4gkrK1Httjsmpj7bzHSFY1KOZka9YQr2fyhO5ivXrqM110j2X7+8+Ob/s54A4mKLMjV/gpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXdcUdXU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXdcUdXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226F61F000FF;
	Sat, 12 Sep 2026 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227585;
	bh=+YADl1hdcekVtPP+mEQkh7SFcLKqFP2vBCBTxWs65LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXdcUdXUhaJvYqMIfh4FOVSDB9KLOqEa20qpgy0IC1D4Q6DxCUI3vzciny73a436n
	 niVsyZE7APwhqesfRCsj9+J5kiyIEEUSyEtYnIwTL5pCtnUt8NWiu79RhkkCvBoeNv
	 /au2/dKU1QXqnsLzGbFgg7f+gg1pmU4EdtXI0GYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0211/1191] NTB: ntb_transport: Reject oversized TX buffers
Date: Sat, 12 Sep 2026 08:48:59 +0200
Message-ID: <20260912065552.949308027@linuxfoundation.org>
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

commit a4f2387db6f1cc2f03abba7f3a6807ad61e26ff7 upstream.

ntb_process_tx() handles an oversized buffer by calling tx_handler()
with a NULL data pointer and returning success. ntb_netdev therefore
neither frees the skb in its completion callback nor takes its enqueue
error path, leaking it.

Reject oversized buffers in ntb_transport_tx_enqueue() before acquiring
a queue entry and return -EMSGSIZE. The caller retains ownership of the
buffer, and the preceding netdev patch frees the skb when enqueue
returns this permanent error.

Fixes: fce8a7bb5b4b ("PCI-Express Non-Transparent Bridge Support")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260817053519.4135287-5-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1924,15 +1924,6 @@ static int ntb_process_tx(struct ntb_tra
 		return -EAGAIN;
 	}
 
-	if (entry->len > qp->tx_max_frame - sizeof(struct ntb_payload_header)) {
-		if (qp->tx_handler)
-			qp->tx_handler(qp, qp->cb_data, NULL, -EIO);
-
-		ntb_list_add(&qp->ntb_tx_free_q_lock, &entry->entry,
-			     &qp->tx_free_q);
-		return 0;
-	}
-
 	ntb_async_tx(qp, entry);
 
 	qp->tx_index++;
@@ -2307,6 +2298,9 @@ int ntb_transport_tx_enqueue(struct ntb_
 	if (!qp->link_is_up)
 		return -ENOLINK;
 
+	if (len > qp->tx_max_frame - sizeof(struct ntb_payload_header))
+		return -EMSGSIZE;
+
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
 	if (!entry) {
 		qp->tx_err_no_buf++;


