Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F11198E83;
	Thu,  5 Sep 2024 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529502; cv=none; b=ojzic8k4rWjLoLBqLMSFrKEqJS8nACgzZ6WST5EZmRFoE3gfr5OUMGKfVDdLhShqXIt6dmTTCrC6KZcZr+DtKD0xd2r1DcvIbdrfdhsbP6/v8vUAr1/6ubU1b3a1QtnCxMrXlQqvRH8K6NTRf/bbAPsKKnjTxe3yP5Fji/MrFqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529502; c=relaxed/simple;
	bh=ymopELaqQAcvAOslyGNd/k9OtpoXvY1zgtqKBFTgFtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSDxOrIJtEZM9s123ncTJFJungTrTgMsP/nDoJyhWlsJRfVFFY8f8mqPR4thDq/EkQDs829DYIAM0ptrvX5EXZLWuP4lHMvoKAteiFagiIFvO+tmbJSGObba9TCeF4J/xmyegRE+J4nbSeEFUUu5OTsewELjn6SWLoNpsI8yxeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxmAQIv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxmAQIv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB388C4CEC7;
	Thu,  5 Sep 2024 09:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529502;
	bh=ymopELaqQAcvAOslyGNd/k9OtpoXvY1zgtqKBFTgFtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxmAQIv9zKjUMrhOv2CD5BsnJQLRZsxijcKWbdFa31O62r1ZnwkGUAoskvHEu7iUx
	 EWJXZ5hn3M+syZBc+cnNMn/ZDlLJ8myJE7HrL5BgLPIyy/ptajsbvsDjI3qEAegGya
	 4cV1vpr6sIh0OmIVlrZP4+5eTsJwdtIpX8f36kSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 052/184] drm/amd/pm: fix the Out-of-bounds read warning
Date: Thu,  5 Sep 2024 11:39:25 +0200
Message-ID: <20240905093734.275163706@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 12c6967428a099bbba9dfd247bb4322a984fcc0b ]

using index i - 1U may beyond element index
for mc_data[] when i = 0.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index b1b4c09c3467..b56298d9da98 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -73,8 +73,9 @@ static int atomctrl_retrieve_ac_timing(
 					j++;
 				} else if ((table->mc_reg_address[i].uc_pre_reg_data &
 							LOW_NIBBLE_MASK) == DATA_EQU_PREV) {
-					table->mc_reg_table_entry[num_ranges].mc_data[i] =
-						table->mc_reg_table_entry[num_ranges].mc_data[i-1];
+					if (i)
+						table->mc_reg_table_entry[num_ranges].mc_data[i] =
+							table->mc_reg_table_entry[num_ranges].mc_data[i-1];
 				}
 			}
 			num_ranges++;
-- 
2.43.0



