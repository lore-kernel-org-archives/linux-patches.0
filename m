Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8896D15959E;
	Mon, 29 Jan 2024 17:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548254; cv=none; b=S+MKhnqkG9U1FeukpI++o6CI1AF2or5ugfEt3KcTEs7OkrOOY4rI8kalpzn26l6dUAa9CSjUqfYNnR+5kG+XMOy0yNQFUpA5Qug+14ANYcJsZ86ErFGVuvVycg5ve+8pLl51ojbIZJCk5ZxHiIaFDgLZUIT31GJKK4tlJEuT9cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548254; c=relaxed/simple;
	bh=ArOMi9pI4jw31vdVNK4IkilqKB5Au/PsWMFAazJPfq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6cg+d49zPSWwCc+YKxESS9o9iz3w8BfBfuGVY37huS8ECtYNefVtisbO5sG6FVjgMkiyGuUgIJWP91TzEqxyiDaAlgRFuXTjGhTSGeGG7P7FXByf9osbKh2B1FUBkmOju6cLZheOcKTQJAS2v/pCLuAuSEf/PWfUd0jYLQyX1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3lmZg7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3lmZg7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D043C433B1;
	Mon, 29 Jan 2024 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548254;
	bh=ArOMi9pI4jw31vdVNK4IkilqKB5Au/PsWMFAazJPfq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3lmZg7iRFgs/45pnbmPvdLuVZ6sv26eEAHg5yCGgBTT5qJdnOLP+UGpUqR4fGwFo
	 VCX2Ai8rs/d00fkJdn/6JxAXYcUgUoigORMSzukiLCrU2AxeDqBqwZ51SWbOoRCjyQ
	 wWBskxgY7vsmlrnemxr2XtUOk86dYvxlyOT6TSQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 275/346] drm/amdgpu: Avoid fetching vram vendor information
Date: Mon, 29 Jan 2024 09:05:06 -0800
Message-ID: <20240129170024.469366833@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 90751bdeee4e3ac87ebf814bf282b0fa97edfeab upstream.

For GFX 9.4.3 APUs, the current method of fetching vram vendor
information is not reliable. Avoid fetching the information.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.7.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1950,7 +1950,8 @@ static void gmc_v9_4_3_init_vram_info(st
 	static const u32 regBIF_BIOS_SCRATCH_4 = 0x50;
 	u32 vram_info;
 
-	if (!amdgpu_sriov_vf(adev)) {
+	/* Only for dGPU, vendor informaton is reliable */
+	if (!amdgpu_sriov_vf(adev) && !(adev->flags & AMD_IS_APU)) {
 		vram_info = RREG32(regBIF_BIOS_SCRATCH_4);
 		adev->gmc.vram_vendor = vram_info & 0xF;
 	}


