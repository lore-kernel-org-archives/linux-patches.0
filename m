Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1004015A857;
	Tue, 18 Jun 2024 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716819; cv=none; b=ZHakujh8rTTp45hjB5AgTmqkx7gVuTP87EhlHHc7MR2f7I0PAHICz2JGWATNVTjy16apynFyVGCF8R04q4RsY11YzgU6+81XZerQDqeGy1OkF/2AbgmyHjZL1qd60NZG15gS+lh0POe1DO2LyYpMjA3amO2nzEaI/GDRAXgueTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716819; c=relaxed/simple;
	bh=f8K1Cay6kGM6owBH/E/uk/GOEPGXfTJLcIvEruOghYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZGDcogtsyb+5sdu7sph84x3B6mNFqq3vrLKfZcmnXt+NqMOTR0UlrpMqIetDuwZNnwB3mP2ejS8pzEq0pGW9zgSDkL6mzdJ5eB6jukXuYv1icnYB3Wp0fiN/+sphZGDRukgDfdkVG28XCHbTe30UNE1J5iapddEt6lwefRtNAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flyOSg6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flyOSg6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D252C4AF1D;
	Tue, 18 Jun 2024 13:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716818;
	bh=f8K1Cay6kGM6owBH/E/uk/GOEPGXfTJLcIvEruOghYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flyOSg6tsSMK1DiEeLSI2gMFJDaZuUSZPolp5XDEQY3sXfgBhqVaaa9ta9AOk8kNi
	 sIwiMq3RsNBDdR+MmzLSPHaw1bHjIO3pidtuKhzVd2+LFltqiNrfPEjBExUtRhUm6w
	 o9cLzh9Xe+2Tg8LNEY0JMODoLdA5+rbMverUJSUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	NeilBrown <neilb@suse.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 756/770] nfsd: fix double fget() bug in __write_ports_addfd()
Date: Tue, 18 Jun 2024 14:40:09 +0200
Message-ID: <20240618123436.449639511@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index b7ac7fe683067..a366d3eb05315 100644
--- a/include/linux/sunrpc/svcsock.h
+++ b/include/linux/sunrpc/svcsock.h
@@ -57,10 +57,9 @@ int		svc_recv(struct svc_rqst *, long);
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
index 90f6231d6ed67..cb0cfcd8a8141 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1342,25 +1342,10 @@ static struct svc_sock *svc_setup_socket(struct svc_serv *serv,
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
@@ -1370,8 +1355,8 @@ EXPORT_SYMBOL_GPL(svc_alien_sock);
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
@@ -1382,6 +1367,9 @@ int svc_addsock(struct svc_serv *serv, const int fd, char *name_return,
 
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



