Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422271EEE6;
	Sat, 13 Jan 2024 10:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJ9D+dig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47DFC433C7;
	Sat, 13 Jan 2024 10:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140147;
	bh=cGWowJcK5YO/1gN4PcJ0Dmyy0sZkETyCrEKOuKik98Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJ9D+digNNCnJFXg8VgszqSfBoZpSpmKcDXmhnavO58kmw+pNNw2ju7+QZHP+nIRs
	 o2IRqDNElB3aomn2h1BBLSFhdq+UpbOJiRRyuZpKDCS3m6369Nic+gVBmzxkSNqfoL
	 I3e1UPNunN6jTedcem17aMOWcDpdnwvpNhIs4RO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	email200202 <email200202@yahoo.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2/4] Revert "nfsd: call nfsd_last_thread() before final nfsd_put()"
Date: Sat, 13 Jan 2024 10:50:40 +0100
Message-ID: <20240113094204.102630577@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094204.017594027@linuxfoundation.org>
References: <20240113094204.017594027@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit bb4f791cb2de1140d0fbcedfe9e791ff364021d7 which is
commit 2a501f55cd641eb4d3c16a2eab0d678693fac663 upstream.

It is reported to cause issues, so revert it.

Reported-by: email200202 <email200202@yahoo.com>
Link: https://lore.kernel.org/r/e341cb408b5663d8c91b8fa57b41bb984be43448.camel@kernel.org
Cc: NeilBrown <neilb@suse.de>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    9 ++-------
 fs/nfsd/nfsd.h   |    1 -
 fs/nfsd/nfssvc.c |    2 +-
 3 files changed, 3 insertions(+), 9 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -716,10 +716,8 @@ static ssize_t __write_ports_addfd(char
 
 	err = svc_addsock(nn->nfsd_serv, net, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
 
-	if (err < 0 && !nn->nfsd_serv->sv_nrthreads && !nn->keep_active)
-		nfsd_last_thread(net);
-	else if (err >= 0 &&
-		 !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
+	if (err >= 0 &&
+	    !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
 		svc_get(nn->nfsd_serv);
 
 	nfsd_put(net);
@@ -769,9 +767,6 @@ out_close:
 		svc_xprt_put(xprt);
 	}
 out_err:
-	if (!nn->nfsd_serv->sv_nrthreads && !nn->keep_active)
-		nfsd_last_thread(net);
-
 	nfsd_put(net);
 	return err;
 }
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -139,7 +139,6 @@ int nfsd_vers(struct nfsd_net *nn, int v
 int nfsd_minorversion(struct nfsd_net *nn, u32 minorversion, enum vers_op change);
 void nfsd_reset_versions(struct nfsd_net *nn);
 int nfsd_create_serv(struct net *net);
-void nfsd_last_thread(struct net *net);
 
 extern int nfsd_max_blksize;
 
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -523,7 +523,7 @@ static struct notifier_block nfsd_inet6a
 /* Only used under nfsd_mutex, so this atomic may be overkill: */
 static atomic_t nfsd_notifier_refcount = ATOMIC_INIT(0);
 
-void nfsd_last_thread(struct net *net)
+static void nfsd_last_thread(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	struct svc_serv *serv = nn->nfsd_serv;


