Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797A679F0;
	Mon,  8 Apr 2024 13:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583975; cv=none; b=Iyee11awLPlEbrpY7Y7Zxnnzsm5J5qAHPnr6Ws7zXFWt3sRXUDvj7fI4Eg6X1UPFJ1STokYL0sOYowoW1q7gdTeTN0uXlOF6rdPF8/rpFPHlITgaHltd7vwK/ERBR8ds6LLHJvhPB/0T+3pEm895SBGesg8OGEBLiYZ4iK4kv8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583975; c=relaxed/simple;
	bh=zKr9pPGd7+xRH47SZGe6c4wZ6rat+6tIFfGJPO2OR40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSmms6EjgsmaNRDfsAzkeIp4RBhR1xwQyWuLJeQ1mpUnPAkVjRKy6x048da9CH1bZA4clIvy4AXmOfQWyeAsKPnoPe1BNAZ8XWoPTPJYaI6MFcfSRHkZ69aU5+V8NK4o33ENIsw8ynRQIIE8SloIKQYDfhGZo5OSJixc/9purVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/cHjKg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/cHjKg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00235C433C7;
	Mon,  8 Apr 2024 13:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583975;
	bh=zKr9pPGd7+xRH47SZGe6c4wZ6rat+6tIFfGJPO2OR40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/cHjKg3eDrYKsfsPQjQoxdagND+cCVx8A6Mn8VuyWMpvsU72GS8PmqOo51ATBmVq
	 QtExedeRdSqRwz6UBu8i2w5GmSvnS7h7iAGRtWsEBGt2KszBJ4ZG7+1efT255yPgzV
	 Pk5t8hY9m6ezuUBgrZpj21vxLbjz568cU5cGIun0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 309/690] NFSD: move create/destroy of laundry_wq to init_nfsd and exit_nfsd
Date: Mon,  8 Apr 2024 14:52:55 +0200
Message-ID: <20240408125410.791280362@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit d76cc46b37e123e8d245cc3490978dbda56f979d ]

This patch moves create/destroy of laundry_wq from nfs4_state_start
and nfs4_state_shutdown_net to init_nfsd and exit_nfsd to prevent
the laundromat from being freed while a thread is processing a
conflicting lock.

Reviewed-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 28 ++++++++++++++++------------
 fs/nfsd/nfsctl.c    |  4 ++++
 fs/nfsd/nfsd.h      |  4 ++++
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3dfdd9e1c5028..582c9c7ba60a8 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -127,6 +127,21 @@ static const struct nfsd4_callback_ops nfsd4_cb_notify_lock_ops;
 
 static struct workqueue_struct *laundry_wq;
 
+int nfsd4_create_laundry_wq(void)
+{
+	int rc = 0;
+
+	laundry_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, "nfsd4");
+	if (laundry_wq == NULL)
+		rc = -ENOMEM;
+	return rc;
+}
+
+void nfsd4_destroy_laundry_wq(void)
+{
+	destroy_workqueue(laundry_wq);
+}
+
 static bool is_session_dead(struct nfsd4_session *ses)
 {
 	return ses->se_flags & NFS4_SESSION_DEAD;
@@ -7761,22 +7776,12 @@ nfs4_state_start(void)
 {
 	int ret;
 
-	laundry_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, "nfsd4");
-	if (laundry_wq == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
 	ret = nfsd4_create_callback_queue();
 	if (ret)
-		goto out_free_laundry;
+		return ret;
 
 	set_max_delegations();
 	return 0;
-
-out_free_laundry:
-	destroy_workqueue(laundry_wq);
-out:
-	return ret;
 }
 
 void
@@ -7813,7 +7818,6 @@ nfs4_state_shutdown_net(struct net *net)
 void
 nfs4_state_shutdown(void)
 {
-	destroy_workqueue(laundry_wq);
 	nfsd4_destroy_callback_queue();
 }
 
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 16920e4512bde..322a208878f2c 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1542,6 +1542,9 @@ static int __init init_nfsd(void)
 	if (retval < 0)
 		goto out_free_filesystem;
 	retval = register_cld_notifier();
+	if (retval)
+		goto out_free_all;
+	retval = nfsd4_create_laundry_wq();
 	if (retval)
 		goto out_free_all;
 	return 0;
@@ -1566,6 +1569,7 @@ static int __init init_nfsd(void)
 
 static void __exit exit_nfsd(void)
 {
+	nfsd4_destroy_laundry_wq();
 	unregister_cld_notifier();
 	unregister_pernet_subsys(&nfsd_net_ops);
 	nfsd_drc_slab_free();
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 23996c6ca75e3..847b482155ae9 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -162,6 +162,8 @@ void nfs4_state_shutdown_net(struct net *net);
 int nfs4_reset_recoverydir(char *recdir);
 char * nfs4_recoverydir(void);
 bool nfsd4_spo_must_allow(struct svc_rqst *rqstp);
+int nfsd4_create_laundry_wq(void);
+void nfsd4_destroy_laundry_wq(void);
 #else
 static inline int nfsd4_init_slabs(void) { return 0; }
 static inline void nfsd4_free_slabs(void) { }
@@ -175,6 +177,8 @@ static inline bool nfsd4_spo_must_allow(struct svc_rqst *rqstp)
 {
 	return false;
 }
+static inline int nfsd4_create_laundry_wq(void) { return 0; };
+static inline void nfsd4_destroy_laundry_wq(void) {};
 #endif
 
 /*
-- 
2.43.0



