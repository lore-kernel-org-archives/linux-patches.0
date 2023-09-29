Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F317B849C
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 20:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696020318; x=1727556318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5hK8PYdSqpMVTtIO5x+qGkBJOJzZIeEW/a5RmMzipn4=;
  b=HrKNrs2mKkYsQfnaXiuXaF8MfDDKRlQxjj+W1yM7uPcvC2l6+C9+ESYl
   p4QWeN74GYnZ5dMAGnubFSXWs6/zvWyhsBV7RByI9ByUd7oZL2kJjDlXI
   GKVlG5+/kCU6UBoeXU//IZXc02urCwggz/N40I/ENNYj/2S/LkoYofjjX
   EhqSyQdehv6ymgj2cTFbG4ryGLTpUZH4fDYaXXYS3UIuhQVnjZAWg31vI
   T2YyrsSoDy3Nu/aBP/dKG1OVCT+ye8OoB25zIID2nDl1lbaRIL1P4SwJK
   tdWoc/qhN2zyN4uuf9riOlA4Dq9Kc8y4pZ/peXRwTrfmXCfkz/VL2QmG/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="468654456"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="468654456"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 13:28:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="893539240"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="893539240"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 13:27:29 -0700
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
Subject: [PATCH v3 5/9] platform/x86/intel/ifs: Validate image size
Date: Fri, 29 Sep 2023 13:24:32 -0700
Message-Id: <20230929202436.2850388-6-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230929202436.2850388-1-jithu.joseph@intel.com>
References: <20230922232606.1928026-1-jithu.joseph@intel.com>
 <20230929202436.2850388-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Perform additional validation prior to loading IFS image.

Error out if the size of the file being loaded doesn't match the size
specified in the header.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 6b827247945b..da54fd060878 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -375,6 +375,7 @@ int ifs_load_firmware(struct device *dev)
 {
 	const struct ifs_test_caps *test = ifs_get_test_caps(dev);
 	struct ifs_data *ifsd = ifs_get_data(dev);
+	unsigned int expected_size;
 	const struct firmware *fw;
 	char scan_path[64];
 	int ret = -EINVAL;
@@ -389,6 +390,13 @@ int ifs_load_firmware(struct device *dev)
 		goto done;
 	}
 
+	expected_size = ((struct microcode_header_intel *)fw->data)->totalsize;
+	if (fw->size != expected_size) {
+		dev_err(dev, "File size mismatch (expected %d, actual %ld). Corrupted IFS image.\n",
+			expected_size, fw->size);
+		return -EINVAL;
+	}
+
 	ret = image_sanity_check(dev, (struct microcode_header_intel *)fw->data);
 	if (ret)
 		goto release;
-- 
2.25.1

