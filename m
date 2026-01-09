Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA172EC54D;
	Fri,  9 Jan 2026 12:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961397; cv=none; b=U+d6c1zTVula6T0ozJDxKrmq9ny+PDyc5YDmsYN4jUWomPU9PqSMTo8LdnEL9Uu1LkKogITV0rf2WGCxIFu6DUr3WGL5I48E3RL1mtOHx8T0iir4r0jt3L0c6lN8pnrW/MIrRSMHhaPpD50HVlihg0X9sQi/oeKYaAGi8yiYy8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961397; c=relaxed/simple;
	bh=s9vJBTZtdOhHIRzUYPCK/ZjsolTsGXmCI17rqQ2YOUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwEuJomr+6ze8pMtqeG4JuXEsaYlU3si0PfpzuiRgDLg7W84MFDYYaff9fdW6oQl03V4LubH4A8qUmEL2zylOAQ0lGtFKBZuvHEWfLxCvlM7Drb4h3OYcxPZ4u/xN+jV8XmReJE57M1Pnid//5ftwo+mZkbX3etkFG7i0tvl528=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VW9xgJW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VW9xgJW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FD8C4CEF1;
	Fri,  9 Jan 2026 12:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961397;
	bh=s9vJBTZtdOhHIRzUYPCK/ZjsolTsGXmCI17rqQ2YOUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VW9xgJW/h/yhjMojt2TjA9AmRSFK3peZm8c2FwECPvcla1dEfM3p4BGQbXTVaWur0
	 ErAO+37udbFy/69xJ/EvfhPVd1uIk0MeaNaEDuWXEC7hgQzZ7ZJ3agUnuiMnw7Xuje
	 V/uVFiez+9tmgM779Hmi0kX/maC3zPNtFFJBBRC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 737/737] Revert "iommu/amd: Skip enabling command/event buffers for kdump"
Date: Fri,  9 Jan 2026 12:44:36 +0100
Message-ID: <20260109112201.830855236@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 44a764aec64b3f3235b9cbac2525222f69685418 which is
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
@@ -840,16 +840,11 @@ static void iommu_enable_command_buffer(
 
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
@@ -898,15 +893,10 @@ static void iommu_enable_event_buffer(st
 
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


