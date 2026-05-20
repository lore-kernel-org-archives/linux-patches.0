Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C9D272E56;
	Wed, 20 May 2026 18:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302212; cv=none; b=bFsJfyec2oJmTH0EJBuajDrNIc58xXpPRtotZ2zu++v5y2/aG5hhDPQTA7kLK+eG/QzZ1kCeuOwCRlKrMGLKMa/A8uOHIYHxjaPQgE2zwzkyqYd1MoCAnE4vPrhJ00WWANLnvE5Vu9YwofZA3JOa5ZPSh45rcu+1CLXp3cQ+9dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302212; c=relaxed/simple;
	bh=hsoZ5g5j8c5x9wdGL+dFJ3CJ259hoeYZ7izNkoDrZCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3QWG4EHjt9yMWxyWuTlH5Jq7J6LI9PDAYfeuNfF3Hr8IslG+/CAeIaYZlVk/prJAnDRrXk2EAgFrqvBlY6wVaqqSJnRxbTiJo4QV2qrETktfasRr2FqfLC9iC2G//O+573KBF71AkvI9brR0tUjl0vw3BKCIlE6upL86h0QahQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4rTwwTq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4rTwwTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466A01F00898;
	Wed, 20 May 2026 18:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302211;
	bh=Xp/YIvB2xiXVm32AkwN76glLxU2TN2bhZNbzoGuDMtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4rTwwTqWfQPL0CCamEIKMnVG8ib9ii+JG14UxfOoTHONbtL2JtIl6F3P59gtvqEc
	 hlv0W0mxhFXpt+W9W0KdWdr5zVPj6Z43hCHc+FCXwoGUQ3rUvRTve+jeLK84OqlEJq
	 wrJMBb8fzty86ZkqhCPq6S5+WdXgHWDZlvhM29IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/508] memory: tegra124-emc: Fix dll_change check
Date: Wed, 20 May 2026 18:20:05 +0200
Message-ID: <20260520162102.580392891@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



