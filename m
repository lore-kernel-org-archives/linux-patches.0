Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E948801;
	Tue, 30 Apr 2024 11:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475587; cv=none; b=mDCpgwL/PyChsgoixn0kGyfTzkirsoY7zVJjHwcI/h4MR5g2IPO3164Pf2Y3FfSUFuJDUpUjW2UwvLn4ctOxkwhOtuTX+LFN5ReTpBW5ikdtklHanLqKugmCDiwx5hzsFR7ajeqhOd9J7FTi5M0q/AFOO6If4rXlmPXS5YQdwmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475587; c=relaxed/simple;
	bh=EtWvbcZmD9S3R7lLamSntd0LKStfjnIQddJ2k1FYVLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6a2SFi+Ec0k3B3CG/qp95IU6OTeIULWDeVaCU12kgGY52cTBKVSxWQoxNa544tuU4ag5TKHkKXIsM1KsosZlVrIUJAA8UzCCtXvCCAlQJJbr4ubeUSl+mNQNHPnR77p3/FvjiSVbNgFFrFNq8J5qux9p83nMwTgBbz7uvOfHFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxsqxjN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxsqxjN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9F3C2BBFC;
	Tue, 30 Apr 2024 11:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475587;
	bh=EtWvbcZmD9S3R7lLamSntd0LKStfjnIQddJ2k1FYVLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxsqxjN9pX82K87hTncf1jHkL9yx7RU7IMCfIo18Rz+0TyMZX9+948Sd2oLB7llVr
	 f3zKWCFDTgJMPl9wlK7th/SaqFYuVMHTCFIjVqBCfmonWu2PTUdODdM2PqQ7WDNOk7
	 xDJXgSIosE7udsXAWGHjR0fXlVKGEixeQg3hn+mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 142/186] drm/amdgpu: Assign correct bits for SDMA HDP flush
Date: Tue, 30 Apr 2024 12:39:54 +0200
Message-ID: <20240430103102.155528331@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

commit aebd3eb9d3ae017e6260043f6bcace2f5ef60694 upstream.

HDP Flush request bit can be kept unique per AID, and doesn't need to be
unique SOC-wide. Assign only bits 10-13 for SDMA v4.4.2.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -365,7 +365,8 @@ static void sdma_v4_4_2_ring_emit_hdp_fl
 	u32 ref_and_mask = 0;
 	const struct nbio_hdp_flush_reg *nbio_hf_reg = adev->nbio.hdp_flush_reg;
 
-	ref_and_mask = nbio_hf_reg->ref_and_mask_sdma0 << ring->me;
+	ref_and_mask = nbio_hf_reg->ref_and_mask_sdma0
+		       << (ring->me % adev->sdma.num_inst_per_aid);
 
 	sdma_v4_4_2_wait_reg_mem(ring, 0, 1,
 			       adev->nbio.funcs->get_hdp_flush_done_offset(adev),


