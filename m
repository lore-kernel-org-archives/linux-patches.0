Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3C023392B;
	Sat, 30 May 2026 18:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164292; cv=none; b=VwOcaOrheLBnV1JWKBcwhPHIXtE23v8oYVxlLapOTLCmxbjV5SM0HbzI5L6D1z/aQZL9zBU0Sj9yO77eJY2WZJrnfPX88QrgGynUtMGJpwVQ3Z8OccgdTQOxQNPg1liRQmUP4K7egTaX+gkcEANTItwe0QsIH+8gXtgof35wXXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164292; c=relaxed/simple;
	bh=x7At7xP0ZM/BiS7NmGyOflYOdgJptDlceGNuen9Zlno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqimMohYA+c1ljevSoqMguYDojxraKGWKkJKRzk/jhHdquByGruE4zI7dplCVaHwWiZQ56wPB2J3BTKDD733HJqrLi30KaM1H1s3zQxrjHPheSzTVXVAGxm7opNMUSa5Xy9UtbrYO6iDhbtZt9D5N9DGpIJZGlFUvrADpoNGN0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EIurXU0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EIurXU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8EF1F00893;
	Sat, 30 May 2026 18:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164290;
	bh=C6UTqnu5y0LrRB0ZGX9QffUlO3PYGYExTM+iBWUi5yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EIurXU0ToacSenY0FMjex1EnhBRKIab4i16YhWTsWpH0VRLJrSYK9xoahms54Yfc
	 Fj8vEEeAtKW4F0wf4zMtL4l6JLETKeCm1ZsS6ZfsiSS8vSIx66pK9wh2YyLcvMYClv
	 KdsE7548McSW/jh4+ScIb8PVm00irKzX/lCMZNGw=
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
Subject: [PATCH 5.15 493/776] unshare: fix nsproxy leak in ksys_unshare() on set_cred_ucounts() failure
Date: Sat, 30 May 2026 18:03:27 +0200
Message-ID: <20260530160253.050921551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e1b291e5e1038..eb772b1e819f2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3176,11 +3176,10 @@ int ksys_unshare(unsigned long unshare_flags)
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
@@ -3196,8 +3195,10 @@ int ksys_unshare(unsigned long unshare_flags)
 			shm_init_task(current);
 		}
 
-		if (new_nsproxy)
+		if (new_nsproxy) {
 			switch_task_namespaces(current, new_nsproxy);
+			new_nsproxy = NULL;
+		}
 
 		task_lock(current);
 
@@ -3229,13 +3230,15 @@ int ksys_unshare(unsigned long unshare_flags)
 
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



