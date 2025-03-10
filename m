Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6097522DFF3;
	Mon, 10 Mar 2025 17:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629577; cv=none; b=N8P/jIWqGtCYLSs+GoZYrK+x1O4UYPLYO0X5UGVWjbp9rexnF144RMY/J+VbjD2JgtoP4IYauZVMgaGLm5uE4CU1IeXxtp3lzK3oxeZwQab70yBX113RNXoYOZy8hYr7nLvC2HyV8/ZreIuptXERhKLL3AgX/Eu2ll4oJFk6Eck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629577; c=relaxed/simple;
	bh=ZTCxl9CvJ3Lhp0Nb7K1hnauDUQbsgLEyPXOm0n5fBxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAEj2j71E4NFofzU7Rhav/9sraE4MzjlfdC00I/cjiVDOY5YqcE1xQ7+neO2oS8w9AgVXLrbYRnoMk692ARTURrJVPOoNmNovCemcXK54KU+h3AgVhxid19SY+SABVDNLEN5vn2qjr3o0wJVbFGVXLp5Jb1V+SwbLV2RHXiIdIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YA20+Dz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YA20+Dz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FF0C4CEE5;
	Mon, 10 Mar 2025 17:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629577;
	bh=ZTCxl9CvJ3Lhp0Nb7K1hnauDUQbsgLEyPXOm0n5fBxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YA20+Dz1mn6i7+6YWVZFbIhMqGPR6HaljF7d9g9MY9r97xEDT248B13FNvq26WSfP
	 YAA/QdCQ7pSTW2OlHgPhKdjWCx/zOKi8e0gcNePoNMX6BtU8AnVLeLfjUie3QkgytO
	 8oa1p+9rQ3RtuzHNRTX8v3lI3QkkKJEKeVr3L//g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Mikolaj Wasiak <mikolaj.wasiak@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/620] drm/i915/selftests: avoid using uninitialized context
Date: Mon, 10 Mar 2025 18:03:08 +0100
Message-ID: <20250310170559.112108489@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f843a5040706a..df3934a990d08 100644
--- a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
@@ -160,7 +160,7 @@ static int igt_ppgtt_alloc(void *arg)
 		return PTR_ERR(ppgtt);
 
 	if (!ppgtt->vm.allocate_va_range)
-		goto err_ppgtt_cleanup;
+		goto ppgtt_vm_put;
 
 	/*
 	 * While we only allocate the page tables here and so we could
@@ -228,7 +228,7 @@ static int igt_ppgtt_alloc(void *arg)
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



