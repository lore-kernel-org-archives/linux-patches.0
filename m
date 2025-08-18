Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16306261B97;
	Mon, 18 Aug 2025 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525411; cv=none; b=NZSsBczqUgTaGYZQiHjpr4ri2rrHC6QZTDLtz8JsMs18Nf4NvSWsMIs2bwAODnYO5v0f7bD9hE8dKQhlyQwdVqbnhsyIUb6Grqn6jZZGPHR2cV5/iKvHbiLQ5iGtUBRgIMwKRMoiNIbY0F44d4GeMWx9a/reQXLrQWXToW9B/44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525411; c=relaxed/simple;
	bh=XigxmDx/mC98HOPwtOaAi5KRnHCWgnKU5gC8dr8zU5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckQW01d9d+S9/ZIOEbRtOjxmgN9G+GfLAhwFiXmyZiQch9dKD0q8i7Jx/oG+DSHI5Atws7c39mP43WwTr+LdaCKk7cMDpCE07w2HRVNgjUE7TXrDsqvpv8chHjxJopRwDrLw8/ggYI/xNLXosb1JFay5N3Yql0vIo7I4YIrm+XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEARwMVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEARwMVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CFBC4CEEB;
	Mon, 18 Aug 2025 13:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525410;
	bh=XigxmDx/mC98HOPwtOaAi5KRnHCWgnKU5gC8dr8zU5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEARwMVVvjS3HE0/8xHudT9ns0w+Hkr8MPzIV1jax5iSpf6PxWImnpJvxhWnImbnX
	 cSRezuu0JC/TQLKdHX55UdF+BSIYeO5Jwn4RUG1kjuoyEdnWo3fobE/OUa4g1njB9p
	 u2dbbMdGG7N9WAYtcZf/7AOKKMLOUtpVDMKvVUBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 255/570] drm/sched/tests: Add unit test for cancel_job()
Date: Mon, 18 Aug 2025 14:44:02 +0200
Message-ID: <20250818124515.641232068@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

[ Upstream commit c2668a0e03501a26cedc82e32fe9f3f692d330db ]

The scheduler unit tests now provide a new callback, cancel_job(). This
callback gets used by drm_sched_fini() for all still pending jobs to
cancel them.

Implement a new unit test to test this.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://lore.kernel.org/r/20250710125412.128476-6-phasta@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/tests/tests_basic.c | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/gpu/drm/scheduler/tests/tests_basic.c b/drivers/gpu/drm/scheduler/tests/tests_basic.c
index 7230057e0594..b1ae10c6bb37 100644
--- a/drivers/gpu/drm/scheduler/tests/tests_basic.c
+++ b/drivers/gpu/drm/scheduler/tests/tests_basic.c
@@ -204,6 +204,47 @@ static struct kunit_suite drm_sched_basic = {
 	.test_cases = drm_sched_basic_tests,
 };
 
+static void drm_sched_basic_cancel(struct kunit *test)
+{
+	struct drm_mock_sched_entity *entity;
+	struct drm_mock_scheduler *sched;
+	struct drm_mock_sched_job *job;
+	bool done;
+
+	/*
+	 * Check that drm_sched_fini() uses the cancel_job() callback to cancel
+	 * jobs that are still pending.
+	 */
+
+	sched = drm_mock_sched_new(test, MAX_SCHEDULE_TIMEOUT);
+	entity = drm_mock_sched_entity_new(test, DRM_SCHED_PRIORITY_NORMAL,
+					   sched);
+
+	job = drm_mock_sched_job_new(test, entity);
+
+	drm_mock_sched_job_submit(job);
+
+	done = drm_mock_sched_job_wait_scheduled(job, HZ);
+	KUNIT_ASSERT_TRUE(test, done);
+
+	drm_mock_sched_entity_free(entity);
+	drm_mock_sched_fini(sched);
+
+	KUNIT_ASSERT_EQ(test, job->hw_fence.error, -ECANCELED);
+}
+
+static struct kunit_case drm_sched_cancel_tests[] = {
+	KUNIT_CASE(drm_sched_basic_cancel),
+	{}
+};
+
+static struct kunit_suite drm_sched_cancel = {
+	.name = "drm_sched_basic_cancel_tests",
+	.init = drm_sched_basic_init,
+	.exit = drm_sched_basic_exit,
+	.test_cases = drm_sched_cancel_tests,
+};
+
 static void drm_sched_basic_timeout(struct kunit *test)
 {
 	struct drm_mock_scheduler *sched = test->priv;
@@ -471,6 +512,7 @@ static struct kunit_suite drm_sched_credits = {
 
 kunit_test_suites(&drm_sched_basic,
 		  &drm_sched_timeout,
+		  &drm_sched_cancel,
 		  &drm_sched_priority,
 		  &drm_sched_modify_sched,
 		  &drm_sched_credits);
-- 
2.39.5



