Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786BB237180;
	Tue, 21 Jul 2026 20:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665828; cv=none; b=oHX1ESm8xi4RrtXQntsTwO/MO2nNHM0gBHYHVz8mpVV6OHh1a2bj6cGHHWSnOqUiiJYHLGr7+XQhXI4UDV5JGH16t01e1eXpvDreq4XkxYITdPYxBp4DfjtWwv9uE+Zw+zRYVScrvBEDPLj4ntbLreWZVmQsYdIdJ2pZw7llazk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665828; c=relaxed/simple;
	bh=KiMwGdeXMvE+gQLagCnTLMuCa1LFsJQHbGm/AuD9wkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMjP5rurMzjcfLulu1L43SBnUHrmtB/IrJe8bwMV5dnHPpgoJgBXonCaaEDtkIShOg3YOzeYPcfqzpWU3zkRo6kVq2Al/i/ji1bV8cxYlJ4z8qoJZmn+SxpKOChKigVt1A0Vqy6bc5+WtSnyFlzIbG6BNL1dQLfu++ylTMO6LWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SZPdb1l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SZPdb1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAA41F000E9;
	Tue, 21 Jul 2026 20:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665827;
	bh=zkSSLi7gpKj8urGhAdLz9FuJXhCx4JHhPun3IpNKwfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SZPdb1lH0CVJsndc8mUa3/BRLTS3Ts+iNWwISu3rHQY6/5xlgfGSXgU6WK/2G8IX
	 x8f+4CgLj5kwci6YtVoifGv8uNTOn3MHaWFa79RHOTKIGbhmls7hk1mJIHLCnjbYly
	 DHjpkyYD4mDQmAJLsh74j9exlLXJTYWem8NrSVZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0450/1266] drm/tegra: Fix iommu_map_sgtable() return value check
Date: Tue, 21 Jul 2026 17:14:47 +0200
Message-ID: <20260721152451.905743171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

[ Upstream commit b3f349517de8f4469c385ebb7bfdfcc148790c0f ]

Commit "iommu: return full error code from iommu_map_sg[_atomic]()"
changed iommu_map_sgtable() to return an ssize_t and negative values
in error cases, rather than a size_t and a zero.

Update tegra_bo_iommu_map() to correctly check for errors from
iommu_map_sgtable.

Fixes: ad8f36e4b6b1 ("iommu: return full error code from iommu_map_sg[_atomic]()")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260421-iommu_map_sgtable-return-v1-2-fb484c07d2a1@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/gem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index 69a7aa5cd76ca4..c4cc8353574ea2 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -224,6 +224,7 @@ static const struct host1x_bo_ops tegra_bo_ops = {
 static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
 {
 	int prot = IOMMU_READ | IOMMU_WRITE;
+	ssize_t size;
 	int err;
 
 	if (bo->mm)
@@ -245,13 +246,15 @@ static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
 
 	bo->iova = bo->mm->start;
 
-	bo->size = iommu_map_sgtable(tegra->domain, bo->iova, bo->sgt, prot);
-	if (!bo->size) {
+	size = iommu_map_sgtable(tegra->domain, bo->iova, bo->sgt, prot);
+	if (size < 0) {
 		dev_err(tegra->drm->dev, "failed to map buffer\n");
-		err = -ENOMEM;
+		err = size;
 		goto remove;
 	}
 
+	bo->size = size;
+
 	mutex_unlock(&tegra->mm_lock);
 
 	return 0;
-- 
2.53.0



