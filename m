Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867A67E590;
	Wed, 21 Feb 2024 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524283; cv=none; b=ufNj9pNkVTfMT+BUYMIvmHQlIhjFeIOHNb8qOZLeHQenrIEaeB9uEVfpUbvY7OsAExwCegZa2SNrfk6obj+cWHmh+iANhWg98qU1gLwZ0cNNa72vf4Jc+kdnasp8q2NMkJQicu4Eij7dMB0qok7LFSdA9GuRpMlF3sBHfC64jac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524283; c=relaxed/simple;
	bh=ZIT1MzNY38bneWJWNVIJGloj3EFumNvvNPhk7jSO9b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IFoz9QqwtiVn9A7BdIT9M4b4xEIxPnLYYq0g0U08aQf1Wmaw1fvmn07nkco9Fda6e3+k2FMqw53tOGbHykR7trPC27L6knxTWROv0HIZLjZvLf55Btcrp6onJbwEAtKddEaFJR8Zdi5/wn9DjmRAS+gt6C7Bl6mKnVsEcqypsDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2eGwGYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2eGwGYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A480BC433F1;
	Wed, 21 Feb 2024 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524283;
	bh=ZIT1MzNY38bneWJWNVIJGloj3EFumNvvNPhk7jSO9b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2eGwGYLAenNCrXKI+5+4G1JWp95goc0TyeRlBwqr81QG86kWcNWtk2rWtYyu71bD
	 2q9ENgLABjebofatmRxGUKAOl4nMH8GTxKnCLuTJ4Au7mTZ40mhObTp4DBjN0i1IAQ
	 PifytO9OKCzXG2WGfStNzUowlNY4OT7VxP1yOSY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/379] drm/amdgpu: Let KFD sync with VM fences
Date: Wed, 21 Feb 2024 14:06:17 +0100
Message-ID: <20240221130000.760377131@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8ea6c49529e7..6a22bc41c205 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -241,7 +241,8 @@ int amdgpu_sync_resv(struct amdgpu_device *adev, struct amdgpu_sync *sync,
 
 		/* Never sync to VM updates either. */
 		if (fence_owner == AMDGPU_FENCE_OWNER_VM &&
-		    owner != AMDGPU_FENCE_OWNER_UNDEFINED)
+		    owner != AMDGPU_FENCE_OWNER_UNDEFINED &&
+	    owner != AMDGPU_FENCE_OWNER_KFD)
 			continue;
 
 		/* Ignore fences depending on the sync mode */
-- 
2.43.0



