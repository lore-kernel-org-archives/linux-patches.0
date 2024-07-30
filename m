Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205531A6166;
	Tue, 30 Jul 2024 16:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358101; cv=none; b=kcf80aZpBze6c+YtGE5yHpOysIBvuBgGVHbTobu4S7K1zDYjGzrVbGxI40YY6+TSzE6mqWk8Yr+Nz3pKvs2t1aQY2kxEOp0PuJJ9kEcu8G+7I0Ocy4Npu256Ts1/T1Dsp+JzXcnLs79CF5kHR4DrMS6W3QMVgbWJreHP4drqGzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358101; c=relaxed/simple;
	bh=K5Ur1T0smxztMsOXq1x08qTFNAqDIhQzSJriWyBNoEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDlrhosMOpEGvpfqN3YyFRzdgxrLBZnGS7/StH88dksMHXqqAsH+mQKhP8y0ssbScR9Ob1qUbtM6xsk5zu/+AiPBgTTnNBmqkFYwd1B9rhDECgpIQWqUgzx5fkcOk6xYTa2eEnb5RNJmluDYCnGosFFDZ9qX5C65vIqDxqwRB/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGLp50E+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGLp50E+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78509C4AF0E;
	Tue, 30 Jul 2024 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358101;
	bh=K5Ur1T0smxztMsOXq1x08qTFNAqDIhQzSJriWyBNoEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGLp50E+UyQK3VDgWM0rd0+4GmieYVQl1wEScDNN9k++2OPfeQ+Jsz/URvYtYyw7b
	 drJP5+qFbwJaqqNB65O8A7BsDJi+5Kle5P2pixEBb8cWe0LBl8kuzAuisu+8qYqpEQ
	 /DJoYPZnCn6Ivq/e1BdRBusqEog1WWyzIRcpjHUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 323/809] drm/ttm/tests: Let ttm_bo_test consider different ww_mutex implementation.
Date: Tue, 30 Jul 2024 17:43:19 +0200
Message-ID: <20240730151737.363816348@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit f85376c890ef470b64a7fea22eea5af18822f05c ]

PREEMPT_RT has a different locking implementation for ww_mutex. The
base mutex of struct ww_mutex is declared as struct WW_MUTEX_BASE. The
latter is defined as `mutex' for non-PREEMPT_RT builds and `rt_mutex'
for PREEMPT_RT builds.

Using mutex_lock() directly on the base mutex in
ttm_bo_reserve_deadlock() leads to compile error on PREEMPT_RT.

The locking-selftest has its own defines to deal with this and it is
probably best to defines the needed one within the test program since
their usefulness is limited outside of well known selftests.

Provide ww_mutex_base_lock() which points to the correct function for
PREEMPT_RT and non-PREEMPT_RT builds.

Fixes: 995279d280d1e ("drm/ttm/tests: Add tests for ttm_bo functions")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240619144630.4DliKOmr@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/tests/ttm_bo_test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
index 1f8a4f8adc929..9cc367a795341 100644
--- a/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
+++ b/drivers/gpu/drm/ttm/tests/ttm_bo_test.c
@@ -18,6 +18,12 @@
 
 #define BO_SIZE		SZ_8K
 
+#ifdef CONFIG_PREEMPT_RT
+#define ww_mutex_base_lock(b)			rt_mutex_lock(b)
+#else
+#define ww_mutex_base_lock(b)			mutex_lock(b)
+#endif
+
 struct ttm_bo_test_case {
 	const char *description;
 	bool interruptible;
@@ -142,7 +148,7 @@ static void ttm_bo_reserve_deadlock(struct kunit *test)
 	bo2 = ttm_bo_kunit_init(test, test->priv, BO_SIZE);
 
 	ww_acquire_init(&ctx1, &reservation_ww_class);
-	mutex_lock(&bo2->base.resv->lock.base);
+	ww_mutex_base_lock(&bo2->base.resv->lock.base);
 
 	/* The deadlock will be caught by WW mutex, don't warn about it */
 	lock_release(&bo2->base.resv->lock.base.dep_map, 1);
-- 
2.43.0



