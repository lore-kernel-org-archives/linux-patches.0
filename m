Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B50F2253AE;
	Mon, 18 Aug 2025 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523126; cv=none; b=dWTfXZns/sss+vc0v0ko5ImMdsRJol5qjeP5nwCfiCoziTEnbYUqIGIliLqDIBZ4irI64+YP187yuDomSM0BPW9Y5FIYelbT/7w14EojA7CSLmoPun9sSX+k6D+U+7lQwyUn2qzyixuX4/ErdYBBPvuCIqheSt1OejgDJr9iVNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523126; c=relaxed/simple;
	bh=TvISiNH7RFqs9W+a0/7L7gGO81xCb7qpluJKew7lJ2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBz/44CQYetcEnpws7YvMZshLxtKAKgRxAbJsE+Gt18UfVshtWyIaJ8WOLbvXJNS/jX7cYYeOm+asOB/WIoZ3QxIbAPAzytLtD9/sKfpSx92JB3QCir4HcTtkY2Y0+JJwAsTw4iC539JnMtgQ3GjScQIxl4g9VWgqq3fPmhEba8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAz5NuWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAz5NuWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00C6C4CEEB;
	Mon, 18 Aug 2025 13:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523126;
	bh=TvISiNH7RFqs9W+a0/7L7gGO81xCb7qpluJKew7lJ2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAz5NuWJNfj2Vp7qkTAH7u9QJGKLr2ZCkeBE830hQ28Ihl7BLe/6E4D41WJlYU9AX
	 LlSHM/6+FEjAYo2LRfYObBjSJ5SrxuUN/KzaSGorDWS9VbrDB7+uMpOKuvwEPH1IJp
	 xzeynx3LnQxWZlzWHPDyK+Gou6W6p0PyTehT1XOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e62c9db591c30e174662@syzkaller.appspotmail.com,
	syzbot+d199b52665b6c3069b94@syzkaller.appspotmail.com,
	syzbot+be6b1fdfeae512726b4e@syzkaller.appspotmail.com,
	Sven Stegemann <sven@stegemann.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 077/515] net: kcm: Fix race condition in kcm_unattach()
Date: Mon, 18 Aug 2025 14:41:03 +0200
Message-ID: <20250818124501.346670351@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Stegemann <sven@stegemann.de>

[ Upstream commit 52565a935213cd6a8662ddb8efe5b4219343a25d ]

syzbot found a race condition when kcm_unattach(psock)
and kcm_release(kcm) are executed at the same time.

kcm_unattach() is missing a check of the flag
kcm->tx_stopped before calling queue_work().

If the kcm has a reserved psock, kcm_unattach() might get executed
between cancel_work_sync() and unreserve_psock() in kcm_release(),
requeuing kcm->tx_work right before kcm gets freed in kcm_done().

Remove kcm->tx_stopped and replace it by the less
error-prone disable_work_sync().

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Reported-by: syzbot+e62c9db591c30e174662@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e62c9db591c30e174662
Reported-by: syzbot+d199b52665b6c3069b94@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d199b52665b6c3069b94
Reported-by: syzbot+be6b1fdfeae512726b4e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=be6b1fdfeae512726b4e
Signed-off-by: Sven Stegemann <sven@stegemann.de>
Link: https://patch.msgid.link/20250812191810.27777-1-sven@stegemann.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/kcm.h |  1 -
 net/kcm/kcmsock.c | 10 ++--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/net/kcm.h b/include/net/kcm.h
index 441e993be634..d9c35e71ecea 100644
--- a/include/net/kcm.h
+++ b/include/net/kcm.h
@@ -71,7 +71,6 @@ struct kcm_sock {
 	struct list_head wait_psock_list;
 	struct sk_buff *seq_skb;
 	struct mutex tx_mutex;
-	u32 tx_stopped : 1;
 
 	/* Don't use bit fields here, these are set under different locks */
 	bool tx_wait;
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 24aec295a51c..8c0577cd764f 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -429,7 +429,7 @@ static void psock_write_space(struct sock *sk)
 
 	/* Check if the socket is reserved so someone is waiting for sending. */
 	kcm = psock->tx_kcm;
-	if (kcm && !unlikely(kcm->tx_stopped))
+	if (kcm)
 		queue_work(kcm_wq, &kcm->tx_work);
 
 	spin_unlock_bh(&mux->lock);
@@ -1688,12 +1688,6 @@ static int kcm_release(struct socket *sock)
 	 */
 	__skb_queue_purge(&sk->sk_write_queue);
 
-	/* Set tx_stopped. This is checked when psock is bound to a kcm and we
-	 * get a writespace callback. This prevents further work being queued
-	 * from the callback (unbinding the psock occurs after canceling work.
-	 */
-	kcm->tx_stopped = 1;
-
 	release_sock(sk);
 
 	spin_lock_bh(&mux->lock);
@@ -1709,7 +1703,7 @@ static int kcm_release(struct socket *sock)
 	/* Cancel work. After this point there should be no outside references
 	 * to the kcm socket.
 	 */
-	cancel_work_sync(&kcm->tx_work);
+	disable_work_sync(&kcm->tx_work);
 
 	lock_sock(sk);
 	psock = kcm->tx_psock;
-- 
2.50.1



