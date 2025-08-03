Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFF41D5CC6;
	Sun,  3 Aug 2025 21:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255944; cv=none; b=DWAlqhmpJTm3vetlqK0L62qx2TMvP/HJ7KG7vKY0D/CLzc1Z74OsVWryyv88pE4SHZVmNGvLpwLMVZwBVQ1K6yHaPET9+4srH+AVsZbMhdvJuBDLn1rjsxTtpzdUThtC9Tx8kbF18f37fR2YLKMjrHEKyd7np3Zyh8hY2hG8nsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255944; c=relaxed/simple;
	bh=YD5bJJPMFlk6eY28GHSUHhs2Z82VE8Kd4QBHLV+/TxE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IFLa6rprQDFqc5cPDcaRZMfaWVVXD7/0UvAyFV4hq+6UFhtFsvKF2CPgi3S7umHqb9glnbKWNNeSXbUah3VdRtQ19SnTTOkMOMEvijzwIDJjkaEQGFHdmXzwnZcWlxh11jqyR/6ETVMmCUjaxifJ5XVPBnavoSm95LzntYi97G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmxMrjIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmxMrjIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6594FC4CEF8;
	Sun,  3 Aug 2025 21:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255944;
	bh=YD5bJJPMFlk6eY28GHSUHhs2Z82VE8Kd4QBHLV+/TxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmxMrjIxlqzu3gZEcsIjmVOTwYW+by4SOT8N3Qkc1pkPT/x905eTAwA2JGwmKQI66
	 1vW5tvpbc/jDCtk6NU/9sHyD/yl91/toS7hjed73V8779NHnFYy9dJO9fZEpfyA+Ir
	 bEsUf68L2u/BQ3Jk+Z41a8Q8ZDoX9ib9a9fgWV6LYsSlQLLdJeR4DMMvr0aiweYhqK
	 WLJslL0+ky8m+Ck1ShmCkuPWLs5rqRRvLgTx9eixfkuErr4/eb2HtjPreKyV0nD7wa
	 nPDQvITvCLGoDrkeN+WoIUTS3KRKaBYw3nkd0mbw8AfFso+FswPZZKu4b10qmm+899
	 4JCVpm3YjvabA==
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
Subject: [PATCH AUTOSEL 6.15 11/34] nvme-pci: try function level reset on init failure
Date: Sun,  3 Aug 2025 17:18:13 -0400
Message-Id: <20250803211836.3546094-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211836.3546094-1-sashal@kernel.org>
References: <20250803211836.3546094-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
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
index 776c867fb64d..5396282015a2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1888,8 +1888,28 @@ static int nvme_pci_configure_admin_queue(struct nvme_dev *dev)
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

