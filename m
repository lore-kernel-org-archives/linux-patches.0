Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43F731A6E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579A6C433C9;
	Wed, 20 Sep 2023 12:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695214087;
	bh=QpNYnPAQAwKHlnA4/apNSw/+aN14PNxxqtamN5hZ5So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ba9YgAKzyMFWd82PDoqPoGYMAAz+/QLYEyD5fardFdBpKfUe2HQZgOExLzSnhqYa6
	 FeyR5D+aRaxVf9LFjcncUTzktEeJPyyIC8eDA/uYNaJKRw801dEqEItE9jVy1l97yl
	 ZrgPJymkBxyFKP8R4cQP1ifFQcxYFDaZKktCfM9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>
Subject: [PATCH 5.15 107/110] drm/amd/display: fix the white screen issue when >= 64GB DRAM
Date: Wed, 20 Sep 2023 13:32:45 +0200
Message-ID: <20230920112834.413453978@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zhang <yifan1.zhang@amd.com>

commit ef064187a9709393a981a56cce1e31880fd97107 upstream.

Dropping bit 31:4 of page table base is wrong, it makes page table
base points to wrong address if phys addr is beyond 64GB; dropping
page_table_start/end bit 31:4 is unnecessary since dcn20_vmid_setup
will do that. Also, while we are at it, cleanup the assignments using
upper_32_bits()/lower_32_bits() and AMDGPU_GPU_PAGE_SHIFT.

Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2354
Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible (v2)")
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Co-developed-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1204,11 +1204,15 @@ static void mmhub_read_system_context(st
 	agp_top = adev->gmc.agp_end >> 24;
 
 
-	page_table_start.high_part = (u32)(adev->gmc.gart_start >> 44) & 0xF;
-	page_table_start.low_part = (u32)(adev->gmc.gart_start >> 12);
-	page_table_end.high_part = (u32)(adev->gmc.gart_end >> 44) & 0xF;
-	page_table_end.low_part = (u32)(adev->gmc.gart_end >> 12);
-	page_table_base.high_part = upper_32_bits(pt_base) & 0xF;
+	page_table_start.high_part = upper_32_bits(adev->gmc.gart_start >>
+						   AMDGPU_GPU_PAGE_SHIFT);
+	page_table_start.low_part = lower_32_bits(adev->gmc.gart_start >>
+						  AMDGPU_GPU_PAGE_SHIFT);
+	page_table_end.high_part = upper_32_bits(adev->gmc.gart_end >>
+						 AMDGPU_GPU_PAGE_SHIFT);
+	page_table_end.low_part = lower_32_bits(adev->gmc.gart_end >>
+						AMDGPU_GPU_PAGE_SHIFT);
+	page_table_base.high_part = upper_32_bits(pt_base);
 	page_table_base.low_part = lower_32_bits(pt_base);
 
 	pa_config->system_aperture.start_addr = (uint64_t)logical_addr_low << 18;


