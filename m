Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472F141DDE3;
	Sat, 12 Sep 2026 10:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208590; cv=none; b=MMtlovD4dOkpbssOJom9B4c+U4UZ8vDAQYHcCUJ2ks3MZfFjwwonQ+0W4VeNR39qEjtk61xp9/0tNuuSXAkt8xC3fcTo6vY+oJ6gUri5I2pNvUmdWrtPlAsy+bGEgTIEFfQ+8atzDJJjawn302+eJy8CUzJOPh2/eibIKKXAtO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208590; c=relaxed/simple;
	bh=2jtcMjZhvRa517J1lpucVAabREK7XZNAkdBDbUm0Ozc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAtd81H+utyK2J3CGvGPC3XDKZuusTW1s04BcAbZVMGMzpa/uc2XjfLqAlHjLC+/MbzmmF0365gLxFXJiwzHzc/E/SiXAmNETrOunIF4UjgQrCdIyvYCiVOoBRnhWiYwHCtWosD+9Vn5uYfgS6Dp+E/7cgGlnZOCmHRGJC9EXX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUHs6g+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUHs6g+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6117C1F000FF;
	Sat, 12 Sep 2026 10:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208588;
	bh=rnc3yo5cX9kZEW9MRIzzvaS7vmyXKsTeA3q/wZAEYh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUHs6g+KMSjyqo1obQVTwA50urEhFvI9dY3dVt0wJT5Kl06OKTB9IB+GSk9IhV3bJ
	 8mZf9ccqUwJHvhHejQIYbfuSgCPS9xVS6v2giS09bxR+LwQ3Uzzg/Or5ZWwftPueYx
	 ghvhVBn42db+IGvASvmw5/WDTaFmOb59rMVtrER8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0605/1518] iommu/tegra241-cmdqv: Require exactly one Stream ID for a vSID
Date: Sat, 12 Sep 2026 08:46:14 +0200
Message-ID: <20260912065637.109993201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit fb292bfc9be936dade7eef7ec5762de1201983d8 ]

tegra241_vintf_init_vsid() maps a guest vSID to a single physical Stream ID
taken from master->streams[0], and only warns when the device does not have
exactly one stream. A device with several streams gets only its first one
mapped, so a guest vSID invalidation cannot reach the others' ATC and IOTLB
entries; a device with none makes master->streams a ZERO_SIZE_PTR, read out
of bounds.

Reject the mapping with -EOPNOTSUPP if master->num_streams is not one.

Fixes: 4dc0d12474f9 ("iommu/tegra241-cmdqv: Add user-space use support")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 5d5aa956e5b9f..29aa7acd194b9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -1302,7 +1302,8 @@ static int tegra241_vintf_init_vsid(struct iommufd_vdevice *vdev)
 	if (virt_sid > FIELD_MAX(VINTF_SID_MATCH_VIRT_SID))
 		return -EINVAL;
 
-	WARN_ON_ONCE(master->num_streams != 1);
+	if (master->num_streams != 1)
+		return -EOPNOTSUPP;
 
 	/* Find an empty pair of SID_REPLACE and SID_MATCH */
 	sidx = ida_alloc_max(&vintf->sids, vintf->cmdqv->num_sids_per_vintf - 1,
-- 
2.53.0



