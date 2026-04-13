Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53648CA6F;
	Mon, 13 Apr 2026 16:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097860; cv=none; b=Y75/XmzHiv/bcavPWNCgZCeVYPsztJ8BIe3MvlCVlsbNknEUZEK1GcZ2zZ7exBcAkAciwnJX3gylFNfC1l4c0XYcXGz4tEk6lvwNh30qDluMS4s1v/fjxb5i6iTJ9iwhM281jIVeO9HP7MS6DmQNNhZGTTd/l2fj0rGfccEcIpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097860; c=relaxed/simple;
	bh=Edc3xuWi9D9cx0naaxFH6Pwq7wkxfIKgPEyYIn7d7dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDap1XhjcdOVrTS2YSZd8lPElvv3uX1RBxHPunMnLIUrmO0JYPGv5Ve63+pXsEEUVKsQvFjPankCiMvd6FSLaOqWKA405P5kCzG9kwx/Y6tjH1y1k0oBxcOEuAqdB2zTeVOgfMQHMcEozBhS+Nv7i1vLla5NPSLGuy4BuNiRvQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUa+wNkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUa+wNkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA2DC2BCAF;
	Mon, 13 Apr 2026 16:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097860;
	bh=Edc3xuWi9D9cx0naaxFH6Pwq7wkxfIKgPEyYIn7d7dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUa+wNknmWgh1a1Ja8PAfqvNN/MrTnqWti0SqvUPPIi3ssJLNDlVTSahJ8+nmX2TX
	 hBnZHaxhgxOIvC99fo11zNsN0GPlwzFqZhNQrxHy8+8eQX09DYh1aXo1GFSv4olc/f
	 4XfKxPRKFKRJ+oLFMbiq+AFnUuj2+GIXZMaRhDb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/570] net/smc: Only save the original clcsock callback functions
Date: Mon, 13 Apr 2026 17:56:39 +0200
Message-ID: <20260413155840.520238286@linuxfoundation.org>
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

[ Upstream commit 97b9af7a70936e331170c79040cc9bf20071b566 ]

Both listen and fallback process will save the current clcsock
callback functions and establish new ones. But if both of them
happen, the saved callback functions will be overwritten.

So this patch introduces some helpers to ensure that only save
the original callback functions of clcsock.

Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6d5e4538364b ("net/smc: fix NULL dereference and UAF in smc_tcp_syn_recv_sock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c    | 55 +++++++++++++++++++++++++++++----------------
 net/smc/smc.h       | 29 ++++++++++++++++++++++++
 net/smc/smc_close.c |  3 ++-
 3 files changed, 67 insertions(+), 20 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 2a642dfbc94a1..5c6759d2e271d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -300,6 +300,7 @@ static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
 	sk->sk_prot->hash(sk);
 	sk_refcnt_debug_inc(sk);
 	mutex_init(&smc->clcsock_release_lock);
+	smc_init_saved_callbacks(smc);
 
 	return sk;
 }
@@ -696,9 +697,24 @@ static void smc_fback_error_report(struct sock *clcsk)
 	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_error_report);
 }
 
+static void smc_fback_replace_callbacks(struct smc_sock *smc)
+{
+	struct sock *clcsk = smc->clcsock->sk;
+
+	clcsk->sk_user_data = (void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+
+	smc_clcsock_replace_cb(&clcsk->sk_state_change, smc_fback_state_change,
+			       &smc->clcsk_state_change);
+	smc_clcsock_replace_cb(&clcsk->sk_data_ready, smc_fback_data_ready,
+			       &smc->clcsk_data_ready);
+	smc_clcsock_replace_cb(&clcsk->sk_write_space, smc_fback_write_space,
+			       &smc->clcsk_write_space);
+	smc_clcsock_replace_cb(&clcsk->sk_error_report, smc_fback_error_report,
+			       &smc->clcsk_error_report);
+}
+
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
-	struct sock *clcsk;
 	int rc = 0;
 
 	mutex_lock(&smc->clcsock_release_lock);
@@ -706,10 +722,7 @@ static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		rc = -EBADF;
 		goto out;
 	}
-	clcsk = smc->clcsock->sk;
 
-	if (smc->use_fallback)
-		goto out;
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -723,18 +736,7 @@ static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		 * in smc sk->sk_wq and they should be woken up
 		 * as clcsock's wait queue is woken up.
 		 */
