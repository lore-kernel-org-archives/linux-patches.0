Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03952D9488;
	Thu, 15 Jan 2026 17:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499774; cv=none; b=FC9BtXZHy0cd7Sn4GAwxdL3VeiW6A/i+D1TOHW4qs+Iyvew5DaYqz0Yy2qM4+CuShGRY8DnHBU9YHZP2WoGVOVku1uiykaCIKq0DJArglofeSoHQ37N9zzwGUSHkZbLDE3xgGKUjd8IDuFfHRnQvV14sqTRwNgLZwkmy4QJXv+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499774; c=relaxed/simple;
	bh=0Dn5nCnBWVyN0OVMqYtujY49ndK5jR/KK5UXDwqjHyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDijqTyMg52hFABJt9cWmYpa4T3evpwA9EijRKEAxRco+AL/77z5kn3R1tweiZnncyLotgvKmGIJaT0rSfjmHaaF+jfnJj9bJvB93m0mwVeyCIM9IPDF/Cbs01OTW+bUKHx10CLhbdkkShWr4ZmuNkCcB8omhlMZ/4r/cYARaNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbfcZzYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbfcZzYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70282C116D0;
	Thu, 15 Jan 2026 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499774;
	bh=0Dn5nCnBWVyN0OVMqYtujY49ndK5jR/KK5UXDwqjHyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbfcZzYfwgSfnUF1Ek0VyzkS0PhTkEjUNFPdAs/k80neYqgPhk+Rn7TNkIsumqHRd
	 jLosStrXQCjj0fWEXzWYDf/Fizkkl0kCwoRrBX4l7aTznhNmKCdVWv7JGpfGipLWuu
	 vvzrizGTc9nXbmklSIvYhv/evmR3LlSzKc58gHWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.10 302/451] iommu/exynos: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:48:23 +0100
Message-ID: <20260115164241.818316816@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1299,17 +1299,14 @@ static int exynos_iommu_of_xlate(struct
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


