Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B892C15A3;
	Tue, 15 Jul 2025 13:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586518; cv=none; b=gJdrygcwI2U0xOIYDc3/fwqGFAaYdS2xfORNIsg9wZTvp6uBtvCV/IXRsbFQjjAjGaPakUm6YdyyF4uA7ACARNUQvpvejc1ia4lpS9Gk2wTIR7C9jKVG6Y4p66lmByBorkDSKBJm26yqKwHkR6O2kljNP7A3ls6ErYAnVh6TBqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586518; c=relaxed/simple;
	bh=IvekdONGq4K4/Lbw8AhnmeMbk0b4vj8QbBM4dZDodzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNnnwnUaUElafd1VOFaRiis/ha1G+V1Jh89OFiZy+i4NE/1QjYBqjODnA7iI1VnY7MFVuj3DSpoGBaZyS1KUjesJjGFF3xaDrrwBH5MeSPMLip+U7Fpj+PMaJsYiDWeDgxzAGeBvdfaMi5mj/hCd1wM/S52QPG2k91A6uzF9sjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9HwxuEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9HwxuEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54D4C4CEE3;
	Tue, 15 Jul 2025 13:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586518;
	bh=IvekdONGq4K4/Lbw8AhnmeMbk0b4vj8QbBM4dZDodzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9HwxuEJl4ALTVLpTgHI8HzqU2r607kabaAQM0KSSqyDa47bPAfNYkLEdd80c1UEO
	 jEtev2a92MLiytNCbzjkJt6vnYgK11j4TtX7sqf9rFu1LKv7rGZZpw420xV0OZVDZG
	 KMlUhGu/pm9UF3mIvgKUG5QLzrGUDKF/gveLrc4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/148] drm/i915/selftests: Change mock_request() to return error pointers
Date: Tue, 15 Jul 2025 15:13:37 +0200
Message-ID: <20250715130804.119121149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/i915/selftests/i915_request.c | 20 ++++++++++---------
 drivers/gpu/drm/i915/selftests/mock_request.c |  2 +-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/selftests/i915_request.c b/drivers/gpu/drm/i915/selftests/i915_request.c
index b3688543ed7d0..6ee24f2061616 100644
--- a/drivers/gpu/drm/i915/selftests/i915_request.c
+++ b/drivers/gpu/drm/i915/selftests/i915_request.c
@@ -47,8 +47,10 @@ static int igt_add_request(void *arg)
 
 	mutex_lock(&i915->drm.struct_mutex);
 	request = mock_request(i915->engine[RCS0]->kernel_context, HZ / 10);
-	if (!request)
+	if (IS_ERR(request)) {
+		err = PTR_ERR(request);
 		goto out_unlock;
+	}
 
 	i915_request_add(request);
 
@@ -69,8 +71,8 @@ static int igt_wait_request(void *arg)
 
 	mutex_lock(&i915->drm.struct_mutex);
 	request = mock_request(i915->engine[RCS0]->kernel_context, T);
-	if (!request) {
-		err = -ENOMEM;
+	if (IS_ERR(request)) {
+		err = PTR_ERR(request);
 		goto out_unlock;
 	}
 	i915_request_get(request);
@@ -142,8 +144,8 @@ static int igt_fence_wait(void *arg)
 
 	mutex_lock(&i915->drm.struct_mutex);
 	request = mock_request(i915->engine[RCS0]->kernel_context, T);
-	if (!request) {
-		err = -ENOMEM;
+	if (IS_ERR(request)) {
+		err = PTR_ERR(request);
 		goto out_locked;
 	}
 
@@ -203,8 +205,8 @@ static int igt_request_rewind(void *arg)
 	GEM_BUG_ON(IS_ERR(ce));
 	request = mock_request(ce, 2 * HZ);
 	intel_context_put(ce);
-	if (!request) {
-		err = -ENOMEM;
+	if (IS_ERR(request)) {
+		err = PTR_ERR(request);
 		goto err_context_0;
 	}
 
@@ -216,8 +218,8 @@ static int igt_request_rewind(void *arg)
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



