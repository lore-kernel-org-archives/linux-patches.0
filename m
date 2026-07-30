Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190F8372691;
	Thu, 30 Jul 2026 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425776; cv=none; b=q7iLUVCOgu/vuHxc8LQbGsx6VRF0Cy3HoPEc+RTttsVQ70OCLRIOPV3AwkAH9P0o/QeLgVNnXDsd7Juyevs/PuSwc0Eoc6se08wbBjFJg79+J+t5x1mI1y3KbQeB2z0nK5hty0jK4sOalmKwiMVcd5ErcFU68CHpb8qEoMjGGlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425776; c=relaxed/simple;
	bh=r2AM8H3gzPp0t3yU7mzUUyHvXeACvFDNf0hNkm1gDz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWPwhcETkdOU8x1kiybCGanR7rp/Ac61nzA6qzIvN0CIXRrIYtSzFkdhaDTJ2FZl8xy1ns846ueyBJnGdJWcQmX7SpEr79lZID89IzRN017gk6+shflzhZRLFP3p7BT9tfDUcXTzr/SSCuYwEYmg8q6WANsyUu9Nq9eB+oEXGJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nDH+SVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nDH+SVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE6E1F000E9;
	Thu, 30 Jul 2026 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425775;
	bh=18GmNPYpyfORJ6IkBvoAyUWHVoTXPf2W1VND96hXxG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nDH+SVjfR84bPJPJUtOqijPLwGB7r5qlvyTF8Vn0ybDmZTy1S2JNqRZKXYVthR4B
	 PAOSPc9Yqeq/GJ2bY/qs4V0pUgG/oeKJOEEAZuKJKip3gNvtQgrOmeCv6uJBnFBNAo
	 yJo5GD9iStwt3iW0cGGG2okCjK0z50OgyZ1iDBzg=
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
Subject: [PATCH 6.12 143/602] wifi: ath11k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET
Date: Thu, 30 Jul 2026 16:08:55 +0200
Message-ID: <20260730141438.984425572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index eee83eb6b2c3c0..6b0e52a6fb89b6 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -197,6 +197,8 @@ static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
 	val |= PCIE_SOC_GLOBAL_RESET_V;
 
 	ath11k_pcic_write32(ab, PCIE_SOC_GLOBAL_RESET, val);
+	/* Flush the posted write to the device */
+	ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
 
 	/* TODO: exact time to sleep is uncertain */
 	delay = 10;
@@ -206,6 +208,8 @@ static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
 	val &= ~PCIE_SOC_GLOBAL_RESET_V;
 
 	ath11k_pcic_write32(ab, PCIE_SOC_GLOBAL_RESET, val);
+	/* Flush the posted write to the device */
+	ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
 
 	mdelay(delay);
 
-- 
2.53.0



