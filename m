Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450D62DC350;
	Tue, 11 Nov 2025 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824160; cv=none; b=nVlFBAXLEcnQbg9svgPR8sDC13diE5D3ED9OXJ9qZFb+L1mEWiOJR4DBBNeUx74zqKQu3GuZK5hwp0rLI0u1kEe50go9ALXX0HEusAe6rb8zUjePMXoyMa3jK/urQnk9nnhXfSgFrSTCT/VSF9CX2AZGVSsJSQhfmfmxxS4yTXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824160; c=relaxed/simple;
	bh=ia+wFeF4Q1DwUO4Z8IUvclYlqM9RZFX3Eqao4SmcevQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6crWtMJwEZZv3pw92ZemkgEpRTBorG1umgo7E8TNq1Q3FMk+CEPm3J4c7WW6kS/v9LSnmkb6Rttb8w47UWYDC4XK9C5gWkKf2Bq4iJItHSnDVG+UHk8L3BHHHdD9lVeAPgHLgAYPjxBgYmAVUNK81E0A9wJxlYDZ0UgQyhlDqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYPIZyEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYPIZyEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99552C113D0;
	Tue, 11 Nov 2025 01:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824159;
	bh=ia+wFeF4Q1DwUO4Z8IUvclYlqM9RZFX3Eqao4SmcevQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYPIZyEKkb0s5uK3aJt1+z5yZKn2WGv8Bi5zJeO2iUWSLRpazVWm1a/8XnCD4OIlH
	 K1l/xAsdh3mZX41pmg6AiXo0egrUjUFslHmhr/1H59O2Mvj8C/WrBFiMQoeSBzZt0B
	 6gFeomm2LdwSrpkg1IRzml5C6Q92l2ZTZE/R9s0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 448/849] iommu/amd: Skip enabling command/event buffers for kdump
Date: Tue, 11 Nov 2025 09:40:18 +0900
Message-ID: <20251111004547.264578537@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit 9be15fbfc6c5c89c22cf6e209f66ea43ee0e58bb ]

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU command buffers and event buffer registers remain locked and
exclusive to the previous kernel. Attempts to enable command and event
buffers in the kdump kernel will fail, as hardware ignores writes to
the locked MMIO registers as per AMD IOMMU spec Section 2.12.2.1.

Skip enabling command buffers and event buffers for kdump boot as they
are already enabled in the previous kernel.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Link: https://lore.kernel.org/r/576445eb4f168b467b0fc789079b650ca7c5b037.1756157913.git.ashish.kalra@amd.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 309951e57f301..d0cd40ee0dec6 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -815,11 +815,16 @@ static void iommu_enable_command_buffer(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->cmd_buf == NULL);
 
-	entry = iommu_virt_to_phys(iommu->cmd_buf);
-	entry |= MMIO_CMD_SIZE_512;
-
-	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
-		    &entry, sizeof(entry));
+	if (!is_kdump_kernel()) {
+		/*
+		 * Command buffer is re-used for kdump kernel and setting
+		 * of MMIO register is not required.
+		 */
+		entry = iommu_virt_to_phys(iommu->cmd_buf);
+		entry |= MMIO_CMD_SIZE_512;
+		memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
+			    &entry, sizeof(entry));
+	}
 
 	amd_iommu_reset_cmd_buffer(iommu);
 }
@@ -870,10 +875,15 @@ static void iommu_enable_event_buffer(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->evt_buf == NULL);
 
-	entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
-
-	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
-		    &entry, sizeof(entry));
+	if (!is_kdump_kernel()) {
+		/*
+		 * Event buffer is re-used for kdump kernel and setting
+		 * of MMIO register is not required.
+		 */
+		entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+		memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+			    &entry, sizeof(entry));
+	}
 
 	/* set head and tail to zero manually */
 	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
-- 
2.51.0



