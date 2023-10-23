Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48E814282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UD9zbD+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEAFC433C9;
	Mon, 23 Oct 2023 11:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059810;
	bh=xHPIltksSc4KgdeeEXtW1xf8OJIGfYdbro7Xj+9PvME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UD9zbD+JY1XGJmBanL3TTzmiRLIMxZXXxbm4a+h5N8TQk15mXYQncCMIr7YHNWC4X
	 EQE2Pq6M5ETGFS02XqyoP2KvLEib+XivNZAue8iPV+vAECwEbnhvq2PbblPMFjTwra
	 QI6zhbqsEFm9RIkdzuVciWLfxG9YSSrU7cMaSy6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Firo Yang <firo.yang@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.19 33/98] cgroup: Remove duplicates in cgroup v1 tasks file
Date: Mon, 23 Oct 2023 12:56:22 +0200
Message-ID: <20231023104814.763557639@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

commit 1ca0b605150501b7dc59f3016271da4eb3e96fce upstream.

One PID may appear multiple times in a preloaded pidlist.
(Possibly due to PID recycling but we have reports of the same
task_struct appearing with different PIDs, thus possibly involving
transfer of PID via de_thread().)

Because v1 seq_file iterator uses PIDs as position, it leads to
a message:
> seq_file: buggy .next function kernfs_seq_next did not update position index

Conservative and quick fix consists of removing duplicates from `tasks`
file (as opposed to removing pidlists altogether). It doesn't affect
correctness (it's sufficient to show a PID once), performance impact
would be hidden by unconditional sorting of the pidlist already in place
(asymptotically).

Link: https://lore.kernel.org/r/20230823174804.23632-1-mkoutny@suse.com/
Suggested-by: Firo Yang <firo.yang@suse.com>
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup-v1.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -395,10 +395,9 @@ static int pidlist_array_load(struct cgr
 	}
 	css_task_iter_end(&it);
 	length = n;
-	/* now sort & (if procs) strip out duplicates */
+	/* now sort & strip out duplicates (tgids or recycled thread PIDs) */
 	sort(array, length, sizeof(pid_t), cmppid, NULL);
-	if (type == CGROUP_FILE_PROCS)
-		length = pidlist_uniq(array, length);
+	length = pidlist_uniq(array, length);
 
 	l = cgroup_pidlist_find_create(cgrp, type);
 	if (!l) {


