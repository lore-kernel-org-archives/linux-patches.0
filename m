Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D277D3FA5FA;
	Wed, 20 May 2026 18:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301332; cv=none; b=KbdI8fSY/HqvM8ZebqNPMSiC4HZkiXYUSWMZgggZYSGFd86ID1PalEHD+L/I1B3BWl2+q20O14gpEahvAjBQAugiZJfuR6eecALFSH5w/Cf87tYKIyPbXd8cRtSdngsi48h6YmXPH2ToaoPLoRezC0DuimIq1+XCpRRN/yIaC7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301332; c=relaxed/simple;
	bh=GMXWTlQu5BDrmhBy4DSqI1ZEyz0Eeh1avqHr/Kicwwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twWzei/w0njI2OsM2T3StYeL2PX0fezfCkS1MpSvVc4jFHpRfWG4QscojOx4Cibdh2TehiZg2pQFJRC+yFhBeee3wGkzVwmDA9msYk+U4m+o8UXZ4kTWFT3NnWWdiCFehIxzaGbhZiCvJr1WMyAtL82SQSofRdtDjeITUxstrkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qwjN1aM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qwjN1aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4161F000E9;
	Wed, 20 May 2026 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301330;
	bh=ZFZxSv6959ZNB7kCQgfrhKLlsXzKudfzjw5Ieh2uapA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qwjN1aM9hOfF9yoNaGgvUBD3Sh80p4Ta6rI5XzyVkM33KBT2Rdd+aWhYrCstHdCC
	 WyCsSQd1/84oHifl/D5tVb00DY/ngRmKRj26lvr0kHNmRqHFCLAMendmvYWGcKMvRw
	 da/eR3cZxzk+8td9bWl3UvZw5iLYQFjPFbCTv2gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Malat <oss@malat.biz>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 513/666] cgroup: Increment nr_dying_subsys_* from rmdir context
Date: Wed, 20 May 2026 18:22:04 +0200
Message-ID: <20260520162122.381396286@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Malat <oss@malat.biz>

[ Upstream commit 13e786b64bd3fd81c7eb22aa32bf8305c32f2ccf ]

Incrementing nr_dying_subsys_* in offline_css(), which is executed by
cgroup_offline_wq worker, leads to a race where user can see the value
to be 0 if he reads cgroup.stat after calling rmdir and before the worker
executes. This makes the user wrongly expect resources released by the
removed cgroup to be available for a new assignment.

Increment nr_dying_subsys_* from kill_css(), which is called from the
cgroup_rmdir() context.

Fixes: ab0312526867 ("cgroup: Show # of subsystem CSSes in cgroup.stat")
Signed-off-by: Petr Malat <oss@malat.biz>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0914a1a189ee1..dfb93a201fc32 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5654,16 +5654,6 @@ static void offline_css(struct cgroup_subsys_state *css)
 	RCU_INIT_POINTER(css->cgroup->subsys[ss->id], NULL);
 
 	wake_up_all(&css->cgroup->offline_waitq);
-
-	css->cgroup->nr_dying_subsys[ss->id]++;
-	/*
-	 * Parent css and cgroup cannot be freed until after the freeing
-	 * of child css, see css_free_rwork_fn().
-	 */
-	while ((css = css->parent)) {
-		css->nr_descendants--;
-		css->cgroup->nr_dying_subsys[ss->id]++;
-	}
 }
 
 /**
@@ -5965,6 +5955,8 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
  */
 static void kill_css(struct cgroup_subsys_state *css)
 {
+	struct cgroup_subsys *ss = css->ss;
+
 	lockdep_assert_held(&cgroup_mutex);
 
 	if (css->flags & CSS_DYING)
@@ -6001,6 +5993,16 @@ static void kill_css(struct cgroup_subsys_state *css)
 	 * css is confirmed to be seen as killed on all CPUs.
 	 */
 	percpu_ref_kill_and_confirm(&css->refcnt, css_killed_ref_fn);
+
+	css->cgroup->nr_dying_subsys[ss->id]++;
+	/*
+	 * Parent css and cgroup cannot be freed until after the freeing
+	 * of child css, see css_free_rwork_fn().
+	 */
+	while ((css = css->parent)) {
+		css->nr_descendants--;
+		css->cgroup->nr_dying_subsys[ss->id]++;
+	}
 }
 
 /**
-- 
2.53.0



