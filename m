Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91032F0C7E;
	Sat, 12 Sep 2026 08:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200032; cv=none; b=kgVeo0gb+G5KFYMJuQhdxvrPgZZ+y4snO4ohH/S5AeWzUp8f+EhGtJuT1plI9VXt8UL1iZpQ/8IraZxw4TG56W/xQDS2dajR+EG1sQ0ZRERXetxOjpuK3UZXLf0x8fwoA+kYBbWIDlTb9GQRBw6/VM2FjNKlor/ZEWKVM0OBPY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200032; c=relaxed/simple;
	bh=REy2tH21L2qOUanKOkGZckx0atYCWfHZtsjC+ImSGfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lepa62AxO8W+g5oc5qtVEgwW0eW+asRxU1dMUwyQKeoV0gZNw6xftrkmrS1oSU49Ayp8QKWUc6ZDk8LyT5271Ug1NjtV8nYqDMoRLUVw66ARa5H5gOHs8X2bZTWdkCD+QDQ9Q+nsO4dihSHRgdksKAHNcpQzi/6HRKMDgyR7iKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9RQbpb5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9RQbpb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C611F000FF;
	Sat, 12 Sep 2026 08:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200031;
	bh=AI1sjo9fowIO0tb97QTVI8C6srcnFYA3jpliIrcVeAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9RQbpb5a/cshZof5sCq151Dm/0kxw2NEZzklerOf+lCM8GZhSo6/Lb7kvNaLxa9s
	 rVXfygW2+vVTq4NpGNzQGFtT8yNaDbLW7X3HX40l2UK5jOf7KVanKHbiRktt95kRqB
	 crBFtMydHznru68+F4RP8piRKYN4oMjgsQ9DdqFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0707/1815] iommu/tegra241-cmdqv: Require exactly one Stream ID for a vSID
Date: Sat, 12 Sep 2026 08:40:57 +0200
Message-ID: <20260912065705.492000530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7c1956c94ef53..43dc3bf9760ae 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -1252,7 +1252,8 @@ static int tegra241_vintf_init_vsid(struct iommufd_vdevice *vdev)
 	if (virt_sid > FIELD_MAX(VINTF_SID_MATCH_VIRT_SID))
 		return -EINVAL;
 
-	WARN_ON_ONCE(master->num_streams != 1);
+	if (master->num_streams != 1)
+		return -EOPNOTSUPP;
 
 	/* Find an empty pair of SID_REPLACE and SID_MATCH */
 	sidx = ida_alloc_max(&vintf->sids, vintf->cmdqv->num_sids_per_vintf - 1,
-- 
2.53.0



