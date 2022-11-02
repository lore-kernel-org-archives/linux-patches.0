Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD55B7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC989C433D6;
	Wed,  2 Nov 2022 02:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357554;
	bh=SXYKW4avPIqz9CtUz/OrTgooWsgjGPf3f+VnNx/Ftbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/uFblIWUd1nHWqD03m1jmjNGhmcjyh9IaKxVNQwTCR3/+SlGi5rXZyPJXjkgEw+Y
	 lKXVbUOA4jCc1/XeqVkmM+/eeoo2diDBK5k62TtIZlYu8Fqn1kUAU7RDlH40uda+G1
	 OPg1ma0Bqpb0FfhpI0hrTHCdO1Fia3kzZaQgZtJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Mendonca <rafaelmendsr@gmail.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 190/240] drm/amdkfd: Fix memory leak in kfd_mem_dmamap_userptr()
Date: Wed,  2 Nov 2022 03:32:45 +0100
Message-Id: <20221102022115.690005108@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit 90bfee142af0f0e9d3bec80e7acd5f49b230acf7 ]

If the number of pages from the userptr BO differs from the SG BO then the
allocated memory for the SG table doesn't get freed before returning
-EINVAL, which may lead to a memory leak in some error paths. Fix this by
checking the number of pages before allocating memory for the SG table.

Fixes: 264fb4d332f5 ("drm/amdgpu: Add multi-GPU DMA mapping helpers")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 2170db83e41d..93ad00453f4b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -509,13 +509,13 @@ kfd_mem_dmamap_userptr(struct kgd_mem *mem,
 	struct ttm_tt *ttm = bo->tbo.ttm;
 	int ret;
 
+	if (WARN_ON(ttm->num_pages != src_ttm->num_pages))
+		return -EINVAL;
+
 	ttm->sg = kmalloc(sizeof(*ttm->sg), GFP_KERNEL);
 	if (unlikely(!ttm->sg))
 		return -ENOMEM;
 
-	if (WARN_ON(ttm->num_pages != src_ttm->num_pages))
-		return -EINVAL;
-
 	/* Same sequence as in amdgpu_ttm_tt_pin_userptr */
 	ret = sg_alloc_table_from_pages(ttm->sg, src_ttm->pages,
 					ttm->num_pages, 0,
-- 
2.35.1



