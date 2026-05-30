Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B8233F8B4;
	Sat, 30 May 2026 17:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162488; cv=none; b=BlBnj46RqX6Xq2rl529+/qlJARvnNquONZX5XrG4Nry7Rz5wraIBUkIWliTjtuPdUHaJDMlijqfIE7tf3PcYzAarLrYsL/JnPTadFypNShmq3TSEC9ojnkHcb7O4pa+Bd1ZqXaj7nJbggnvnItrk9NReFKzE5TvQxXWyaTvodso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162488; c=relaxed/simple;
	bh=Xws1MGelZzHqnrVyYLz9LLmWRYjk9YfNrd8OQf4WgSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0FQETwq6OdnWmliFEwNO5DcfDlKEEM8mQgBOkjCjJ6fxBjhe8S3ifvaRSMA6VRL+wR/XYJI6vZCa2ECn5YpNQTa4lwQuBxyGqJHoLK4fZAjXV00ExUKAcCAZlXeHZbY4qEJm7XuVISS2URUCAEq8wDhlMBpeZ9nXlRUeokdaBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvfMPvYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvfMPvYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738DB1F00893;
	Sat, 30 May 2026 17:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162487;
	bh=U70d22u6WjTb7K+COQGVYnVO0vvokeXHjj2Ys85lJaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvfMPvYT61A/j9bM4pAdohM1sQ5KIN4k9JnBALAljf0rbocUtzJcKH5lY/1WXqTQe
	 uT/2izYu9CdFIBWXTf82yyUbbxs+fz12HsKstaCvs9bMUZfnw9dGJkH5dORqf9GvqV
	 tgSGw3s6c0amqAAU7meIoO6vk/NY433dmcOjeDCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 935/969] drm/msm: Fix iommu_map_sgtable() return value check and avoid WARN
Date: Sat, 30 May 2026 18:07:39 +0200
Message-ID: <20260530160326.569252019@linuxfoundation.org>
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

[ Upstream commit 55e0f0d1c1a4ee1e46da7da4d443eb3044fb3851 ]

Commit "iommu: return full error code from iommu_map_sg[_atomic]()"
changed iommu_map_sgtable() to return an ssize_t and negative values
in error cases, rather than a size_t and a zero.

Store the return value in the appropriate type and in case of error,
return it rather than WARNing.

Fixes: ad8f36e4b6b1 ("iommu: return full error code from iommu_map_sg[_atomic]()")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Patchwork: https://patchwork.freedesktop.org/patch/719685/
Message-ID: <20260421-iommu_map_sgtable-return-v1-3-fb484c07d2a1@nvidia.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_iommu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index 0de3612135e96..aa69713ea7f80 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -359,14 +359,15 @@ static int msm_iommu_map(struct msm_mmu *mmu, uint64_t iova,
 		struct sg_table *sgt, size_t len, int prot)
 {
 	struct msm_iommu *iommu = to_msm_iommu(mmu);
-	size_t ret;
+	ssize_t ret;
 
 	/* The arm-smmu driver expects the addresses to be sign extended */
 	if (iova & BIT_ULL(48))
 		iova |= GENMASK_ULL(63, 49);
 
 	ret = iommu_map_sgtable(iommu->domain, iova, sgt, prot);
-	WARN_ON(!ret);
+	if (ret < 0)
+		return ret;
 
 	return (ret == len) ? 0 : -EINVAL;
 }
-- 
2.53.0



