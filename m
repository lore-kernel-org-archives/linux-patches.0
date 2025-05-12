Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A4B23C4FB;
	Mon, 12 May 2025 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071160; cv=none; b=S55Z5IL8u4pRPZXxWSXObQ705V5cF6CKFcRVqp+hZs6IJOhUsrLk8so09NhHNqQmOjCcpDieFCe1oY9CQKTGJ7D+10VXEuzBfTc8dp04+JCIqnyLNy8BMzU6Qh/LFRh6DcjlPBK7TwHLRip0BSjdu4DhEtEAYHLI27QSPMgnySc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071160; c=relaxed/simple;
	bh=RRBaBMuk6dh2oqtZdJzjf5YHuwcMc9UHWuSTjHiorX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ed6lRm5rPOt+bWhD4xPaG/09/mMD9ubBuq22C0TvRvalYJQoi8sSAyS7Wp36CGEF5uSpCuaQp3g0G2oAbtzAOvGZZ0U2THNXtHoRL7Aj4OPM3QlfsIQCjy/9Jg8utRMqMkRCluBl1sJcJUX41cCCfiXzoew0LlCkA+QuyA9pIFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KigomukE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KigomukE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E04C4CEE7;
	Mon, 12 May 2025 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071160;
	bh=RRBaBMuk6dh2oqtZdJzjf5YHuwcMc9UHWuSTjHiorX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KigomukEYlM7gDCERvPZ2zic5v8X68AYOkaj05xQwGv5xjf1qZqcBHNItAgtd4K1H
	 +IQCUpvAAubY9XcmBKzTS6ubVr596x7iO1Ml/eRu5AVRhZz+AIrJShHqZRqVKEnkR4
	 bl2dmLKz3tr2bBC/cTA/li4cgoyeqxMhAdyhx8BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Shichangkuo <shi.changkuo@h3c.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 32/54] ocfs2: switch osb->disable_recovery to enum
Date: Mon, 12 May 2025 19:29:44 +0200
Message-ID: <20250512172016.934780489@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit c0fb83088f0cc4ee4706e0495ee8b06f49daa716 upstream.

Patch series "ocfs2: Fix deadlocks in quota recovery", v3.

This implements another approach to fixing quota recovery deadlocks.  We
avoid grabbing sb->s_umount semaphore from ocfs2_finish_quota_recovery()
and instead stop quota recovery early in ocfs2_dismount_volume().


This patch (of 3):

We will need more recovery states than just pure enable / disable to fix
deadlocks with quota recovery.  Switch osb->disable_recovery to enum.

Link: https://lkml.kernel.org/r/20250424134301.1392-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20250424134515.18933-4-jack@suse.cz
Fixes: 5f530de63cfc ("ocfs2: Use s_umount for quota recovery protection")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>
Cc: Shichangkuo <shi.changkuo@h3c.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/journal.c |   14 ++++++++------
 fs/ocfs2/ocfs2.h   |    7 ++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -173,7 +173,7 @@ int ocfs2_recovery_init(struct ocfs2_sup
 	struct ocfs2_recovery_map *rm;
 
 	mutex_init(&osb->recovery_lock);
-	osb->disable_recovery = 0;
+	osb->recovery_state = OCFS2_REC_ENABLED;
 	osb->recovery_thread_task = NULL;
 	init_waitqueue_head(&osb->recovery_event);
 
@@ -208,7 +208,7 @@ void ocfs2_recovery_exit(struct ocfs2_su
 	/* disable any new recovery threads and wait for any currently
 	 * running ones to exit. Do this before setting the vol_state. */
 	mutex_lock(&osb->recovery_lock);
-	osb->disable_recovery = 1;
+	osb->recovery_state = OCFS2_REC_DISABLED;
 	mutex_unlock(&osb->recovery_lock);
 	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
 
@@ -1523,14 +1523,16 @@ bail:
 
 void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
 {
+	int was_set = -1;
+
 	mutex_lock(&osb->recovery_lock);
+	if (osb->recovery_state < OCFS2_REC_DISABLED)
+		was_set = ocfs2_recovery_map_set(osb, node_num);
 
 	trace_ocfs2_recovery_thread(node_num, osb->node_num,
-		osb->disable_recovery, osb->recovery_thread_task,
-		osb->disable_recovery ?
-		-1 : ocfs2_recovery_map_set(osb, node_num));
+		osb->recovery_state, osb->recovery_thread_task, was_set);
 
-	if (osb->disable_recovery)
+	if (osb->recovery_state == OCFS2_REC_DISABLED)
 		goto out;
 
 	if (osb->recovery_thread_task)
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -284,6 +284,11 @@ enum ocfs2_mount_options
 #define OCFS2_OSB_ERROR_FS	0x0004
 #define OCFS2_DEFAULT_ATIME_QUANTUM	60
 
+enum ocfs2_recovery_state {
+	OCFS2_REC_ENABLED = 0,
+	OCFS2_REC_DISABLED,
+};
+
 struct ocfs2_journal;
 struct ocfs2_slot_info;
 struct ocfs2_recovery_map;
@@ -346,7 +351,7 @@ struct ocfs2_super
 	struct ocfs2_recovery_map *recovery_map;
 	struct ocfs2_replay_map *replay_map;
 	struct task_struct *recovery_thread_task;
-	int disable_recovery;
+	enum ocfs2_recovery_state recovery_state;
 	wait_queue_head_t checkpoint_event;
 	struct ocfs2_journal *journal;
 	unsigned long osb_commit_interval;


