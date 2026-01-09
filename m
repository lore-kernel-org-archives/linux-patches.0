Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2346333A712;
	Fri,  9 Jan 2026 12:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963184; cv=none; b=Vf1JLziG2uJT/AKgwDPDalcChfDNHDHjjT3jPOhkGBv7EbR2KBQtZEyDhgWqyE+9nfd9rYl4k8ZfVJ3NDxjKRyjjnPRJJKg1G/iW4XsjVTieP6FkGBScoXZbVPr6lMXayaFh/sQacGrFpwvg7pF6ehg36136Ove5ILh15Ynqb7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963184; c=relaxed/simple;
	bh=45skOZP3E1FMp4vNKY8mPQiOaIh2HirSP5nOvofdglQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amhob2gN4ymGglbdR16ELLrYtoCUcGBbUn5Twm/SneI+uHVVcUxXEz19Szxy7fDoGXpnvK+SB8VU13b8Rgfe2b2CZo6Z8591CJ0tpiLBqz7rqKfxGBdgyNrBmN2CyoZFDF8L690XSlWl0Z/GZDkoRgP8PiHB8p0SSjg/T/qg798=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRiIMI2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRiIMI2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4202C4CEF1;
	Fri,  9 Jan 2026 12:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963184;
	bh=45skOZP3E1FMp4vNKY8mPQiOaIh2HirSP5nOvofdglQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRiIMI2gniy3YGuy1UiUXX2ytOPWHprsUMETsjb7daRNOQ9avkmLiRfk2XIg9FlEh
	 0bzS7wgEUziIBs5998U0p3FPtLK3JdfQodAMDSCLR5YPvaP1TKRX/P9VJRsqF0QKVm
	 lTIRwEQ+31OFwL3RkubD7Kxpe8CSWQLwdxJf+iWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 625/634] Revert "iommu/amd: Skip enabling command/event buffers for kdump"
Date: Fri,  9 Jan 2026 12:45:03 +0100
Message-ID: <20260109112141.155967308@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f33890f95140660923003ba1e2f114dee20e691b which is
commit 9be15fbfc6c5c89c22cf6e209f66ea43ee0e58bb upstream.

This causes problems in older kernel trees as SNP host kdump is not
supported in them, so drop it from the stable branches.

Reported-by: Ashish Kalra <ashish.kalra@amd.com>
Link: https://lore.kernel.org/r/dacdff7f-0606-4ed5-b056-2de564404d51@amd.com
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -805,16 +805,11 @@ static void iommu_enable_command_buffer(
 
 	BUG_ON(iommu->cmd_buf == NULL);
 
-	if (!is_kdump_kernel()) {
-		/*
-		 * Command buffer is re-used for kdump kernel and setting
-		 * of MMIO register is not required.
-		 */
-		entry = iommu_virt_to_phys(iommu->cmd_buf);
-		entry |= MMIO_CMD_SIZE_512;
-		memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
-			    &entry, sizeof(entry));
-	}
+	entry = iommu_virt_to_phys(iommu->cmd_buf);
+	entry |= MMIO_CMD_SIZE_512;
+
+	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
+		    &entry, sizeof(entry));
 
 	amd_iommu_reset_cmd_buffer(iommu);
 }
@@ -863,15 +858,10 @@ static void iommu_enable_event_buffer(st
 
 	BUG_ON(iommu->evt_buf == NULL);
 
-	if (!is_kdump_kernel()) {
-		/*
-		 * Event buffer is re-used for kdump kernel and setting
-		 * of MMIO register is not required.
-		 */
-		entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
-		memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
-			    &entry, sizeof(entry));
-	}
+	entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+
+	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+		    &entry, sizeof(entry));
 
 	/* set head and tail to zero manually */
 	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);


