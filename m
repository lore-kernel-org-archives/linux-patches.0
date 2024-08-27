Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E8C1BDA93;
	Tue, 27 Aug 2024 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772694; cv=none; b=WRNc844Z/jZL5xQdpKqQ6mAo7gu1DNsXzgtBQQJoXvUEguJhp54nCOCeF6286JuU2QjuGatEBGwvjFvUBNehNRUPcE1Ov0jkz+PUbf3i4GShIEaG1BUyUj37Foy9pAoHm/fffVJmF7pt5ShsbqnZ/OnYPsi2uyxBlXkFMrczHl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772694; c=relaxed/simple;
	bh=C7Wv5tbGi9CateHaer3OKf+++uORwOtKrAFsv1VjJ2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2ahbhmtw0sDame3HCvCp5M5pzfVHNayVI+ZaZO+LbzTTTbXQPL93g9Q+Q9+b08jER7Xvb6208BrwOJ0i2aRHcxxxUYD2kr41L0F7hFIsmRbMJ5ppgQ53SjsC+o3M0mYESx6xxvoEdBZ2NT5Aak0AXmPP3RPpmS80AeH9m4KMRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuwjLrCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuwjLrCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A7BC4DDF1;
	Tue, 27 Aug 2024 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772693;
	bh=C7Wv5tbGi9CateHaer3OKf+++uORwOtKrAFsv1VjJ2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuwjLrCJTEm4MyoZ3Ig9BxXsVNbfyZH2Z9Zih6dnF/OS2Ny8KenB2XfL/aIB8YaPN
	 DDUxfFh0Gq1LYL6iKsOh5gHN4R2oPozbO3GqI5jSBE2waxREBQzKDzklcR6BQi9DK0
	 inX6sKIDywu+/Aey9EMDus5VMoAVVVw1R8u0U/xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 291/321] nfsd: call nfsd_last_thread() before final nfsd_put()
Date: Tue, 27 Aug 2024 16:39:59 +0200
Message-ID: <20240827143849.329146888@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 2a501f55cd641eb4d3c16a2eab0d678693fac663 ]

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
@@ -720,8 +720,10 @@ static ssize_t __write_ports_addfd(char
 
 	err = svc_addsock(nn->nfsd_serv, net, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
 
-	if (err >= 0 &&
-	    !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
+	if (err < 0 && !nn->nfsd_serv->sv_nrthreads && !nn->keep_active)
+		nfsd_last_thread(net);
+	else if (err >= 0 &&
+		 !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
 		svc_get(nn->nfsd_serv);
 
 	nfsd_put(net);
@@ -771,6 +773,9 @@ out_close:
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
@@ -139,6 +139,7 @@ int nfsd_vers(struct nfsd_net *nn, int v
 int nfsd_minorversion(struct nfsd_net *nn, u32 minorversion, enum vers_op change);
 void nfsd_reset_versions(struct nfsd_net *nn);
 int nfsd_create_serv(struct net *net);
+void nfsd_last_thread(struct net *net);
 
 extern int nfsd_max_blksize;
 
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -532,7 +532,7 @@ static struct notifier_block nfsd_inet6a
 /* Only used under nfsd_mutex, so this atomic may be overkill: */
 static atomic_t nfsd_notifier_refcount = ATOMIC_INIT(0);
 
-static void nfsd_last_thread(struct net *net)
+void nfsd_last_thread(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	struct svc_serv *serv = nn->nfsd_serv;


