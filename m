Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B3D46A615;
	Tue, 21 Jul 2026 15:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648832; cv=none; b=UptIViCARf6OhrQRJOQI0zLqqe38+OZRPY7p4J/81U9hb84mjsx+Z4nsdpDwkjWUGA5ZXFJvVMygz1jjSHqvDJykEvKxDQtlsYHsaJoRUA6PkyyLOu17Gk88YytqpYffs7qRKJZZvTwEEjpp4QCCoFwCNf17ecL7wY2gCklUnYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648832; c=relaxed/simple;
	bh=dmGco3QDRNJgmhOul/fR6HN257wXbAehWV2lvmmweio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpkGE/3brdZGMoBYbhtkuKshbxHQIIor1BHfg1MdgAts8701bnGMGOcIsn+Exh28pChNUpKAfb4kRaVTCZIk9Hg3bm4DStHo1tpfsjm+MIezz3JAEGpMQtfJ1A36dl5xUDGjDRrn39o3cKifu/fTLftTe1hRTB/YqNXLfr3jATs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZqSwYI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZqSwYI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40921F000E9;
	Tue, 21 Jul 2026 15:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648831;
	bh=XjRH3WL0fEPFxuMilB9zoEDgLdM8ZiUarKhuVkXYFRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZqSwYI4CLpyMqLXDc1SWjOGzugOYRXmNNCwSyyaQA9VYxZQCp8NJXjIMSIy0bp7i
	 yOJB7R11yQStT0rPApTwu52BXtDiCdfnFWKeNsk1E+zPHJGF8K3vLHMLfDQrt1bpMI
	 yfVy8UphXR+/7eznYnQkblA5vJNeJGgTb4xqHqeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0347/2077] drm/tegra: dc: Fix device node reference leak in tegra_dc_has_output()
Date: Tue, 21 Jul 2026 17:00:20 +0200
Message-ID: <20260721152600.876776721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 63a3998d792ab5c45304bf879e385a31fa923b61 ]

The of_for_each_phandle() macro increments the reference count of the
device node it iterates over. If the loop exits early, the reference must
be released manually.

In tegra_dc_has_output(), the function returns true immediately when a
match is found, failing to release the current node's reference.

Fix this by adding a call to of_node_put() before returning from the loop.

Fixes: c57997bce423 ("drm/tegra: sor: Add Tegra186 support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Acked-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260128-dc-v1-1-a88205826301@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 06370b7e0e5678..c6734a87ef0aff 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -101,8 +101,10 @@ bool tegra_dc_has_output(struct tegra_dc *dc, struct device *dev)
 	int err;
 
 	of_for_each_phandle(&it, err, np, "nvidia,outputs", NULL, 0)
-		if (it.node == dev->of_node)
+		if (it.node == dev->of_node) {
+			of_node_put(it.node);
 			return true;
+		}
 
 	return false;
 }
-- 
2.53.0



