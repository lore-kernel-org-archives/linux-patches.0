Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AAE2BE7C0;
	Wed,  4 Feb 2026 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218272; cv=none; b=pCLQdxbwA4nxn0QxQbK04rDqzl6eG+4taNvAXJIfbAkxGsLXN8CEIhp055yP6yrTnhoCn0ejeSP0Tn7dWyjP50yZiwURenxg5kuV3qS0fV8Gemrv/Q6xRWZ8AE52EiuhMRzC/7AOVk4BLgzuAHj+JaPGj2kU2CGPIae3fYU4938=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218272; c=relaxed/simple;
	bh=5iFf3jn30wgNrKmPDLbLQmbnRIR3fPATdn/SCYHQAmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5oFx4yjiOV9CiUl+7eiWENEJ6TVHg27YBpOcO6IFDxolMcYNbQwfB3vC/3EM68dWew7zWY8qZzczwVAtvW3A645q9Ta+GoSwEgEMwg/LIM8Bnb7K1modKCA97+YxxREmCdAO1oeTZkoJRvqQmqM0EaBMHB2hQmoppRyUkRTgcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbRcX3Nt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbRcX3Nt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029DEC4CEF7;
	Wed,  4 Feb 2026 15:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218272;
	bh=5iFf3jn30wgNrKmPDLbLQmbnRIR3fPATdn/SCYHQAmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbRcX3NtRZ5ZeOaowJHXzsq/lfsfYPeDlNW73EHmyzQ934Mjr6MyXd/TVnnepewSU
	 cnoMBrYqYpoCtVh11+2Opxpw8MEQII1/2MwZeU+XpX4M3fWl9s8Q6mVLKBHL3Rmbf8
	 hvwvZp7jfw6f4rkji4cTIVRn2G4g5O6gr6jsEiTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.1 261/280] blk-cgroup: Reinit blkg_iostat_set after clearing in blkcg_reset_stats()
Date: Wed,  4 Feb 2026 15:40:35 +0100
Message-ID: <20260204143919.090825055@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 3d2af77e31ade05ff7ccc3658c3635ec1bea0979 ]

When blkg_alloc() is called to allocate a blkcg_gq structure
with the associated blkg_iostat_set's, there are 2 fields within
blkg_iostat_set that requires proper initialization - blkg & sync.
The former field was introduced by commit 3b8cc6298724 ("blk-cgroup:
Optimize blkcg_rstat_flush()") while the later one was introduced by
commit f73316482977 ("blk-cgroup: reimplement basic IO stats using
cgroup rstat").

Unfortunately those fields in the blkg_iostat_set's are not properly
re-initialized when they are cleared in v1's blkcg_reset_stats(). This
can lead to a kernel panic due to NULL pointer access of the blkg
pointer. The missing initialization of sync is less problematic and
can be a problem in a debug kernel due to missing lockdep initialization.

Fix these problems by re-initializing them after memory clearing.

Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
Fixes: f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230606180724.2455066-1-longman@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Remove this line: bis -> blkg = blkg for blkg was introduced by commit
  3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()") since v6.2. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -531,8 +531,12 @@ static int blkcg_reset_stats(struct cgro
 			struct blkg_iostat_set *bis =
 				per_cpu_ptr(blkg->iostat_cpu, cpu);
 			memset(bis, 0, sizeof(*bis));
+
+			/* Re-initialize the cleared blkg_iostat_set */
+			u64_stats_init(&bis->sync);
 		}
 		memset(&blkg->iostat, 0, sizeof(blkg->iostat));
+		u64_stats_init(&blkg->iostat.sync);
 
 		for (i = 0; i < BLKCG_MAX_POLS; i++) {
 			struct blkcg_policy *pol = blkcg_policy[i];


