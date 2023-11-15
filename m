Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEEA31721
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7RKWu/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCB9C433C7;
	Wed, 15 Nov 2023 19:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076343;
	bh=/c+rBuSSFYZCv54OWu6+YNSsKtwfxq5zj40ycCyd4Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7RKWu/6jgmKhZtdWr6jwIIHsH17qWZ6xoLns4R6DQTvdgntoGpcRUUPCp3eIDQRA
	 oH00hb8ZfGrv7JOyT4M+POWOk/cYanVt6l7Nj77SLrOMuRGv500DMOdxG4LiLPPK4+
	 cldEpX+wQwHkW6arci98mC8RtriY90NOPjgcENpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 232/550] drm/amdkfd: Remove svm range validated_once flag
Date: Wed, 15 Nov 2023 14:13:36 -0500
Message-ID: <20231115191616.794620760@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 4c1b72194a6f8..8cbfe18d16c6e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1685,10 +1685,8 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
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
index 21b14510882b8..21ca57992e054 100644
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



