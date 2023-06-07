Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4157F34D8D
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE951C433D2;
	Wed,  7 Jun 2023 20:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169382;
	bh=YE+BKBf3nfvwzcQqvRIalIl0CinM4yQthfmhPMmqpvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0+i0RlQBWxxVnTvkBuTtxIQxZmSxTMvY15U6Wh/dYzvICYDRtj4xdt5SUcLXuKv/
	 7rnyNFhzNNGUom5FV0P0dRkNuzh7PDuDkU373DB9w3Z9A7MVs1RO98mcsAX/3FxT0M
	 TIhZzNNVQv+3RpjwpHKNLoYGFSFrKmiMps3p6IvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	NeilBrown <neilb@suse.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 059/286] nfsd: fix double fget() bug in __write_ports_addfd()
Date: Wed,  7 Jun 2023 22:12:38 +0200
Message-ID: <20230607200924.999750735@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index 7b8f17ee52243..ba07757f3cd0a 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -702,16 +702,11 @@ static ssize_t __write_ports_addfd(char *buf, struct net *net, const struct cred
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
index bf2d2cdca1185..e2a94589dd5df 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1340,25 +1340,10 @@ static struct svc_sock *svc_setup_socket(struct svc_serv *serv,
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
@@ -1368,8 +1353,8 @@ EXPORT_SYMBOL_GPL(svc_alien_sock);
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
@@ -1380,6 +1365,9 @@ int svc_addsock(struct svc_serv *serv, const int fd, char *name_return,
 
 	if (!so)
 		return err;
+	err = -EINVAL;
+	if (sock_net(so->sk) != net)
+		goto out;
 	err = -EAFNOSUPPORT;
 	if ((so->sk->sk_family != PF_INET) && (so->sk->sk_family != PF_INET6))
 		goto out;
-- 
2.39.2



