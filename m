Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1001586D5;
	Tue, 18 Jun 2024 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716162; cv=none; b=u/GhIIT6y8wJP5lo/FYv9F8YflkoR7fQ09U4iEOyHXvJ0klKQus28yyGMZZMZ2lTJMZ+U9CVONTwJhYrIBejXFKicSf+8Bl6uqk3lU5709i8rr3lKV17ugG1ADLl0OC04SF6QabO9TXM/aVaeOxcIYAHbmq/VXjqqXsrLUjKagU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716162; c=relaxed/simple;
	bh=VBgDCcSiXPti7QpdNn0opzhBaxRMVfmusDXhwqMGBX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Todb2ltXhfcYTYH6mNrS72Prq0zUzPlzEFl7MxL7fBQOphcqNmpYbXZMnFiDm1xP48o0+d6qZgP+93TGOZl0Ul7zOyqAVu3734+NM72i3curx61u3nBOp9/YXHR031pxA0CFr9lSut6Ks8pR2wcIpTQ3Tr+/GYc3hEV4JLpRCCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhp7wO72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhp7wO72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6336C3277B;
	Tue, 18 Jun 2024 13:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716162;
	bh=VBgDCcSiXPti7QpdNn0opzhBaxRMVfmusDXhwqMGBX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhp7wO72uL/6j6HfW8/nsR0h4yYE4RjaIrGRE5RDvupvGbG4J6cHg6MI8GWFQlJ53
	 yPELfQDZLD3DOLpi82DnXFxCMnNcL5D/ZTPO0D0UW/clz4lfBtsOG6jaqdeGkCFPZm
	 dujaDucElScwJbWQyGbYVff0ID1TKYsJlk1BAFJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 512/770] NFSD: move create/destroy of laundry_wq to init_nfsd and exit_nfsd
Date: Tue, 18 Jun 2024 14:36:05 +0200
Message-ID: <20240618123427.074767953@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit d76cc46b37e123e8d245cc3490978dbda56f979d ]

This patch moves create/destroy of laundry_wq from nfs4_state_start
and nfs4_state_shutdown_net to init_nfsd and exit_nfsd to prevent
the laundromat from being freed while a thread is processing a
conflicting lock.

Reviewed-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 28 ++++++++++++++++------------
 fs/nfsd/nfsctl.c    |  4 ++++
 fs/nfsd/nfsd.h      |  4 ++++
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 4ba0a70d8990f..30ea1c7b6b9fd 100644
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
@@ -7775,22 +7790,12 @@ nfs4_state_start(void)
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
@@ -7827,7 +7832,6 @@ nfs4_state_shutdown_net(struct net *net)
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



