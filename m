Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D39E3905F4;
	Fri,  4 Sep 2026 05:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500970; cv=none; b=Yz4e2GMd0tk7vUh3ySFGZYx5DZOGvPgMhNXYVUizVlJ4OcRbpjlG0ATM37GesnuRC9Om8Q1xbAirbMpI+7RNfWSMYyRJOXYdVwAl00mbwtlLB819UiDDWVRmKMF9tdUHG92ZfoRJrVYhSAkAw3p+tGRygzwbpeJtXX1CKiqIgiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500970; c=relaxed/simple;
	bh=YRgYUYYKCi7bMi4BLIXhVcgpoZzj7y24BAbmiL1IuQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU54zvVbiwZtvi9nyW2WV5w4JeLk0Am22Hy5MBZT//Rv9zneFeWXmIaau2ZqjdzCIhumDvjlvFTTurf9Dzjpkc17BFfOz6yrmRRQqv9h52kIkqlTt35gzxPI6S3ULMmXYpMRskm7rJ/zpEnCu2LCZch1b+qnQMhWxDRBg7ebR4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+pqEo7M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+pqEo7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F961F00A3D;
	Fri,  4 Sep 2026 05:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500969;
	bh=LYo0NrO+aeoTGerRuhEy9KXMOBJHTiQaSbATsIadV3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+pqEo7MqTle4VUjg32LCkzWDQVT+ewmH/Il4H0+puqWIJRdfJwxk9Cmpr205YzlT
	 2jsy0syA3TZhMQITf2tT9XAeZFCBzUXh3iy1Uyboo0HAN0NOADUicKM+hcQ19/GvDo
	 sPR2QUVRkwkrw/jwUQtFG6jHNZSRNLnUyB7Wnro8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.18 243/552] cxl/pmem: Format the nvdimm serial number as unsigned decimal
Date: Fri,  4 Sep 2026 06:56:40 +0200
Message-ID: <20260904045755.002100569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -563,7 +563,8 @@ struct cxl_nvdimm_bridge {
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
 


