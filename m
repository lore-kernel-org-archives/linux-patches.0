Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC71175A87;
	Fri, 15 May 2026 15:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860490; cv=none; b=iCBMXu2XYYzZSRgZDeLq6TmaT3hXnN4XFbo9SPx6YOpTQDXWrBgu0nXQa6ZF7aQ4BXN4xqDPayfGId4AFw7LibDt2lELPFRCpfSYsP3NIWA37W67bVU4GtP78Ph2qdr9KqisyDaRrkWV6CnaA5Q8DmE2L54dbR6wVnMzpfp38YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860490; c=relaxed/simple;
	bh=Ktd8c9uz6DnSb3uv7cHWs8ZZ6ngdRSbuFQVZ6gsby/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOXx0lDmgYZPKJ6ND5Q4HS5Hn3SJ9eifVBonASvxitemwOeZsSXHOGy2MlryVW28+aRrFUkbmzKeu9wDgzj8TcXIu3ifzBccWj2KaOqLBbxF5FoDeENSEkufQxTrviKChbKoa9B9cEchcqYkA4Q5QqjO3befqYdL2tz7oKThgIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhCVAXXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhCVAXXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A2EC2BCB0;
	Fri, 15 May 2026 15:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860490;
	bh=Ktd8c9uz6DnSb3uv7cHWs8ZZ6ngdRSbuFQVZ6gsby/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhCVAXXcaosMPi7LdtPEpLfV4KbQja6pDpZZgcg0mx1X20ljBGPtOB1xAkwpGOQPc
	 z1MWrnVgTBSwYRPwM6ZupPcMnyNoofoZWzEY1xkFmYRliQ5/nMbpFiP+2OThfn6R6z
	 MBv5ehxD0PvElHxuPgHIiT0dRdvYj13XDNOZLIRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Shetaia <Amir.Shetaia@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 067/144] drm/amdkfd: Clear VRAM on allocation to prevent stale data exposure
Date: Fri, 15 May 2026 17:48:13 +0200
Message-ID: <20260515154655.098418734@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1737,7 +1737,8 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_
 			alloc_domain = AMDGPU_GEM_DOMAIN_GTT;
 			alloc_flags = 0;
 		} else {
-			alloc_flags = AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE;
+			alloc_flags = AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE |
+				AMDGPU_GEM_CREATE_VRAM_CLEARED;
 			alloc_flags |= (flags & KFD_IOC_ALLOC_MEM_FLAGS_PUBLIC) ?
 			AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED : 0;
 


