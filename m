Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805683F789B;
	Wed, 20 May 2026 18:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300673; cv=none; b=PMIlk/fWZFfhCWCorH0EhtUpvieBM0P1jE0fN5qEFbuom7YVz2LN2VHpMYTVFTh83H5bYfRP9+4CvBJDV9IbZp5qEmyq/7oudLEfRQMJGmFtgnPs5L9QoIK8AlCJ1dPhyg5/vnFnQgSu0GMzbPExiDvmRTHu8edt5QwmgUkbTNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300673; c=relaxed/simple;
	bh=XG0URnDHmdvKKtvC7s9CGNNXhcFC9Ws1mS6fPlSUv+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUaK/5dZx+0/9ZOUSlpDCa8JXu+ay698FJ49rTArbp2uIaZ1zwngPBxuEYwVFhqzZq86oaf82lk+6DWuCmNNskKSB7RDomADZ4TDLy/N7+bjsXtFMFvUm2GuKdWYFb6XKep7tozZ27LDtXMdlR6SQxcRV+GA6DkD65vQlYrNGgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RS/5SvEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RS/5SvEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2EC1F000E9;
	Wed, 20 May 2026 18:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300672;
	bh=WkPwCme3grXM1J1fVFCgfsagAETi7PQRuIcgjFipJyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RS/5SvELhNz0QqU9KKe8O/1/35iddatu3HXKSCskjSVgVSpxz+6mjKdh3KG/ISrol
	 Sr6grZ/9yDS8csIojo3sMVvCF9X1Fm9vqD4iCLkgK3ABONR1Bc450Cy98uu33rJ6Nl
	 0+yhH7FkK0SyMmGWBjOtsy6m0jKOmLszVbgCtYho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/666] memory: tegra124-emc: Fix dll_change check
Date: Wed, 20 May 2026 18:17:56 +0200
Message-ID: <20260520162116.959975004@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 03f1daa2d132a..71d20b5916d89 100644
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



