Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46C72036E9;
	Tue,  3 Dec 2024 15:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240586; cv=none; b=XTz7Uhd6E1qyYQM40uvpjPchq516qvRJh14KGkElYAv6oi1o8PNdB/evsX+0pNFA/pmZp0VEKda0JJ4iPw9in0uX4nTHkBBq6ANKo93RhIhbB4iTOS+ka5NXuseDwYfQalYLJqdzrw86/H/3fK0lAENSiotE3V6GIny9t3jBG3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240586; c=relaxed/simple;
	bh=ywqUev0QsxqmZG4xTEtcCvRnrX8ZXkTc/Dd9VXn95ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aH71twlKnRjTRLBT3yByP6quQ0oaLGv8KMbIIRHcSnKSEvLdbk+K1xIfnRyzLEl/5aDONQDr2s+cuWX8v2AJq7y0VbUtziF4A1M1OxmOeeWhbWEEoYSyWgd1LEgWmOO4pfCj50lq3hqln7xks0VQ/82Tv+PgvmtG2w3pQulSudk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fn9pqW2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fn9pqW2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E06C4CED8;
	Tue,  3 Dec 2024 15:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240586;
	bh=ywqUev0QsxqmZG4xTEtcCvRnrX8ZXkTc/Dd9VXn95ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fn9pqW2Gs5Ymk41hEx9JeLjPJ/E/ORz+F+ynTBmxz3v89Ni3/pt+VRZYr/hrlJbsh
	 7a4ncTmCoxDy4C+h/lF/IjqE8pOvLYg3Hgyx6NU6Ld/3xtl3Nhq0K5v2He/UGCg3NM
	 YyAVV8fbWa/mcZthqgliBT0VsJpfPqKThb3uHG7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/826] platform/x86/intel/pmt: allow user offset for PMT callbacks
Date: Tue,  3 Dec 2024 15:38:26 +0100
Message-ID: <20241203144750.719165384@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

[ Upstream commit 0c32840763b1579c923b4216c18bb756ca4ba473 ]

Usage of the telem sysfs file allows for partial reads at an offset.
The current callback method returns the buffer starting from offset 0
only.

Include the requested offset in the callback and update the necessary
address calculations with the offset.

Note: offset addition is moved from the caller to the local usage. For
non-callback usage this is unchanged behavior.

Fixes: e92affc74cd8 ("platform/x86/intel/vsec: Add PMT read callbacks")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://lore.kernel.org/r/20241114130358.2467787-2-michael.j.ruhl@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/class.c     | 8 +++++---
 drivers/platform/x86/intel/pmt/class.h     | 2 +-
 drivers/platform/x86/intel/pmt/telemetry.c | 2 +-
 include/linux/intel_vsec.h                 | 3 ++-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
index c04bb7f97a4db..c3ca2ac91b056 100644
--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -59,10 +59,12 @@ pmt_memcpy64_fromio(void *to, const u64 __iomem *from, size_t count)
 }
 
 int pmt_telem_read_mmio(struct pci_dev *pdev, struct pmt_callbacks *cb, u32 guid, void *buf,
-			void __iomem *addr, u32 count)
+			void __iomem *addr, loff_t off, u32 count)
 {
 	if (cb && cb->read_telem)
-		return cb->read_telem(pdev, guid, buf, count);
+		return cb->read_telem(pdev, guid, buf, off, count);
+
+	addr += off;
 
 	if (guid == GUID_SPR_PUNIT)
 		/* PUNIT on SPR only supports aligned 64-bit read */
@@ -96,7 +98,7 @@ intel_pmt_read(struct file *filp, struct kobject *kobj,
 		count = entry->size - off;
 
 	count = pmt_telem_read_mmio(entry->ep->pcidev, entry->cb, entry->header.guid, buf,
-				    entry->base + off, count);
+				    entry->base, off, count);
 
 	return count;
 }
diff --git a/drivers/platform/x86/intel/pmt/class.h b/drivers/platform/x86/intel/pmt/class.h
index a267ac9644230..b2006d57779d6 100644
--- a/drivers/platform/x86/intel/pmt/class.h
+++ b/drivers/platform/x86/intel/pmt/class.h
@@ -62,7 +62,7 @@ struct intel_pmt_namespace {
 };
 
 int pmt_telem_read_mmio(struct pci_dev *pdev, struct pmt_callbacks *cb, u32 guid, void *buf,
-			void __iomem *addr, u32 count);
+			void __iomem *addr, loff_t off, u32 count);
 bool intel_pmt_is_early_client_hw(struct device *dev);
 int intel_pmt_dev_create(struct intel_pmt_entry *entry,
 			 struct intel_pmt_namespace *ns,
diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index c9feac859e574..0cea617c6c2e2 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -219,7 +219,7 @@ int pmt_telem_read(struct telem_endpoint *ep, u32 id, u64 *data, u32 count)
 	if (offset + NUM_BYTES_QWORD(count) > size)
 		return -EINVAL;
 
-	pmt_telem_read_mmio(ep->pcidev, ep->cb, ep->header.guid, data, ep->base + offset,
+	pmt_telem_read_mmio(ep->pcidev, ep->cb, ep->header.guid, data, ep->base, offset,
 			    NUM_BYTES_QWORD(count));
 
 	return ep->present ? 0 : -EPIPE;
diff --git a/include/linux/intel_vsec.h b/include/linux/intel_vsec.h
index 11ee185566c31..b94beab64610b 100644
--- a/include/linux/intel_vsec.h
+++ b/include/linux/intel_vsec.h
@@ -74,10 +74,11 @@ enum intel_vsec_quirks {
  * @pdev:  PCI device reference for the callback's use
  * @guid:  ID of data to acccss
  * @data:  buffer for the data to be copied
+ * @off:   offset into the requested buffer
  * @count: size of buffer
  */
 struct pmt_callbacks {
-	int (*read_telem)(struct pci_dev *pdev, u32 guid, u64 *data, u32 count);
+	int (*read_telem)(struct pci_dev *pdev, u32 guid, u64 *data, loff_t off, u32 count);
 };
 
 /**
-- 
2.43.0



