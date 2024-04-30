Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA1E1E50A;
	Tue, 30 Apr 2024 11:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475584; cv=none; b=BDlPmtHTiXzn6VWLUiD5pojHaAWydpx5n6/Ge2CLeBjq4L4Jm0N6A3dNxXF5FOw9BWvP4qFDyAtn/it3HEFCaxPK4cB6GZKeU3NV6h5DX7sPfl1Ii+el/d6Zh69dyY6pQXFct0UtMGzhmYBVAgCvrlg2IJ9McLgeklFY9VqagfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475584; c=relaxed/simple;
	bh=ycONLZEvvtYqCb3WuDzJvTe25E9GAGfd249LwHlXxBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AKjeHXfLIocZ+urfbFE1tBiIaj+yTfLZg8U7Tiwpasd3UKXuvZIdGInlAA5aR+0ta/s9zCsqSY+075zhe1g4nnuq+Twr4pIRTUm28ecTGbGzyTqoMqN39B0QHdq0Gk6n+bTDLsGq4ci3ypX9o2eIifx8S0ZX84Hs0KaLJstHtxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSaZpwZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSaZpwZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BBAC2BBFC;
	Tue, 30 Apr 2024 11:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475584;
	bh=ycONLZEvvtYqCb3WuDzJvTe25E9GAGfd249LwHlXxBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSaZpwZ8JPOp3DI66L1ToEelciiufuixAUS/9Hz5jp/h6AW43S4Mi4bpP88dSgQa6
	 FlgmKO1n2lQxFM1E032ifShg70klgVtogxx0G0RuAy2m/u8xPqFrtthCjqBJqTZV12
	 Nvwa6VYEn5xR+se8GNSIlDSw9sk6l517Q6gTaxyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 141/186] drm/amdgpu/sdma5.2: use legacy HDP flush for SDMA2/3
Date: Tue, 30 Apr 2024 12:39:53 +0200
Message-ID: <20240430103102.126719400@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9792b7cc18aaa0c2acae6af5d0acf249bcb1ab0d upstream.

This avoids a potential conflict with firmwares with the newer
HDP flush mechanism.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -292,17 +292,21 @@ static void sdma_v5_2_ring_emit_hdp_flus
 	u32 ref_and_mask = 0;
 	const struct nbio_hdp_flush_reg *nbio_hf_reg = adev->nbio.hdp_flush_reg;
 
-	ref_and_mask = nbio_hf_reg->ref_and_mask_sdma0 << ring->me;
+	if (ring->me > 1) {
+		amdgpu_asic_flush_hdp(adev, ring);
+	} else {
+		ref_and_mask = nbio_hf_reg->ref_and_mask_sdma0 << ring->me;
 
-	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
-			  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(1) |
-			  SDMA_PKT_POLL_REGMEM_HEADER_FUNC(3)); /* == */
-	amdgpu_ring_write(ring, (adev->nbio.funcs->get_hdp_flush_done_offset(adev)) << 2);
-	amdgpu_ring_write(ring, (adev->nbio.funcs->get_hdp_flush_req_offset(adev)) << 2);
-	amdgpu_ring_write(ring, ref_and_mask); /* reference */
-	amdgpu_ring_write(ring, ref_and_mask); /* mask */
-	amdgpu_ring_write(ring, SDMA_PKT_POLL_REGMEM_DW5_RETRY_COUNT(0xfff) |
-			  SDMA_PKT_POLL_REGMEM_DW5_INTERVAL(10)); /* retry count, poll interval */
+		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
+				  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(1) |
+				  SDMA_PKT_POLL_REGMEM_HEADER_FUNC(3)); /* == */
+		amdgpu_ring_write(ring, (adev->nbio.funcs->get_hdp_flush_done_offset(adev)) << 2);
+		amdgpu_ring_write(ring, (adev->nbio.funcs->get_hdp_flush_req_offset(adev)) << 2);
+		amdgpu_ring_write(ring, ref_and_mask); /* reference */
+		amdgpu_ring_write(ring, ref_and_mask); /* mask */
+		amdgpu_ring_write(ring, SDMA_PKT_POLL_REGMEM_DW5_RETRY_COUNT(0xfff) |
+				  SDMA_PKT_POLL_REGMEM_DW5_INTERVAL(10)); /* retry count, poll interval */
+	}
 }
 
 /**


