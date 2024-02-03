Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F0043163;
	Sat,  3 Feb 2024 04:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933651; cv=none; b=s1KYRKdbLiJd8NicN/DJy0irlg0uY+OeEZoyBqd1EkDRG9grG7ftQvADphar0tmJ7tWgSmV2OS8kjivjXcMzPhNo4KW7Q7/u1kqBl/VuAhjmJRbeodC+QpsIE+D5vkMgUgI66sgEKmSWjaUFZelv0TAIpIK23Z9QZrkmxpN+dM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933651; c=relaxed/simple;
	bh=lrv7JC9Y80gHjv9ioD7/yrM7geBEEFU97NNT0yXGMQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p6hWNicB5bLczxwi2v00vIGSsC2zTKkcXl9uEsEOjxylXXHe2ICAZ5XD3tS6dIHksQnJvmWeY3l4kpWu1uOlwknwoxEdQowWojwcy1P7NVUdR+6yRgOWwtCCd/dxLirLJi6ApanG78TCivOis2o4B7MnSnLiviK3LCvNC8kXFYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZkUXaAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZkUXaAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11788C433F1;
	Sat,  3 Feb 2024 04:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933651;
	bh=lrv7JC9Y80gHjv9ioD7/yrM7geBEEFU97NNT0yXGMQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZkUXaAnc2g55RrVawfwtewPwXjQDcEX06r91+PRLPeXaG69ytAiE6O/+KCIVbeus
	 S0cAbWn44BNB7eW+laVnOp9ZrexVgZ8+PYtpeyj1kDaulKZMv4+ZQKvlYCAK1GesxN
	 +mtU8LySu1V234VCJnBP5q5NxFTmlxWKTbE9bqB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/322] drm/amdgpu: Let KFD sync with VM fences
Date: Fri,  2 Feb 2024 20:05:08 -0800
Message-ID: <20240203035406.068757113@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit ec9ba4821fa52b5efdbc4cdf0a77497990655231 ]

Change the rules for amdgpu_sync_resv to let KFD synchronize with VM
fences on page table reservations. This fixes intermittent memory
corruption after evictions when using amdgpu_vm_handle_moved to update
page tables for VM mappings managed through render nodes.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
index dcd8c066bc1f..1b013a44ca99 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -191,7 +191,8 @@ static bool amdgpu_sync_test_fence(struct amdgpu_device *adev,
 
 	/* Never sync to VM updates either. */
 	if (fence_owner == AMDGPU_FENCE_OWNER_VM &&
-	    owner != AMDGPU_FENCE_OWNER_UNDEFINED)
+	    owner != AMDGPU_FENCE_OWNER_UNDEFINED &&
+	    owner != AMDGPU_FENCE_OWNER_KFD)
 		return false;
 
 	/* Ignore fences depending on the sync mode */
-- 
2.43.0



