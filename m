Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215116;
	b=QdSBqlcqBBqpfZOC93Y9ZnYo4ib+rmkVOsKhK3aAR/I3PnFYYC9U4XtbHfMbu1+QlM/M
	 8KaefeP02zIBNgC5XldQNc6ASh/+Pg0ak/3Z7IaVVzrL8YWN3cFDNgrm6MdK03743aUUb
	 duHCGSE2Ey82e5PrsjzudKw4KSZ1Z+4nRAHGCty2eq8OZKJED56XI7jkxaQjT+VzYkmdr
	 GeqdcAgt0LwKsVnVBvvuDsAznIhF94QctMVHc10xdotdI6RYj5yDsHr1LRsU67E+0uPKM
	 Ew4S3+ibs5ZAR1qL3qzeaGt88yXCaJ8qyJJRs9f/F8LPB0pXyGkHPQffdlb1bzM8o1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/DGdDlHDyYyo+vmJc7qPFZ06Py8FBW1y1Np3NDRC+fk=;
	b=Ft7An3Q+vAtjYxn0iKjbYnSgKDStt3O6NIPQbVJHTWIlZODX0amxzYCGIHq9By2UZS/g
	 UTyj4FXYGQYje821QkrBYg7KilatlHJgIWWSGqpNOh7F4HPuGUsIZLz6en3t23VHE1fIK
	 fxf8uVMx1AI1rt1FqZDvaV26121pUg/f0SbFb3E0ejH3hfrCRpECrd3DVm50cYuPXAsyd
	 h48RSkrpcBIKmvhU3GPD3a5WWcg/ysd8CG18IjtK/O8BuJpOId8cGgCKhykheF+g22Ake
	 C9v8a+SfJcOgHz/1utlvgG3Q8G1ixeq1bukqyoGThd2gZp4bwJznw0GOe/BP6ZYWCsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McCU5Z8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA8A606A31A;
	Wed, 28 Oct 2026 19:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McCU5Z8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F3A1F01825;
	Wed, 28 Oct 2026 19:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215116;
	bh=/DGdDlHDyYyo+vmJc7qPFZ06Py8FBW1y1Np3NDRC+fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McCU5Z8p+jOAWFdtq6FfBA5+wlb7OKU9tBc3yGuikAbivbsyHg2+DgQNCJFR61beg
	 FAJJ+ngJfk0NaZfS0m95vJbqxnq7oKZmy4DX++mvqbzPTF3QhDqlNbMyvN6nOyuAbE
	 o9j5/nS9G9fz0O/FnqoAUdwmVU9aGyeqrQCZhuGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1099/1887] l2tp: pppol2tp: hold reference to session in pppol2tp_ioctl()
Date: Wed, 28 Oct 2026 17:53:15 +0100
Message-ID: <20261028170524.413983851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



