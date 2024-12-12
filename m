Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8E92210F1;
	Thu, 12 Dec 2024 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023747; cv=none; b=d6RSFbU/EF+3O067Lj4QFspJltHFsyS8Wk8oUP6cNR6QMSqg8o+Dn4IvZqycLixk+eXqsSFqyYNO/zkJEImNTsai/BShoB7GrdZaHpLbCt+o8/gde1X1Z5ksb9s6gq4LQwCYAjDRCV9YQgsFpoPa1Mu30AOWrcquNrNa8o3xywc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023747; c=relaxed/simple;
	bh=o8h4zKQQ7azSiP2kMkzHzpdVmn0FC3FcxyyetEohAg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2IhvfbughefPFc8LcOR3nHM67+hAuxT06XhQzhgbsnCPDJKA5F/Qhr0X+FLxfyJcvYercH0oPC2kAVcIfy9MFBE1p/pfLIA7XfB8hSdXCAbElIl35PTladAWjSfAUg88gjsDPNpses3jxQ+CBdV2eWu1VUe5dV+qZCIm8DK/yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEcU77Gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEcU77Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5523FC4CECE;
	Thu, 12 Dec 2024 17:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023746;
	bh=o8h4zKQQ7azSiP2kMkzHzpdVmn0FC3FcxyyetEohAg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEcU77GuYg8/fDjghh3JcDpvfbpK/1IJuoKUO98G6OgWaMNjdPxW0LgjugphL3nqF
	 se7EBFgVFKm16mvEj+tspO/8x/R4+UsrHLXas8T2eV1oCgt7Vw2lWmbl01RPkAkhZw
	 ZkcFrXuftPyjSPheDSVigmQbVdGyagFGv3TTx0ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/459] EDAC/bluefield: Fix potential integer overflow
Date: Thu, 12 Dec 2024 15:56:47 +0100
Message-ID: <20241212144256.241877627@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e4736eb37bfb3..0ef0489827682 100644
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



