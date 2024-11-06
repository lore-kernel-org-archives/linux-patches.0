Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B951DFDAF;
	Wed,  6 Nov 2024 12:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895892; cv=none; b=c0/xEcZglBSdSekXLBieSsLMoISg1iVzTliDvxuOC/B5ZQjp9ahQ7+H5mpae4JK6TfTuVJUae2Qb0xTK2JxIBfD3vbdUH+jFAY/A0b7kJmdISyp7RmY0Qu8uLiy5lXixwoJ6VtccBgUqssj4HQjtfoZisbmQOZMW61G6VdNaN9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895892; c=relaxed/simple;
	bh=boEgGvu3K1KOBi+giUza6xlil0YbiI8q/29v3cldiTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hxg+sDLkpLl2t3O8ODDqfacmsW/pWmj3i1S5xYPM+F4C++8232yoRNixUcBC4+pl/f/AZ1UHwBHXPslmEwYOXnF0N4vG3VjfYn3AEf55xiLvTXzf28829dxFRZkcNhqc6uAc4OyjCaQYRAXSQsHaEm7cq77ekygiTJknSRYU8CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hq75c9Qr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hq75c9Qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3C1C4CECD;
	Wed,  6 Nov 2024 12:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895891;
	bh=boEgGvu3K1KOBi+giUza6xlil0YbiI8q/29v3cldiTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hq75c9Qrs3RXdJpcfz0BTRaHun2lYwyIgh8id6DuP0OSY/B+oIPQlnHUXboGdk53C
	 LAUFxNjINpnb8Phkw3bA45cvIt/Zpnfis/isjt30xUubNyJ+vaWB/Gv+oPZzOQIttu
	 KBKqbg57BP3WN9qTRJVYbO3hEJJeqdEXAQr6KIpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Min <Frank.Min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 002/245] drm/amdgpu: fix random data corruption for sdma 7
Date: Wed,  6 Nov 2024 13:00:55 +0100
Message-ID: <20241106120319.301391105@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Min <Frank.Min@amd.com>

[ Upstream commit 108bc59fe817686a59d2008f217bad38a5cf4427 ]

There is random data corruption caused by const fill, this is caused by
write compression mode not correctly configured.

So correct compression mode for const fill.

Signed-off-by: Frank Min <Frank.Min@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 75400f8d6e36afc88d59db8a1f3e4b7d90d836ad)
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
index 403c177f24349..bbf43e668c1c4 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
@@ -51,6 +51,12 @@ MODULE_FIRMWARE("amdgpu/sdma_7_0_1.bin");
 #define SDMA0_HYP_DEC_REG_END 0x589a
 #define SDMA1_HYP_DEC_REG_OFFSET 0x20
 
+/*define for compression field for sdma7*/
+#define SDMA_PKT_CONSTANT_FILL_HEADER_compress_offset 0
+#define SDMA_PKT_CONSTANT_FILL_HEADER_compress_mask   0x00000001
+#define SDMA_PKT_CONSTANT_FILL_HEADER_compress_shift  16
+#define SDMA_PKT_CONSTANT_FILL_HEADER_COMPRESS(x) (((x) & SDMA_PKT_CONSTANT_FILL_HEADER_compress_mask) << SDMA_PKT_CONSTANT_FILL_HEADER_compress_shift)
+
 static void sdma_v7_0_set_ring_funcs(struct amdgpu_device *adev);
 static void sdma_v7_0_set_buffer_funcs(struct amdgpu_device *adev);
 static void sdma_v7_0_set_vm_pte_funcs(struct amdgpu_device *adev);
@@ -1611,7 +1617,8 @@ static void sdma_v7_0_emit_fill_buffer(struct amdgpu_ib *ib,
 				       uint64_t dst_offset,
 				       uint32_t byte_count)
 {
-	ib->ptr[ib->length_dw++] = SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_CONST_FILL);
+	ib->ptr[ib->length_dw++] = SDMA_PKT_CONSTANT_FILL_HEADER_OP(SDMA_OP_CONST_FILL) |
+		SDMA_PKT_CONSTANT_FILL_HEADER_COMPRESS(1);
 	ib->ptr[ib->length_dw++] = lower_32_bits(dst_offset);
 	ib->ptr[ib->length_dw++] = upper_32_bits(dst_offset);
 	ib->ptr[ib->length_dw++] = src_data;
-- 
2.43.0



