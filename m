Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03556F063;
	Mon, 29 Jan 2024 17:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548455; cv=none; b=clYKWBVBZxUhx7YDyvVhBftIOyAirKiaXirS+B7EY1ln6pbTWHzpKXV5HAOlmXyTi//wwq2Yw5H+pX1JfbtIDzRwAN7jekOmWcYs3BPHEvBf1FMrRYBsp9BdenefQbmeWYOn0jHoJNOAZS0HCSd3DOT6HjvysW1tnnB1quYfwp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548455; c=relaxed/simple;
	bh=R55As2AcTkSCB41KxvHfhH9YtKphN7StdpSXCHYrewU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2vxeUOnWmFXOqeB6jbMfh0y+yO1MG5MseD5ZNh4Bfe8jeR+Ym9XtQR/4sDc7HQ97pcW613Rzn9B7wsXWKeagPr2kqPVgEqfotiHRQ1Qqu7653y6X6SM3G/VPZPR/wNnLx0eXO4ykB/s7TX/hVch4KbYvciLBzzjCAT2t+I3fcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEpojmzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEpojmzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BE2C433F1;
	Mon, 29 Jan 2024 17:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548455;
	bh=R55As2AcTkSCB41KxvHfhH9YtKphN7StdpSXCHYrewU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEpojmzUp0O6nCqV475nDX57P4p1/o0aIdKbNScEABByhbgYkqOrVKRSxdB1lVK51
	 cgKhscaNnygGA214hebUtrmOciOK6ax3EE+aUva4WLTkrU8ji5FCnlo47kmMX1ArTl
	 /b71JBWLDeuMPep6oSf33iPrrY2X6wWaqzmeAUtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.6 067/331] bus: mhi: host: Add alignment check for event ring read pointer
Date: Mon, 29 Jan 2024 09:02:11 -0800
Message-ID: <20240129170016.889846235@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Krishna chaitanya chundru <quic_krichai@quicinc.com>

commit eff9704f5332a13b08fbdbe0f84059c9e7051d5f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -268,7 +268,8 @@ static void mhi_del_ring_element(struct
 
 static bool is_valid_ring_ptr(struct mhi_ring *ring, dma_addr_t addr)
 {
-	return addr >= ring->iommu_base && addr < ring->iommu_base + ring->len;
+	return addr >= ring->iommu_base && addr < ring->iommu_base + ring->len &&
+			!(addr & (sizeof(struct mhi_ring_element) - 1));
 }
 
 int mhi_destroy_device(struct device *dev, void *data)


