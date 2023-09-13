Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD423649
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 18:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694630284; x=1726166284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1QD1hfFNbY0dgb7El0Aw5L89YdqnDMRaACvnIzni/zs=;
  b=TAwGoCwDdxwBE7tx8oIlyuJyQcBtg3/YlrPOAsgzLdLVsRVcWJGNmofP
   HxYqKUI2ar6KtMeSu7XV/7ZZ5nKi8nPsPwwSXPLb+kqztqCjQj4nfpFFd
   LMCrmyl/8Ihoq5YAuGEVluCGxnTwCQiH8r65uOmw4qbLCc/dpLVlIFeFm
   W77BWAiA7U3hVjgyd6vw8Bp7Y8XU416etcGzmMCdWrv1DoyjpYXPdp2cU
   opwk2uxV6iqARwFmX2yzmiaCgDHNCGmoj1Ysyc5xHpV7L8DJrVSBRE0Oj
   z7tVZ9Jcip6Fk3H0pcYS6QjiNuL6HEtwNkJmgKNCnfolPgctDbD8M3rh3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="369019169"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="369019169"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="744238590"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="744238590"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:55 -0700
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
	pengfei.xu@intel.com
Subject: [PATCH 06/10] platform/x86/intel/ifs: Validate image size
Date: Wed, 13 Sep 2023 11:33:44 -0700
Message-Id: <20230913183348.1349409-7-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913183348.1349409-1-jithu.joseph@intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Perform additional validation prior to loading IFS image.

Error out if the size of the file being loaded doesn't
match the size specified in the header.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index e8fb03dd8bcf..778a3b89a24d 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -376,6 +376,7 @@ int ifs_load_firmware(struct device *dev)
 {
 	const struct ifs_test_caps *test = ifs_get_test_caps(dev);
 	struct ifs_data *ifsd = ifs_get_data(dev);
+	unsigned int expected_size;
 	const struct firmware *fw;
 	char scan_path[64];
 	int ret = -EINVAL;
@@ -390,6 +391,13 @@ int ifs_load_firmware(struct device *dev)
 		goto done;
 	}
 
+	expected_size = ((struct microcode_header_intel *)fw->data)->totalsize;
+	if (fw->size != expected_size) {
+		dev_err(dev, "File size mismatch (expected %d, actual %ld). Corrupted IFS image.\n",
+			expected_size, fw->size);
+		return -EBADFD;
+	}
+
 	ret = image_sanity_check(dev, (struct microcode_header_intel *)fw->data);
 	if (ret)
 		goto release;
-- 
2.25.1

