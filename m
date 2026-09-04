Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0363B19BC;
	Fri,  4 Sep 2026 05:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499997; cv=none; b=rDYX+73jRknTO1ZzefGKZ/KMHj2/Y3TJpp4FnkIyPQdBjjJhHq5zCp8XSzizBBE2WDSYFQbMqxNaHZHr6yB8Faj3qaRhkRD6aO9mCO7lG9qmtPw+gTXC6LZ4YWTppuWImmJq7dsJFy0df2J2IeMwoeU9QjB0J3jFCAuujB5Gry4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499997; c=relaxed/simple;
	bh=A3d+KNjdwZT6xpWvzC7VXBEeyOQYxFOFgsjhw+7VnH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbRKHP6RhaCsbz+VHcbgzeHj2U4C5sCBZQ83pF52w8NG338dypee+F+FXLjA4pNewrMYyy4lEOokfqXu+JK+Ot4cDRDlCNw3aWFgYLt4yet7BWWokVhKMSEtfb6snb/o1//ewLRZqDARxcR4bjM2RGaDfRY6XhC6trsDuiUcC/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPYpWPSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPYpWPSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EAC1F00A3D;
	Fri,  4 Sep 2026 05:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499996;
	bh=gpPwx+JDUxsjoJ5SE/2CNLVv9Opur58QVwhoSHz51WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPYpWPSU7Dv+MGB90PGFd7TvjnPtqauUfZM2zhPUPQ/utrtdHZbDf9VCezm0UHt6z
	 Qxfeh8/RJQjlsCvT2psraRDbzAQdF41NHngHCpGzL/N3HzdYxPKW1ErL/7Kvxnf9dY
	 bDTZeP8AVQYEhXD7sdg4jQ9DuoOKb4ZUDz/cvfNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 614/713] NTB: ntb_transport: Reject oversized TX buffers
Date: Fri,  4 Sep 2026 06:59:42 +0200
Message-ID: <20260904045817.591149793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1955,15 +1955,6 @@ static int ntb_process_tx(struct ntb_tra
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
 
 	qp->tx_pkts++;
@@ -2356,6 +2347,9 @@ int ntb_transport_tx_enqueue(struct ntb_
 	if (!qp->link_is_up)
 		return -ENOLINK;
 
+	if (len > qp->tx_max_frame - sizeof(struct ntb_payload_header))
+		return -EMSGSIZE;
+
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
 	if (!entry) {
 		qp->tx_err_no_buf++;


