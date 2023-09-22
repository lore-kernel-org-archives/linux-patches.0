Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C869E48E80
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 23:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695425414; x=1726961414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eBFr+P8r5vNXCcrUFO02naJBuqwBT/yzn6Gswd0MWNo=;
  b=ExXV+AXP6KiPUgksY4mb/3b4A9MI3tQN6pehjEWOWtpkdgdDPw52yFub
   dIzh5/CYfVC1Zd/C+ptWUVQpJggSeNuY8EPR7FHbahsMDrzHjQGZgWx/u
   F4sxKR06qav4iAfvgZTf3z/GSHUmBS7u8MK3HEA+jMeeAM5A6vJCai3+P
   TCbe+gxe2iPM0qwLTebIJc8+Mw+6EjL0NeKM824HFUptvNb/EZY3JLF3X
   bxHVeGjUJbzYxcopRTlRcxP4RUqPK9NvgSn1KHF90ND1eDuEkazLpvWwO
   xqHnT2kncro89CViPp+cDXoDXdZSGjsL0CT2Ou9Rdb3N//ZFe5M6oqzPo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="411896935"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="411896935"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="921350830"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="921350830"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:11 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	pengfei.xu@intel.com,
	ilpo.jarvinen@linux.intel.com
Subject: [PATCH v2 2/9] platform/x86/intel/ifs: Refactor image loading code
Date: Fri, 22 Sep 2023 16:25:59 -0700
Message-Id: <20230922232606.1928026-3-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230922232606.1928026-1-jithu.joseph@intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com>
 <20230922232606.1928026-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IFS image loading flow is slightly different for newer IFS generations.

In preparation for adding support for newer IFS generations, refactor
portions of existing image loading code for reuse.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 31 ++++++++++++++++-----------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index cefd0d886cfd..851c97cc6a6b 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -80,6 +80,23 @@ static struct metadata_header *find_meta_data(void *ucode, unsigned int meta_typ
 	return NULL;
 }
 
+static void hashcopy_err_message(struct device *dev, u32 err_code)
+{
+	if (err_code >= ARRAY_SIZE(scan_hash_status))
+		dev_err(dev, "invalid error code 0x%x for hash copy\n", err_code);
+	else
+		dev_err(dev, "Hash copy error : %s\n", scan_hash_status[err_code]);
+}
+
+static void auth_err_message(struct device *dev, u32 err_code)
+{
+	if (err_code >= ARRAY_SIZE(scan_authentication_status))
+		dev_err(dev, "invalid error code 0x%x for authentication\n", err_code);
+	else
+		dev_err(dev, "Chunk authentication error : %s\n",
+			scan_authentication_status[err_code]);
+}
+
 /*
  * To copy scan hashes and authenticate test chunks, the initiating cpu must point
  * to the EDX:EAX to the test image in linear address.
@@ -109,11 +126,7 @@ static void copy_hashes_authenticate_chunks(struct work_struct *work)
 
 	if (!hashes_status.valid) {
 		ifsd->loading_error = true;
-		if (err_code >= ARRAY_SIZE(scan_hash_status)) {
-			dev_err(dev, "invalid error code 0x%x for hash copy\n", err_code);
-			goto done;
-		}
-		dev_err(dev, "Hash copy error : %s", scan_hash_status[err_code]);
+		hashcopy_err_message(dev, err_code);
 		goto done;
 	}
 
@@ -133,13 +146,7 @@ static void copy_hashes_authenticate_chunks(struct work_struct *work)
 
 		if (err_code) {
 			ifsd->loading_error = true;
-			if (err_code >= ARRAY_SIZE(scan_authentication_status)) {
-				dev_err(dev,
-					"invalid error code 0x%x for authentication\n", err_code);
-				goto done;
-			}
-			dev_err(dev, "Chunk authentication error %s\n",
-				scan_authentication_status[err_code]);
+			auth_err_message(dev, err_code);
 			goto done;
 		}
 	}
-- 
2.25.1

