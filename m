Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D7D3A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYZQ+9dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268E9C433C7;
	Wed, 15 Nov 2023 19:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077383;
	bh=e+0l6ggTHVp0YZCrdsy2eEv9oy0R45HWi3ZuuDEioD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYZQ+9dxwbmXH6KFb4pCXsAfNYTZzRj26AR2di5so4g2DprV37Cz2F99OyW2SCi8B
	 QzMPhj8wUjrKV4fl1t3PKRKiVHUuDxanU7X14Obi5t8VPjPYMXr47/dPy9XZ2uS6rA
	 DXlIEdrGT82a4+h8DDUlEjNZ3czHNGBqhK/Jnsmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/603] drm/amdkfd: Remove svm range validated_once flag
Date: Wed, 15 Nov 2023 14:13:08 -0500
Message-ID: <20231115191630.035072557@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit c99b16128082de519975aa147d9da3e40380de67 ]

The validated_once flag is not used after the prefault was removed, The
prefault was needed to ensure validate all system memory pages at least
once before mapping or migrating the range to GPU.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: eb3c357bcb28 ("drm/amdkfd: Handle errors from svm validate and map")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 4 +---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.h | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index bb65a99439802..dfc11699e79ab 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1720,10 +1720,8 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
 		addr = next;
 	}
 
-	if (addr == end) {
-		prange->validated_once = true;
+	if (addr == end)
 		prange->mapped_to_gpu = true;
-	}
 
 unreserve_out:
 	svm_range_unreserve_bos(ctx);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.h b/drivers/gpu/drm/amd/amdkfd/kfd_svm.h
index 9e668eeefb32d..c216c8dd13c6c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.h
@@ -132,7 +132,6 @@ struct svm_range {
 	struct list_head		child_list;
 	DECLARE_BITMAP(bitmap_access, MAX_GPU_INSTANCE);
 	DECLARE_BITMAP(bitmap_aip, MAX_GPU_INSTANCE);
-	bool				validated_once;
 	bool				mapped_to_gpu;
 	bool				is_error_flag;
 };
-- 
2.42.0



