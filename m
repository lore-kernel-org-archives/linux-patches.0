Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CFB13D51E;
	Wed,  4 Jun 2025 00:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998469; cv=none; b=oRA5dxx5IZNisAVDD9xwBiKjWTkRobW/mOU1Ax2Ls1USbfzaP8L1fVlesNgjbGn4hBzgMpSvlLJ0Lw2wM7IVnwK72CxnO+zOQykcOuemN5N9UqhW7B1r4XqP+ZcKwwk/QDvrRTBiaou5SQfB2R/oqHHxFjeafAS9uz4ovccbpzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998469; c=relaxed/simple;
	bh=2X0P1GsNVzgYrD6eTzDd41ZLUT2CV4WK0OivoVML9tw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ibOfHSHW+/SMWRnzJJfm833Dl4P8p+eVLmcxerJnaNBx4gZB4MQZpMrACoo4HEW7QXUXs60xqr9G13Ur7Tue01LyrAp6UyAjKSHSSbeP1dbhiwL+Jnwy905kerD9Ysh4uGMFy88gk6clM64LO4Xw3Kcpp4WzT0ynOK0J4rI1EeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3eZ3Zzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3eZ3Zzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271F0C4CEED;
	Wed,  4 Jun 2025 00:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998469;
	bh=2X0P1GsNVzgYrD6eTzDd41ZLUT2CV4WK0OivoVML9tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3eZ3ZzlifnfhkuMi+W9IV6+WX5n+dJ1CfNrSjbUIsc/vdLXkHFayAxM0nit7CfRl
	 mqxbFCbb6myL2yVwsgza1S/jXUkAkWpmi/JJ7hMcSW0IVAU7oMHad+yG/QfK9kQ16+
	 qzbXZ+8R76WNBGcCjXUszPQ1fQaZVSnDZ9imUe4pK6alX9WtSNIrQRnCf8UO4frEXl
	 QbCyT8feSVR5nm/8ttDwp7r3GvmknzZYEa59lE2GBAuXKXwkAjsw/kOv+4RiPUKmk6
	 Bd304QIubu6v1kgpkhiJWyWooI/xrogkz4mZePNeDqY1SI+pbttZRXceWzGwb+pWrB
	 TM9Gn3ukheE1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	will@kernel.org,
	iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.15 092/118] iommu: Avoid introducing more races
Date: Tue,  3 Jun 2025 20:50:23 -0400
Message-Id: <20250604005049.4147522-92-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 0c8e9c148e29a983e67060fb4944a8ca79d4362a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now I have enough context to analyze this commit. Based on my analysis:
**YES** This commit should be backported to stable kernel trees. ##
Analysis ### Nature of the Fix This commit addresses a **race
condition** in the IOMMU subsystem's device probing mechanism. The key
changes are: 1. **Line 428**: Adding a check for `!dev->iommu->fwspec`
before calling `dma_configure()` to avoid unnecessary work when firmware
spec already exists 2. **Lines 432-434**: Adding validation after re-
acquiring the lock to check if another instance completed the probe
while the lock was dropped 3. **Comment update**: Clarifying that the
device should not have a driver bound when called from `dma_configure`
### Why This Should Be Backported **1. Fixes Important Race
Conditions:** The commit directly addresses race conditions in device
probing that can occur when multiple IOMMU instances are probing devices
in parallel. The code pattern of dropping and re-acquiring locks (lines
429-431) is inherently racy without proper validation. **2. Small and
Contained Changes:** - Only 6 lines of actual code changes in a single
function - Adds safety checks rather than changing core logic - Changes
are defensive programming rather than architectural modifications **3.
Follows Established Pattern:** Looking at the similar commits marked
"YES": - Similar Commit #1: Also fixes races in IOMMU device probe with
minimal changes - Similar Commit #3: Also adds locking to prevent
double-probe scenarios **4. Addresses Critical Subsystem:** IOMMU is a
critical kernel subsystem that handles memory isolation and device
security. Race conditions here can lead to: - Malformed IOMMU groups -
Potential lack of device isolation - System instability **5. Low Risk:**
- The changes are purely defensive (adding checks) - No functional
behavior changes for the common case - Early return paths reduce
unnecessary work - Follows the principle of "fail fast" when
inconsistent state is detected **6. Context Matches Stable Criteria:** -
**Bug fix**: ✓ (addresses race conditions) - **Small scope**: ✓ (single
function, 6 lines) - **Low risk**: ✓ (defensive checks only) -
**Important subsystem**: ✓ (IOMMU handles device security) The commit
message explicitly mentions this is part of temporary workarounds for
lock-juggling, and the author (Robin Murphy) acknowledges the
nervousness about race conditions, making this a clear stability
improvement rather than a new feature.

 drivers/iommu/iommu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 9d728800a862e..ee9c62150b560 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -422,13 +422,15 @@ static int iommu_init_device(struct device *dev)
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
-- 
2.39.5

