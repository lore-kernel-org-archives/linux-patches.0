Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBC71C4EDD;
	Tue, 27 Aug 2024 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772228; cv=none; b=QX6BpZ/9X2pkeYVFK8G354ePdvCmT6Fh4odhBbyKDDZJY8fZvx892Cn/ZQ3WmnOLjVB1u8JX5KPcfEnIsZEM9hw0xzHJGRhWz9QL3E77LocsFLXvo0GJIwBENajYKAG/Db7aBGUfQGpNDSI7BY9U0SRMO/lQ7xvL77ig2pdNDlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772228; c=relaxed/simple;
	bh=Yxk2WDclNsLpS1UgMTXXDsOmGvHkAJdAc3+gslvlvp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPAPYf3Mg5bq+4pFoZbjtRrH11xyitjifcD0h1fXWUFqDrPFPDou0noNuCek6ZG+BgKuxYcBQJQLkfq2PzMw8OBDRlY1y0YevjGS97I+yAjMNT028LDhG8aIorBHLk5YBdb5u+LiyfjorJGW4BH2+4gcGRRe5SshGhShrRiO8cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1s5J/LP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1s5J/LP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51329C61062;
	Tue, 27 Aug 2024 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772227;
	bh=Yxk2WDclNsLpS1UgMTXXDsOmGvHkAJdAc3+gslvlvp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1s5J/LPR9aBsKolmUV9Mxvd4soVD0sCl6evE/Xt05Vo6UGSQ+/rCYgntmgA7Ad40
	 HjtyC77ry9WEbzHWdmX+PUQgUoG/2Sk4Ts4+xDJPoHI4LYlOUY7laEIUmh7yb4viV6
	 dqcLknBPStT4NIX5VtYTevl/XPHoyaaS6psZ8ZsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Mhetre <amhetre@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/321] drm/tegra: Zero-initialize iosys_map
Date: Tue, 27 Aug 2024 16:37:22 +0200
Message-ID: <20240827143843.344694229@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 3868ff006b572cf501a3327832d36c64a9eca86a ]

UBSAN reports an invalid load for bool, as the iosys_map is read
later without being initialized. Zero-initialize it to avoid this.

Reported-by: Ashish Mhetre <amhetre@nvidia.com>
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230901115910.701518-2-cyndis@kapsi.fi
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index 81991090adcc9..cd06f25499549 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -175,7 +175,7 @@ static void tegra_bo_unpin(struct host1x_bo_mapping *map)
 static void *tegra_bo_mmap(struct host1x_bo *bo)
 {
 	struct tegra_bo *obj = host1x_to_tegra_bo(bo);
-	struct iosys_map map;
+	struct iosys_map map = { 0 };
 	int ret;
 
 	if (obj->vaddr) {
-- 
2.43.0



