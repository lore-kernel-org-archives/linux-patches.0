Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA961C4EE8;
	Tue, 27 Aug 2024 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771052; cv=none; b=DXMsvkRusx/VPvOjLnAjb6BIWHh3fd+jfp117ZjA+r2NtZRmEswFndOVnCDfp2ULjkLugJ5UgsS9KrOSB3nnhC4zy8cGuJsNANEMlFnNINM3wRQNojAmSZNCDbIMsqXqJ5/z+lGq7gnI2nAPsYBx2K6TtsbuLX+nrqzc5/i5ntE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771052; c=relaxed/simple;
	bh=AXA8QolLRWZTVOThkVZbIVkYCoCufRZMOsNvJ9sKzw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpjeIRWcU0TXs4lTD4UBDMk689G7GDl3BqQUMDwBB5l+ejpzrKIZMHCSSCtGo5gtTJPzie+b5XcmCaXBUY1Og/KCmz96euQ9v7jpW33AFGtP5d5OwM6iX0fwgagUQygufMiEWeejMvsWH4lcNtCuQBDYm2qAFWrlpyfnJDka/Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J78mndhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J78mndhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CA8C6104C;
	Tue, 27 Aug 2024 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771052;
	bh=AXA8QolLRWZTVOThkVZbIVkYCoCufRZMOsNvJ9sKzw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J78mndhp+dxtW4K+2/sJkZ764h0IRV98AnoYrxXt0jDsz9whURfyG0k0FRU+HmvdU
	 QHFu08DlXpmRmDV01Wz84RP9ImRWVw4K2UbnEX4uZdkGy3vSmV5wURYSJxdYded8vX
	 yD7fTwHrQNvx0boBUYOzQP57se5RM8ZfYFpAYlBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 073/273] drm/amdgpu/jpeg2: properly set atomics vmid field
Date: Tue, 27 Aug 2024 16:36:37 +0200
Message-ID: <20240827143836.193796728@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e414a304f2c5368a84f03ad34d29b89f965a33c9 upstream.

This needs to be set as well if the IB uses atomics.

Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 35c628774e50b3784c59e8ca7973f03bcb067132)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -543,11 +543,11 @@ void jpeg_v2_0_dec_ring_emit_ib(struct a
 
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JPEG_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring,	PACKETJ(mmUVD_LMI_JRBC_IB_64BIT_BAR_LOW_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));


