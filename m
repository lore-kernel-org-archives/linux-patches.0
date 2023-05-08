Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33221168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6175BC433EF;
	Mon,  8 May 2023 10:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542055;
	bh=jhaS2KqOfxRTPe4+M5q9wdH/42iAqlxw2qnQXJCgFXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGveJcSkNzOVzE3mJtNtocWS0u9BH9VtCp5hOeJ9+HdgRm4gGq54wnzDuJW2hwXj3
	 iDn9xWLU/uD34kxLuEGBjC1/RcWyNAN+SvwOLGatw+PeU/AQCyAQsrTFBuXpipEcG2
	 0Q3UKqO/+68Yz/k3HQmzftALHuxbyKWF7Mhu5TBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 310/663] scsi: target: Move cmd counter allocation
Date: Mon,  8 May 2023 11:42:16 +0200
Message-Id: <20230508094438.250017077@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 4edba7e4a8f39112398d3cda94128a8e13a7d527 ]

iSCSI needs to allocate its cmd counter per connection for MCS support
where we need to stop and wait on commands running on a connection instead
of per session. This moves the cmd counter allocation to
target_setup_session() which is used by drivers that need the stop+wait
behavior per session.

xcopy doesn't need stop+wait at all, so we will be OK moving the cmd
counter allocation outside of transport_init_session().

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/20230319015620.96006-3-michael.christie@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 395cee83d02d ("scsi: target: iscsit: Stop/wait on cmds during conn close")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_login.c | 10 +++++
 drivers/target/target_core_internal.h     |  1 -
 drivers/target/target_core_transport.c    | 55 +++++++++++------------
 drivers/target/target_core_xcopy.c        | 15 +------
 include/target/target_core_fabric.h       |  4 +-
 5 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 27e448c2d066c..8ab6c0107d89c 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -324,8 +324,18 @@ static int iscsi_login_zero_tsih_s1(
 		goto free_ops;
 	}
 
+	/*
+	 * This is temp for iser. It will be moved to per conn in later
+	 * patches for iscsi.
+	 */
+	sess->se_sess->cmd_cnt = target_alloc_cmd_counter();
+	if (!sess->se_sess->cmd_cnt)
+		goto free_se_sess;
+
 	return 0;
 
+free_se_sess:
+	transport_free_session(sess->se_sess);
 free_ops:
 	kfree(sess->sess_ops);
 free_id:
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 38a6d08f75b34..85e35cf582e50 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -138,7 +138,6 @@ int	init_se_kmem_caches(void);
 void	release_se_kmem_caches(void);
 u32	scsi_get_new_index(scsi_index_t);
 void	transport_subsystem_check_init(void);
-void	transport_uninit_session(struct se_session *);
 unsigned char *transport_dump_cmd_direction(struct se_cmd *);
 void	transport_dump_dev_state(struct se_device *, char *, int *);
 void	transport_dump_dev_info(struct se_device *, struct se_lun *,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3d6034f00dcd8..60647a49a1d31 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -228,7 +228,7 @@ static void target_release_cmd_refcnt(struct percpu_ref *ref)
 	wake_up(&cmd_cnt->refcnt_wq);
 }
 
