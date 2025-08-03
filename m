Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719E52040A8;
	Sun,  3 Aug 2025 21:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256052; cv=none; b=m2nh7ie3n5gzJn0K7hh+gM0DtJNAUqgLudJZHtYEFaBNnHRJ0m31DISmXWRP+faq+o6mr+LQS9p8cSdDcBwIumCLxPjUp6gAL6tt4GrmgFYANjxn2Peb/I5KSc2s9Q4mSmYUd3pYyWomDnApfJ72FrNIrl16y3ZRAq6u+tuFq78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256052; c=relaxed/simple;
	bh=Ld9X9JoCPEIrPSbX5LxBGB1hFnXkaU8w0enkDj1V8cU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=raqDvyLO77oN7xCAposf0Aow9p/yx0AZvn9B10mL95faZB0CAMQzyu7ZObmMwLkciS+401ftOxewcbdogxySxfdsaHMGG9S1L8TdtCAgOngonLRwOFqVe9EAAkazz/rE1mVNqd9BNxVDg4NQmU3jfFVV+Gfg23ff+d/M8sQLWIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NaWixhrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NaWixhrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB47C4CEF0;
	Sun,  3 Aug 2025 21:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256052;
	bh=Ld9X9JoCPEIrPSbX5LxBGB1hFnXkaU8w0enkDj1V8cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NaWixhrAtENTfK7CcnHm4VzVgc7Nea4cZXHuKmll0EQxMbIPnzErXDy87u0aMFfTi
	 1xHlTj6B/E1Simwjhxvqsp8slT43UoKvbWqY+2RmtBKYxAK4KHea5iPtGAf3Emd9Zh
	 7/X6CFIo7q8t/ZgkHlMIINwSbSQof+l9Ke/PXWJSwWg+6O67HjrSsj7u8AKV4hOeL7
	 vwZeFm/WPYv5+wgbTsxiu4rbubKMSg3UN/22U8/W/CiSHO0Bf61iuw1z7C8Zr4SaRP
	 eb95dPrlv9Bxo50YTNJ6FIZwP62o2OmOAEKkX/Zza+S9Dm+jE+hm3ziuyeafWDyCB0
	 eOgxiDtrAxcLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.6 08/23] nvme-pci: try function level reset on init failure
Date: Sun,  3 Aug 2025 17:20:15 -0400
Message-Id: <20250803212031.3547641-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212031.3547641-1-sashal@kernel.org>
References: <20250803212031.3547641-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 5b2c214a95942f7997d1916a4c44017becbc3cac ]

NVMe devices from multiple vendors appear to get stuck in a reset state
that we can't get out of with an NVMe level Controller Reset. The kernel
would report these with messages that look like:

  Device not ready; aborting reset, CSTS=0x1

These have historically required a power cycle to make them usable
again, but in many cases, a PCIe FLR is sufficient to restart operation
without a power cycle. Try it if the initial controller reset fails
during any nvme reset attempt.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees based on the
following analysis:

## 1. Fixes a Real User-Impacting Bug

The commit addresses a significant hardware issue where NVMe devices
from multiple vendors get stuck in a reset state showing "Device not
ready; aborting reset, CSTS=0x1". This is a real-world problem that:
- Affects multiple vendors' devices (not vendor-specific)
- Historically required a full power cycle to recover
- Renders the storage device completely unusable

## 2. Minimal and Contained Fix

The code change is very focused and minimal:
- Only adds ~20 lines of code in a single location
- The fix is contained within the `nvme_pci_configure_admin_queue()`
  function
- Only executes when the initial controller reset fails (error path)
- No architectural changes or new features

## 3. Clear Recovery Mechanism

The fix implements a well-understood recovery mechanism:
```c
if (result < 0) {
    struct pci_dev *pdev = to_pci_dev(dev->dev);
    result = pcie_reset_flr(pdev, false);
    if (result < 0)
        return result;

    pci_restore_state(pdev);
    result = nvme_disable_ctrl(&dev->ctrl, false);
```

It uses PCIe Function Level Reset (FLR) as a "bigger hammer" when the
NVMe-level controller reset fails, which is a standard PCIe recovery
mechanism.

## 4. Low Risk of Regression

- Only triggers in error conditions (when `nvme_disable_ctrl` fails)
- Falls back gracefully if FLR also fails
- Uses existing, well-tested PCIe APIs (`pcie_reset_flr`,
  `pci_restore_state`)
- Adds informative logging when recovery succeeds

## 5. Follows Stable Tree Rules

- Fixes a bug that prevents device initialization
- No new features or functionality
- Small, self-contained change
- Clear benefit (avoiding power cycles) with minimal risk

## 6. Similar Issues Fixed in Stable

The git history shows multiple commits addressing "stuck reset" issues
in the NVMe driver (e.g., `3f674e7b670b`, `ebef7368571d`), indicating
this is an ongoing class of problems that stable kernels need to handle.

The commit message explicitly states this affects devices from "multiple
vendors" and provides a solution that avoids requiring power cycles,
making it a clear candidate for stable backporting to improve system
reliability.

 drivers/nvme/host/pci.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 97ab91a479d1..136dba6221d8 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1755,8 +1755,28 @@ static int nvme_pci_configure_admin_queue(struct nvme_dev *dev)
 	 * might be pointing at!
 	 */
 	result = nvme_disable_ctrl(&dev->ctrl, false);
-	if (result < 0)
-		return result;
+	if (result < 0) {
+		struct pci_dev *pdev = to_pci_dev(dev->dev);
+
+		/*
+		 * The NVMe Controller Reset method did not get an expected
+		 * CSTS.RDY transition, so something with the device appears to
+		 * be stuck. Use the lower level and bigger hammer PCIe
+		 * Function Level Reset to attempt restoring the device to its
+		 * initial state, and try again.
+		 */
+		result = pcie_reset_flr(pdev, false);
+		if (result < 0)
+			return result;
+
+		pci_restore_state(pdev);
+		result = nvme_disable_ctrl(&dev->ctrl, false);
+		if (result < 0)
+			return result;
+
+		dev_info(dev->ctrl.device,
+			"controller reset completed after pcie flr\n");
+	}
 
 	result = nvme_alloc_queue(dev, 0, NVME_AQ_DEPTH);
 	if (result)
-- 
2.39.5

