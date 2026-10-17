Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57402DF126;
	Sat, 17 Oct 2026 17:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258986; cv=none; b=ldO7i8W4vMLlirOjxH9+UxE3RHeUNgZBNKBBr1H2VJimd+AL+aUj23v9Ui5Meg01dI4vdJjePpIZycXRj6KEZ/OusZrN4UVPugYA+Yi+BAALNqo4Hmx4qo9g7ZOnN0ziykUBAQyvn6UCnCpIoh6fXzkmdExdMkbfbXy0h2lwQfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258986; c=relaxed/simple;
	bh=gtbg2Y35vrCJwu/lGHMKE0xpgWqBUNvfmjGHWHs0uw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQ6eras+bs+XnbaPzIxTIXt96/kbftGKyDmjt4QKHqp6NRLadORwInQ/w4PE04jqujszJLtQMTV13hBAzYD39mz6N6ihoN8CwqHP/A1HJXGjmCFF2etJZH/B5XqM2Qhvb5KTGcgW0YFpLhD699V6cZ/dZAwPBH+PX/hkAZF/uNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLhvoBVY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLhvoBVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AE81F000C4;
	Sat, 17 Oct 2026 17:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258985;
	bh=drc34hV3CyR4Y6DcIlXsKmKead/qonfTCpoU3s/JCto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLhvoBVYkXNSnEuq3vJGbNbC1/JxnuWoCZNblFnVWi6SiarQWQpP8FnniyuUAB2zv
	 e7NCHft+DosrdsUsuxjgyu+2lEXQeIQOw0yA8n8C+xIfzAshbvbls1qIwhknbMUMdC
	 BoZieeQYyyGb6NewrabS4mMxlcM3nmBEcr9N6vLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1023/1674] l2tp: pppol2tp: hold reference to session in pppol2tp_ioctl()
Date: Sat, 17 Oct 2026 17:54:55 +0200
Message-ID: <20261017160457.391144729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit a213a8950414c684999dcf03edeea6c46ede172e ]

pppol2tp_ioctl() read sock->sk->sk_user_data directly without any
locks or reference counting.  If a controllable sleep was induced during
copy_from_user() (e.g. via a userfaultfd page fault sleep), a concurrent
socket close could trigger pppol2tp_session_close() asynchronously.  This
frees the l2tp_session structure via the l2tp_session_del_work workqueue.
Upon resuming, the ioctl thread dereferences the stale session pointer,
resulting in a Use-After-Free (UAF).

Fix this by securely fetching the session reference using the RCU-safe,
refcounted helper pppol2tp_sock_to_session(sk) on entry.  This locks the
session's refcount across the sleep.  We structured the function to exit
via standard err breaks, guaranteeing that l2tp_session_put() is cleanly
called on all return paths to drop the reference.

To preserve existing behavior we validate the session and its magic
signature only for the specific L2TP commands that require it.  This
ensures that generic/unknown ioctls called on an unconnected socket
still return -ENOIOCTLCMD and correctly fall back to generic handlers
(e.g. in sock_do_ioctl()).

Signed-off-by: Lee Jones <lee@kernel.org>
Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Link: https://patch.msgid.link/20260527133630.2120612-1-lee@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_ppp.c | 82 +++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 32 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 1573edb66ee35..230b1b156465a 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1056,64 +1056,76 @@ static int pppol2tp_ioctl(struct socket *sock, unsigned int cmd,
 {
 	struct pppol2tp_ioc_stats stats;
 	struct l2tp_session *session;
+	int err = 0;
+
+	session = pppol2tp_sock_to_session(sock->sk);
 
+	/* Validate session presence and magic integrity ONLY for commands
+	 * that belong to L2TP and require a valid session.
+	 */
 	switch (cmd) {
 	case PPPIOCGMRU:
 	case PPPIOCGFLAGS:
-		session = sock->sk->sk_user_data;
+	case PPPIOCSMRU:
+	case PPPIOCSFLAGS:
+	case PPPIOCGL2TPSTATS:
 		if (!session)
 			return -ENOTCONN;
 
-		if (WARN_ON(session->magic != L2TP_SESSION_MAGIC))
+		if (session->magic != L2TP_SESSION_MAGIC) {
+			sock_put(sock->sk);
 			return -EBADF;
+		}
+		break;
+	default:
+		break;
+	}
 
+	switch (cmd) {
+	case PPPIOCGMRU:
+	case PPPIOCGFLAGS:
 		/* Not defined for tunnels */
-		if (!session->session_id && !session->peer_session_id)
-			return -ENOSYS;
+		if (!session->session_id && !session->peer_session_id) {
+			err = -ENOSYS;
+			break;
+		}
 
-		if (put_user(0, (int __user *)arg))
-			return -EFAULT;
+		if (put_user(0, (int __user *)arg)) {
+			err = -EFAULT;
+			break;
+		}
 		break;
 
 	case PPPIOCSMRU:
 	case PPPIOCSFLAGS:
-		session = sock->sk->sk_user_data;
-		if (!session)
-			return -ENOTCONN;
-
-		if (WARN_ON(session->magic != L2TP_SESSION_MAGIC))
-			return -EBADF;
-
 		/* Not defined for tunnels */
-		if (!session->session_id && !session->peer_session_id)
-			return -ENOSYS;
+		if (!session->session_id && !session->peer_session_id) {
+			err = -ENOSYS;
+			break;
+		}
 
-		if (!access_ok((int __user *)arg, sizeof(int)))
-			return -EFAULT;
+		if (!access_ok((int __user *)arg, sizeof(int))) {
+			err = -EFAULT;
+			break;
+		}
 		break;
 
 	case PPPIOCGL2TPSTATS:
-		session = sock->sk->sk_user_data;
-		if (!session)
-			return -ENOTCONN;
-
-		if (WARN_ON(session->magic != L2TP_SESSION_MAGIC))
-			return -EBADF;
-
 		/* Session 0 represents the parent tunnel */
 		if (!session->session_id && !session->peer_session_id) {
 			u32 session_id;
-			int err;
 
 			if (copy_from_user(&stats, (void __user *)arg,
-					   sizeof(stats)))
-				return -EFAULT;
+					   sizeof(stats))) {
+				err = -EFAULT;
+				break;
+			}
 
 			session_id = stats.session_id;
 			err = pppol2tp_tunnel_copy_stats(&stats,
 							 session->tunnel);
 			if (err < 0)
-				return err;
+				break;
 
 			stats.session_id = session_id;
 		} else {
@@ -1123,15 +1135,21 @@ static int pppol2tp_ioctl(struct socket *sock, unsigned int cmd,
 		stats.tunnel_id = session->tunnel->tunnel_id;
 		stats.using_ipsec = l2tp_tunnel_uses_xfrm(session->tunnel);
 
-		if (copy_to_user((void __user *)arg, &stats, sizeof(stats)))
-			return -EFAULT;
+		if (copy_to_user((void __user *)arg, &stats, sizeof(stats))) {
+			err = -EFAULT;
+			break;
+		}
 		break;
 
 	default:
-		return -ENOIOCTLCMD;
+		err = -ENOIOCTLCMD;
+		break;
 	}
 
-	return 0;
+	if (session)
+		sock_put(sock->sk);
+
+	return err;
 }
 
 /*****************************************************************************
-- 
2.53.0



