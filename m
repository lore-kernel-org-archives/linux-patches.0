Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DBB25B08A;
	Sat, 30 May 2026 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166553; cv=none; b=PIyh7KwOuYXUbvT5HglRUciwK7vBz7KGuEZFRQAZ+MnaFaMCw455F5+miNXMvuXe9e5Uz4qSx/xy2BEQs49GlMZ193wQ7pyoBcUmNDa3IWeaQ0VoNvNvZ9qPib2RPgPNG5hvXS/ttVO43t/5HhuWMyAnh4rFUHqBfhZW6FG0jzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166553; c=relaxed/simple;
	bh=jSsaJEofjPXXsjEP0oyoQsE9YqEH21r6BJ+TdpYXTmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDEBY1tgoCqUjTgPFKOpmuImQ0cYM9NsAfR+7STB6i1XFX3xd9SrP0+dlwEzqBvWwvjkkwSmhNMKZi7KcWSBGeRQJPXpI2wE2eNJwH1vgb97zaN8mk3yNSwaS/7Nwb7QyOhU7jpUnopsTJdfU4NXn64aXSzdxcfPIuPG+eYt14A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ys9x722p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ys9x722p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D821F00893;
	Sat, 30 May 2026 18:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166552;
	bh=azqHBg4uBkXS83R+SuGmRhmeUCochY4VRGvxbh+SYTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ys9x722pk/UWz5NN2vFBYaLHRaSepxYKlnE4wLSW/N+ObBykvMs0g9UjyRHNQClBd
	 TUD28xEuWni/k1byXLB2cU38DBA4lrAO4el9IH6noJ+/UYAQlwOihZwpNYytlQP8ho
	 rEMzfL8sx0N/sshaQFSZIjWb5C/adKKCIJzXEoyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 361/589] memory: tegra124-emc: Fix dll_change check
Date: Sat, 30 May 2026 18:04:02 +0200
Message-ID: <20260530160234.333766734@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 9597ab9a8296ab337e6820f8a717ff621078b632 ]

The code checking whether the specified memory timing enables DLL
in the EMRS register was reversed. DLL is enabled if bit A0 is low.
Fix the check.

Fixes: 73a7f0a90641 ("memory: tegra: Add EMC (external memory controller) driver")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Link: https://patch.msgid.link/20260126-fix-emc-dllchange-v1-1-47ad3bb63262@nvidia.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra124-emc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/tegra/tegra124-emc.c b/drivers/memory/tegra/tegra124-emc.c
index dae816e840a96..f5218fea69ed9 100644
--- a/drivers/memory/tegra/tegra124-emc.c
+++ b/drivers/memory/tegra/tegra124-emc.c
@@ -578,7 +578,7 @@ int tegra_emc_prepare_timing_change(struct tegra_emc *emc,
 
 	if ((last->emc_mode_1 & 0x1) == (timing->emc_mode_1 & 0x1))
 		dll_change = DLL_CHANGE_NONE;
-	else if (timing->emc_mode_1 & 0x1)
+	else if (!(timing->emc_mode_1 & 0x1))
 		dll_change = DLL_CHANGE_ON;
 	else
 		dll_change = DLL_CHANGE_OFF;
-- 
2.53.0



