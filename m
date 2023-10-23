Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9DC1845
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbtKUVjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD984C433C7;
	Mon, 23 Oct 2023 11:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058881;
	bh=I12qBV8MyzZNzl9N2ySD7sBynhOV0XEHKGSVk5d7H94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbtKUVjIwHy639SH7hrYCnhGAlitvlZmp1Me4k5WeC+8s20micyTh6lRf7TH55Ioy
	 /Kg2EzRpatAL0WyPwh1MLZlSBlt7dwYijI3EmsmB59AN0q+zq26Oog1+iZqfbk4XhZ
	 0pCY0QDJrtNh5mWOvB5ai7R28Yyx3JrgchSjlTMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Firo Yang <firo.yang@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.14 20/66] cgroup: Remove duplicates in cgroup v1 tasks file
Date: Mon, 23 Oct 2023 12:56:10 +0200
Message-ID: <20231023104811.552233034@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
References: <20231023104810.781270702@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -392,10 +392,9 @@ static int pidlist_array_load(struct cgr
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


