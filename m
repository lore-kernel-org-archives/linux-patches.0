Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F78125A9;
	Sat,  3 Feb 2024 04:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933419; cv=none; b=CRr/PR/Sbb3GqB7jFFXilZ88iMmIdF3IUP59pfzKhQdf9Umbnq76+f0g2FJ2oew4UY4R47W87RzhY/iIQM9ZCtlAdy+Y53o5XMu91nBKiM8hi0/j2Jd++uiNhdJwhZXRawPWp/GyurF6Nob3YPD9Th4TcMH75aSL4FDJVL+QJ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933419; c=relaxed/simple;
	bh=lfJW+YRL3UdMrMIiNGiiTZ9mwSPT7zJLTima4NQhj9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PmO+8FjcDgRR0jGFhTpZiffQeWoBxpnu894xa5Yf1jePcMdh+iIKFdJzTQuzXtTJjCXTkQP3jTwwTK3EmhYnyOYWSv5uzgV5YTT9KsEm88/Xhh8C8WQ1573btW0RMdyR7Exz5NUlXkYm4+ylKiWh/FGoh36MxoBvQ7DDI9bIcHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vo4p6YUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vo4p6YUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC426C43390;
	Sat,  3 Feb 2024 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933418;
	bh=lfJW+YRL3UdMrMIiNGiiTZ9mwSPT7zJLTima4NQhj9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vo4p6YUthbgfPFaglqeVgLiE3ZY0WHIqCOZmctk4LGYYuZZ4LpqgYPftyHfkEZy79
	 3VEH4QLGjdKZRUH7gJi5hYuY8XtDRZegzOJG5dCWUxTiexSOZd7H3TqBdeCDn2+Owg
	 5iQ1Rfgb38wZD84PMilwbVbZRu9oF/c6kyja7m2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/219] drm/amdgpu: Let KFD sync with VM fences
Date: Fri,  2 Feb 2024 20:05:15 -0800
Message-ID: <20240203035337.421073874@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 090e66a1b284..54bdbd83a8cc 100644
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



