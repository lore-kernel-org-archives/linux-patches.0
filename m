Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7782B2EF9B7;
	Thu,  3 Jul 2025 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554452; cv=none; b=PMMgJFjtwtrudLVgmOMR+C+DfyP6Wupb0cgd6gpL7HsdOrS1bZv1dLZtMfIIejS5YekWsnxjBZlI+kP29aiUhd/oRltQ3jZxnnpzWye5ZU1Fc9pLmNOM6rS2stPWT5aYvpRUODoWJ0ulnjVfNBvms/0/g0rxQi4cV63tZUhAal4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554452; c=relaxed/simple;
	bh=XuLUelcPYOiiIJrQEcCEVmmTdfSQ8V2G1KwFlrGjI28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMd48yWuchkFTJoJ9/PW8vetzaWaIBk2Fv6CJ3UZijeWGy+/VWRoXldCfexApxGFBneXTZZj8JaraGKE/GP6VnIMAUz3sOqtqNDg4FrppRHMM/6uHIKJ3f2fig7N/uprRPE5JHaUj+8+Rj5tl+nDvWK7WYWW+wSN28Bc6mfnbzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEBf1J26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEBf1J26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD82C4CEE3;
	Thu,  3 Jul 2025 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554452;
	bh=XuLUelcPYOiiIJrQEcCEVmmTdfSQ8V2G1KwFlrGjI28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEBf1J26CvZ3yFPXpyyRf9zL0X47NRKWuvrM1UoNxjT4STSDZSm+BP2Y5ytAJ0YlK
	 2yglV28eSGeYV0m1lkpLfF+w9HJrla25VRZv/y7n0/dVi3sCHBVEOZjRiJ/ukENL9h
	 Uazru8z2PbSTiKkhFnDfFndXV8HcssQYhJefF6Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Olender <john.olender@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Subject: [PATCH 6.12 162/218] drm/amdgpu: amdgpu_vram_mgr_new(): Clamp lpfn to total vram
Date: Thu,  3 Jul 2025 16:41:50 +0200
Message-ID: <20250703144002.636030040@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Olender <john.olender@gmail.com>

commit 4d2f6b4e4c7ed32e7fa39fcea37344a9eab99094 upstream.

The drm_mm allocator tolerated being passed end > mm->size, but the
drm_buddy allocator does not.

Restore the pre-buddy-allocator behavior of allowing such placements.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3448
Signed-off-by: John Olender <john.olender@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -463,7 +463,7 @@ static int amdgpu_vram_mgr_new(struct tt
 	int r;
 
 	lpfn = (u64)place->lpfn << PAGE_SHIFT;
-	if (!lpfn)
+	if (!lpfn || lpfn > man->size)
 		lpfn = man->size;
 
 	fpfn = (u64)place->fpfn << PAGE_SHIFT;


