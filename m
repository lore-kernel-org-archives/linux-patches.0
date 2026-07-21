Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D694035C682;
	Tue, 21 Jul 2026 22:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671612; cv=none; b=iTZTbFMphLiCKA/bQgm6HTVTGpx72N6nT6PbKQoRsBBaLAY9h5F2aNzTauo0tnhiloJKCBG2i1xOshh5HXeRzcA7S36j3bfLK6TH3K0gUPVfG9VIS/VCKGAkZjbri1xi4EWAWo+UKyml/Kv8GIAeuQJMcG7tIyQuTV77i1dQNzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671612; c=relaxed/simple;
	bh=s1KmOkJRN49YnNTnz3w8QMtOnwTAeBW6Hq85qklTOG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwBrO/WC/majWH5ImuzL3Y5ELTFevMSVORGx2ud37gCQgn2QHsxANkbSYaJwMeVbg4TliSkrP0P2A0/dpPBG7IqsG48yx3ICZ29yT/KXG1Gi5NbJqyedY/eerROuDcKvegMs0oI21ayS8+CjIp/QeO7451lJwu/XuqQ0mTqw++s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrZwa1ZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrZwa1ZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471671F000E9;
	Tue, 21 Jul 2026 22:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671611;
	bh=O6DvIyNI98C6At8linGv1G5mgcGWRZLVTftzWkOh7U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrZwa1ZOzsgCd60BdROTPe6pCZemkSRYj5I7ZBPdH+oiexba64k4r+rWCjuQlvtwX
	 FSvzO8pmEqiT1BVfovoEaJ9KpN+8TqxwZUsebh4t38HHXxxQwASA4z4Z4k+aJWzfmD
	 5CgcOtUNl3rcnVj8xe1FnWQP/Fp6OQPdzM7rFLG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/843] drm/tegra: dc: Fix device node reference leak in tegra_dc_has_output()
Date: Tue, 21 Jul 2026 17:18:24 +0200
Message-ID: <20260721152412.075501174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index e81fcfc2c005ba..280e1f4b09fb4d 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -94,8 +94,10 @@ bool tegra_dc_has_output(struct tegra_dc *dc, struct device *dev)
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



