Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D7912C487;
	Tue, 30 Apr 2024 11:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475062; cv=none; b=uQGTVEuJRvpdy2bPRSCWbP5BDTA40DNsHPsCzx2poDXEVFjXnh53aUBqBIqYdtVTAREA761PC2K/X7DZZz58nTkdcriDkPtnsNU5tD+eGua4sAazgKhdd6fknh4ReZ6OxVErOuoEalUhyDtpr0rsy29Wm+TXSmlemnLM+OuVhTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475062; c=relaxed/simple;
	bh=y2crCXY3shkGq8Jmgoj7CvUEmTgZtTSZYUsNyyqmJZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E83x7JuPdEC3lP+B+NrLEw7hAxNQeF5MJvnvU9V4nPkAXjzSFD9FvO6DWgdK7mJPTtrch8ZnDNCqTiAHQZq9IqD0W6s/kOp/Bd+PJa+jnJfYHv976Vpk7looHS/lfsR+2VFGzVpgZczrGzUNzVZ5cF45OADD7ym3jdVZYFVDIFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0L901tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0L901tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5293DC2BBFC;
	Tue, 30 Apr 2024 11:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475062;
	bh=y2crCXY3shkGq8Jmgoj7CvUEmTgZtTSZYUsNyyqmJZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0L901tfKu23nCAXd2OzCPYCRfjuVpT1r2baXeqr0mtWw7zCDLAt3J6cNL1HNN3SG
	 0ygM/N80R2G85R7SqMhwYnKN7ywz5/wiTTPAOyO2sG8eXWAeCWMsXskXl+swYH7WQV
	 LmTWrMIWLzdrjXIAtPz3AlPJiYXaOcAPBRwJUsOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 119/138] drm/amdgpu/sdma5.2: use legacy HDP flush for SDMA2/3
Date: Tue, 30 Apr 2024 12:40:04 +0200
Message-ID: <20240430103052.910342635@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -390,17 +390,21 @@ static void sdma_v5_2_ring_emit_hdp_flus
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


