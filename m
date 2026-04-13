Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35A3226D18;
	Mon, 13 Apr 2026 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097863; cv=none; b=ltq8sy/eH+ON4v/0uCXfQD+MswBfkigf2VHdhaSYXldQSX723xxwdmwqdFUVvv/c90PHnG3E8y9RfkBkKsjW345DWb/hUwxhxtAIUN38y902f6XGB1Nho9Umz5KKH/i9Ip+pt2YLMnUVL5z4bFqf/S9u7GX+jxhhh1eyNt7ooG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097863; c=relaxed/simple;
	bh=0GKs8B6u10t+hSABOE0fOnm+fKfNkJ0m+8mWzyzB7IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoLLXN3Tcf0btEbgMkD+jfdEoDOyP1ish9bEeolIwjwzc0ERdbep/eNt17DbAgaF3UhwlaYnllM+a9qQoW+EGSKZZwV2uv1FUyvzQiscdGF5NrQKlP2++DJRmE4Gt1pkrU/qUYwYMWdpY0tNcNK7pwbkbvI7jAcTG/h9XZuzYG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCEsf74U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCEsf74U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FD7C2BCAF;
	Mon, 13 Apr 2026 16:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097862;
	bh=0GKs8B6u10t+hSABOE0fOnm+fKfNkJ0m+8mWzyzB7IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCEsf74UoXuOeG75+O8vwRDMMmIGuDFT32o4dV3ab/5HWTCl4yc3htVBXDCV3KApB
	 AcQ3xc15c90v9Y2vt6jo/G16z3vvCRS4pBEQgmAHK11Bp11VxM1YF7ZxnZfMuLpTfx
	 //CBPn1S4cqf7+ffCzOXytGtEHccRoVnFl7wNCg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b425899ed22c6943e00b@syzkaller.appspotmail.com,
	Wen Gu <guwen@linux.alibaba.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/570] net/smc: Fix slab-out-of-bounds issue in fallback
Date: Mon, 13 Apr 2026 17:56:40 +0200
Message-ID: <20260413155840.557172392@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 0558226cebee256aa3f8ec0cc5a800a10bf120a6 ]

syzbot reported a slab-out-of-bounds/use-after-free issue,
which was caused by accessing an already freed smc sock in
fallback-specific callback functions of clcsock.

This patch fixes the issue by restoring fallback-specific
callback functions to original ones and resetting clcsock
sk_user_data to NULL before freeing smc sock.

Meanwhile, this patch introduces sk_callback_lock to make
the access and assignment to sk_user_data mutually exclusive.

Reported-by: syzbot+b425899ed22c6943e00b@syzkaller.appspotmail.com
Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
Link: https://lore.kernel.org/r/00000000000013ca8105d7ae3ada@google.com/
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6d5e4538364b ("net/smc: fix NULL dereference and UAF in smc_tcp_syn_recv_sock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c    | 80 ++++++++++++++++++++++++++++++++-------------
 net/smc/smc_close.c |  2 ++
 2 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 5c6759d2e271d..ea1a185327629 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -170,11 +170,27 @@ struct proto smc_proto6 = {
 };
 EXPORT_SYMBOL_GPL(smc_proto6);
 
+static void smc_fback_restore_callbacks(struct smc_sock *smc)
+{
+	struct sock *clcsk = smc->clcsock->sk;
+
+	write_lock_bh(&clcsk->sk_callback_lock);
+	clcsk->sk_user_data = NULL;
+
+	smc_clcsock_restore_cb(&clcsk->sk_state_change, &smc->clcsk_state_change);
+	smc_clcsock_restore_cb(&clcsk->sk_data_ready, &smc->clcsk_data_ready);
+	smc_clcsock_restore_cb(&clcsk->sk_write_space, &smc->clcsk_write_space);
+	smc_clcsock_restore_cb(&clcsk->sk_error_report, &smc->clcsk_error_report);
+
+	write_unlock_bh(&clcsk->sk_callback_lock);
+}
+
 static void smc_restore_fallback_changes(struct smc_sock *smc)
 {
 	if (smc->clcsock->file) { /* non-accepted sockets have no file yet */
 		smc->clcsock->file->private_data = smc->sk.sk_socket;
 		smc->clcsock->file = NULL;
+		smc_fback_restore_callbacks(smc);
 	}
 }
 
@@ -659,48 +675,57 @@ static void smc_fback_forward_wakeup(struct smc_sock *smc, struct sock *clcsk,
 
 static void smc_fback_state_change(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_state_change);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_state_change);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_data_ready(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_data_ready);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_data_ready);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_write_space(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_write_space);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_write_space);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_error_report(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_error_report);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_error_report);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_replace_callbacks(struct smc_sock *smc)
 {
 	struct sock *clcsk = smc->clcsock->sk;
 
+	write_lock_bh(&clcsk->sk_callback_lock);
 	clcsk->sk_user_data = (void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 
 	smc_clcsock_replace_cb(&clcsk->sk_state_change, smc_fback_state_change,
@@ -711,6 +736,8 @@ static void smc_fback_replace_callbacks(struct smc_sock *smc)
 			       &smc->clcsk_write_space);
 	smc_clcsock_replace_cb(&clcsk->sk_error_report, smc_fback_error_report,
 			       &smc->clcsk_error_report);
+
+	write_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
@@ -2095,17 +2122,20 @@ static void smc_tcp_listen_work(struct work_struct *work)
 
 static void smc_clcsock_data_ready(struct sock *listen_clcsock)
 {
-	struct smc_sock *lsmc =
-		smc_clcsock_user_data(listen_clcsock);
+	struct smc_sock *lsmc;
 
+	read_lock_bh(&listen_clcsock->sk_callback_lock);
+	lsmc = smc_clcsock_user_data(listen_clcsock);
 	if (!lsmc)
-		return;
+		goto out;
 	lsmc->clcsk_data_ready(listen_clcsock);
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
 		if (!queue_work(smc_hs_wq, &lsmc->tcp_listen_work))
 			sock_put(&lsmc->sk);
 	}
+out:
+	read_unlock_bh(&listen_clcsock->sk_callback_lock);
 }
 
 static int smc_listen(struct socket *sock, int backlog)
@@ -2137,10 +2167,12 @@ static int smc_listen(struct socket *sock, int backlog)
 	/* save original sk_data_ready function and establish
 	 * smc-specific sk_data_ready function
 	 */
+	write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 	smc->clcsock->sk->sk_user_data =
 		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	smc_clcsock_replace_cb(&smc->clcsock->sk->sk_data_ready,
 			       smc_clcsock_data_ready, &smc->clcsk_data_ready);
+	write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 
 	/* save original ops */
 	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
@@ -2152,9 +2184,11 @@ static int smc_listen(struct socket *sock, int backlog)
 
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
+		write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 		smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
 				       &smc->clcsk_data_ready);
 		smc->clcsock->sk->sk_user_data = NULL;
+		write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 		goto out;
 	}
 	sk->sk_max_ack_backlog = backlog;
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 42f9a7cf9e671..313ef522dfab4 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -212,9 +212,11 @@ int smc_close_active(struct smc_sock *smc)
 		sk->sk_state = SMC_CLOSED;
 		sk->sk_state_change(sk); /* wake up accept */
 		if (smc->clcsock && smc->clcsock->sk) {
+			write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 			smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
 					       &smc->clcsk_data_ready);
 			smc->clcsock->sk->sk_user_data = NULL;
+			write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
 		}
 		smc_close_cleanup_listen(sk);
-- 
2.51.0



