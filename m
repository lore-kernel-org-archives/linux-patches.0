Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1260D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67926C433EF;
	Mon, 12 Jun 2023 10:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566916;
	bh=jPXj7UZWK8yM4MXRrOA1TDLPsTkxYnw7zLnVDivUqzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFGvhJnV5bf6Ej4CYb7PkKsZTSomfksk+klgfaNcTmM1hEvYprjcEW18ip7z2eAKf
	 t0vsWgw5jXk+lBZIVuyx4bx9mh6WUJqq14UaBH1QOoLqkxNtrPiT/yqAVmDlYqATZw
	 RAZPeLZm4ec91tSrjnXRgH1lwirlenQkcFHRLq7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 052/160] drm/i915/selftests: Add some missing error propagation
Date: Mon, 12 Jun 2023 12:26:24 +0200
Message-ID: <20230612101717.408518760@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

[ Upstream commit 79d0150d2d983a4f6efee676cea06027f586fcd0 ]

Add some missing error propagation in live_parallel_switch.

To avoid needlessly burdening the various backport processes, note I am
not marking it as a fix against any patches and not copying stable since
it is debug/selftests only code.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Fixes: 50d16d44cce4 ("drm/i915/selftests: Exercise context switching in parallel")
Fixes: 6407cf533217 ("drm/i915/selftests: Stop using kthread_stop()")
Link: https://patchwork.freedesktop.org/patch/msgid/20230605131135.396854-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit 412fa1f097f48c8c1321806dd25e46618e0da147)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/gem/selftests/i915_gem_context.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
index a81fa6a20f5aa..7b516b1a4915b 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c
@@ -346,8 +346,10 @@ static int live_parallel_switch(void *arg)
 				continue;
 
 			ce = intel_context_create(data[m].ce[0]->engine);
-			if (IS_ERR(ce))
+			if (IS_ERR(ce)) {
+				err = PTR_ERR(ce);
 				goto out;
+			}
 
 			err = intel_context_pin(ce);
 			if (err) {
@@ -367,8 +369,10 @@ static int live_parallel_switch(void *arg)
 
 		worker = kthread_create_worker(0, "igt/parallel:%s",
 					       data[n].ce[0]->engine->name);
-		if (IS_ERR(worker))
+		if (IS_ERR(worker)) {
+			err = PTR_ERR(worker);
 			goto out;
+		}
 
 		data[n].worker = worker;
 	}
@@ -397,8 +401,10 @@ static int live_parallel_switch(void *arg)
 			}
 		}
 
-		if (igt_live_test_end(&t))
-			err = -EIO;
+		if (igt_live_test_end(&t)) {
+			err = err ?: -EIO;
+			break;
+		}
 	}
 
 out:
-- 
2.39.2



