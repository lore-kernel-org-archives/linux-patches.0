Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D153155753;
	Wed, 19 Feb 2025 08:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953944; cv=none; b=FAemv+vx1Axp1jpWV8oYnp2TWFScCa8nizeBQXu1hwaPT3NDIBpBMfiwYp3s3biyMPSJo5nhoV00sujAqlGE1at3zmhxK94OI/JCIc0aNbYGnFge8SIJIEZ87ZDEMKbsQS/27RVoApWSex7tQjJnLVe/+pYTHE2z6+0lToFd9Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953944; c=relaxed/simple;
	bh=cReloR3VdY0ZY8GZ6S/dmwYYNDc7TndHJ5m5AJdn7ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJeMjQ5Gq2fl+k5YmZ+7XCMiV+2BWpXKtf+Hl6bZAVhu9fbFcx9Yoc0IDO5zo9S0WExHitgVYcGmssDLnI5OPBiodZQuzdCiwgXAHXdJk8BUiwgttZwKk8u7/ni+sUirlUcqa2BClnPY4FuO7rY6nNDuNIbLlDY4K5FfSzsbtcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsE6Ilsj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsE6Ilsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35D3C4CEE6;
	Wed, 19 Feb 2025 08:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953944;
	bh=cReloR3VdY0ZY8GZ6S/dmwYYNDc7TndHJ5m5AJdn7ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsE6Ilsj8L4/9hb0+l/lLhNKuKJe66uO6jafXiXykC3Gcjntof3U/8LrZiWT5t3ea
	 oJXW9GYW4Cd4eMP8LIYNVVsEmM95y9SJ8Zz4kr0XNh4NeI3Pq7QtUC0YOHC43ruNtO
	 glw9MdtAs35E8olAEDG0C02s/3p2C3/a/3ZRzQEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Mikolaj Wasiak <mikolaj.wasiak@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 047/274] drm/i915/selftests: avoid using uninitialized context
Date: Wed, 19 Feb 2025 09:25:01 +0100
Message-ID: <20250219082611.364553331@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Karas <krzysztof.karas@intel.com>

[ Upstream commit 53139b3f9998ea07289e7b70b909fea2264a0de9 ]

There is an error path in igt_ppgtt_alloc(), which leads
to ww object being passed down to i915_gem_ww_ctx_fini() without
initialization. Correct that by only putting ppgtt->vm and
returning early.

Fixes: 480ae79537b2 ("drm/i915/selftests: Prepare gtt tests for obj->mm.lock removal")
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Mikolaj Wasiak <mikolaj.wasiak@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/iuaonpjc3rywmvhna6umjlvzilocn2uqsrxfxfob24e2taocbi@lkaivvfp4777
(cherry picked from commit 8d8334632ea62424233ac6529712868241d0f8df)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
index 5c397a2df70e2..5d27e1c733c52 100644
--- a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
@@ -168,7 +168,7 @@ static int igt_ppgtt_alloc(void *arg)
 		return PTR_ERR(ppgtt);
 
 	if (!ppgtt->vm.allocate_va_range)
-		goto err_ppgtt_cleanup;
+		goto ppgtt_vm_put;
 
 	/*
 	 * While we only allocate the page tables here and so we could
@@ -236,7 +236,7 @@ static int igt_ppgtt_alloc(void *arg)
 			goto retry;
 	}
 	i915_gem_ww_ctx_fini(&ww);
-
+ppgtt_vm_put:
 	i915_vm_put(&ppgtt->vm);
 	return err;
 }
-- 
2.39.5



