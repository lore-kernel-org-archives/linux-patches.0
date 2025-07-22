Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A6B2ED870;
	Tue, 22 Jul 2025 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193471; cv=none; b=FtXTnkKwb49fl1x7qgUCsbBX5MMzhtwWEAZel6ZqyaiiM/DDOvfj+kNorMR+Ng1+TsOC1BWjTekeTg4vZvC+mFTNGUabrdeSK/CHmW5Zjhw5WLvIIZxlBuT4FRNAuBjYFXf5xj9769iRUjvkHBfq/eQByIh+/QzJPsLg6hudYS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193471; c=relaxed/simple;
	bh=XKuplCVpJV+CKJO2uwPdvUWwPMcWp11xP48qAYJ6A0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkJEN/9ESL/+VOX6pKVZ7q8q9oE7Jv2L30UZNHonhc5MGrmQVuLfKA6ZPF3HFX0sumFg7ZmgZK/33ECmxFvZdhgRsYxu69hHpppBd6w7/ddCp6z3xXC8rTStVopZa2ePzgeJVW5usug4NvPmnSNbHxRWt6Pa9bqTuIfzaWvCPmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+d+4P29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+d+4P29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95BDC4CEEB;
	Tue, 22 Jul 2025 14:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193471;
	bh=XKuplCVpJV+CKJO2uwPdvUWwPMcWp11xP48qAYJ6A0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+d+4P29pWsiin1+mLWXGxwlg1pYLYP1NwKllC3vOf1DDHafFABQox//zU9439fuO
	 wZSGilUZj67Q4xJqD8WfmWTO22KE5383sV2tVTYqxwqK0QiMdx4ub6DamaxkY9jBHu
	 Pe2gVgSYz4O3hjfvbArQChhd8zmXvI4EJaqCt1J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 101/187] soundwire: amd: fix for clearing command status register
Date: Tue, 22 Jul 2025 15:44:31 +0200
Message-ID: <20250722134349.535452184@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a9a57cb6257cc..7a671a7861979 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -238,7 +238,7 @@ static u64 amd_sdw_send_cmd_get_resp(struct amd_sdw_manager *amd_manager, u32 lo
 
 	if (sts & AMD_SDW_IMM_RES_VALID) {
 		dev_err(amd_manager->dev, "SDW%x manager is in bad state\n", amd_manager->instance);
-		writel(0x00, amd_manager->mmio + ACP_SW_IMM_CMD_STS);
+		writel(AMD_SDW_IMM_RES_VALID, amd_manager->mmio + ACP_SW_IMM_CMD_STS);
 	}
 	writel(upper_data, amd_manager->mmio + ACP_SW_IMM_CMD_UPPER_WORD);
 	writel(lower_data, amd_manager->mmio + ACP_SW_IMM_CMD_LOWER_QWORD);
-- 
2.39.5



