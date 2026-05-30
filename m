Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70643A7848;
	Sat, 30 May 2026 17:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161307; cv=none; b=kaTMw5kahMcpoSniXmeuSvWUAVC5tQbuPylKw5V5VNhpWl/FVBPeCKyPTuXoXFsRkcnP1AD8erAkap6DdxNeDjGEiez+BFpOwEfETqRBaxg45mH7bsqPRepWs8IIKw3nhf8DoiCvpapWbVfCBPVQJV6jLTXfVtydSqrmvlCsP+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161307; c=relaxed/simple;
	bh=r7UHvwublkafXJWchB+cL5QK3WX3kBTAjno8btwAZiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaePJ51dwLaVE0/9Ok7+/hgrIYyl1ocGOvuDlnW1Sz2VufdmtgYQOP02xnIm2fkFw/9OJaw06febI/QAiHgb8JaivglJupLzIIUteGfW7KWnRYlqtIi4EJtCH33nyTB5d1reyjCTDIjEfXGfug7xhZk4tcaF4F0p5kCLUaMluMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVAzIXiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVAzIXiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9D81F00893;
	Sat, 30 May 2026 17:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161306;
	bh=dppS2R9Jqq4uM1EY6WlygO6oT50+ZNY/kFe3nZV8/Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVAzIXiT9W4jlKSnLIiGkV/ZvCxV6Q6D6XKRSYhxPJmkW3eafEOgZ152u3M8Q3RhY
	 AxdapT2dRLhRw3ZMM7CLVwBciBEUQ2H8aTtqbFdRA8kwIM0KYkcpNxjLrfKyibX2wF
	 uJmQFZrC6Cy80NiIMszIGZzsrS684TtKphdgqWm0=
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
Subject: [PATCH 6.1 585/969] unshare: fix nsproxy leak in ksys_unshare() on set_cred_ucounts() failure
Date: Sat, 30 May 2026 18:01:49 +0200
Message-ID: <20260530160316.566365667@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 96ecab82e38af..db2a9016f636f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3285,11 +3285,10 @@ int ksys_unshare(unsigned long unshare_flags)
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
@@ -3305,8 +3304,10 @@ int ksys_unshare(unsigned long unshare_flags)
 			shm_init_task(current);
 		}
 
-		if (new_nsproxy)
+		if (new_nsproxy) {
 			switch_task_namespaces(current, new_nsproxy);
+			new_nsproxy = NULL;
+		}
 
 		task_lock(current);
 
@@ -3335,13 +3336,15 @@ int ksys_unshare(unsigned long unshare_flags)
 
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



