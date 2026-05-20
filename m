Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB1F33A033;
	Wed, 20 May 2026 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298311; cv=none; b=d8PXJTDNM/v9bGsLIx0BfIx87AKuh3ZxfIwe1MQGN3dN4zLU3xKiZy7MlLVPcqqSsAYTLLYmK2LTaPD3Q/MkDAA8wYPCC1jMej8Xhmz8bW+y4yaZgyLFgdf9eDrvw2ovafMuY7afII50CLJ2vCJjNWReU5wPsuB39Ccaioh28P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298311; c=relaxed/simple;
	bh=GJzPe78ORS07YnevEt9lhsEy6dw4abMMM5RkJ0pjFZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOL3cZDHoajhY5X9fuzfEmeafjTaZjREk4kcFdPCp6tPBuzwfAjF+Y1YPWf8rqcpzrfVindLtTRKboMjuBZarAs+KLVm4c9RNK6GQ49PZwvJRChDN4jnp84DJRZcbHzjy6rw+AAG+SNn2cM3zZAKIZ+C1rq2s5JHWgKQCTEApb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8dBL8VQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8dBL8VQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A061F000E9;
	Wed, 20 May 2026 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298310;
	bh=u9PetfJODt/iAi7fTkFu0Pl1wZZ3nKBCUP3re2yWEVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z8dBL8VQB538lx3jl5Ks4+8CYA91hW6N9Nbf/FTshagIN1hkGlouw7vxfW3mOF40h
	 I06bJM5q5RFja7JXGsKjzbm4vm4OxrpR3dqBfTEGQTHhd180gUNMAIv0Z0bTeT5etW
	 5eWj0TIM0C8JSl76ZKGSAq+1/6RXs2jTYlkb6Ds8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 363/957] memory: tegra124-emc: Fix dll_change check
Date: Wed, 20 May 2026 18:14:06 +0200
Message-ID: <20260520162142.402448063@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



