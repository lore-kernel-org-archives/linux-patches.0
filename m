Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843FF4DB55B;
	Mon, 31 Aug 2026 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183563; cv=none; b=XS8GwBb291kYx5OiqSTN+2BH7OaoA9IhN7eXwA/u5B/4pVb8Cc0LTYFG4Q9FIomeRyGQP/+hPzfKVxSSzzHQlWTVM3RR8OwM+BUGiPpf9LQyeJtGAhUYN0joXGHCWws2ZAECMiMW4ZQ0NpK7WFmbu18VBWNFDVA01K+pViBVlik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183563; c=relaxed/simple;
	bh=HH24XWvydhd1vQzRcM2Zbn1brg334Bma9RHnz0kEhMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwV74DyRd6HSDfvdPxTQFsgo6TGua93gC8rwdzxQgFeZlHwmg0BMHL86HNutCwIO6S2F3Z03HEAmrZxxAWLzrMHFvqqkKowpM/7+EfzmDiWqSzn1Nwa4h9YM0+D4/G/eipxR+apKdkX0fJq9KIluTf4WOjhdh8M3susGeYBdgow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d21Yl5wo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d21Yl5wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220FD1F00A3D;
	Mon, 31 Aug 2026 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183561;
	bh=iSE3A/991G2j5h93MT0YhlQUKs7zgjb2Y7gc1xL3Tj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d21Yl5woAoeJXKbCf80q9eidORX9lo0u74zHl+sdLzrShjUvrdcEjhjGpGsjyiJvW
	 hLkHiXPpOg3ERZK8o1OfR0PxZvvETkfV1uvr91sN78n9+76Otexkfu6wSlgKn3esa+
	 yS1kYY4j0CE0Ke7KDcyQmRKQVTMHCyABhtZVL4kkjIrAUSiJluObAaGid5c2pbKC6+
	 cj/tA6ceE614o17/KbH0M9+b5GT3igA2yXMDsWHXF5fAo56oDGHNTqvdRrQAE1bOpG
	 6EKfzXbw6K1pEmleIIXSwwip2SC7MTT5yGOSRMVQneLW+M6TMxc4Eq17wXq6PHPwYV
	 OOF9k2jQtSVFg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhanjun Dong <zhanjun.dong@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/xe: Fix null pointer dereference in devcoredump cleanup
Date: Mon, 31 Aug 2026 09:23:18 -0400
Message-ID: <20260831133314.4125787-170-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhanjun Dong <zhanjun.dong@intel.com>

[ Upstream commit 12ef528d78adc8ea4e7e3db594f3bcac327e79fa ]

In xe_devcoredump_snapshot_free(), ss->gt may be NULL when the snapshot
was never fully populated (e.g., when cleanup is triggered without a
prior capture). Guard the xe_guc_capture_put_matched_nodes() call with
IS_ERR_OR_NULL() to prevent a null dereference.

In xe_devcoredump_free(), the deferred work is only queued when a
coredump is captured, so guard cancel_work_sync() with a check on
coredump->captured.

Signed-off-by: Zhanjun Dong <zhanjun.dong@intel.com>
Reviewed-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20260326181017.2060209-1-zhanjun.dong@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The follow-up check completed: `git log` found no commits matching the
fix (`IS_ERR_OR_NULL(ss->gt)` or "devcoredump cleanup"), so it isn’t in
this tree yet. That matches the earlier read of `xe_devcoredump.c` — the
unconditional dereference and `cancel_work_sync()` are still there.
Backport recommendation remains **YES** for v6.18.43.

 drivers/gpu/drm/xe/xe_devcoredump.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_devcoredump.c b/drivers/gpu/drm/xe/xe_devcoredump.c
index 203e3038cc817..26a294f79e79f 100644
--- a/drivers/gpu/drm/xe/xe_devcoredump.c
+++ b/drivers/gpu/drm/xe/xe_devcoredump.c
@@ -150,7 +150,8 @@ static void xe_devcoredump_snapshot_free(struct xe_devcoredump_snapshot *ss)
 	xe_guc_ct_snapshot_free(ss->guc.ct);
 	ss->guc.ct = NULL;
 
-	xe_guc_capture_put_matched_nodes(&ss->gt->uc.guc);
+	if (!IS_ERR_OR_NULL(ss->gt))
+		xe_guc_capture_put_matched_nodes(&ss->gt->uc.guc);
 	ss->matched_node = NULL;
 
 	xe_guc_exec_queue_snapshot_free(ss->ge);
@@ -255,7 +256,8 @@ static void xe_devcoredump_free(void *data)
 	if (!data || !coredump_to_xe(coredump))
 		return;
 
-	cancel_work_sync(&coredump->snapshot.work);
+	if (coredump->captured)
+		cancel_work_sync(&coredump->snapshot.work);
 
 	mutex_lock(&coredump->lock);
 
-- 
2.53.0

