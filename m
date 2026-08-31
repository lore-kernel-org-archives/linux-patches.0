Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F6C563FBA;
	Mon, 31 Aug 2026 13:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184073; cv=none; b=tZUzVF49iUAqGy4B3H7yXwrD4aDONT+pG6KJB1LpUj+67eZD0ExlLQPYTHWrDx0Z1onjGnuTS8CWXZHbSGsqsnNemrQPvb3dDJ/he8/JLNLKUAplw9sFLXgJz6ryuF6xQVWPkul6E56YLeUWs0SBxGA13leoyvO+ScL2GXK042k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184073; c=relaxed/simple;
	bh=ItkKW4mkuQhkIHYtvu7+qMQsBPQDggLoeRB0eTfgntk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sW7BsMOvNVG/sFUhpdxgN1vtjwe290iYnLuugHYxwahXdoMz7/kn2Q8L6V9aned0fftUvkYkgMos01uNLQkfYv3Tcstk38RjlD4yk1uszehbL0QmM2RQcv3lzxzNpx9nhTIBEMvv+rwLtxG12KR58MsEj2ZbfWKWdR/0X9KXCuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjGAM2kj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjGAM2kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAF91F00A3F;
	Mon, 31 Aug 2026 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184072;
	bh=bFaIR2jhArVbjKiTHHUfd4qRTiCX8wyA6IHrm3cPzss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjGAM2kjEdVW9tGWOPLzxmy/ZbVF2O1/vLQuI268/IXFvl276zu1P4kqiWVH1C/0q
	 vuOS1l0OjOngcecJOvzxGI5R7A5EHRIpyUzpTFTOwQf7WXr9iGUF1NAM26VwlvR9n2
	 +ApUD2KXiPPvxF0/O6tpi2e4bs4Z768LhGynmJVHPSl5tGQw+3ExOKbQVsbD1pHrJl
	 2ZfyKHQioztr+ipN/VDrRapOSsexpXhngVHla2MHGqS+syNzz3IXWWG2qqgBebhrhi
	 Z4ZmNZXQuqSxGKBfH1Mh0aWUPinv4v4jhXapzhbHD5xIQL7MCOitUckHLmuDPfBmQM
	 csxwXldmeDuCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Pei <cp0613@linux.alibaba.com>,
	"Dan Williams (nvidia)" <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	bhelgaas@google.com,
	rafael@kernel.org,
	linux-pci@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ACPI: PCI: Clear _DEP dependencies after PCI root bridge attach
Date: Mon, 31 Aug 2026 09:28:22 -0400
Message-ID: <20260831133314.4125787-474-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit 3a59c3b772e5dc0cedecce8e7fbf7c2d6245b643 ]

PCI root bridges enumerated by acpi_pci_root_add() can be the _DEP
supplier for other ACPI consumers, most notably ACPI0017 CXL root
devices whose probe path depends on acpi_pci_find_root() succeeding.
Once the root bus has been added, those consumers can safely be
enumerated, so notify them by clearing the dependency.

Call acpi_dev_clear_dependencies() at the end of acpi_pci_root_add(),
after pci_bus_add_devices(), following the same pattern used by other
ACPI suppliers such as the EC (drivers/acpi/ec.c) and the ACPI PCI
Link device (drivers/acpi/pci_link.c). The clear is intentionally
done only on the success path; on the error paths the supplier did
not attach and consumers must keep dep_unmet set.

This is a prerequisite for honoring _DEP on ACPI0016 host bridges,
which matters on architectures where the probe order of acpi_pci_root
relative to cxl_acpi is not guaranteed (e.g. RISC-V).

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Suggested-by: Dan Williams (nvidia) <djbw@kernel.org>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260526025118.38935-2-cp0613@linux.alibaba.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished and match the earlier analysis:

- **Commit located**: `b52e0117014b6` (stable prep) and upstream
  `3a59c3b772e5d` — on `autosel` / `all-next`, not in current `v6.18.44`
  HEAD.
- **Companion patch**: `82dbacca5220e` (“Honor _DEP for ACPI0016”) is
  also only on `autosel`, not in 6.18.44.
- **Current tree**: `drivers/acpi/pci_root.c` still lacks
  `acpi_dev_clear_dependencies()`, and `acpi_honor_dep_ids[]` has no
  `ACPI0016` entry.

**Verdict unchanged: YES** — backport this commit together with patch
2/2 for the CXL `_DEP` ordering fix on 6.18.y.

 drivers/acpi/pci_root.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 74ade41603145..332568e00f37c 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -760,6 +760,10 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	pci_lock_rescan_remove();
 	pci_bus_add_devices(root->bus);
 	pci_unlock_rescan_remove();
+
+	/* Clear _DEP dependencies to allow consumers to enumerate */
+	acpi_dev_clear_dependencies(device);
+
 	return 1;
 
 remove_dmar:
-- 
2.53.0

