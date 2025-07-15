Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77FA2E4993;
	Tue, 15 Jul 2025 13:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587315; cv=none; b=k8qAHU22BXhvEIIU6N/2XovkvqZQYoyiaaUE3XW2UUgl8mtxLFT/U2tFGziGVlZpC+tlfdK4oSeD38SwHwGeyUP1jWZQg68usCLRZARUGec+WBPzCVVsjHyJXD9dFEvkqxGwWmyoWCyiZrqulZRkgCY7JxyxjzeGamM5A3ZBQ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587315; c=relaxed/simple;
	bh=LOYcUfBHGE+iTy9zqduPJZA/Fp69vimZRwuwgDZYqxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+H1r8/5kTwymGHkDb6NbsAQY9Xe54E/lLrMkmqu3/gprFg3IC/hSO3UvnCkJOlLy72Noi49mZ/HxT4G3jar658Y04wdXJo7hhRCy0hAzcVNuQ4L2172G9L6kkpyEVjHVouNDNvea3UtSek8Uc7UH1tCdYvb0CvT34k245rNimc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEoEn1Id; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEoEn1Id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A41FC4CEE3;
	Tue, 15 Jul 2025 13:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587315;
	bh=LOYcUfBHGE+iTy9zqduPJZA/Fp69vimZRwuwgDZYqxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEoEn1Idv5V4tTmVPDxqeVAy5D5OHOZRWEi8ae6g1hV4Wghy8n1InaYwdsBweKM38
	 SenpTfiLAt3etjpqtiRiZqyr8SpuyU8AWRrA+YvshJAhM9k3qhZOH4mLZUoMXJXHYn
	 T7RqN62VzlxcLVhDCpjWGkCveRdcS51GV2Cnb9nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 55/88] drm/tegra: nvdec: Fix dma_alloc_coherent error check
Date: Tue, 15 Jul 2025 15:14:31 +0200
Message-ID: <20250715130756.769832325@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 44306a684cd1699b8562a54945ddc43e2abc9eab ]

Check for NULL return value with dma_alloc_coherent, in line with
Robin's fix for vic.c in 'drm/tegra: vic: Fix DMA API misuse'.

Fixes: 46f226c93d35 ("drm/tegra: Add NVDEC driver")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250702-nvdec-dma-error-check-v1-1-c388b402c53a@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/nvdec.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tegra/nvdec.c b/drivers/gpu/drm/tegra/nvdec.c
index 276fe04727302..99ada87e25895 100644
--- a/drivers/gpu/drm/tegra/nvdec.c
+++ b/drivers/gpu/drm/tegra/nvdec.c
@@ -209,10 +209,8 @@ static int nvdec_load_firmware(struct nvdec *nvdec)
 
 	if (!client->group) {
 		virt = dma_alloc_coherent(nvdec->dev, size, &iova, GFP_KERNEL);
-
-		err = dma_mapping_error(nvdec->dev, iova);
-		if (err < 0)
-			return err;
+		if (!virt)
+			return -ENOMEM;
 	} else {
 		virt = tegra_drm_alloc(tegra, size, &iova);
 	}
-- 
2.39.5



