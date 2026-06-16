Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9778D45107A;
	Tue, 16 Jun 2026 15:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624796; cv=none; b=Dlx11h0r8rHuyAwy5U79i7gWdDBHaRm4s8O/fGlYavbE5kwH1QPy3RTRYYvDzi9pKPJJNZiI/Wrc9NFoYJuN7HhQzoPjfWG8tO6Q9JKwwVE37t37WOqwWSA8jJVBFvRtP5Kru0DSR1lZxprYmAaBVvMA+FGNWy7a+NWES2sONbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624796; c=relaxed/simple;
	bh=AsYgbmtz1Z+9FPUIKNScMDTEmA31Bb0oScDlu/oAE7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Om+TaV0hWgqtWKTyUKIWzrjCfdQCMM9hvtleXrgpe8UF5Jk3EduzxBiOH64MGf4IJJsGAhFZ2UfpZnG2qb7wGdYis2rH66iIrnmEJPFdqpznfasuUKe9V7RIJno/S0uUt6PI4+vOfqIKfmd0fnIqyYS6wbazEp9PAum/vc4rAGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiMvQZF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiMvQZF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCF31F000E9;
	Tue, 16 Jun 2026 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624793;
	bh=0oF3t8rkrcIYkSlQQJPThEwXl5lwCBOyEFgJ0SuVbtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wiMvQZF8XjF8kF6SY8vfTOEFnK4Yv27ezPWnArkrxmyTi7uLASSlAIoRlA61sBAQg
	 9KhtFbOGNXlTDTSOeyqqmWWXw+3OUsTHOV0toq3u65js/t+CHHyH3POi+XSXIli2YX
	 pngRLWelaRnC49cZYF1GV7PFDeWHmAhKDGaOe2wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/325] l2tp: pppol2tp: hold reference to session in pppol2tp_ioctl()
Date: Tue, 16 Jun 2026 20:27:06 +0530
Message-ID: <20260616145059.260463258@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
index 5e12e7ce17d8a7..f388bf9abf378d 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1044,64 +1044,76 @@ static int pppol2tp_ioctl(struct socket *sock, unsigned int cmd,
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
+			l2tp_session_put(session);
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
@@ -1111,15 +1123,21 @@ static int pppol2tp_ioctl(struct socket *sock, unsigned int cmd,
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
+		l2tp_session_put(session);
+
+	return err;
 }
 
 /*****************************************************************************
-- 
2.53.0



