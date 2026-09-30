Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793FA51357D;
	Wed, 30 Sep 2026 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786657; cv=none; b=Bp9CzJsrKlknFOtgBLD1qLyZLenQlpZVJeO8T6QZWDsI5+0pxOo5zGe7lRFgfvPE1EJ7uleg+JwxTKJGRbxcNCBrSLDgDOOYOJJ2Gy1MaisXDMd2w5+P+Pkugt5lx8/5mwt3sTYxlHaLwWdNO01Xv59OncZ8d/2eXojE7vs3l0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786657; c=relaxed/simple;
	bh=coQ5/e+qM5q9Y+DAeryei6Yadtk2OI8I3kGZPBTEyX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1CDrrE0TvjOvijAS4Pj5ZvRXPr+eC4ntBhbWpDgn6xZK4riwggNVze169jzrb7sdM484SR1jxEoQ0gAEL/gbjAaxXPPPxwaza+uFELzznWtLeN/0Y6P0iFOZyv+I5TUtIi9neTAGFJZCfAB0vm+RgqXYs6+83+8pNct83jHISo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuvhsRr8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuvhsRr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4B71F000FF;
	Wed, 30 Sep 2026 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786656;
	bh=JNUeS8EC7lfLorc8QzF+fHPq19CJ9msmIMTlxaSs3Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuvhsRr8kHdubW6/1ibwl3dBDAcowuzhS5VI8mQ4HZ+MFsT2A5Lk/CYuqbaKrihhL
	 iWJMTKpL7XO7SrMpOoJomZ+G6IWfLu1wv5mxWzBILhmVq2hoHpvhPLKh8l9fwirl4P
	 oJMtPLsyje/1TwkCcz3+xSBIaglq0YFw7Cgderyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 940/982] drm/amdgpu: Fix last_update fence leak in amdgpu_vm_init()
Date: Wed, 30 Sep 2026 17:27:56 +0200
Message-ID: <20260930152436.930976010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit b4f7b4459b1b155e4c4977a6482b5df2cf08758c upstream.

amdgpu_vm_init() initializes vm->last_update, vm->last_unlocked and
vm->last_tlb_flush with references to the stub fence taken via
dma_fence_get_stub().  The error label at the end of the function
releases the last_unlocked and last_tlb_flush references with
dma_fence_put(), but the reference stored in vm->last_update is never
dropped, so whenever the page table root creation, the reservation of
the root BO or the PASID registration fails, the stub fence reference
leaks.

Drop the vm->last_update reference together with the other stub fence
references on the error path.

Fixes: 187916e6ed9d ("drm/amdgpu: install stub fence into potential unused fence pointers")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e7979c84fc05a176bdf855ee664871b1648404c9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2135,6 +2135,7 @@ error_free_root:
 	vm->root.bo = NULL;
 
 error_free_delayed:
+	dma_fence_put(vm->last_update);
 	dma_fence_put(vm->last_tlb_flush);
 	dma_fence_put(vm->last_unlocked);
 	drm_sched_entity_destroy(&vm->delayed);


