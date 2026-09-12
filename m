Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B033736828B;
	Sat, 12 Sep 2026 19:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242370; cv=none; b=BGc8GapYepE3erYSwZoJuZV0MvoKFD8I0Xhv+eh+afu/SSw4of8dL6fbsO6wv3lX+ND3KbSJTdUVbCOlFMykVlugihcstyF3DBvqX1APzMvhzVoE1v7E+IYTJTZaeU7loXr9k7SEntc6Hrq9K7DJQ+Fxrx0Ei+mbKJWjzyGfsS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242370; c=relaxed/simple;
	bh=5SYKg1tyQ2u4nHbn7UO88zAWPqfc/eps291fmn+YKf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oI0ErJIQ/KzJ0I7yYHq+MGuKRuaxHWu5jNxD2oIv/09sIpcIKSNZn5T4pwOxJu9274AJutTmw26zHHN8yIUybMNNcGK9ysoLaD9Mz9XXNdc35i1F8xNpC0Gt+F2uodDfeydIqt/9nJULSb1Rnlgm9kTT0L93cRmVBf37t1AdN7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnNlgHpR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnNlgHpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139011F000FF;
	Sat, 12 Sep 2026 19:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242368;
	bh=WSvs2lo16m/vWSsUv6vb1E7hSeZGGrNH0D/BXJoL3T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnNlgHpRcxF1yFCaYu0nvSMzW60D7Pu3xM0DKmTg8Ejk2NObWDkE2pvovrA4jyrg5
	 Wuy+5i1ZHZfsoBCuErASG9WZ0hmwcNLcRd3iih5fBM+18Pg0RAy+pqX9Cm3YXstGx0
	 KFdUixmNmqCsALGjYb7Fn8tnfDIH+OFtpn+TWwpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 336/798] smack: fix incorrect task context in smack_msg_queue_msgrcv
Date: Sat, 12 Sep 2026 08:59:24 +0200
Message-ID: <20260912065524.863249964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit fba3d32825f4bbc8e20f0cdc3b14df57965b8fe5 ]

The smack_msg_queue_msgrcv() function incorrectly checks
the permissions of the 'current' task instead of the
'target' task.

In the msgsnd() syscall path, if a receiver is already waiting,
the pipelined_send() optimization is used to push the message
directly to the receiver task:

    ipc/msg.c`pipelined_send():
    ` smp_store_release(&msr->r_msg, msg)

In this case, the 'sender' (current) task performs the check
on behalf of the 'receiver' task (msr->r_tsk, passed as the
'target' parameter):

  ipc/msg.c`pipelined_send():
  ` security_msg_queue_msgrcv(,, target := msr->r_tsk,,)

