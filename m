Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCC8348C5E;
	Sat, 30 May 2026 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164212; cv=none; b=RdJz2vabB762jhIWwm/90bBMvPnRCn/qUf1QMNg7U5URqXFcySfCKfOUYvUbMQijQcrdkz7sGXRLa+Wblpy1GoBceQhBBfHgTNH6rhWmJMZn575bL62nGXz8TgdpzptFm8dWiM4EX52DLzXcwjNNVA70HHV7Q++jWCw5g+zmZBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164212; c=relaxed/simple;
	bh=3kimuW+mIsHB3bEn6CYX0kQcZXeiIsOEGcOL+B5KioM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4LPAgWYEVH5hBcEYkqSxn3bwbghPwJo9GP3mwKz5Fb2Gbc8h1cdf0VS5Il+NcZVs65bqK/dPFzLiaKjib0eprtfc6oeLsuAz1QazmsMVb6V0lVqQW3eckOlK/JX0oYDXUECSx0GcKTpNHmicxtET6ejC7K+EPcUHgRyc8SYD+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmy2FDPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmy2FDPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAAC1F00893;
	Sat, 30 May 2026 18:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164211;
	bh=Q18pZG6tr4Exm7e2ILIC25xPnIstKzX6ymff2npqqFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmy2FDPLkINpLnVVBCYxBbSvEaj6ubYeXd1yg4opJluTrkUEDA74srlbELNFcIKIC
	 xln170FhWGG9Yp7/wVIAK8orZ99o9AXqePMAddeSbB00xXGQPFEHJ+KgaK5FnzWXvb
	 shXmYmkaofbsuesk+gjuxhGqADpp002eNAyDVAZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 487/776] memory: tegra124-emc: Fix dll_change check
Date: Sat, 30 May 2026 18:03:21 +0200
Message-ID: <20260530160252.912555768@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 908f8d5392b21..6d5eb7d5b75c2 100644
--- a/drivers/memory/tegra/tegra124-emc.c
+++ b/drivers/memory/tegra/tegra124-emc.c
@@ -608,7 +608,7 @@ static int tegra_emc_prepare_timing_change(struct tegra_emc *emc,
 
 	if ((last->emc_mode_1 & 0x1) == (timing->emc_mode_1 & 0x1))
 		dll_change = DLL_CHANGE_NONE;
-	else if (timing->emc_mode_1 & 0x1)
+	else if (!(timing->emc_mode_1 & 0x1))
 		dll_change = DLL_CHANGE_ON;
 	else
 		dll_change = DLL_CHANGE_OFF;
-- 
2.53.0



