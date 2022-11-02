Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1C37E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2FFC433D6;
	Wed,  2 Nov 2022 02:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356789;
	bh=XZ7AIisS0BoyaAy0f2lSX8XzCoSaWxfet4pDlPthyGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvavLxmh7lRRbte8yDcAG34xT5QDf8WG6Jcq7TjKcGCwFh/RtL+/Jxmle0qKrvlZZ
	 kG3SwJlU3shGI/pPEquy3mT+0k1cktb7ihvVNOK1uez30ZGNdxmMpbrF91ZjD8KOlG
	 pVRp/xhGPsSOX7b9cL2SdReJfJwo82TbZmYGA1tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.0 058/240] drm/amdgpu: Fix VRAM BO swap issue
Date: Wed,  2 Nov 2022 03:30:33 +0100
Message-Id: <20221102022112.711804486@linuxfoundation.org>
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

From: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

commit 312b4dc11d4f74bfe03ea25ffe04c1f2fdd13cb9 upstream.

DRM buddy manager allocates the contiguous memory requests in
a single block or multiple blocks. So for the ttm move operation
(incase of low vram memory) we should consider all the blocks to
compute the total memory size which compared with the struct
ttm_resource num_pages in order to verify that the blocks are
contiguous for the eviction process.

v2: Added a Fixes tag
v3: Rewrite the code to save a bit of calculations and
    variables (Christian)

Fixes: c9cad937c0c5 ("drm/amdgpu: add drm buddy support to amdgpu")
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -424,8 +424,9 @@ error:
 static bool amdgpu_mem_visible(struct amdgpu_device *adev,
 			       struct ttm_resource *mem)
 {
-	uint64_t mem_size = (u64)mem->num_pages << PAGE_SHIFT;
+	u64 mem_size = (u64)mem->num_pages << PAGE_SHIFT;
 	struct amdgpu_res_cursor cursor;
+	u64 end;
 
 	if (mem->mem_type == TTM_PL_SYSTEM ||
 	    mem->mem_type == TTM_PL_TT)
@@ -434,12 +435,18 @@ static bool amdgpu_mem_visible(struct am
 		return false;
 
 	amdgpu_res_first(mem, 0, mem_size, &cursor);
+	end = cursor.start + cursor.size;
+	while (cursor.remaining) {
+		amdgpu_res_next(&cursor, cursor.size);
 
-	/* ttm_resource_ioremap only supports contiguous memory */
-	if (cursor.size != mem_size)
-		return false;
+		/* ttm_resource_ioremap only supports contiguous memory */
+		if (end != cursor.start)
+			return false;
+
+		end = cursor.start + cursor.size;
+	}
 
-	return cursor.start + cursor.size <= adev->gmc.visible_vram_size;
+	return end <= adev->gmc.visible_vram_size;
 }
 
 /*


