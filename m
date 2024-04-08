Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02EF7BAF5;
	Mon,  8 Apr 2024 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584742; cv=none; b=pt4/Xsxy4dSJm17cGgyBfD/cut/XVASBsBdHnUQpjYw5ryxOYMw8dwmWTJSUmRd/XgNenEp2AUPau8F/c8TkFjVO2vcLC2La/5cXD3rZshxfkzaPoTUMkRzv/wnZoAl8HPP7UfJxjSYsdZtENVFzKdB+Fh1gO0INbzA9zuLs0lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584742; c=relaxed/simple;
	bh=Sp2dheCy0dFLQ4W3sCaOkR5JMdlCt1TJl8UTIzD284I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbGv1R0XW2FQhbjOf9LofljicHoOSRbM4iSkoNzuB01WG121vfYh/r5iOMXlY+Q27kg018ObYQITXgF5/WNuQFs/5mYDpOcdAv8jDPn8uMspngcqwScD3oKfEtGsfWmOQj8No15JN+jFBX4ZGNJkQgMe7ioqvVkDbvwYGGI6Osc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFQUCbDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFQUCbDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67805C433F1;
	Mon,  8 Apr 2024 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584741;
	bh=Sp2dheCy0dFLQ4W3sCaOkR5JMdlCt1TJl8UTIzD284I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFQUCbDWG3a8tLS3KeUACQfPIAq0Fm2+vJ0pBmFV3cTNnj/f5Ym8YEMSApuBObpzJ
	 gcs3DvfdmZccfmiurZ9DQPTUTAyB2LwoofVUjY8XRJWE8+bKJGoB1mvwg7HauIDoCQ
	 sZkSVibP4Q9eMHH9/AuUbC1yNZVwIjvnlhPvgWwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	NeilBrown <neilb@suse.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 541/690] nfsd: fix double fget() bug in __write_ports_addfd()
Date: Mon,  8 Apr 2024 14:56:47 +0200
Message-ID: <20240408125419.255856728@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c034203b6a9dae6751ef4371c18cb77983e30c28 ]

The bug here is that you cannot rely on getting the same socket
from multiple calls to fget() because userspace can influence
that.  This is a kind of double fetch bug.

The fix is to delete the svc_alien_sock() function and instead do
the checking inside the svc_addsock() function.

Fixes: 3064639423c4 ("nfsd: check passed socket's net matches NFSd superblock's one")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: NeilBrown <neilb@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsctl.c               |  7 +------
 include/linux/sunrpc/svcsock.h |  7 +++----
 net/sunrpc/svcsock.c           | 24 ++++++------------------
 3 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index c2577ee7ffb22..76a60e7a75097 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -714,16 +714,11 @@ static ssize_t __write_ports_addfd(char *buf, struct net *net, const struct cred
 	if (err != 0 || fd < 0)
 		return -EINVAL;
 
-	if (svc_alien_sock(net, fd)) {
-		printk(KERN_ERR "%s: socket net is different to NFSd's one\n", __func__);
-		return -EINVAL;
-	}
-
 	err = nfsd_create_serv(net);
 	if (err != 0)
 		return err;
 
-	err = svc_addsock(nn->nfsd_serv, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
+	err = svc_addsock(nn->nfsd_serv, net, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
 
 	if (err >= 0 &&
 	    !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
diff --git a/include/linux/sunrpc/svcsock.h b/include/linux/sunrpc/svcsock.h
index bcc555c7ae9c6..13aff355d5a13 100644
--- a/include/linux/sunrpc/svcsock.h
+++ b/include/linux/sunrpc/svcsock.h
@@ -59,10 +59,9 @@ int		svc_recv(struct svc_rqst *, long);
 int		svc_send(struct svc_rqst *);
 void		svc_drop(struct svc_rqst *);
 void		svc_sock_update_bufs(struct svc_serv *serv);
-bool		svc_alien_sock(struct net *net, int fd);
-int		svc_addsock(struct svc_serv *serv, const int fd,
-					char *name_return, const size_t len,
-					const struct cred *cred);
+int		svc_addsock(struct svc_serv *serv, struct net *net,
+			    const int fd, char *name_return, const size_t len,
+			    const struct cred *cred);
 void		svc_init_xprt_sock(void);
 void		svc_cleanup_xprt_sock(void);
 struct svc_xprt *svc_sock_create(struct svc_serv *serv, int prot);
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index be7081284a098..112236dd72901 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1334,25 +1334,10 @@ static struct svc_sock *svc_setup_socket(struct svc_serv *serv,
 	return svsk;
 }
 
-bool svc_alien_sock(struct net *net, int fd)
-{
-	int err;
-	struct socket *sock = sockfd_lookup(fd, &err);
-	bool ret = false;
-
-	if (!sock)
-		goto out;
-	if (sock_net(sock->sk) != net)
-		ret = true;
-	sockfd_put(sock);
-out:
-	return ret;
-}
-EXPORT_SYMBOL_GPL(svc_alien_sock);
-
 /**
  * svc_addsock - add a listener socket to an RPC service
  * @serv: pointer to RPC service to which to add a new listener
+ * @net: caller's network namespace
  * @fd: file descriptor of the new listener
  * @name_return: pointer to buffer to fill in with name of listener
  * @len: size of the buffer
@@ -1362,8 +1347,8 @@ EXPORT_SYMBOL_GPL(svc_alien_sock);
  * Name is terminated with '\n'.  On error, returns a negative errno
  * value.
  */
-int svc_addsock(struct svc_serv *serv, const int fd, char *name_return,
-		const size_t len, const struct cred *cred)
+int svc_addsock(struct svc_serv *serv, struct net *net, const int fd,
+		char *name_return, const size_t len, const struct cred *cred)
 {
 	int err = 0;
 	struct socket *so = sockfd_lookup(fd, &err);
@@ -1374,6 +1359,9 @@ int svc_addsock(struct svc_serv *serv, const int fd, char *name_return,
 
 	if (!so)
 		return err;
+	err = -EINVAL;
+	if (sock_net(so->sk) != net)
+		goto out;
 	err = -EAFNOSUPPORT;
 	if ((so->sk->sk_family != PF_INET) && (so->sk->sk_family != PF_INET6))
 		goto out;
-- 
2.43.0



