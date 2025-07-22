Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3323F1A2C25;
	Tue, 22 Jul 2025 14:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192881; cv=none; b=u8U+CyvcjMl1BiLEctfxk/JE2A6O+jza1H8Ll5ok60N+SxA/RQKR7b9xEGW3rtkgYRfib5ZfaiXPUc4nCmw+Q+LAsUOjiEh05Y71hC47ahpWnhRimYD/6Vccq95TJjOW+JIoy5xZLY36c7BhChovEcSxn2yCZ/bnWt4x9HWHbJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192881; c=relaxed/simple;
	bh=U/PZag4DRa0RcG9F3u/G93W8B7jUNETaBxUo68J05vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKPZoz2CXhNHCYUaqvoI1mPHpRFSAaWSibt96cVI7gMnHOC1yM9HEwopKqXjtiU3dKzV1HYgGT0lHc6DQ4qnxT64c7VFM/boGL8SLL/NYRt5O1b+7bJhBMcHd+lAnyxxKZTko3yyt9v3r9mXJYOLqsgl/1WwONKxaZJdOqsSzG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sm8FiB9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sm8FiB9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D30BC4CEF5;
	Tue, 22 Jul 2025 14:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192881;
	bh=U/PZag4DRa0RcG9F3u/G93W8B7jUNETaBxUo68J05vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sm8FiB9/NntJW5ws1ooDuVjY8eZvE10NJfDKb/KE3/ZRSdWsx73AMBI1rKnOj7Zli
	 7TEydnmfKxR/ul5yD6MrgWjCoCk7nFIeclKHdJwvIq+ay+AgDpRqlqxhS7LgXhixYh
	 ZVwoqul/qoSYSpDhqPp9kdeU5/0v5zEWTQuNjgOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/158] soundwire: amd: fix for clearing command status register
Date: Tue, 22 Jul 2025 15:44:29 +0200
Message-ID: <20250722134343.941501918@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2912f874a1352..1895fba5e70bb 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -187,7 +187,7 @@ static u64 amd_sdw_send_cmd_get_resp(struct amd_sdw_manager *amd_manager, u32 lo
 
 	if (sts & AMD_SDW_IMM_RES_VALID) {
 		dev_err(amd_manager->dev, "SDW%x manager is in bad state\n", amd_manager->instance);
-		writel(0x00, amd_manager->mmio + ACP_SW_IMM_CMD_STS);
+		writel(AMD_SDW_IMM_RES_VALID, amd_manager->mmio + ACP_SW_IMM_CMD_STS);
 	}
 	writel(upper_data, amd_manager->mmio + ACP_SW_IMM_CMD_UPPER_WORD);
 	writel(lower_data, amd_manager->mmio + ACP_SW_IMM_CMD_LOWER_QWORD);
-- 
2.39.5



