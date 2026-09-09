Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D803D967A;
	Wed,  9 Sep 2026 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962947; cv=none; b=MW0NL5xwNSJXoW09/EC1dUSAdKGOPBZEEsNjSTg31yFKAtiCfrRQ8ugUM8VUbD/ZZaBCK8WOJ75Cqdv+uqoT7K6amkwBE6iLt1ytydNzon+9CeHN+0hJ8kA2JBW95bhjMkfAuJoaBSPEF6dClMMUoYdHqoMAlmOv8XUNVdjdp8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962947; c=relaxed/simple;
	bh=/LJu5+k4/wl1YIp+T2V0JYDbUkIHGKiJlvacvfFspbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBPUspOU8uXriTLFHdalkei/8S141jhNZnJhE9PtI3R7zbrp7XYvTxfMBxdd/DbGQs6n1gukJDRSwk1R6BqIuZ88/9VEz1KxxBfRT01pt6O6Qp3J6IxiP9oaRzZPCpXXjreJmD6cc3FJxYISZwa7ohnS0hIu5ZugvFvetF43VhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1PwFbqO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1PwFbqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551971F00A3A;
	Wed,  9 Sep 2026 14:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962945;
	bh=HL58pN22iVsiAYbZJ/cYj2/R/ddtb9YihAAUQoOuRWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1PwFbqOwl0rfohJgeUpVA6W6in80FnnCQLXWtkTeYfJDb/IM2r0zW5Pm8OuPgStO
	 yGc5c9xbvopa8ZtOuB98GI2EbYxfqdgMLfzF7FcAcNyGuIUiRo+mI5ObnIL/249fEG
	 PmVFXC3C/1/JzqxMmuZdRSLxKolWhRFyQVLsGbq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 467/556] f2fs: protect critical_task_priority updates with s_umount
Date: Wed,  9 Sep 2026 15:42:27 +0200
Message-ID: <20260909134246.987302944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

commit 8e4692c6c165e81b2cbb847d8da4b45a53483b33 upstream.

The sysfs store path already takes s_umount for GC thread control
entries, and ckpt_thread_ioprio is covered as well.

critical_task_priority also updates checkpoint or GC kthread scheduling
state, but it is not covered by that serialization. It can race with
remount or teardown paths that are stopping those threads.

Protect critical_task_priority sysfs writes with s_umount too.

Fixes: 52190933c37a ("f2fs: sysfs: introduce critical_task_priority")
Cc: stable@kernel.org
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -1007,7 +1007,8 @@ static ssize_t f2fs_sbi_store(struct f2f
 	ssize_t ret;
 	bool gc_entry = (!strcmp(a->attr.name, "gc_urgent") ||
 					a->struct_type == GC_THREAD);
-	bool thread_entry = !strcmp(a->attr.name, "ckpt_thread_ioprio");
+	bool thread_entry = !strcmp(a->attr.name, "ckpt_thread_ioprio") ||
+			!strcmp(a->attr.name, "critical_task_priority");
 
 	if (gc_entry || thread_entry) {
 		if (!down_read_trylock(&sbi->sb->s_umount))


