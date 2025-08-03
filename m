Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BBC1D5CC6;
	Sun,  3 Aug 2025 21:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255887; cv=none; b=M90td8Jthb5milOwBnXXNLi2rMC/GY+AY9FRXEwpondCw/vPnLo+7A2tET7x1Cinx2CygRcFwQz4hnHNe9QKrIDCHG4R2+kl6RprrrcUkA6u6YV6wzSbcR5vTrKUXsDJO1jzbM5eF86aomojOf9N/ETclsRKHDLKn1OaskopZTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255887; c=relaxed/simple;
	bh=ZQ0SmCmxHSQA1JbgC6r/RTOGEuKlt5umJkDA6od/wgk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fD8NOHgxlfGxmm0sqUzOpx8HldFUBuR5JxdoiuwCmkU3BlCF4uwQZR12tSsLu4YX0UOyAkFCwa2KlI/dt1vMnKKCkVCXv1f6ZPG/CId1UJ5ipmQ+WjPFPPCdS+xXbfMsOARpDz1E7UKO6eBBaI9sj+3lJAkEX37q70bCJd9xhsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a7U4kCk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a7U4kCk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8FEC4CEEB;
	Sun,  3 Aug 2025 21:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255886;
	bh=ZQ0SmCmxHSQA1JbgC6r/RTOGEuKlt5umJkDA6od/wgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7U4kCk/v97yqv4M673wOhSL5n6kpIa6uppG8ZdPuzTB1/mznobyXuppPyqlefgtR
	 DHBH75Q/R7lL14VgtR3Uf44PgluQsrh4DHMJhbktMx7cDhtr6N+fDM9QPL3tlODqyc
	 xZ01MRLAFvlztz7+tqBWpIuDTEZv0FOgMpmzTmT/nIAjg+0snlccxVqzXAAUMFlIE/
	 PZwCyUo4iIWrdSwBjFX46M9gGBjs2VL/8hjybZoy05yXRwVpmqBIMUa+omLzSNzkvf
	 ejCYvCw4Cq7aYv6zhomVEeIMc5M8oHyZjzaIohcdxVNY9T6O+yJmA5K+ou9a8Lk9UA
	 0B0xIb1ioTkTw==
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
Subject: [PATCH AUTOSEL 6.16 12/35] nvme-pci: try function level reset on init failure
Date: Sun,  3 Aug 2025 17:17:12 -0400
Message-Id: <20250803211736.3545028-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211736.3545028-1-sashal@kernel.org>
References: <20250803211736.3545028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
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
index 320aaa41ec39..3ef30c36bf10 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1958,8 +1958,28 @@ static int nvme_pci_configure_admin_queue(struct nvme_dev *dev)
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

