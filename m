Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973B23B19DB;
	Sat, 12 Sep 2026 18:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237055; cv=none; b=kA8JHDPTUYQama+pMAxZ/pao+7y4IpORf5xTsTNO8hDbhHESh3LA+Y28cv+7sJYKZE8+YrdqaraMayticW7ZTASsXrOUP1UPxB4BgdWnqqPifAx1VX2Udn2Wslf3Uxvjj8G+sbuw75k6DQZWfJLUcczIvFKVxHUq68nQ7+FQAzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237055; c=relaxed/simple;
	bh=1GdUWeByDa2ggRy4wm5va/SE8wtIDzBfZe1EYVVb84I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KK0XFUmUEjJtDhBNPwrmMkt5INaS1+Z4rChnfwHxBs7Ucb3HCtwnTfqZdKwUe9/zmr5nmpORWeeCGYOYTFRcFDbt5AhIqwytnrFcEjU/yAyR39ziBBi5pVSEOZ7CCGd0wreMEvMzTRveYGzad1lZgW4U2spI9w0p/T4p2DRnyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iE+pCuh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iE+pCuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506CD1F000FF;
	Sat, 12 Sep 2026 18:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237054;
	bh=822F55IU5aggpryonqqLyPU1d9ANANqaolSmDGqW3+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iE+pCuhNAqtAoM5RvTnPrao5lldwgHoSwioJcKmtu7BMJK8hR/crp+PdIST+iu27
	 7oDjNUiFRXGoWQud5pvLuAVq/lZqGFY3222y6gm7cgyQG9lAZyeVPOG23OmqMXufEa
	 XXV4gEmZ3zq5UFvWXd2yvsZR5jyjwduka7mE2C88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 182/935] NTB: ntb_transport: Reject oversized TX buffers
Date: Sat, 12 Sep 2026 08:53:32 +0200
Message-ID: <20260912065530.991506559@linuxfoundation.org>
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
@@ -1911,15 +1911,6 @@ static int ntb_process_tx(struct ntb_tra
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
@@ -2294,6 +2285,9 @@ int ntb_transport_tx_enqueue(struct ntb_
 	if (!qp->link_is_up)
 		return -ENOLINK;
 
+	if (len > qp->tx_max_frame - sizeof(struct ntb_payload_header))
+		return -EMSGSIZE;
+
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
 	if (!entry) {
 		qp->tx_err_no_buf++;


