Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4D51F12E0;
	Tue,  3 Dec 2024 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240171; cv=none; b=HdUBP9KSnHg4SHagadUig8yIAlfkqBVgUCYMXvTrmbWQ9sLUXBLDU6ctnbL9d2nxwbPijIPDMcC3Hl5kPhOLfIWxkfuwG/mVmHTGakh8SFYmZ2Sf/KZ7ZQ16QZ3l9OWxpSQ3GYek8YsOVSZ8tRy9OPP7BNVJMiwDSan62kV6pAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240171; c=relaxed/simple;
	bh=TaUxiZGBN6asaTV4nyhYgyQLqdHDuWJ2K8k42zMdy0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoePmLX9RWIO+lf3kdx7eph97C/YpJF1z8Lvn+Re/fSb3x25qkUndYtcUROVwgqoAt0SYAeKy/7nrPhstFkfB+WqYRigTmlD/tJva/rftMIutYIOE+5XbLZ9Ve+K6UgyNnCxKZlzxqltB1IxXDPKZt1hS9SHIoSAV0zsbb0gjk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEDWddzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEDWddzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556B9C4CECF;
	Tue,  3 Dec 2024 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240171;
	bh=TaUxiZGBN6asaTV4nyhYgyQLqdHDuWJ2K8k42zMdy0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEDWddzImSnu2rfeYofbtdz39fpAznoSeKqdS92i7bQXMvQifjDZN75rbu8Ki4UYw
	 bkSss4eNn679AgjsQ6okh2i8zIJnLpWvS02tLpOyRuLdXg6YXNATpNhuGvwOn+OMOA
	 T5cNZf7mUkEOhHKMfZpHkLixJVhup4TVLLJU+m2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/826] EDAC/bluefield: Fix potential integer overflow
Date: Tue,  3 Dec 2024 15:36:15 +0100
Message-ID: <20241203144745.345260696@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit 1fe774a93b46bb029b8f6fa9d1f25affa53f06c6 ]

The 64-bit argument for the "get DIMM info" SMC call consists of mem_ctrl_idx
left-shifted 16 bits and OR-ed with DIMM index.  With mem_ctrl_idx defined as
32-bits wide the left-shift operation truncates the upper 16 bits of
information during the calculation of the SMC argument.

The mem_ctrl_idx stack variable must be defined as 64-bits wide to prevent any
potential integer overflow, i.e. loss of data from upper 16 bits.

Fixes: 82413e562ea6 ("EDAC, mellanox: Add ECC support for BlueField DDR4")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Link: https://lore.kernel.org/r/20240930151056.10158-1-davthompson@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/bluefield_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/bluefield_edac.c b/drivers/edac/bluefield_edac.c
index 5b3164560648e..0e539c1073510 100644
--- a/drivers/edac/bluefield_edac.c
+++ b/drivers/edac/bluefield_edac.c
@@ -180,7 +180,7 @@ static void bluefield_edac_check(struct mem_ctl_info *mci)
 static void bluefield_edac_init_dimms(struct mem_ctl_info *mci)
 {
 	struct bluefield_edac_priv *priv = mci->pvt_info;
-	int mem_ctrl_idx = mci->mc_idx;
+	u64 mem_ctrl_idx = mci->mc_idx;
 	struct dimm_info *dimm;
 	u64 smc_info, smc_arg;
 	int is_empty = 1, i;
-- 
2.43.0



