Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250AA223327;
	Mon,  2 Jun 2025 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875322; cv=none; b=MXbvAYlYJN3Gkz3hqMhYUzy/Xw0HQcvsuSaCErWwsP0eoKjDhelozBDtBB4azyt3evaDW9NvMuMJ+b4nkddQ4jUSmVj6/HQkIH3bCYez/aCeOTy2yrdDwKYzdCpHPTbOTwVxeLMQ+NK+srK7TB7Kf+0EKb5d7v2C7yDwrnAr71Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875322; c=relaxed/simple;
	bh=M+IISjHYj0XqHy666LY/FAFcjY+V6oBGxun4n/AJvIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNaX+uV3a641EER74EUViDoslmnbDD57OZfGnnHRy1S7kHcYDlamjvM9aOPzVoVnJRP+Y1LX7WB134gLJOOIqHpB26eBaJvaKKhP/tkr1Ee6egYnTvAWktty07tIhgUFy5MS3Yg0BlLKKtunIJMDliRlGup2qdRhTDGQ9C6IemA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DvkVmaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DvkVmaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A0DC4CEEB;
	Mon,  2 Jun 2025 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875322;
	bh=M+IISjHYj0XqHy666LY/FAFcjY+V6oBGxun4n/AJvIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DvkVmaGKbQE+iSF50bt3vzFUlh/zeHJOIYCulzVNeNvdtGxDutsCEpt3Uo8PHrYe
	 e0J+tWx61dVWL1XUI0B0VUGqP+cVLfa+yy+zlR6MIFM639/Gh4uym2fRd4mawEAXRT
	 TEiE/VW5iefi0018RL8KCvYB5nhzp1Z9pwxCl3hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Changwei Ge <gechangwei@live.cn>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Shichangkuo <shi.changkuo@h3c.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 067/270] ocfs2: implement handshaking with ocfs2 recovery thread
Date: Mon,  2 Jun 2025 15:45:52 +0200
Message-ID: <20250602134309.931135296@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jan Kara <jack@suse.cz>

commit 8f947e0fd595951460f5a6e1ac29baa82fa02eab upstream.

We will need ocfs2 recovery thread to acknowledge transitions of
recovery_state when disabling particular types of recovery.  This is
similar to what currently happens when disabling recovery completely, just
more general.  Implement the handshake and use it for exit from recovery.

Link: https://lkml.kernel.org/r/20250424134515.18933-5-jack@suse.cz
Fixes: 5f530de63cfc ("ocfs2: Use s_umount for quota recovery protection")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>
Cc: Shichangkuo <shi.changkuo@h3c.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/journal.c |   52 +++++++++++++++++++++++++++++++++++-----------------
 fs/ocfs2/ocfs2.h   |    4 ++++
 2 files changed, 39 insertions(+), 17 deletions(-)

--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -194,31 +194,48 @@ int ocfs2_recovery_init(struct ocfs2_sup
 	return 0;
 }
 
-/* we can't grab the goofy sem lock from inside wait_event, so we use
- * memory barriers to make sure that we'll see the null task before
- * being woken up */
 static int ocfs2_recovery_thread_running(struct ocfs2_super *osb)
 {
-	mb();
 	return osb->recovery_thread_task != NULL;
 }
 
-void ocfs2_recovery_exit(struct ocfs2_super *osb)
+static void ocfs2_recovery_disable(struct ocfs2_super *osb,
+				   enum ocfs2_recovery_state state)
 {
-	struct ocfs2_recovery_map *rm;
-
-	/* disable any new recovery threads and wait for any currently
-	 * running ones to exit. Do this before setting the vol_state. */
 	mutex_lock(&osb->recovery_lock);
-	osb->recovery_state = OCFS2_REC_DISABLED;
+	/*
+	 * If recovery thread is not running, we can directly transition to
+	 * final state.
+	 */
+	if (!ocfs2_recovery_thread_running(osb)) {
+		osb->recovery_state = state + 1;
+		goto out_lock;
+	}
+	osb->recovery_state = state;
+	/* Wait for recovery thread to acknowledge state transition */
+	wait_event_cmd(osb->recovery_event,
+		       !ocfs2_recovery_thread_running(osb) ||
+				osb->recovery_state >= state + 1,
+		       mutex_unlock(&osb->recovery_lock),
+		       mutex_lock(&osb->recovery_lock));
+out_lock:
 	mutex_unlock(&osb->recovery_lock);
-	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
 
-	/* At this point, we know that no more recovery threads can be
-	 * launched, so wait for any recovery completion work to
-	 * complete. */
+	/*
+	 * At this point we know that no more recovery work can be queued so
+	 * wait for any recovery completion work to complete.
+	 */
 	if (osb->ocfs2_wq)
 		flush_workqueue(osb->ocfs2_wq);
+}
+
+void ocfs2_recovery_exit(struct ocfs2_super *osb)
+{
+	struct ocfs2_recovery_map *rm;
+
+	/* disable any new recovery threads and wait for any currently
+	 * running ones to exit. Do this before setting the vol_state. */
+	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
 
 	/*
 	 * Now that recovery is shut down, and the osb is about to be
@@ -1509,7 +1526,8 @@ bail:
 
 	ocfs2_free_replay_slots(osb);
 	osb->recovery_thread_task = NULL;
-	mb(); /* sync with ocfs2_recovery_thread_running */
+	if (osb->recovery_state == OCFS2_REC_WANT_DISABLE)
+		osb->recovery_state = OCFS2_REC_DISABLED;
 	wake_up(&osb->recovery_event);
 
 	mutex_unlock(&osb->recovery_lock);
@@ -1528,13 +1546,13 @@ void ocfs2_recovery_thread(struct ocfs2_
 	int was_set = -1;
 
 	mutex_lock(&osb->recovery_lock);
-	if (osb->recovery_state < OCFS2_REC_DISABLED)
+	if (osb->recovery_state < OCFS2_REC_WANT_DISABLE)
 		was_set = ocfs2_recovery_map_set(osb, node_num);
 
 	trace_ocfs2_recovery_thread(node_num, osb->node_num,
 		osb->recovery_state, osb->recovery_thread_task, was_set);
 
-	if (osb->recovery_state == OCFS2_REC_DISABLED)
+	if (osb->recovery_state >= OCFS2_REC_WANT_DISABLE)
 		goto out;
 
 	if (osb->recovery_thread_task)
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -288,6 +288,10 @@ enum ocfs2_mount_options
 
 enum ocfs2_recovery_state {
 	OCFS2_REC_ENABLED = 0,
+	OCFS2_REC_WANT_DISABLE,
+	/*
+	 * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
+	 */
 	OCFS2_REC_DISABLED,
 };
 


