Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DF27E797;
	Wed, 21 Feb 2024 13:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522175; cv=none; b=JEhDv6r1JrFNAy0WHlhte0uvnZnHTfLKGMu5GqrDGDO/mhyXCRO03W14nzSDSAoxOrMd4hz1SEEKfallQZzw+r/7nw5zDJEzqsLDb2JQIEmfue2668WVHnUtOukVBJyNBENSMCtnxO05Vx4ArDMH8CA0b9ksdzyDqopaCvO0GuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522175; c=relaxed/simple;
	bh=mMFEdd3sxUYjNLFtLATRmDqGvNpjT+42WGkfgOnwOtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TApIBr2yoKgk2DKs9F2qjfYSiu2iVvPxXVMMxZssqi+iUpQJJDDq1zmxoGCi/lY/77zFE9svRWvcOHLw0Cee71pP0iHcEqhmsC1tOjv4uqLT/VedN+FJ0rSUuh6BfwIlwX0sjzggm2A5V/v/MPBi4DGp24Tt59+wgxmYVNo3NTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTMd2GBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTMd2GBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFF5C433C7;
	Wed, 21 Feb 2024 13:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522175;
	bh=mMFEdd3sxUYjNLFtLATRmDqGvNpjT+42WGkfgOnwOtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTMd2GBjzPGEKxJ2KB0aR2xtqZnqonksDbtsoMyB3jNci+MnD4Qt/N7xiv8t5cR8M
	 gg1GejM6vC0RFUvT7AMXvKqIagL0mxQMyJrdm2kN5TJycpZwaG+/r3xjHtNYCDWF0N
	 +6tz773JhysEL1woMVEPQ+2mFahUPPrR0s2RJL/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/476] bus: mhi: host: Add alignment check for event ring read pointer
Date: Wed, 21 Feb 2024 14:02:29 +0100
Message-ID: <20240221130011.607399316@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Krishna chaitanya chundru <quic_krichai@quicinc.com>

[ Upstream commit eff9704f5332a13b08fbdbe0f84059c9e7051d5f ]

Though we do check the event ring read pointer by "is_valid_ring_ptr"
to make sure it is in the buffer range, but there is another risk the
pointer may be not aligned.  Since we are expecting event ring elements
are 128 bits(struct mhi_ring_element) aligned, an unaligned read pointer
could lead to multiple issues like DoS or ring buffer memory corruption.

So add a alignment check for event ring read pointer.

Fixes: ec32332df764 ("bus: mhi: core: Sanity check values from remote device before use")
cc: stable@vger.kernel.org
Signed-off-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231031-alignment_check-v2-1-1441db7c5efd@quicinc.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/host/main.c b/drivers/bus/mhi/host/main.c
index 23bd1db94558..1cb7c60594f1 100644
--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -267,7 +267,8 @@ static void mhi_del_ring_element(struct mhi_controller *mhi_cntrl,
 
 static bool is_valid_ring_ptr(struct mhi_ring *ring, dma_addr_t addr)
 {
-	return addr >= ring->iommu_base && addr < ring->iommu_base + ring->len;
+	return addr >= ring->iommu_base && addr < ring->iommu_base + ring->len &&
+			!(addr & (sizeof(struct mhi_ring_element) - 1));
 }
 
 int mhi_destroy_device(struct device *dev, void *data)
-- 
2.43.0



