Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8498A3F871C;
	Fri, 15 May 2026 16:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861574; cv=none; b=Y5j7aiBRTC2+lP0QwLqtW4czHE714LySiKF8oVtZIuLbtoQcHvx17+refJ9WYYnMl8FbK5BELYKae9u5tOnYUhA3t/VIkQU+I8oCwlTv0ROycTvdkMOL4HGdfAiiudId3ufGdWMB8n/Hzghz6SQqsr3dqd4lHDBOM4m0GyvsIRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861574; c=relaxed/simple;
	bh=vJ9yP/Ta0Dyg5aag/dEiu5GO0AJswFVJDPtgNVpwnd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qkysFLLIHtd1J5wJ4yQTIk5BdtlfnxGHQcQrbOiLPZYZxNkVGyFbjNq4UM4cfShEBrL3JulnaS5nOplwufavNxpmbRc039cIdTHEkOPewIkZsOIIWhSYJgJS0ec5c/qZTO5Nd57ZHk9+0InX9+3lnW1xmNzFjr6oBkRWNtJZ0Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIJrVqxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIJrVqxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7A1C2BCB0;
	Fri, 15 May 2026 16:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861574;
	bh=vJ9yP/Ta0Dyg5aag/dEiu5GO0AJswFVJDPtgNVpwnd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIJrVqxBSw0nd0x5RYaFvTvbp8Sbb7bBxRoMldKd6eMaS1su+x+640AuLxDH5RE0q
	 gJ4U2WYLIPnMZew89MDHHIjre618RgoshcbktmmVGh5jYi6Xj4cLZo+fpEgQIj7LJ4
	 SnXFP2ijn69FfU16HqNWEDmW+4vm9BmN8Rj//KpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Shetaia <Amir.Shetaia@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 340/474] drm/amdkfd: Clear VRAM on allocation to prevent stale data exposure
Date: Fri, 15 May 2026 17:47:29 +0200
Message-ID: <20260515154722.371750394@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Amir Shetaia <Amir.Shetaia@amd.com>

commit ad52d61d82181dbdb7f05826de38352d5e550cc2 upstream.

KFD VRAM allocations set AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE
but not AMDGPU_GEM_CREATE_VRAM_CLEARED, leaving freshly allocated
VRAM with stale data from prior use observable by compute kernels.

The GEM ioctl path already sets VRAM_CLEARED for all userspace
allocations via amdgpu_gem_create_ioctl() and
amdgpu_mode_dumb_create(). The KFD path was missing this flag,
allowing stale page table remnants to leak into user buffers.

This causes crashes in RCCL P2P transport where non-zero data in
ptrExchange/head/tail fields corrupts the protocol handshake.

Signed-off-by: Amir Shetaia <Amir.Shetaia@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1665,7 +1665,8 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_
 			alloc_domain = AMDGPU_GEM_DOMAIN_GTT;
 			alloc_flags = 0;
 		} else {
-			alloc_flags = AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE;
+			alloc_flags = AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE |
+				AMDGPU_GEM_CREATE_VRAM_CLEARED;
 			alloc_flags |= (flags & KFD_IOC_ALLOC_MEM_FLAGS_PUBLIC) ?
 			AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED : 0;
 		}


