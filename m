Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213B430595C;
	Tue,  6 Jan 2026 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722442; cv=none; b=IGoZyOX/JqjD7XtwWJNIUORIYqYLhwTWnFqx+C6RuL4SvMgI71NDh3GtdxuINEy2RYrGTPhVk2tEXvnuwS0E9yr6IF748u9rTtmZOu/sHREahJJx+zFdM8FR5vRwf9y7JMNvBBDOPT8Ro9gqputG/7F3TPTFyEvhQZQeVHrfKz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722442; c=relaxed/simple;
	bh=/UD+DLte2UOUGqd4PHiNbBwU0EGBBIs17IXvbYD+Qbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=InWWzjQLZXNFbjb21hIraNtXzr27X246KI0PhY1jsI/q8iNItWp6jKl/gQ3JqF4XxrNda5zUzY9BmjKwlwhV2oGQ+XB/sQ2fS0kYQ9kKQvVuFdwgChvKTApAdZHCPj+O8gCceXisOecZmGaw9Don6usHd1CAVwROWvKtLETKg2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODjhPtQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODjhPtQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEE5C116C6;
	Tue,  6 Jan 2026 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722442;
	bh=/UD+DLte2UOUGqd4PHiNbBwU0EGBBIs17IXvbYD+Qbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODjhPtQk8PWevKJrncHvEJ6oRzL+fJkFjkeHgQFim27S+ZjV1fm5jDpQQsNc2jo+Q
	 Xk8VocmJmA9o5jCUHwfHItKSVTXoCGUPfjoU3F0HkCC0jsTCAS1Uz5RcU+m86oqB++
	 SAaWF21rXjrEUbn0cTofJKiMLCM2qE6dVUYvKWqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 264/312] drm/amdgpu: Forward VMID reservation errors
Date: Tue,  6 Jan 2026 18:05:38 +0100
Message-ID: <20260106170557.396775615@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Natalie Vock <natalie.vock@gmx.de>

commit 8defb4f081a5feccc3ea8372d0c7af3522124e1f upstream.

Otherwise userspace may be fooled into believing it has a reserved VMID
when in reality it doesn't, ultimately leading to GPU hangs when SPM is
used.

Fixes: 80e709ee6ecc ("drm/amdgpu: add option params to enforce process isolation between graphics and compute")
Cc: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2910,8 +2910,7 @@ int amdgpu_vm_ioctl(struct drm_device *d
 	switch (args->in.op) {
 	case AMDGPU_VM_OP_RESERVE_VMID:
 		/* We only have requirement to reserve vmid from gfxhub */
-		amdgpu_vmid_alloc_reserved(adev, vm, AMDGPU_GFXHUB(0));
-		break;
+		return amdgpu_vmid_alloc_reserved(adev, vm, AMDGPU_GFXHUB(0));
 	case AMDGPU_VM_OP_UNRESERVE_VMID:
 		amdgpu_vmid_free_reserved(adev, vm, AMDGPU_GFXHUB(0));
 		break;


