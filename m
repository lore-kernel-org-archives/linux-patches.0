Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFE51FCF7C;
	Sun,  3 Aug 2025 21:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256000; cv=none; b=Ov9qkh7r/v9Q65sxTqSADLEHMGQ40w0Y+E9ebRXfEZ0w2ikiZgsXwHJ3tHIomfQ8yMoWBO+Qx05AijujIuW91oGYH0zRBRtwKznOzyeotFYt83dlUfK5cmRsv2XITTUK0VW6m7pFglG8CZjNbSPXmjrtRKiBbGVWhzxSkCD9Q24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256000; c=relaxed/simple;
	bh=R2bC7O+Y/NmTVupnnQ7W+mSwYOgf9soiaysMl4Sit1k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N6FhQgBq6R95t4Mcb5QjiDQCEd7OSmzccTH1lljCSt+3S9J4GKw/rePN2kRIROpSVzYBIsxsQ5aS0rxxkH3Zw3Hc5M3PKzeSwaqqsMeX0CU1BH3JuoVYwD9I01jxJtzeW8qXK6WewvTVyNfPttIeDgAbgbhZEcKh7daRIXX/9xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVLZ8UcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVLZ8UcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FA7C4CEF9;
	Sun,  3 Aug 2025 21:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255999;
	bh=R2bC7O+Y/NmTVupnnQ7W+mSwYOgf9soiaysMl4Sit1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVLZ8UcFiriA3OFjUqQl9rxHQ4lyRqA9c0UUeTPMMWzfE2WPhAjh6xfUrkF0q0XY7
	 KZiIrtgOi+33zBIP2Ku6+waDIF8bVACVrkAut7NFcUbiYhstxnunjA6zL5KnsDCG+8
	 yyUS9fCNLNwdSo64HyY9qLWPfHaa79P/w3nasSVSXkR8h/cdxtO70hMIjoSMX1PHMY
	 WQDazaW8qmsb8HflWeNQncue30vtqWFRceRh+Tc3MnFSHQnL9FRgvYz7OJ6i2f6l8x
	 Q3BDL2VIBn99XhwyohMU3cLipxhJrdb8nixPeBJ3fcBBObyAJnDdyvPwL2pIpEsQ6X
	 sG+/DKxeBIhbw==
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
Subject: [PATCH AUTOSEL 6.12 09/31] nvme-pci: try function level reset on init failure
Date: Sun,  3 Aug 2025 17:19:12 -0400
Message-Id: <20250803211935.3547048-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211935.3547048-1-sashal@kernel.org>
References: <20250803211935.3547048-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
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
index 37fd1a8ace12..2bddc9f60fec 100644
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

