Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDED350A05;
	Sat, 30 May 2026 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161372; cv=none; b=DtEoDAS/OeLKQWM1pTGBxH+m4CBKhyEDN65xnxvL0V3jg5T4A+xtA6n4zWXtmR0P3GXUFgehygbb0IWmosvmXznFg5QYJRj9dgpUzs8q3Ow2gA4153h2Maemkdur5U4KC2VUUzcmOmDqUR54pejYtpkb2YPyygJFk58dDzIvIHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161372; c=relaxed/simple;
	bh=xWzKgDdNRpVC4EpdF0WCE5UgcI0ucTJ9XcOrVsODosw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kufWfkVoQIjXFNyGOQcrz6ownGzRssVPo2kmtz+wILzqh8qUQ8cOhD5H/N+YbnAjw1mklDNqBl64IIvg78KYw5TGrR89QdAPmRA4YhFliheFsBLVHFmwM6oAPfi/STFbMLV0zDaFoUG0x5eI5PkyNoB96Df/YvwnqIhjrABvbpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4oa1vKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4oa1vKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B513A1F00893;
	Sat, 30 May 2026 17:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161370;
	bh=czLuF9PU/B2aown5nJ0G6Z8PZ6sHFDq1BULMKkFK0A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4oa1vKdA25qzvBXRfExLdFEdaiELsfz21L7qSZihUymvDpQqmY5a4DssUj6+rsWD
	 Ivnqkc4WGabJIcBfGOkusBJqRyh6gYWPQUv12j/uwjrtEt2T6hz7PlvEU+Z4AAlk8r
	 CwE9Q+eB+S26nsYG1WP7uVy6WX/VRw7ORAKpFZ7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 574/969] memory: tegra30-emc: Fix dll_change check
Date: Sat, 30 May 2026 18:01:38 +0200
Message-ID: <20260530160316.253014149@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 0a93f2355cf4922ad2399dbef5ea1049fef116d4 ]

The code checking whether the specified memory timing enables DLL
in the EMRS register was reversed. DLL is enabled if bit A0 is low.
Fix the check.

Fixes: e34212c75a68 ("memory: tegra: Introduce Tegra30 EMC driver")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Link: https://patch.msgid.link/20260126-fix-emc-dllchange-v1-2-47ad3bb63262@nvidia.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra30-emc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/memory/tegra/tegra30-emc.c b/drivers/memory/tegra/tegra30-emc.c
index 1ea3792beb86d..fb09e8a463bd5 100644
--- a/drivers/memory/tegra/tegra30-emc.c
+++ b/drivers/memory/tegra/tegra30-emc.c
@@ -554,14 +554,14 @@ static int emc_prepare_timing_change(struct tegra_emc *emc, unsigned long rate)
 	emc->emc_cfg = readl_relaxed(emc->regs + EMC_CFG);
 	emc_dbg = readl_relaxed(emc->regs + EMC_DBG);
 
-	if (emc->dll_on == !!(timing->emc_mode_1 & 0x1))
+	if (emc->dll_on == !(timing->emc_mode_1 & 0x1))
 		dll_change = DLL_CHANGE_NONE;
-	else if (timing->emc_mode_1 & 0x1)
+	else if (!(timing->emc_mode_1 & 0x1))
 		dll_change = DLL_CHANGE_ON;
 	else
 		dll_change = DLL_CHANGE_OFF;
 
-	emc->dll_on = !!(timing->emc_mode_1 & 0x1);
+	emc->dll_on = !(timing->emc_mode_1 & 0x1);
 
 	if (timing->data[80] && !readl_relaxed(emc->regs + EMC_ZCAL_INTERVAL))
 		emc->zcal_long = true;
-- 
2.53.0



