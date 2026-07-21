Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82B1441616;
	Tue, 21 Jul 2026 22:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673106; cv=none; b=UN/DyqX4rR9OQu+0OxeCIruAh1QSbfbMCvN8o28MFR8OgWdR+lTx4m3BDOwjuUUaepBp8OiprZcn8YHxeshOYcIzbRat0xvpOWyhRXoj5ErRS8026CRORHC2rI24V5DpFhKgqyBvsxyBHICu/rZMdI2PWyVMeSLTdSB2yJ5y5rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673106; c=relaxed/simple;
	bh=a3/i/04/ldTCorjMADXhzwOhPUpOAx8VM6oGidZkDnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZ871RFw2r5PYdSbCinBoHeBR56/ruYgAyzkrA5wk97oQ0dditAkzGsURIu3vYfN40SoTQ3esPvTJMb34X0IC6vR6yeRF/aVWf+rENid6YkXPHGTmatNdGC9DPQAcd315zcIvGU7wmFw35DDqValCpdArQBmDn1ysjVsV4VGZtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTZkYiHm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTZkYiHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715F01F000E9;
	Tue, 21 Jul 2026 22:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673105;
	bh=Wxkut0bqGdjEcNC9WZTEjOi2BfYbdq8FsBNU9SH3Af0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTZkYiHmZ1GUdpYbKSNDtub6I5qs8d9vDnSSeLYj7obQt0CYXQkBoVdd/r1QOb+Lq
	 IsNgoIRcwNp3NwccG3xW/hrjPSDMXHw0FV2jE2dW8vZdvQaJDfgC46j1oedELjl7P5
	 eCnt99jX0NbTFu4Y9FRAeblYPCScFpAHo6C9uc6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>
Subject: [PATCH 5.10 011/699] bus: mhi: host: Add alignment check for event ring read pointer
Date: Tue, 21 Jul 2026 17:16:10 +0200
Message-ID: <20260721152355.936429058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -222,7 +222,8 @@ static void mhi_del_ring_element(struct
 
 static bool is_valid_ring_ptr(struct mhi_ring *ring, dma_addr_t addr)
 {
-	return addr >= ring->iommu_base && addr < ring->iommu_base + ring->len;
+	return addr >= ring->iommu_base && addr < ring->iommu_base + ring->len &&
+			!(addr & (sizeof(struct mhi_tre) - 1));
 }
 
 int mhi_destroy_device(struct device *dev, void *data)


