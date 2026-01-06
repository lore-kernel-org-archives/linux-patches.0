Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321D827FD76;
	Tue,  6 Jan 2026 17:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721921; cv=none; b=fKNrU1CqQYlDcQ3oQ/HCTnUUNbnqXXDHqokFAvzg0lgEEzsFxvdL/7gVvECzJM4GeaTv+KEXE/aLIaQthYZAWfjAdmYjGaHXoGvvLURXXvMm4OWRk3DIpc6SLJ3ujZaxJ7nG500YL2Vh4I0zCmkoCzdoZVarRYUxA+gACWZEJz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721921; c=relaxed/simple;
	bh=wbh2g/vRprOay/v/OZItls6RkfvGg+X1c3DD/+9C1kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abQF1nEvIc/E2G1dqGJKn69zUcoy/2OYvC4fHHazcuOfqBJQTixDUJN0vqirpEdINuMuBRU0fRn0DkJOs4ATPtUr1zMyrorLiq8ZzcB8jTYdxFog01b3ztdhwzUnlSsR2XtCX+neX+R49WQ4cHNPU5tXJGehdtiX1vquTRY+OuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQwYv7Zk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQwYv7Zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96893C116C6;
	Tue,  6 Jan 2026 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721921;
	bh=wbh2g/vRprOay/v/OZItls6RkfvGg+X1c3DD/+9C1kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQwYv7ZkpC7XlwHXuyu/0G9ncZI1skOB6ob2tRjLlulaMSGDvgII/3cBNTqoTX239
	 Pcft+g82/hfboswEnpq6drIot9+8opOdgxtssEoGOUS5w0TNAu0gYNKoALoo8hjYFL
	 DhYnwIzUr3oZvENUWl1eseWLSBhjFxy1GelG83KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 111/312] iommu/exynos: fix device leak on of_xlate()
Date: Tue,  6 Jan 2026 18:03:05 +0100
Message-ID: <20260106170551.852518326@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
@@ -1446,17 +1446,14 @@ static int exynos_iommu_of_xlate(struct
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


