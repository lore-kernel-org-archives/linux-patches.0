Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3837944607D;
	Tue, 21 Jul 2026 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648835; cv=none; b=PMlujCO/em1zEXCantYbmkHkmwY/qzH2nxQmJT8nlEs9U4F7zaBjl11wkD+miiToe7wV4g0hEd1sFEL+PFI/Ogwb6Cp3duoW2R5z547MKvOql+RO1z6HkPUht22P1TRNEcFJ2mjg2Zv3hbXh6sJY5r2d0yjok9Vu1k0lv3dTCLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648835; c=relaxed/simple;
	bh=NeACuUH/tFwtZArK8dxj/QbnPGnIigMotKC72AUnc6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5ciU156caK7hYlfRvlOM1SBGbkziEz5C3kMV1J03GLo/B8TdF7TxuehLnsUj9Kde7pRSD7xUV++S2gK9VdMjKaNXMGVWiMeYAOD/nvHwsAe5vb9rNhw4v3/75KiPFVBFeOCMkfURDbygKZFlUdjvjM0ZPuRSozA1C1/vZ1ZIyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fj5urFA/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fj5urFA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8501F000E9;
	Tue, 21 Jul 2026 15:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648834;
	bh=iGSzCNSUvo6Ec6NqG8cF58F1YVMIopC05AbcLQiCtP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fj5urFA/3ocHWt9fGJ2vmS12Ay+2P16v6bhtKskh7ss5HSdhWJNeU+xyrHwAuuyix
	 XmzlOyzbVoocsxXf4tTr7i2KHELKsU8om5M/cTABpXPpUKaeudU5/cQWTUVFA9WCIp
	 eixoFJ8YrP0mOClkELusXhTWwjN9aR7jQUuYZRK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0348/2077] gpu: host1x: Fix iommu_map_sgtable() return value check
Date: Tue, 21 Jul 2026 17:00:21 +0200
Message-ID: <20260721152600.901078032@linuxfoundation.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 18f74762013a4b6aa6f905c4459e0f506f9c5c7b ]

Commit "iommu: return full error code from iommu_map_sg[_atomic]()"
changed iommu_map_sgtable() to return an ssize_t and negative values
in error cases, rather than a size_t and a zero.

pin_job() also was incorrectly assigning to 'int', which could cause
overflows into negative values.

Update pin_job() to correctly check for errors from iommu_map_sgtable.

Fixes: ad8f36e4b6b1 ("iommu: return full error code from iommu_map_sg[_atomic]()")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260421-iommu_map_sgtable-return-v1-1-fb484c07d2a1@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/job.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index 3ed49e1fd93322..70bda32f1ff488 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -235,6 +235,8 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 		}
 
 		if (host->domain) {
+			ssize_t map_err;
+
 			for_each_sgtable_sg(map->sgt, sg, j)
 				gather_size += sg->length;
 
@@ -248,11 +250,11 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 				goto put;
 			}
 
-			err = iommu_map_sgtable(host->domain, iova_dma_addr(&host->iova, alloc),
-						map->sgt, IOMMU_READ);
-			if (err == 0) {
+			map_err = iommu_map_sgtable(host->domain, iova_dma_addr(&host->iova, alloc),
+						    map->sgt, IOMMU_READ);
+			if (map_err < 0) {
 				__free_iova(&host->iova, alloc);
-				err = -EINVAL;
+				err = map_err;
 				goto put;
 			}
 
-- 
2.53.0



