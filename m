Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCF420ED;
	Sat, 12 Sep 2026 08:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203271; cv=none; b=A5MEZwuARdUheRXv3rLlg5aAh9m9Vw0+T/w6AJdywcRtcCSfQu2nPqCWy9FDR2eB27WEkwzUr6XKuGS/s9EyPSzysU+xG4A6MEDh+frZRIJT6fHcezkZGoSHlFqaatWO1oF27nVgujZ8zkyfRXycob3PpByKyvdx45FTAT+vLrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203271; c=relaxed/simple;
	bh=lgbAiDl9zP8vF3vRPqGdXFoUaJdwqX5LVK5yzDulAVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3YqhtaZwpZXJhqcO++K1dRqx1v5Nt0aETQ1b3tGTrHTL3HZnrCyVeSWvPkiINEIl2lQ+QHt5+LxXOaM+8rCkgtcCpIoZj0+gRH4dgZKFo5WrftgEXebsWs0Bt196TnhP+/riBKMzBhRGW+HE1mJYjkZlevpVQuJPzSi/wGVmKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdnWWiwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdnWWiwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4EE1F000FF;
	Sat, 12 Sep 2026 08:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203270;
	bh=9y+a+YF15I3q+VqkMfCi8U1i0JtUdChMeKRYAx1z+E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdnWWiwZM5ilZE+mf4+7oO4ZuM29GA0tGBpEjfDzgMrneyW4Tjjvk8O7h/BadVqmh
	 RkKgKs0iWoQE5l9mRex3EA+vEedF76AuTC80SECKVmqzyCVwTPx2gvW1QNB2Gx65eg
	 gliVNTdyH2yIP5SXpBEOalJip9ISEnx+ZzlmoMVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1331/1815] iommu/amd: Fix incorrect device ID in invalid PASID error message
Date: Sat, 12 Sep 2026 08:51:21 +0200
Message-ID: <20260912065720.269650087@linuxfoundation.org>
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

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 5322e19fc5acf013784207bc38191cd418a8bb48 ]

The IO page fault notifier handler logs pdev->dev.id when reporting an
invalid PASID, but pdev->dev.id is the kernel-internal device ID and
not the IOMMU device ID (BDF). Use dev_data->devid instead, which
reflects actual devid.

Fixes: 978d626b8f1a ("iommu/amd: Add IO page fault notifier handler")
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/ppr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/ppr.c b/drivers/iommu/amd/ppr.c
index 80369ca1e316e..1dde19a79e80f 100644
--- a/drivers/iommu/amd/ppr.c
+++ b/drivers/iommu/amd/ppr.c
@@ -140,7 +140,7 @@ static void iommu_call_iopf_notifier(struct amd_iommu *iommu, u64 *raw)
 	if (event.fault.prm.pasid == 0 ||
 	    event.fault.prm.pasid >= dev_data->max_pasids) {
 		pr_info_ratelimited("Invalid PASID : 0x%x, device : 0x%x\n",
-				    event.fault.prm.pasid, pdev->dev.id);
+				    event.fault.prm.pasid, dev_data->devid);
 		goto out;
 	}
 
-- 
2.53.0