-		smc->clcsk_state_change = clcsk->sk_state_change;
-		smc->clcsk_data_ready = clcsk->sk_data_ready;
-		smc->clcsk_write_space = clcsk->sk_write_space;
-		smc->clcsk_error_report = clcsk->sk_error_report;
-
-		clcsk->sk_state_change = smc_fback_state_change;
-		clcsk->sk_data_ready = smc_fback_data_ready;
-		clcsk->sk_write_space = smc_fback_write_space;
-		clcsk->sk_error_report = smc_fback_error_report;
-
-		smc->clcsock->sk->sk_user_data =
-			(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+		smc_fback_replace_callbacks(smc);
 	}
 out:
 	mutex_unlock(&smc->clcsock_release_lock);
@@ -1388,6 +1390,19 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 	 * function; switch it back to the original sk_data_ready function
 	 */
 	new_clcsock->sk->sk_data_ready = lsmc->clcsk_data_ready;
+
+	/* if new clcsock has also inherited the fallback-specific callback
+	 * functions, switch them back to the original ones.
+	 */
+	if (lsmc->use_fallback) {
+		if (lsmc->clcsk_state_change)
+			new_clcsock->sk->sk_state_change = lsmc->clcsk_state_change;
+		if (lsmc->clcsk_write_space)
+			new_clcsock->sk->sk_write_space = lsmc->clcsk_write_space;
+		if (lsmc->clcsk_error_report)
+			new_clcsock->sk->sk_error_report = lsmc->clcsk_error_report;
+	}
+
 	(*new_smc)->clcsock = new_clcsock;
 out:
 	return rc;
@@ -2122,10 +2137,10 @@ static int smc_listen(struct socket *sock, int backlog)
 	/* save original sk_data_ready function and establish
 	 * smc-specific sk_data_ready function
 	 */
-	smc->clcsk_data_ready = smc->clcsock->sk->sk_data_ready;
-	smc->clcsock->sk->sk_data_ready = smc_clcsock_data_ready;
 	smc->clcsock->sk->sk_user_data =
 		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+	smc_clcsock_replace_cb(&smc->clcsock->sk->sk_data_ready,
+			       smc_clcsock_data_ready, &smc->clcsk_data_ready);
 
 	/* save original ops */
 	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
@@ -2137,7 +2152,9 @@ static int smc_listen(struct socket *sock, int backlog)
 
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
-		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
+		smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
+				       &smc->clcsk_data_ready);
+		smc->clcsock->sk->sk_user_data = NULL;
 		goto out;
 	}
 	sk->sk_max_ack_backlog = backlog;
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 1c00f1bba2cdb..268dc975249f8 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -269,12 +269,41 @@ static inline struct smc_sock *smc_sk(const struct sock *sk)
 	return (struct smc_sock *)sk;
 }
 
+static inline void smc_init_saved_callbacks(struct smc_sock *smc)
+{
+	smc->clcsk_state_change	= NULL;
+	smc->clcsk_data_ready	= NULL;
+	smc->clcsk_write_space	= NULL;
+	smc->clcsk_error_report	= NULL;
+}
+
 static inline struct smc_sock *smc_clcsock_user_data(const struct sock *clcsk)
 {
 	return (struct smc_sock *)
 	       ((uintptr_t)clcsk->sk_user_data & ~SK_USER_DATA_NOCOPY);
 }
 
+/* save target_cb in saved_cb, and replace target_cb with new_cb */
+static inline void smc_clcsock_replace_cb(void (**target_cb)(struct sock *),
+					  void (*new_cb)(struct sock *),
+					  void (**saved_cb)(struct sock *))
+{
+	/* only save once */
+	if (!*saved_cb)
+		*saved_cb = *target_cb;
+	*target_cb = new_cb;
+}
+
+/* restore target_cb to saved_cb, and reset saved_cb to NULL */
+static inline void smc_clcsock_restore_cb(void (**target_cb)(struct sock *),
+					  void (**saved_cb)(struct sock *))
+{
+	if (!*saved_cb)
+		return;
+	*target_cb = *saved_cb;
+	*saved_cb = NULL;
+}
+
 extern struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index bcd3ea894555d..42f9a7cf9e671 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -212,7 +212,8 @@ int smc_close_active(struct smc_sock *smc)
 		sk->sk_state = SMC_CLOSED;
 		sk->sk_state_change(sk); /* wake up accept */
 		if (smc->clcsock && smc->clcsock->sk) {
-			smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
+			smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
+					       &smc->clcsk_data_ready);
 			smc->clcsock->sk->sk_user_data = NULL;
 			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
 		}
-- 
2.51.0