However, smack_msg_queue_msgrcv() ignores the 'target' and
checks 'current':

  smack_msg_queue_msgrcv(…)
  ` smk_curacc_msq(isp, MAY_READWRITE); // current task

'current' MAY satisfy smack_msg_queue_msgrcv r/w requirement,
but 'target' (the receiver task) might NOT;
as a result, an unauthorized receiver gets the message,
violating MAC policy.

Test:
1) create a sysv message queue with label “foo”
2) echo "bar foo r" >/smack/load2
3) msgrcv(,,,0,MSG_NOERROR) in "bar"-labeled task.
    The task is waiting for the messages ...
4) msgsnd() from a "foo"-labeled task:
"bar"-labeled task gets the message.

This patch fixes the issue by checking permission on the
'target' task instead of 'current'.

(2008-02-04, Casey Schaufler)
Fixes: e114e473771c ("Smack: Simplified Mandatory Access Control Kernel")

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 65 +++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 94d6eac268550..909952cd784d2 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -133,12 +133,13 @@ static int smk_bu_note(char *note, struct smack_known *sskp,
 #define smk_bu_note(note, sskp, oskp, mode, RC) (RC)
 #endif
 
-#ifdef CONFIG_SECURITY_SMACK_BRINGUP
-static int smk_bu_current(char *note, struct smack_known *oskp,
-			  int mode, int rc)
+static int
+smk_bu_tsk_to_obj(struct task_struct *tsk, const struct task_smack *tsp,
+		  char *note, struct smack_known *oskp, int mode, int rc)
 {
-	struct task_smack *tsp = smack_cred(current_cred());
+#ifdef CONFIG_SECURITY_SMACK_BRINGUP
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
+	char comm[TASK_COMM_LEN];
 
 	if (rc <= 0)
 		return rc;
@@ -146,14 +147,22 @@ static int smk_bu_current(char *note, struct smack_known *oskp,
 		rc = 0;
 
 	smk_bu_mode(mode, acc);
+
 	pr_info("Smack %s: (%s %s %s) %s %s\n", smk_bu_mess[rc],
-		tsp->smk_task->smk_known, oskp->smk_known,
-		acc, current->comm, note);
+		smk_of_task(tsp)->smk_known, oskp->smk_known,
+		acc, get_task_comm(comm, tsk), note);
 	return 0;
-}
 #else
-#define smk_bu_current(note, oskp, mode, RC) (RC)
+	return rc;
 #endif
+}
+
+static int smk_bu_current(char *note, struct smack_known *oskp,
+			  int mode, int rc)
+{
+	return smk_bu_tsk_to_obj(current, smack_cred(current_cred()),
+				 note, oskp, mode, rc);
+}
 
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
 static int smk_bu_task(struct task_struct *otp, int mode, int rc)
@@ -3146,14 +3155,20 @@ static int smack_sem_semop(struct kern_ipc_perm *isp, struct sembuf *sops,
 }
 
 /**
- * smk_curacc_msq : helper to check if current has access on msq
- * @isp : the msq
+ * smk_tskacc_msq : helper to check if tsk has access on msq
+ * @tsk: the task that requests access
+ * @isp : the sysv msg queue permissions
  * @access : access requested
  *
- * return 0 if current has access, error otherwise
+ * return 0 if tsk has access, error otherwise
  */
-static int smk_curacc_msq(struct kern_ipc_perm *isp, int access)
+static int
+smk_tskacc_msq(struct task_struct *tsk, struct kern_ipc_perm *isp, int access)
 {
+	const bool tsk_is_current = (tsk == current);
+	const struct cred * const tsk_cred =
+			(tsk_is_current ? current_cred() : get_task_cred(tsk));
+	struct task_smack * const tsp = smack_cred(tsk_cred);
 	struct smack_known *msp = smack_of_ipc(isp);
 	struct smk_audit_info ad;
 	int rc;
@@ -3162,11 +3177,25 @@ static int smk_curacc_msq(struct kern_ipc_perm *isp, int access)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
 	ad.a.u.ipc_id = isp->id;
 #endif
-	rc = smk_curacc(msp, access, &ad);
-	rc = smk_bu_current("msq", msp, access, rc);
+	rc = smk_tskacc(tsp, msp, access, &ad);
+	rc = smk_bu_tsk_to_obj(tsk, tsp, "msq", msp, access, rc);
+	if (!tsk_is_current)
+		put_cred(tsk_cred);
 	return rc;
 }
 
+/**
+ * smk_curacc_msq : helper to check if current has access on msq
+ * @isp : the sysv msg queue permissions
+ * @access : access requested
+ *
+ * return 0 if current has access, error otherwise
+ */
+static int smk_curacc_msq(struct kern_ipc_perm *isp, int access)
+{
+	return smk_tskacc_msq(current, isp, access);
+}
+
 /**
  * smack_msg_queue_associate - Smack access check for msg_queue
  * @isp: the object
@@ -3234,21 +3263,21 @@ static int smack_msg_queue_msgsnd(struct kern_ipc_perm *isp, struct msg_msg *msg
 }
 
 /**
- * smack_msg_queue_msgrcv - Smack access check for msg_queue
+ * smack_msg_queue_msgrcv - check it target has r/w access to msg_queue
  * @isp: the object
  * @msg: unused
- * @target: unused
+ * @target: the task that msgrcv() from the queue
  * @type: unused
  * @mode: unused
  *
- * Returns 0 if current has read and write access, error code otherwise
+ * Returns 0 if target has read and write access, error code otherwise
  */
 static int smack_msg_queue_msgrcv(struct kern_ipc_perm *isp,
 				  struct msg_msg *msg,
 				  struct task_struct *target, long type,
 				  int mode)
 {
-	return smk_curacc_msq(isp, MAY_READWRITE);
+	return smk_tskacc_msq(target, isp, MAY_READWRITE);
 }
 
 /**
-- 
2.53.0



