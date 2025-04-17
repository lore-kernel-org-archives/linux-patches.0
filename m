Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3582566D7;
	Thu, 17 Apr 2025 17:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912540; cv=none; b=hbvlHHzPshcFY9j/sIy2Tcep8hxgWvRkqQVgVrTd5PCcbA+777Rny6IExJjN2/Uz3H5Se5mwrpjxE+xAJaXOqX+fJLACFXk0r1onZLUOjfHJy46doR7rsmMjiuR0voHOSxq476QHTgDAEsTjZGae5fxKa+GkYDTW7U9E2oTdPVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912540; c=relaxed/simple;
	bh=z6V92QLnYXrPlVdnn47DcNsUhZfPtRfrzuvw02FefMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GV4hfDbIzFvECoHb8tAeITQmXPAcEs81a4aIDHiGxmooTsJFIR0bkJ2x8CPL22ekt6+d4ynvKOezkH7/fnoSXlftQMQytg+UWQILe0BWThd0B8hhQTZTFPYATdvkutgD05yEP2OBOeweTKCJzSpLqAszLGhFT9OAVLtHpVFyuLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fkIuWj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fkIuWj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF23C4CEE7;
	Thu, 17 Apr 2025 17:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912539;
	bh=z6V92QLnYXrPlVdnn47DcNsUhZfPtRfrzuvw02FefMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fkIuWj6VGRdODvw66EUS11h1+4WYJZKZQ4ehNA5K16XuxO+xwUI/1n7Mbq5/I/I4
	 eoj5kie+/DD+kv2I3cbhorSFHTy76moiIQbiGHduzA6Wr6QlzFKz6Tw5EL6sLi6MpE
	 rw2Pk0RKzDq5mxi+fLhnW22k3McQTOdxhoAa6qnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 044/449] iommu/exynos: Fix suspend/resume with IDENTITY domain
Date: Thu, 17 Apr 2025 19:45:32 +0200
Message-ID: <20250417175119.760398122@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 99deffc409b69000ac4877486e69ec6516becd53 ]

Commit bcb81ac6ae3c ("iommu: Get DT/ACPI parsing into the proper probe
path") changed the sequence of probing the SYSMMU controller devices and
calls to arm_iommu_attach_device(), what results in resuming SYSMMU
controller earlier, when it is still set to IDENTITY mapping. Such change
revealed the bug in IDENTITY handling in the exynos-iommu driver. When
SYSMMU controller is set to IDENTITY mapping, data->domain is NULL, so
adjust checks in suspend & resume callbacks to handle this case
correctly.

Fixes: b3d14960e629 ("iommu/exynos: Implement an IDENTITY domain")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250401202731.2810474-1-m.szyprowski@samsung.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/exynos-iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 69e23e017d9e5..317266aca6e28 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -832,7 +832,7 @@ static int __maybe_unused exynos_sysmmu_suspend(struct device *dev)
 		struct exynos_iommu_owner *owner = dev_iommu_priv_get(master);
 
 		mutex_lock(&owner->rpm_lock);
-		if (&data->domain->domain != &exynos_identity_domain) {
+		if (data->domain) {
 			dev_dbg(data->sysmmu, "saving state\n");
 			__sysmmu_disable(data);
 		}
@@ -850,7 +850,7 @@ static int __maybe_unused exynos_sysmmu_resume(struct device *dev)
 		struct exynos_iommu_owner *owner = dev_iommu_priv_get(master);
 
 		mutex_lock(&owner->rpm_lock);
-		if (&data->domain->domain != &exynos_identity_domain) {
+		if (data->domain) {
 			dev_dbg(data->sysmmu, "restoring state\n");
 			__sysmmu_enable(data);
 		}
-- 
2.39.5



