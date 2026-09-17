Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06D8519DE0;
	Thu, 17 Sep 2026 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664176; cv=none; b=OZE6TH9uLh4E1v+mUmibrfIJaSsfO+eS6DEcWwo7rU18eSSMY1Es656wOQ5cDr9ygreZFKFsyONXnWPjm18Q2n21H56AqqJX6CwY2DjvjTDxQSjGhRwHYltOc54PCgAHfvbK3jk2TTocJ2Y7iSbRd8HmBBmO8StErgf4QYweADI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664176; c=relaxed/simple;
	bh=qpOhW+UKq9YzH+rwEJb03Zal8vaEFozpxVTma+RwwlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVsDfW5DjlNc+/fEsB9Qenf/5yytgn0pa6yfjkrVUBgD+5AM0FWxMabV0eYmUU8vLUqcNIqPcccY/qBvMWzhX/Jg4rgEnj80enEL1ZA8GwtWXjCH+X9pULg1fRv48s+cLV77X+lIIyJRoLIchZGZZ2uVuZ6TU7CXqs17ftgpMYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osV8ogmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osV8ogmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023AE1F000FF;
	Thu, 17 Sep 2026 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664175;
	bh=3C5s797tBHMrvhKT+VoFeG763FD8++YGWN2hM26VSZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osV8ogmcPzVghiUNcepK1mmh4OxpD2M5z7TFjR216M9bQbfu+xpEG9GSnYOp3eV1Y
	 gkp66NfSsLYSauRnGNdq8XTq+d4soF05Tf5I2qk6pehW5SUEWiskd1lPYkjdU8Eney
	 cM7q5eI9wygFc+mG4VDdL9Hr5xNB7ZNC0teAjOCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	Alison Schofield <alison.schofield@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0283/1250] ACPI: scan: Honor _DEP for ACPI0016 PCI/CXL host bridge
Date: Thu, 17 Sep 2026 16:01:18 +0100
Message-ID: <20260917151559.804492162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit bf5418a5fe63f35da35941ae896d5df121d95ffc ]

CXL root devices (ACPI0017) declare _DEP on their parent ACPI0016
PCI/CXL host bridge so that cxl_acpi probes only after acpi_pci_root
has attached the PCI root and registered it for acpi_pci_find_root().
However, acpi_dev_ready_for_enumeration() only consults dep_unmet
when the supplier's HID is on acpi_honor_dep_ids[]; otherwise the
dependency is silently ignored.

Without honoring the dependency, cxl_acpi can probe before the PCI
root is ready. The resulting CXL topology is broken: decoder targets
read as 0 and no port/endpoint devices appear under
/sys/bus/cxl/devices/.

Add ACPI0016 to acpi_honor_dep_ids[] so the _DEP declared by ACPI0017
is enforced. This relies on the preceding patch ("ACPI: PCI: clear
_DEP dependencies after PCI root bridge attach"), which releases the
dependency once the PCI root is fully enumerated; the two patches
must be applied together.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260526025118.38935-3-cp0613@linux.alibaba.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 92928389ea0f9..32fa1c1ded601 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -870,6 +870,7 @@ static const char * const acpi_honor_dep_ids[] = {
 	"RSCV0005", /* RISC-V SBI MPXY MBOX */
 	"RSCV0006", /* RISC-V RPMI SYSMSI */
 	"PNP0C0F",  /* PCI Link Device */
+	"ACPI0016", /* CXL/PCIe host bridge: CXL root (ACPI0017) depends on PCI root attach */
 	NULL
 };
 
-- 
2.53.0



