Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BE43A961E;
	Fri,  4 Sep 2026 05:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499206; cv=none; b=QNyeF07MQeNH9E+AKXWhVdIUpDCCO0Xu3I7G7l4Pr/zv+21y6WO3UgKEjWYo+3OBYyeMbxmCOr46wn1ZrZPzqaboxx0Afx5T5nmx3R6wbv0+zas9QhvbVpk1He/ojWvi0mue0AaMep9yOM7KlWkXkwQZv7PA+vZpsFxu1gG18kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499206; c=relaxed/simple;
	bh=13H5zooBMb/635fEcg9345iWIShE7K0ZWa5okHqo4Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bqij9K+gP4AcOHsrlFVcBbvrnuByemfc9p+H4ilAXL57m/duGyqDxp1HyF0/tDPqsuXESNwuSXjg3jAdw38d6foblk7U089CM+ZkH8+g4s97FIEF4KP1rzkPgpz/5L2UInZ6ofgs4H1hqMhUEe2xqVEVMslP4fyBMnFgQk0DfLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eNBnxTN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eNBnxTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC99E1F00A3D;
	Fri,  4 Sep 2026 05:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499205;
	bh=VfzpeS9sjnkb8B53lTlW1aYY4wXDaa+K5vYvS9CWm1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0eNBnxTNu/XTmNkhBUOEYAfL1Uu0kEGR7c1XQKq2G2l0ZjprKbjXZ5PV65/q1tiEb
	 GzBK+qS01sRqfpyi3S8aGygfMlgP6Qz+3CwxM+ujDV14LV4PPd+Ace58w9g9+IBs+k
	 nBMPC9L5tNrdCeSJJzzCfr14m/kWAspY3vDfL6eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 7.2 335/713] cxl/pmem: Format the nvdimm serial number as unsigned decimal
Date: Fri,  4 Sep 2026 06:55:03 +0200
Message-ID: <20260904045811.338138118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

commit 8a80d3d65cd06ee35b913d8517fb2f2319f8e70c upstream.

The CXL NVDIMM security passphrase key description and the nvdimm 'id'
sysfs attribute are both derived from the CXL device serial number,
but the serial number is not formatted consistently.

The key description is formatted in hexadecimal while the 'id'
attribute is formatted in decimal. As a result, ndctl stores the key
using a decimal description while the kernel later looks it up using
a hexadecimal description. For serial numbers of 10 and above, the
descriptions no longer match, preventing automatic unlock after
reboot.

The decimal formatting has a second problem: both the key description
and the 'id' attribute use the signed %lld format for a u64 PCIe
Device Serial Number. Devices whose vendor OUI sets bit 63, such as
Montage CXL devices, appear with negative decimal serial numbers.

Format the security key description and 'id' attribute as unsigned
decimal, %llu, and document that the 'id' attribute is an unsigned
decimal value.

The key lookup mismatch was exposed by CXL unit test cxl-security.sh
when cxl_test mock serial numbers were extended to 10 and above.

A work around is described for ndctl load-key users here:
https://github.com/pmem/ndctl/issues/299

Cc: stable@vger.kernel.org
Fixes: b5807c80b5bc ("cxl: add dimm_id support for __nvdimm_create()")
Acked-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/2c673a5ba0a8fa93ad160578e193bd556091fa95.1784924949.git.alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-bus-nvdimm |    3 ++-
 drivers/cxl/core/pmem.c                    |   10 ++++++----
 drivers/cxl/cxl.h                          |    3 ++-
 drivers/cxl/pmem.c                         |    2 +-
 4 files changed, 11 insertions(+), 7 deletions(-)

--- a/Documentation/ABI/testing/sysfs-bus-nvdimm
+++ b/Documentation/ABI/testing/sysfs-bus-nvdimm
@@ -48,7 +48,8 @@ What:		/sys/bus/nd/devices/nmemX/cxl/id
 Date:		November 2022
 KernelVersion:	6.2
 Contact:	Dave Jiang <dave.jiang@intel.com>
-Description:	(RO) Show the id (serial) of the device. This is CXL specific.
+Description:	(RO) Show the id (serial) of the device, formatted as an
+		unsigned 64-bit decimal value. This is CXL specific.
 
 What:		/sys/bus/nd/devices/nmemX/cxl/provider
 Date:		November 2022
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -219,12 +219,14 @@ static struct cxl_nvdimm *cxl_nvdimm_all
 	dev->bus = &cxl_bus_type;
 	dev->type = &cxl_nvdimm_type;
 	/*
-	 * A "%llx" string is 17-bytes vs dimm_id that is max
-	 * NVDIMM_KEY_DESC_LEN
+	 * dev_id is the nvdimm dimm_id used for security key lookup.
+	 * It must match id_show(), which emits the CXL serial as an
+	 * unsigned decimal. A u64 decimal string is at most 20 digits
+	 * plus NUL.
 	 */
-	BUILD_BUG_ON(sizeof(cxl_nvd->dev_id) < 17 ||
+	BUILD_BUG_ON(sizeof(cxl_nvd->dev_id) < 21 ||
 		     sizeof(cxl_nvd->dev_id) > NVDIMM_KEY_DESC_LEN);
-	sprintf(cxl_nvd->dev_id, "%llx", cxlmd->cxlds->serial);
+	sprintf(cxl_nvd->dev_id, "%llu", cxlmd->cxlds->serial);
 
 	return cxl_nvd;
 }
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -505,7 +505,8 @@ struct cxl_nvdimm_bridge {
 	struct nvdimm_bus_descriptor nd_desc;
 };
 
-#define CXL_DEV_ID_LEN 19
+/* Holds a u64 serial as a decimal string: up to 20 digits + NUL */
+#define CXL_DEV_ID_LEN 21
 
 enum {
 	CXL_NVD_F_INVALIDATED = 0,
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -52,7 +52,7 @@ static ssize_t id_show(struct device *de
 	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
 	struct cxl_dev_state *cxlds = cxl_nvd->cxlmd->cxlds;
 
-	return sysfs_emit(buf, "%lld\n", cxlds->serial);
+	return sysfs_emit(buf, "%llu\n", cxlds->serial);
 }
 static DEVICE_ATTR_RO(id);
 


