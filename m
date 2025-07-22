Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BB4A32;
	Tue, 22 Jul 2025 13:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192421; cv=none; b=JCwIV6eEsYTc3ZYgRLIohvt0a7WwPc/oulGK/SQYhJwZ0BwkkN31Fx5Hcv8UB4XfES2fGyw5Ch+V4ojhzHLvJ37kR7T51f1zAuNzkRH6mZ2kXC5DiJYE9D6ivJ7bQDEKY2b1VBbhlNVSEpjKfNF+6Ob8DPCUQk/alkiXgBAv+38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192421; c=relaxed/simple;
	bh=dxvu9UMZuzKzzqMeSAhy4Qfp5BiL7BZ4xF+zEgH7tpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4JVoxOOFZk0haTnwQj6m8t434XJqe2w49qAMpcwy46PmisDcenB5T66cXv3HWkSEUHdFlwOxKotMt5AQLIOKbVFeiSg0AutgwuObCPbMLdf7W9X6T4eD2gmQ0hQtfunL3SMuVEjrDfS/672BWNc5JC8xLrqaSjFtz28zvBQJA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXYlKPRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXYlKPRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750B1C4CEEB;
	Tue, 22 Jul 2025 13:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192420;
	bh=dxvu9UMZuzKzzqMeSAhy4Qfp5BiL7BZ4xF+zEgH7tpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXYlKPRW4ljxGuaLsk421Rxn9QylRE5Py1kJTZlm2dp5/ocWQRqcmP3tx5jC7Aam2
	 nIZ/Pw7VjPgD17jd7qIHOt1fCYWgWA6zfa0cbVx4KJqBAR1xCeTyLxLa+cnQRwbKQK
	 COEujW8u/dZ7/zXywGQ2bX4JtU+a9KptAFpX+FrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/111] soundwire: amd: fix for clearing command status register
Date: Tue, 22 Jul 2025 15:44:35 +0200
Message-ID: <20250722134335.624627610@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit a628e69b6412dc02757a6a23f7f16ce0c14d71f1 ]

To clear the valid result status, 1 should be written to
ACP_SDW_IMM_CMD_STS register. Update the ACP_SW_IMM_CMD_STS register value
as 1.

Fixes: d8f48fbdfd9a ("soundwire: amd: Add support for AMD Manager driver")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250620102617.73437-1-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index ce1c8e1372eed..b89f8067e6cdd 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -205,7 +205,7 @@ static u64 amd_sdw_send_cmd_get_resp(struct amd_sdw_manager *amd_manager, u32 lo
 
 	if (sts & AMD_SDW_IMM_RES_VALID) {
 		dev_err(amd_manager->dev, "SDW%x manager is in bad state\n", amd_manager->instance);
-		writel(0x00, amd_manager->mmio + ACP_SW_IMM_CMD_STS);
+		writel(AMD_SDW_IMM_RES_VALID, amd_manager->mmio + ACP_SW_IMM_CMD_STS);
 	}
 	writel(upper_data, amd_manager->mmio + ACP_SW_IMM_CMD_UPPER_WORD);
 	writel(lower_data, amd_manager->mmio + ACP_SW_IMM_CMD_LOWER_QWORD);
-- 
2.39.5



