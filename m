Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8859E279DAF;
	Mon, 13 Oct 2025 15:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369336; cv=none; b=K/xhOnu5b7oBVLzPcWS8sr9YIvgTZO7VldRtRVa0lPvahnWValbrFeuxLNix/7pqNszY1Tg8hSUikRGpfJADnJz0k1EF9RD+oyEtRet5hgqgGerYxD8ghhblHTJwtXP58ihcR1VRD7A+5W0CubdiRRvomKnlrD9xNW25cCXi1iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369336; c=relaxed/simple;
	bh=hnI5s/FycRJEGna1oHiE6UAy5iUqypB9gmh2uWV6yek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhgIPDZ9IwqbCF32PvOkxlpP2zqb+7joQ9F0AosB+OMHojQ5bTl1rbhox/DHSxVncuGyA2Wh9AwyT6AemaxdLKZtZwP4C/spkuhaK1IohZu9Srzo3lgF7UeKakycomPJE72kfqXOScXIl0yHGxoKTdfNIwJkhED9g6ybIo/AQtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0J0M+0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0J0M+0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061FDC4CEE7;
	Mon, 13 Oct 2025 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369336;
	bh=hnI5s/FycRJEGna1oHiE6UAy5iUqypB9gmh2uWV6yek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0J0M+0xTdjMnEssDCyQhQB684KcwMb2a72DzksW8JAlBa5afIJegiM5wT4I2e4rt
	 u94756W9+iyp/GtCplXSqIArc7TO3XgQ2rMPFJWgImVFchC1NXaL2OwHboRm1BqjLy
	 hwT/ZTG7oGqhKVRhROLrpxGTgtAU71nUdkBnhEuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 211/563] drm/sched: Fix a race in DRM_GPU_SCHED_STAT_NO_HANG test
Date: Mon, 13 Oct 2025 16:41:12 +0200
Message-ID: <20251013144418.928427152@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit 2650bc4007c15e05f995f472b4fc89e793162bc4 ]

The "skip reset" test waits for the timeout handler to run for the
duration of 2 * MOCK_TIMEOUT, and because the mock scheduler opted to
remove the "skip reset" flag once it fires, this gives opportunity for the
timeout handler to run twice. Second time the job will be removed from the
mock scheduler job list and the drm_mock_sched_advance() call in the test
will fail.

Fix it by making the "don't reset" flag persist for the lifetime of the
job and add a new flag to verify that the code path had executed as
expected.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: 1472e7549f84 ("drm/sched: Add new test for DRM_GPU_SCHED_STAT_NO_HANG")
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Philipp Stanner <phasta@kernel.org>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://lore.kernel.org/r/20250716084817.56797-1-tvrtko.ursulin@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/tests/mock_scheduler.c | 2 +-
 drivers/gpu/drm/scheduler/tests/sched_tests.h    | 7 ++++---
 drivers/gpu/drm/scheduler/tests/tests_basic.c    | 4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/scheduler/tests/mock_scheduler.c b/drivers/gpu/drm/scheduler/tests/mock_scheduler.c
index 65acffc3fea82..8e9ae7d980eb2 100644
--- a/drivers/gpu/drm/scheduler/tests/mock_scheduler.c
+++ b/drivers/gpu/drm/scheduler/tests/mock_scheduler.c
@@ -219,7 +219,7 @@ mock_sched_timedout_job(struct drm_sched_job *sched_job)
 	unsigned long flags;
 
 	if (job->flags & DRM_MOCK_SCHED_JOB_DONT_RESET) {
-		job->flags &= ~DRM_MOCK_SCHED_JOB_DONT_RESET;
+		job->flags |= DRM_MOCK_SCHED_JOB_RESET_SKIPPED;
 		return DRM_GPU_SCHED_STAT_NO_HANG;
 	}
 
diff --git a/drivers/gpu/drm/scheduler/tests/sched_tests.h b/drivers/gpu/drm/scheduler/tests/sched_tests.h
index 63d4f2ac70749..5b262126b7760 100644
--- a/drivers/gpu/drm/scheduler/tests/sched_tests.h
+++ b/drivers/gpu/drm/scheduler/tests/sched_tests.h
@@ -95,9 +95,10 @@ struct drm_mock_sched_job {
 
 	struct completion	done;
 
-#define DRM_MOCK_SCHED_JOB_DONE		0x1
-#define DRM_MOCK_SCHED_JOB_TIMEDOUT	0x2
-#define DRM_MOCK_SCHED_JOB_DONT_RESET	0x4
+#define DRM_MOCK_SCHED_JOB_DONE			0x1
+#define DRM_MOCK_SCHED_JOB_TIMEDOUT		0x2
+#define DRM_MOCK_SCHED_JOB_DONT_RESET		0x4
+#define DRM_MOCK_SCHED_JOB_RESET_SKIPPED	0x8
 	unsigned long		flags;
 
 	struct list_head	link;
diff --git a/drivers/gpu/drm/scheduler/tests/tests_basic.c b/drivers/gpu/drm/scheduler/tests/tests_basic.c
index 55eb142bd7c5d..82a41a456b0a8 100644
--- a/drivers/gpu/drm/scheduler/tests/tests_basic.c
+++ b/drivers/gpu/drm/scheduler/tests/tests_basic.c
@@ -317,8 +317,8 @@ static void drm_sched_skip_reset(struct kunit *test)
 	KUNIT_ASSERT_FALSE(test, done);
 
 	KUNIT_ASSERT_EQ(test,
-			job->flags & DRM_MOCK_SCHED_JOB_DONT_RESET,
-			0);
+			job->flags & DRM_MOCK_SCHED_JOB_RESET_SKIPPED,
+			DRM_MOCK_SCHED_JOB_RESET_SKIPPED);
 
 	i = drm_mock_sched_advance(sched, 1);
 	KUNIT_ASSERT_EQ(test, i, 1);
-- 
2.51.0



