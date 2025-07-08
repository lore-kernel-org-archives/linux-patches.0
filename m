Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF691DB127;
	Tue,  8 Jul 2025 16:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993533; cv=none; b=NL8E/SuCI+09DVBVPfoaBpNKtdQ+eHcqYwvzkAMihIPWpl5i1Y5YMM5vPiI7eVgontgv4ue/gqgm/gzmQNrhEEO6vNh+tySn+KRoIrWUNvbdaq25z6DBEuQsYXOYXuE4TIpWT/dRorEiZIWENEH8utFqghA9BiHvh1JjA/H52Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993533; c=relaxed/simple;
	bh=7JJluCZhmgndw92rH2Z8bMMOc2xGCWeMWJfYCa1oXi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikpWDQjqD6Va55EaL84O+gaAadw66Vvq3R2ol5/xVuhYmaauqykj3Z8Of2gnSYy3+MHFJ+Hw0hybjSMAZEE4o+QgLmZEjW0yrQHNcw/mk4LAO1RKji48t1s3OMyfk2zXgC/BLj3763wiHjUj9cHtlsD4kyinWNoaTfPI/bO++gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DH5Nozz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DH5Nozz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBACC4CEED;
	Tue,  8 Jul 2025 16:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993533;
	bh=7JJluCZhmgndw92rH2Z8bMMOc2xGCWeMWJfYCa1oXi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DH5Nozz1Mf5GPlw8IeJWlBfnPVu05uOLty2u9khUSWCjQfXfBl3ZDOxzzc9pa8KyQ
	 n0KgApPUWbOK1/eE1lxLy++7w1bivj1xXWqb9ZuWVk1rlECNwSkfbxzoG20zT2ete0
	 MLDJS0ehYOSNEIob8iLtVYbNcEmK2bbW67JQX4uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 076/178] drm/i915/selftests: Change mock_request() to return error pointers
Date: Tue,  8 Jul 2025 18:21:53 +0200
Message-ID: <20250708162238.663450810@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit caa7c7a76b78ce41d347003f84975125383e6b59 ]

There was an error pointer vs NULL bug in __igt_breadcrumbs_smoketest().
The __mock_request_alloc() function implements the
smoketest->request_alloc() function pointer.  It was supposed to return
error pointers, but it propogates the NULL return from mock_request()
so in the event of a failure, it would lead to a NULL pointer
dereference.

To fix this, change the mock_request() function to return error pointers
and update all the callers to expect that.

Fixes: 52c0fdb25c7c ("drm/i915: Replace global breadcrumbs with per-context interrupt tracking")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://lore.kernel.org/r/685c1417.050a0220.696f5.5c05@mx.google.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 778fa8ad5f0f23397d045c7ebca048ce8def1c43)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/selftests/i915_request.c | 20 +++++++++----------
 drivers/gpu/drm/i915/selftests/mock_request.c |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/selftests/i915_request.c b/drivers/gpu/drm/i915/selftests/i915_request.c
index 88870844b5bd9..2fb7a9e7efec6 100644
--- a/drivers/gpu/drm/i915/selftests/i915_request.c
+++ b/drivers/gpu/drm/i915/selftests/i915_request.c
@@ -73,8 +73,8 @@ static int igt_add_request(void *arg)
 	/* Basic preliminary test to create a request and let it loose! */
 
 	request = mock_request(rcs0(i915)->kernel_context, HZ / 10);
-	if (!request)
-		return -ENOMEM;
+	if (IS_ERR(request))
+		return PTR_ERR(request);
 
 	i915_request_add(request);
 
@@ -91,8 +91,8 @@ static int igt_wait_request(void *arg)
 	/* Submit a request, then wait upon it */
 
 	request = mock_request(rcs0(i915)->kernel_context, T);
-	if (!request)
-		return -ENOMEM;
+	if (IS_ERR(request))
+		return PTR_ERR(request);
 
 	i915_request_get(request);
 
@@ -160,8 +160,8 @@ static int igt_fence_wait(void *arg)
 	/* Submit a request, treat it as a fence and wait upon it */
 
 	request = mock_request(rcs0(i915)->kernel_context, T);
-	if (!request)
-		return -ENOMEM;
+	if (IS_ERR(request))
+		return PTR_ERR(request);
 
 	if (dma_fence_wait_timeout(&request->fence, false, T) != -ETIME) {
 		pr_err("fence wait success before submit (expected timeout)!\n");
@@ -219,8 +219,8 @@ static int igt_request_rewind(void *arg)
 	GEM_BUG_ON(IS_ERR(ce));
 	request = mock_request(ce, 2 * HZ);
 	intel_context_put(ce);
-	if (!request) {
-		err = -ENOMEM;
+	if (IS_ERR(request)) {
+		err = PTR_ERR(request);
 		goto err_context_0;
 	}
 
@@ -237,8 +237,8 @@ static int igt_request_rewind(void *arg)
 	GEM_BUG_ON(IS_ERR(ce));
 	vip = mock_request(ce, 0);
 	intel_context_put(ce);
-	if (!vip) {
-		err = -ENOMEM;
+	if (IS_ERR(vip)) {
+		err = PTR_ERR(vip);
 		goto err_context_1;
 	}
 
diff --git a/drivers/gpu/drm/i915/selftests/mock_request.c b/drivers/gpu/drm/i915/selftests/mock_request.c
index 09f747228dff5..1b0cf073e9643 100644
--- a/drivers/gpu/drm/i915/selftests/mock_request.c
+++ b/drivers/gpu/drm/i915/selftests/mock_request.c
@@ -35,7 +35,7 @@ mock_request(struct intel_context *ce, unsigned long delay)
 	/* NB the i915->requests slab cache is enlarged to fit mock_request */
 	request = intel_context_create_request(ce);
 	if (IS_ERR(request))
-		return NULL;
+		return request;
 
 	request->mock.delay = delay;
 	return request;
-- 
2.39.5



