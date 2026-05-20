Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319D236C9D2;
	Wed, 20 May 2026 17:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298493; cv=none; b=UzAIp5+s2+v6STHkt6m/k6gQ+T7JHv5qhi61wkKD+JtRLcLIjT49aSzVtmbzShLFvXpp9H+LIC01OwQMrg6wPqzLRscmwoPUOe08w8ZkuLunrz/JwfwB4i286pxWRATk2f5BnjXHhi14aZFx52Be8yiiKu696uwfQ6AMSFtWEes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298493; c=relaxed/simple;
	bh=4OBbmKJeyezJcjQlOQPItSW2X3Z0Z8yu+xe+O0gAGEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+J5ZwZs7hBP8qQ/0u70J/CKQFRAVIkqWQ5X63YagRuAIIfa1NM8eOmTJdbSMIyoLtURNvmPqoTuZf4IYD4TTVWsHROBUq+iJhZHe0y4X9cSVO+Bzxndldk2+JrP0qevQ+9EVlSdFtAg0wweoGm6mq8t8sSmUVwlmUscCBo5RlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxfMA6a1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxfMA6a1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C261F000E9;
	Wed, 20 May 2026 17:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298492;
	bh=lVZI365Q37ErscjvOZt+AufUtHHPtmZcx4YK4iPvNks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxfMA6a1tCaTqegD+JZUotiEaQ6jETV09kk/3UXh8qn/QffwDIvIDnP5wbiQVVhfK
	 qKAWdVUqZFePRzmuygH0baxm1q8FTNDDLZR4aT5UPAWP3PrAU9I3wKRrgExlANRIDe
	 bELXVYSlEeFtg5qtxtMfXYFUiqSpUvPO5KFV8RoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Grzedzicki <mge@meta.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Alexey Gladkov (Intel)" <legion@kernel.org>,
	Ben Segall <bsegall@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 430/957] unshare: fix nsproxy leak in ksys_unshare() on set_cred_ucounts() failure
Date: Wed, 20 May 2026 18:15:13 +0200
Message-ID: <20260520162143.846844737@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Grzedzicki <mge@meta.com>

[ Upstream commit a98621a0f187a934c115dcfe79a49520ae892111 ]

When set_cred_ucounts() fails in ksys_unshare() new_nsproxy is leaked.

Let's call put_nsproxy() if that happens.

Link: https://lkml.kernel.org/r/20260213193959.2556730-1-mge@meta.com
Fixes: 905ae01c4ae2 ("Add a reference to ucounts for each cred")
Signed-off-by: Michal Grzedzicki <mge@meta.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Gladkov (Intel) <legion@kernel.org>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 34e6b94c22129..3ad76c2cf5af5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3132,11 +3132,10 @@ int ksys_unshare(unsigned long unshare_flags)
 					 new_cred, new_fs);
 	if (err)
 		goto bad_unshare_cleanup_cred;
-
 	if (new_cred) {
 		err = set_cred_ucounts(new_cred);
 		if (err)
-			goto bad_unshare_cleanup_cred;
+			goto bad_unshare_cleanup_nsproxy;
 	}
 
 	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
@@ -3152,8 +3151,10 @@ int ksys_unshare(unsigned long unshare_flags)
 			shm_init_task(current);
 		}
 
-		if (new_nsproxy)
+		if (new_nsproxy) {
 			switch_task_namespaces(current, new_nsproxy);
+			new_nsproxy = NULL;
+		}
 
 		task_lock(current);
 
@@ -3182,13 +3183,15 @@ int ksys_unshare(unsigned long unshare_flags)
 
 	perf_event_namespaces(current);
 
+bad_unshare_cleanup_nsproxy:
+	if (new_nsproxy)
+		put_nsproxy(new_nsproxy);
 bad_unshare_cleanup_cred:
 	if (new_cred)
 		put_cred(new_cred);
 bad_unshare_cleanup_fd:
 	if (new_fd)
 		put_files_struct(new_fd);
-
 bad_unshare_cleanup_fs:
 	if (new_fs)
 		free_fs_struct(new_fs);
-- 
2.53.0



