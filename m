Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD3540EB9B;
	Thu, 30 Jul 2026 14:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421803; cv=none; b=CEaR9pXbCXJEnf1pUG8DVxauiAZLLt7qVI97OOKK6pd5/RvA3o6hrU8cIuVd/ATq+faMHOOv6UtqQVNhqz1a6yc98jzednCQrhUAkLMBPNXrCFh97JgwGSGUZAWGRjpFRcCItJ+jAzRE3TIUp5knf8KL5egg8MOojj2UAdH7f+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421803; c=relaxed/simple;
	bh=jgnJwxe2II1N+GHy+RQaU46OV/lbfyRW8bS5IEY7CA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxc6BzVUME/Csm3wzU9CZFcfONmyYbz7A2ey0mFk01d40mRLVikdK7R3gB/Ml8qrDxN5ier7VRL00QxMft+Nb16OwPoY9jK5r7lcgEYbsShI+pFh1n2to0OatL9aY9Oogb00Bhcm/PdsQLdCUzcXdc5godLZgqRMwkBUM86igks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPtcgkYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPtcgkYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BF11F000E9;
	Thu, 30 Jul 2026 14:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421802;
	bh=Xx+faix8jMSFGEpkWS4am0m1OTcOOQH+Glp0m/rzSao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPtcgkYNU/z60BTzyJcCtGq3XH8P0MAsg3RzYxvh9V2RqfqHEg7NxyrLPxT3GWjMK
	 rFrbsIETXnoNMZacKsH+kDJTGomWusNU3TecoQwscscrmA9ftobRkvWqcY+FO0vNw3
	 /0ubkIYeaJBpY+ylruxV23XqI5n3Nkk3O0i0ioW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex@shazbot.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 180/744] wifi: ath11k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET
Date: Thu, 30 Jul 2026 16:07:33 +0200
Message-ID: <20260730141448.111731027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 0fe8010fc5b147607fc19ba010ba469afc95f35f ]

ath11k_pci_soc_global_reset() tries to reset the device by writing to the
PCIE_SOC_GLOBAL_RESET register. But it doesn't do a read-back to ensure
that the write gets flushed to the device before the delay.

This may lead to the delay on the host to be insufficient, if the posted
write doesn't reach the device before the delay.

So add a read-back after writing to the PCIE_SOC_GLOBAL_RESET register and
before the delay.

Compile tested only.

Fixes: f3c603d412b3 ("ath11k: reset MHI during power down and power up")
Reported-by: Alex Williamson <alex@shazbot.org>
Closes: https://lore.kernel.org/linux-pci/20260622160822.09350246@shazbot.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>
Link: https://patch.msgid.link/20260623141649.41087-1-manivannan.sadhasivam@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 35bb9e7a63a207..a163168f361764 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -199,6 +199,8 @@ static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
 	val |= PCIE_SOC_GLOBAL_RESET_V;
 
 	ath11k_pcic_write32(ab, PCIE_SOC_GLOBAL_RESET, val);
+	/* Flush the posted write to the device */
+	ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
 
 	/* TODO: exact time to sleep is uncertain */
 	delay = 10;
@@ -208,6 +210,8 @@ static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
 	val &= ~PCIE_SOC_GLOBAL_RESET_V;
 
 	ath11k_pcic_write32(ab, PCIE_SOC_GLOBAL_RESET, val);
+	/* Flush the posted write to the device */
+	ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
 
 	mdelay(delay);
 
-- 
2.53.0



