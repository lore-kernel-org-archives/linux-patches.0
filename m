Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BC1342151;
	Tue, 11 Nov 2025 01:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823176; cv=none; b=JkPoIYPeL+SE16OJWGT+QIFWTdiSKXq/CTjwsUZobblVfiUiqydhzn7uLRaE9sWUdvFXRGCIsXfao1bQuWyAluo6bTgPCinS98cGlzA1VJUZSHhUK5DARXYunUfcchTyL5N2lXy3/rELQub7zUw27qYKKgBb0T2OxFwDz3fj8co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823176; c=relaxed/simple;
	bh=NOgy+57dbvqJxaFJ6ryvIlC2ucKuqFFJ+96JoUd8Pf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzMDQA2wTUAMwZRlS3yXl42Hrcke35uhzQGlIuyIByiyfvMLEf1YdTj6YU60vITQv6az6k0WZ19FtTqQytbojr9lfVdPAqy6BPF2Hxdh1wNZoJJIZSdguAk5UP7L9EykKBuIJL7Oy44zV1TsfLV5U7EHdj4IrPmwIJBqvv3i/8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etgJNVce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etgJNVce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6254CC16AAE;
	Tue, 11 Nov 2025 01:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823176;
	bh=NOgy+57dbvqJxaFJ6ryvIlC2ucKuqFFJ+96JoUd8Pf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etgJNVceFJYoJVOLVOHtmrofGxBjlZltARGltC0DjkIwDsj9BCUDQxl9MSKKTQ4EU
	 5bdn5wZQiXMjZdrZfsE8Xc1iHuX9DxTZ4dRwnUcKYodKyYwY050mzoX9wfpdHPzfiX
	 yN2cZuc8S1VL0HetdqPn7maJYnw90S9eTMoSqTyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 245/849] drm/amdgpu: Update IPID value for bad page threshold CPER
Date: Tue, 11 Nov 2025 09:36:55 +0900
Message-ID: <20251111004542.355458532@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 8f0245ee95c5ba65a2fe03f60386868353c6a3a0 ]

Update the IPID register value for bad page threshold CPER according to
the latest definition.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
index 48a8aa1044b15..ee937d617c826 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
@@ -206,6 +206,7 @@ int amdgpu_cper_entry_fill_bad_page_threshold_section(struct amdgpu_device *adev
 {
 	struct cper_sec_desc *section_desc;
 	struct cper_sec_nonstd_err *section;
+	uint32_t socket_id;
 
 	section_desc = (struct cper_sec_desc *)((uint8_t *)hdr + SEC_DESC_OFFSET(idx));
 	section = (struct cper_sec_nonstd_err *)((uint8_t *)hdr +
@@ -224,6 +225,9 @@ int amdgpu_cper_entry_fill_bad_page_threshold_section(struct amdgpu_device *adev
 	section->ctx.reg_arr_size = sizeof(section->ctx.reg_dump);
 
 	/* Hardcoded Reg dump for bad page threshold CPER */
+	socket_id = (adev->smuio.funcs && adev->smuio.funcs->get_socket_id) ?
+				adev->smuio.funcs->get_socket_id(adev) :
+				0;
 	section->ctx.reg_dump[CPER_ACA_REG_CTL_LO]    = 0x1;
 	section->ctx.reg_dump[CPER_ACA_REG_CTL_HI]    = 0x0;
 	section->ctx.reg_dump[CPER_ACA_REG_STATUS_LO] = 0x137;
@@ -234,8 +238,8 @@ int amdgpu_cper_entry_fill_bad_page_threshold_section(struct amdgpu_device *adev
 	section->ctx.reg_dump[CPER_ACA_REG_MISC0_HI]  = 0x0;
 	section->ctx.reg_dump[CPER_ACA_REG_CONFIG_LO] = 0x2;
 	section->ctx.reg_dump[CPER_ACA_REG_CONFIG_HI] = 0x1ff;
-	section->ctx.reg_dump[CPER_ACA_REG_IPID_LO]   = 0x0;
-	section->ctx.reg_dump[CPER_ACA_REG_IPID_HI]   = 0x96;
+	section->ctx.reg_dump[CPER_ACA_REG_IPID_LO]   = (socket_id / 4) & 0x01;
+	section->ctx.reg_dump[CPER_ACA_REG_IPID_HI]   = 0x096 | (((socket_id % 4) & 0x3) << 12);
 	section->ctx.reg_dump[CPER_ACA_REG_SYND_LO]   = 0x0;
 	section->ctx.reg_dump[CPER_ACA_REG_SYND_HI]   = 0x0;
 
-- 
2.51.0