-static struct target_cmd_counter *target_alloc_cmd_counter(void)
+struct target_cmd_counter *target_alloc_cmd_counter(void)
 {
 	struct target_cmd_counter *cmd_cnt;
 	int rc;
@@ -252,6 +252,7 @@ static struct target_cmd_counter *target_alloc_cmd_counter(void)
 	kfree(cmd_cnt);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(target_alloc_cmd_counter);
 
 static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
@@ -271,24 +272,14 @@ static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
  *
  * The caller must have zero-initialized @se_sess before calling this function.
  */
-int transport_init_session(struct se_session *se_sess)
+void transport_init_session(struct se_session *se_sess)
 {
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
-	se_sess->cmd_cnt = target_alloc_cmd_counter();
-	if (!se_sess->cmd_cnt)
-		return -ENOMEM;
-
-	return  0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
-void transport_uninit_session(struct se_session *se_sess)
-{
-	target_free_cmd_counter(se_sess->cmd_cnt);
-}
-
 /**
  * transport_alloc_session - allocate a session object and initialize it
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
@@ -296,7 +287,6 @@ void transport_uninit_session(struct se_session *se_sess)
 struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
-	int ret;
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
 	if (!se_sess) {
@@ -304,11 +294,7 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
-	if (ret < 0) {
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
-	}
+	transport_init_session(se_sess);
 	se_sess->sup_prot_ops = sup_prot_ops;
 
 	return se_sess;
@@ -474,8 +460,13 @@ target_setup_session(struct se_portal_group *tpg,
 		     int (*callback)(struct se_portal_group *,
 				     struct se_session *, void *))
 {
+	struct target_cmd_counter *cmd_cnt;
 	struct se_session *sess;
+	int rc;
 
+	cmd_cnt = target_alloc_cmd_counter();
+	if (!cmd_cnt)
+		return ERR_PTR(-ENOMEM);
 	/*
 	 * If the fabric driver is using percpu-ida based pre allocation
 	 * of I/O descriptor tags, go ahead and perform that setup now..
@@ -485,29 +476,36 @@ target_setup_session(struct se_portal_group *tpg,
 	else
 		sess = transport_alloc_session(prot_op);
 
-	if (IS_ERR(sess))
-		return sess;
+	if (IS_ERR(sess)) {
+		rc = PTR_ERR(sess);
+		goto free_cnt;
+	}
+	sess->cmd_cnt = cmd_cnt;
 
 	sess->se_node_acl = core_tpg_check_initiator_node_acl(tpg,
 					(unsigned char *)initiatorname);
 	if (!sess->se_node_acl) {
-		transport_free_session(sess);
-		return ERR_PTR(-EACCES);
+		rc = -EACCES;
+		goto free_sess;
 	}
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
 	 */
 	if (callback != NULL) {
-		int rc = callback(tpg, sess, private);
-		if (rc) {
-			transport_free_session(sess);
-			return ERR_PTR(rc);
-		}
+		rc = callback(tpg, sess, private);
+		if (rc)
+			goto free_sess;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
+
+free_sess:
+	transport_free_session(sess);
+free_cnt:
+	target_free_cmd_counter(cmd_cnt);
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL(target_setup_session);
 
@@ -632,7 +630,8 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	transport_uninit_session(se_sess);
+	if (se_sess->cmd_cnt)
+		target_free_cmd_counter(se_sess->cmd_cnt);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49eaee022ef1d..49a83500c8b75 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -461,8 +461,6 @@ static const struct target_core_fabric_ops xcopy_pt_tfo = {
 
 int target_xcopy_setup_pt(void)
 {
-	int ret;
-
 	xcopy_wq = alloc_workqueue("xcopy_wq", WQ_MEM_RECLAIM, 0);
 	if (!xcopy_wq) {
 		pr_err("Unable to allocate xcopy_wq\n");
@@ -479,9 +477,7 @@ int target_xcopy_setup_pt(void)
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_list);
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_sess_list);
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
-	ret = transport_init_session(&xcopy_pt_sess);
-	if (ret < 0)
-		goto destroy_wq;
+	transport_init_session(&xcopy_pt_sess);
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
 	xcopy_pt_nacl.nacl_sess = &xcopy_pt_sess;
@@ -490,19 +486,12 @@ int target_xcopy_setup_pt(void)
 	xcopy_pt_sess.se_node_acl = &xcopy_pt_nacl;
 
 	return 0;
-
-destroy_wq:
-	destroy_workqueue(xcopy_wq);
-	xcopy_wq = NULL;
-	return ret;
 }
 
 void target_xcopy_release_pt(void)
 {
-	if (xcopy_wq) {
+	if (xcopy_wq)
 		destroy_workqueue(xcopy_wq);
-		transport_uninit_session(&xcopy_pt_sess);
-	}
 }
 
 /*
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 38f0662476d14..65527174b8bc6 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -133,7 +133,9 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
-int transport_init_session(struct se_session *se_sess);
+struct target_cmd_counter *target_alloc_cmd_counter(void);
+
+void transport_init_session(struct se_session *se_sess);
 struct se_session *transport_alloc_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
-- 
2.39.2



