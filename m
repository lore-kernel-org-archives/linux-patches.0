Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D1733FE15;
	Sat, 30 May 2026 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161368; cv=none; b=gay+5hMesW8MFfgoItHNqODv5fEtXRUYMaxH9s0YNyUPD7NLhKthHIRwTcuMdm48gMYdYojMpgLcHeszWOhYjgaUmal99oZggMZO4HOKxAyJZoig8Ky3qM1b1YzM7oIheHkyvggAii6i4Qm3i0b+MKqQhIqH/K0AEK8aLpBZp+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161368; c=relaxed/simple;
	bh=3COOhJDhwXyf0tiVC55wfY4SFD+9Slb22KLB4SFhLgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egCW/wywAcsLamUBUZb7nGROzvPBlBvZXjKIUk6OpVfD4Ce8zfQw/dAIwvxpHPLAGNd7yFBGOj4AOcv8DJeB/VQ090QDIgIxp3C0/+jJtkT3rIgN/JuJpmYi0GJ7rlEVDFW8XiJ4A3T6q5HkriNXchMLsR+c2h/XlrBt3vGm/+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veO2WSdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veO2WSdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4901F00893;
	Sat, 30 May 2026 17:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161367;
	bh=Wbtzg33gazgpCczFw3P0fzsTxOrEiOqjPCw53X8Jy/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veO2WSdYMAooI50p7Rpv1Su7l3lKrl5JFip0QZjz6aomsPdpEAifvp1fPH0FCQaJP
	 mC4J1Z5IZAWn51v5DmZUoBa4JwiPInF2a3vXgsu32WB7PjXZY9WF5Ul0BAFlLK9rRy
	 sAhC6oaOnMO5QXVPPphYxaZ/qzrXnTioGUupSJ1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 573/969] memory: tegra124-emc: Fix dll_change check
Date: Sat, 30 May 2026 18:01:37 +0200
Message-ID: <20260530160316.225120866@linuxfoundation.org>
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
index 00ed2b6a0d1b2..ca2714b0a521a 100644
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



