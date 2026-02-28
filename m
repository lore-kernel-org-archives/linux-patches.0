Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5E6372228;
	Sat, 28 Feb 2026 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301487; cv=none; b=t7MbOHtqPajw7RhRw/6XHF6IFqf6BkjEElkQlc6DCTOkw102HdkBF/vi/LElKX7ZpCf2gcTR2jNUcq2EQOf7M5L0iuTKqupVBqZeLnyKUYPF6nt5YZFXCumcsIz5cMPe6E16KcAQk1kzgGMsAprWMUru2UaPIDuGeDzIuLEIP0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301487; c=relaxed/simple;
	bh=zxQD0QF20d25dMynZ6egejmOa/yapQiB1fmBclY3TLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IXWgv/TS9TIcjIU6sYEXXlDLFK7cFoJMERoUNqgn5R9uXrZqEAw26Fjd0afT6TqhzgILSKZyl46fktlqGbZdPv/aR0UIsXdVHkil25qb0iLXtCLTHMGdVbOQIZRoYFHPUnsHhnRqKfNxl51+QtAMTSpDPJjEyjpNSW9wPkcn0Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B3OFxcEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B3OFxcEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7EAC19423;
	Sat, 28 Feb 2026 17:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301487;
	bh=zxQD0QF20d25dMynZ6egejmOa/yapQiB1fmBclY3TLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3OFxcEE7r6eWyBCCgPqgIbN/QcnUxY/Y/ODuAqXxvVknj7uChsOW1mTWB+fDZHjJ
	 lWqjpvGIIp3XOS0x0d57Zp6QfqAs/yt73QpRB+zJpPo0Jv3nEERzxAg3TND4+zLw5K
	 F9orj0uC1yweqixWkHo/W2N3rOCpJdzzUPixkUXCE1khfDjOGIEO3z+cZb588N3oCr
	 zb03YV2nD7W49YlyiPWc5HXs86arYiZxrEyTIXuiXPDgAzNmQWifTJSpEv2zyoJ689
	 SnBauR+MavAq6sBhPWeK5gZZiN4U+95VbsCoXIFFCFdZPgRUifVQlA3uUwFl4bGkrQ
	 W7G/Xdj2XmJkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sizhe Liu <liusizhe5@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 673/752] PCI: Don't claim disabled bridge windows
Date: Sat, 28 Feb 2026 12:46:24 -0500
Message-ID: <20260228174750.1542406-673-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 2ecc1bf14e2fdaff78bd1b8e7ed3dba336a3fad5 ]

The commit 8278c6914306 ("PCI: Preserve bridge window resource type flags")
changed bridge window resource behavior such that flags are no longer zero
if the bridge window is not valid or is disabled (mainly to preserve the
type flags for later use). If a bridge window has its limit smaller than
base address, pci_read_bridge_*() sets both IORESOURCE_UNSET and
IORESOURCE_DISABLED to indicate the bridge window exists but is not valid
with the current base and limit configuration.

The code in pci_claim_bridge_resources() still depends on the old behavior
of checking validity of the bridge window solely based on !r->flags,
whereas after 8278c6914306, also IORESOURCE_DISABLED may indicate bridge
window addresses are not valid.

While pci_claim_resource() does check IORESOURCE_UNSET,
pci_claim_bridge_resource() attempts to clip the resource if
pci_claim_resource() fails, which is not correct for bridge window
resources that are not valid. As pci_bus_clip_resource() performs clipping
regardless of flags and then clears IORESOURCE_UNSET, it should not be
called unless the resource is valid.

The problem is visible in this log:

  pci 0000:20:00.0: PCI bridge to [bus 21]
  pci 0000:20:00.0: bridge window [io  size 0x0000 disabled]: can't claim; no address assigned
  pci 0000:20:00.0: [io  0x0000-0xffffffffffffffff disabled] clipped to [io 0x0000-0xffff disabled]

Add IORESOURCE_DISABLED check in pci_claim_bridge_resources() to only
claim bridge windows that appear to have a valid configuration.

Fixes: 8278c6914306 ("PCI: Preserve bridge window resource type flags")
Reported-by: Sizhe Liu <liusizhe5@huawei.com>
Link: https://lore.kernel.org/all/20260203023545.2753811-1-liusizhe5@huawei.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/4d9228d6-a230-6ddf-e300-fbf42d523863@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 5d15298469cbc..c2d640164f697 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1681,6 +1681,8 @@ static void pci_claim_bridge_resources(struct pci_dev *dev)
 
 		if (!r->flags || r->parent)
 			continue;
+		if (r->flags & IORESOURCE_DISABLED)
+			continue;
 
 		pci_claim_bridge_resource(dev, i);
 	}
-- 
2.51.0

