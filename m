Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C095B2C3247;
	Mon,  2 Jun 2025 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872193; cv=none; b=k1GbcSXzgyb33ar0gg7oklQKlo2XBKfnuV2fdy3W+GryDHbAzs7D0o4hGu7jvWKJbXcf4BBVfIj8FIAWB1rcJMwi5iC7cqxtbDyqcoMMzv0jbfXlusv34Zeu+dJ77OxR5hxCdxG531wsam6GMYUk4Zcfyi5Q3T3PMOh48mQdVvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872193; c=relaxed/simple;
	bh=1nKWGXnUrINnAEcQRsaPXAhxUtiP/SvyFGJ9JQkNwZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+RCPNK8cbhi2kO6T95rGxRWLfUvy5t/mnw6j7/O95uOlgRNs8Zn6cRvc6bbUNxXmaEaJ8s75qCtpBBAuMt/SMkFUzHnty7nFxOhmQUyP7NY9E+mMrsRdiOojPiX2FQnx2ZBJsmAgC/ZIemOpAZJvZGCVWlJ7rqhhyyd1HF/WRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCT3dfeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCT3dfeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F84C4CEEB;
	Mon,  2 Jun 2025 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872193;
	bh=1nKWGXnUrINnAEcQRsaPXAhxUtiP/SvyFGJ9JQkNwZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCT3dfeGtLpgPEMjgrdy6Pda0Tu38EpAIlWcie2A1m3u47MG55WDlN9UjhudAJQ0A
	 DQRtRmHUUEqHEDAdW4p6bhH/Ye/p6LiCSR/s3uJha4BPUCekI4XDxu8ERW905Jeucd
	 XJFQInsMuY9/gaW6ogTzQ7r3Q6i5Stw6rVhDbppc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.15 48/49] iommu: Avoid introducing more races
Date: Mon,  2 Jun 2025 15:47:40 +0200
Message-ID: <20250602134239.825403013@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 0c8e9c148e29a983e67060fb4944a8ca79d4362a upstream.

Although the lock-juggling is only a temporary workaround, we don't want
it to make things avoidably worse. Jason was right to be nervous, since
bus_iommu_probe() doesn't care *which* IOMMU instance it's probing for,
so it probably is possible for one walk to finish a probe which a
different walk started, thus we do want to check for that.

Also there's no need to drop the lock just to have of_iommu_configure()
do nothing when a fwspec already exists; check that directly and avoid
opening a window at all in that (still somewhat likely) case.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/09d901ad11b3a410fbb6e27f7d04ad4609c3fe4a.1741706365.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -422,13 +422,15 @@ static int iommu_init_device(struct devi
 	 * is buried in the bus dma_configure path. Properly unpicking that is
 	 * still a big job, so for now just invoke the whole thing. The device
 	 * already having a driver bound means dma_configure has already run and
-	 * either found no IOMMU to wait for, or we're in its replay call right
-	 * now, so either way there's no point calling it again.
+	 * found no IOMMU to wait for, so there's no point calling it again.
 	 */
-	if (!dev->driver && dev->bus->dma_configure) {
+	if (!dev->iommu->fwspec && !dev->driver && dev->bus->dma_configure) {
 		mutex_unlock(&iommu_probe_device_lock);
 		dev->bus->dma_configure(dev);
 		mutex_lock(&iommu_probe_device_lock);
+		/* If another instance finished the job for us, skip it */
+		if (!dev->iommu || dev->iommu_group)
+			return -ENODEV;
 	}
 	/*
 	 * At this point, relevant devices either now have a fwspec which will


