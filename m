Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C5829DB64;
	Sat, 12 Sep 2026 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229042; cv=none; b=dSY5haz+qX2OGDfWtAPyu2fpfiarp5vbfcriqoUyaYRK0aokjclE2JfiOWuV47GNOrNb+yVxqvu1ycN+/9fObEBVThTqGgb0jQUSFf0gdUem1szmOLTHCOwjadpl3A/inajVKcsJldLukg95mq+hyRQbXcA/Deg+YKHpQJWuBiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229042; c=relaxed/simple;
	bh=oY2oUcBBKZ/WLb46OttygFANRnVQekdeNftI4NPu1rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HhRRWdLbWCjGn2OSzzPgAj5bv00HcGdgtFY0LNUcEwYE2gwtxTW+33Rg4RRnmxyydFO569oZFEHanm+/kD1XfKt+GTHVGUmmqRId2jsg9eGD5PzeUVYjb9Y23siVuuGd2WW/Osd/hn03A1gSvmd2BqpVBP7PqQoGJIvS8bsrLEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHEPO84y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHEPO84y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A941F000FF;
	Sat, 12 Sep 2026 16:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229040;
	bh=mBc8AAGa/vaJjKj+ELLN/+a8yJuCB3eIzvskgwn0cDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHEPO84yPEqBK6m/7B5jN2Li8J/r8gm5Ln8+KftxJnGR3THyrCwqQXCWY9eOO3Nj+
	 rcecQI5d6YLJE+SYOHw5gwB962gwdjCHFY1t+tgtcXS9EVzjXmrT4GnvNDDbsjahwi
	 NJ+ZYeCuGZeBlBg7bUgoh2WhK2kINHPOx2anpEW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0467/1191] smack: fix incorrect task context in smack_msg_queue_msgrcv
Date: Sat, 12 Sep 2026 08:53:15 +0200
Message-ID: <20260912065558.723854624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8c5bdae927152..0853da7748088 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -136,12 +136,13 @@ static int smk_bu_note(char *note, struct smack_known *sskp,
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
@@ -149,14 +150,22 @@ static int smk_bu_current(char *note, struct smack_known *oskp,
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
@@ -3212,14 +3221,20 @@ static int smack_sem_semop(struct kern_ipc_perm *isp, struct sembuf *sops,
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
@@ -3228,11 +3243,25 @@ static int smk_curacc_msq(struct kern_ipc_perm *isp, int access)
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
@@ -3300,21 +3329,21 @@ static int smack_msg_queue_msgsnd(struct kern_ipc_perm *isp, struct msg_msg *msg
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



