Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DAD2F0C7F;
	Fri,  9 Jan 2026 12:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960862; cv=none; b=M6zTseV++pS8uNg+TlgeEiqIDEklZ5qnzt9wTGEF6Tb/G8BowfX9SaWlQVZy/yjy9iyo6s/vzriUOytM5RnS8WegMiX1qBjsTGExXeHO/II1H0j7F9foHK8lOCMzZuw+0jxotisLojPhZ1KaVeMDYD/wQBbGwhnYMwjU+g3ugak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960862; c=relaxed/simple;
	bh=1oit+wBpXKwzKwAKT++k2bo8TYKiI+TI0/vCzsfQDHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UewASBhFhZyWtHP6sNEwrzralqJcjZtFQD8Iwr+wsXRcLF8N0nAcxAwodVY+ghhYF9B6N3OxhWTx3hC7zNRpmCeGswb3g/75WNiP688WRnvOP4zP9CCjQAFjDFw7W7rmUVRGDVXfs/+HYi6LrdUcHcbgOrs8R5wVVKgzfmm+CEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTlQ1MLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTlQ1MLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5F3C4CEF1;
	Fri,  9 Jan 2026 12:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960862;
	bh=1oit+wBpXKwzKwAKT++k2bo8TYKiI+TI0/vCzsfQDHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTlQ1MLRGzkmTS+JM9YBGlXMWp1K+n5NdwZiNZiwXl8z1Ot58VZHl2hfpIiQa4usw
	 xNhWOlmBkC8YCq4SZgDc5mqivLC3MzDggkQr8KsG338Hp+/qNfcwffTXE6OQQFKkvz
	 MyzTI1WSThh4LotDsMyDVSPWYZRhfTz/OBjq1Ou8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 551/737] iommu/exynos: fix device leak on of_xlate()
Date: Fri,  9 Jan 2026 12:41:30 +0100
Message-ID: <20260109112154.723681118@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 05913cc43cb122f9afecdbe775115c058b906e1b upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Note that commit 1a26044954a6 ("iommu/exynos: add missing put_device()
call in exynos_iommu_of_xlate()") fixed the leak in a couple of error
paths, but the reference is still leaking on success.

Fixes: aa759fd376fb ("iommu/exynos: Add callback for initializing devices from device tree")
Cc: stable@vger.kernel.org	# 4.2: 1a26044954a6
Cc: Yu Kuai <yukuai3@huawei.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/exynos-iommu.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1443,17 +1443,14 @@ static int exynos_iommu_of_xlate(struct
 		return -ENODEV;
 
 	data = platform_get_drvdata(sysmmu);
-	if (!data) {
-		put_device(&sysmmu->dev);
+	put_device(&sysmmu->dev);
+	if (!data)
 		return -ENODEV;
-	}
 
 	if (!owner) {
 		owner = kzalloc(sizeof(*owner), GFP_KERNEL);
-		if (!owner) {
-			put_device(&sysmmu->dev);
+		if (!owner)
 			return -ENOMEM;
-		}
 
 		INIT_LIST_HEAD(&owner->controllers);
 		mutex_init(&owner->rpm_lock);


