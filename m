Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B9933C1B6;
	Fri,  9 Jan 2026 12:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961179; cv=none; b=EZ+9lbnpJdbLCUy0VpeNH2c5O0V6kNzqWekvYQ4cXAPNVZ3dIiaE3y3myj1FuDybfQWNmXE7j735EC7dg9L3QmBmJVY1JfLjSogOOYbTlCfI41GBUx78V0WW1NXAfPGDmIKb0JWVn/0C0rsPBlRxD6NV1hAyEEIXnYRg8xRHsh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961179; c=relaxed/simple;
	bh=uSyX+aPQhDw6+F70Zltk1ftC+OMP2sTcCOQwSxE389I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWcBnTHrIsZTdE8lXs+xxqfH+HGSdJhZocc0g5/HiRBEoAT3EOUWwirxmMy0l1KI+CtWSlKNmXWet7L/oNGw03xfjfFyzAsdgpES62PmQi9LxLZyXWh/vsv/ws3Ji07T0UA20OnyzSCYu1We+5UUwIa0OsWIJITQ0hX23J9pLhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnWCPOH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnWCPOH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB79C4CEF1;
	Fri,  9 Jan 2026 12:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961179;
	bh=uSyX+aPQhDw6+F70Zltk1ftC+OMP2sTcCOQwSxE389I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnWCPOH2nohHEcypFzePD/tZoC3Qh2BMbvb2myuC9vq42n1M/u5+slT9aa+PHh0mL
	 5Z7A+A+XBVzttfvuBLs7Ds0h2VbP/MMZQc3q+HltSPj+qATMxxVJZZQydiZaPPAV2R
	 riH5OG8gFqZWrpEOO+rf1QisM91O86yirOf+jyOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 662/737] drm/amdgpu: Forward VMID reservation errors
Date: Fri,  9 Jan 2026 12:43:21 +0100
Message-ID: <20260109112158.943450673@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Natalie Vock <natalie.vock@gmx.de>

[ Upstream commit 8defb4f081a5feccc3ea8372d0c7af3522124e1f ]

Otherwise userspace may be fooled into believing it has a reserved VMID
when in reality it doesn't, ultimately leading to GPU hangs when SPM is
used.

Fixes: 80e709ee6ecc ("drm/amdgpu: add option params to enforce process isolation between graphics and compute")
Cc: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ adapted 3-argument amdgpu_vmid_alloc_reserved(adev, vm, vmhub) call to 2-argument version and added separate error check to preserve reserved_vmid tracking logic. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2496,10 +2496,12 @@ int amdgpu_vm_ioctl(struct drm_device *d
 	case AMDGPU_VM_OP_RESERVE_VMID:
 		/* We only have requirement to reserve vmid from gfxhub */
 		if (!fpriv->vm.reserved_vmid[AMDGPU_GFXHUB(0)]) {
-			amdgpu_vmid_alloc_reserved(adev, AMDGPU_GFXHUB(0));
+			int r = amdgpu_vmid_alloc_reserved(adev, AMDGPU_GFXHUB(0));
+
+			if (r)
+				return r;
 			fpriv->vm.reserved_vmid[AMDGPU_GFXHUB(0)] = true;
 		}
-
 		break;
 	case AMDGPU_VM_OP_UNRESERVE_VMID:
 		if (fpriv->vm.reserved_vmid[AMDGPU_GFXHUB(0)]) {


