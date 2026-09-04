Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963363A9D9B;
	Fri,  4 Sep 2026 06:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501605; cv=none; b=pVJJR7dhK5OwfaJwknDI9dJPDBaANOSI1pikQlEMaGQmiGQRySF3EST5JkFmYuEWbJBNg/mO9R+T6Sd/3BMmdEBWRet00iS2CfY1rLo2YFDgEBztuDq1+4+UHanSw1TGfdGfMqBqb2jKJ27T2jR1kXWo9MhipUO34yYkiyj9bm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501605; c=relaxed/simple;
	bh=m6wLCXYP3zm6M4cwJy8RlauKH1a+nfzDN775VEUY19s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2QRMWnDkyndr82LkiQJYW7CV0iDxKMrBFBOYwsBUVE33weFFGZnRIc8tFerrOFJYBu72+XhaVNl1lW54a+/KNMsDrNlq9hKconDUROLzO86jsnPYoNcKGYIZrqhOHrsic0ge2pfdtIsryz/MoG0OOjzdj5oQqOatj8ek7+6va4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPd9P6au; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPd9P6au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F102B1F00A3D;
	Fri,  4 Sep 2026 06:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501604;
	bh=VoQbNDSkRBzMf6yXphRCp6Pemceed9wpQ0DiMk5Taqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPd9P6audqRvOhdpVSlftRwfR8mBepW35wIZ8h4153FDE5GxKO3b4BeZ+UJcqDh7U
	 Juq/BXl5P3GP2lwU79Vtxfz0a5IUXYFPsJjw70cFwk44WqI+cCJnWYJb9IxMRcLMSK
	 bXwk/FaNqTQk2uVQr3VKqiKEs9PyzeyH40VsGTLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 468/552] NTB: ntb_transport: Reject oversized TX buffers
Date: Fri,  4 Sep 2026 07:00:25 +0200
Message-ID: <20260904045801.304481885@linuxfoundation.org>
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
@@ -1935,15 +1935,6 @@ static int ntb_process_tx(struct ntb_tra
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
@@ -2318,6 +2309,9 @@ int ntb_transport_tx_enqueue(struct ntb_
 	if (!qp->link_is_up)
 		return -ENOLINK;
 
+	if (len > qp->tx_max_frame - sizeof(struct ntb_payload_header))
+		return -EMSGSIZE;
+
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
 	if (!entry) {
 		qp->tx_err_no_buf++;


