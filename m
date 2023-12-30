Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B3F79C2;
	Sat, 30 Dec 2023 12:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/qm8vL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A18C433C7;
	Sat, 30 Dec 2023 12:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937948;
	bh=chiuZF5Zh9OeEqcN6RoT0PWxdUuFMMu8JkX0b8j5MKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/qm8vL0veFQhqcnqq8kxi68R6/jPRYmyFagGZxHSE9ssb+XNc7Y5fJ5CUS+i5DkE
	 5ZyBRJgGuKQ66Xa6AlaQPq/8FDDcbXpYsya/6v2HRPrKSIZGMN5lp0CacQj42mVLHJ
	 V6/AU9OpoR/+tcySoZFCM3QanrJIorSAl/7vNCk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 124/156] nfsd: call nfsd_last_thread() before final nfsd_put()
Date: Sat, 30 Dec 2023 11:59:38 +0000
Message-ID: <20231230115816.427046313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 2a501f55cd641eb4d3c16a2eab0d678693fac663 upstream.

If write_ports_addfd or write_ports_addxprt fail, they call nfsd_put()
without calling nfsd_last_thread().  This leaves nn->nfsd_serv pointing
to a structure that has been freed.

So remove 'static' from nfsd_last_thread() and call it when the
nfsd_serv is about to be destroyed.

Fixes: ec52361df99b ("SUNRPC: stop using ->sv_nrthreads as a refcount")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    9 +++++++--
 fs/nfsd/nfsd.h   |    1 +
 fs/nfsd/nfssvc.c |    2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -704,8 +704,10 @@ static ssize_t __write_ports_addfd(char
 
 	err = svc_addsock(nn->nfsd_serv, net, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
 
-	if (err >= 0 &&
-	    !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
+	if (err < 0 && !nn->nfsd_serv->sv_nrthreads && !nn->keep_active)
+		nfsd_last_thread(net);
+	else if (err >= 0 &&
+		 !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
 		svc_get(nn->nfsd_serv);
 
 	nfsd_put(net);
@@ -756,6 +758,9 @@ out_close:
 		svc_xprt_put(xprt);
 	}
 out_err:
+	if (!nn->nfsd_serv->sv_nrthreads && !nn->keep_active)
+		nfsd_last_thread(net);
+
 	nfsd_put(net);
 	return err;
 }
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -138,6 +138,7 @@ int nfsd_vers(struct nfsd_net *nn, int v
 int nfsd_minorversion(struct nfsd_net *nn, u32 minorversion, enum vers_op change);
 void nfsd_reset_versions(struct nfsd_net *nn);
 int nfsd_create_serv(struct net *net);
+void nfsd_last_thread(struct net *net);
 
 extern int nfsd_max_blksize;
 
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -542,7 +542,7 @@ static struct notifier_block nfsd_inet6a
 /* Only used under nfsd_mutex, so this atomic may be overkill: */
 static atomic_t nfsd_notifier_refcount = ATOMIC_INIT(0);
 
-static void nfsd_last_thread(struct net *net)
+void nfsd_last_thread(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	struct svc_serv *serv = nn->nfsd_serv;


