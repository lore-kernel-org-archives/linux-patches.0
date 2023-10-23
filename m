Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11D715EA7
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odVJ8WgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326B1C433CB;
	Mon, 23 Oct 2023 11:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061459;
	bh=3ChMFkaFBujS++c8gs5E2M2otk37nVY96tkkL0kGjKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odVJ8WgXsIcC4WnQxKYs4iLXuEJRLBFO5ZvgQfp0g1J6zFZ37qLZzjEmuubVOPRqN
	 FFDyXbqCT6FmoZa183W4wY3jppbV9nQoMjFBSXX9O5tIsMLLQAoREWObYHtTBT/TW6
	 AU59FfszmrW14JblTrMKowllAOL1LDONqHBnKJ0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Firo Yang <firo.yang@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 054/202] cgroup: Remove duplicates in cgroup v1 tasks file
Date: Mon, 23 Oct 2023 12:56:01 +0200
Message-ID: <20231023104828.151589302@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -361,10 +361,9 @@ static int pidlist_array_load(struct cgr
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


