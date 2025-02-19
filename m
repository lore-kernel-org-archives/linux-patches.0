Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DA21DE4C9;
	Wed, 19 Feb 2025 08:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955468; cv=none; b=iov8DZqMuGIpHNXC8tPsQdVGpC8uQSsV0aPOHs/mhw25jGnnvfmkO9wVc5YN1wtZvyp1sX1hbdLT3IwOZMCiFBqmaOYOXKU0DXTW2supLDW5H01Z7jkO+G6fJBwjLf3b8y12gn4aRSkonzOUDKDKIBEt6Uh3yIkB5iQHTAU2FoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955468; c=relaxed/simple;
	bh=1FLkriyTQJzUojkgRY/TuGCLt8oH1LqUr//dUREFOcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/YdW/Hi2LQjB3Pb4Wa5jJtNDvJSVfZnrXkPC2ApxLxrobBWvJ/u80S4dUOaUpx6il+1JuH2ONXgtIv8vK9sbBRuUTPdw0qxSDwc/ADEYAZizpvqJsnmPe4A9JkJHQOhi4fjW9mTvd4XFKPHC20giKlpZ8Q+s8/p5l18JFqobmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMUlp6yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMUlp6yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5461C4CED1;
	Wed, 19 Feb 2025 08:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955468;
	bh=1FLkriyTQJzUojkgRY/TuGCLt8oH1LqUr//dUREFOcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMUlp6yqWBQChX2AVUVkGOt2bCXPBd+ie/IYJxupV/zhQujrbH8ZzO6lxU31nPysb
	 GL6pxMXnE3/b3+mcjkY3TVghTubFEOnubJnXu1VgwBaGh+0eRDBpNcSUe9ezoFaO9K
	 BHDaHRpI1iO20wtJgtwibbhPi38s/R5rpvsfPdRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Mikolaj Wasiak <mikolaj.wasiak@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/152] drm/i915/selftests: avoid using uninitialized context
Date: Wed, 19 Feb 2025 09:27:09 +0100
Message-ID: <20250219082550.669215531@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



