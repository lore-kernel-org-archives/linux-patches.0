Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A4141767
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LTv+8Uz0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696535749; x=1728071749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GtDY6ML84SF+F8nWzdP67B1CzR7rZUd3wkHRxH1boOQ=;
  b=LTv+8Uz0fv6nuexDTjQQqmuywH6jMF78sOuCO5tUqw2KiiU6BkjE92yU
   lvlRIUFwZttR7aLv8+fiXIlrXRaViZQ9kMo+I+tciQaafVeiNvHWijzO4
   n9c7ch3cRRQkmtJN19ijAbemb+LTQnqNkSk3aD1UYR1hra9P5x0HdFS8U
   KVAOGmYQehQH9/FsYp16IY1/qDP6bRYmvLSYzDBFaHa3BgzWZExbvnuoV
   pyQmv/VCa1cmBbkYsJMXKJj6H1zgPmUGr2IoogkuzCjHEQQPu9GSvAyC9
   NRfq4idHKzkCKjcVSUr6BAjxhXWmIy0ucIa8LfyA7XffxbohPWl76/WnO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="386432548"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="386432548"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="755600118"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="755600118"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:44 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: ilpo.jarvinen@linux.intel.com,
	hdegoede@redhat.com,
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
Subject: [PATCH v4 2/9] platform/x86/intel/ifs: Refactor image loading code
Date: Thu,  5 Oct 2023 12:51:30 -0700
Message-Id: <20231005195137.3117166-3-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231005195137.3117166-1-jithu.joseph@intel.com>
References: <20230929202436.2850388-1-jithu.joseph@intel.com>
 <20231005195137.3117166-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

IFS image loading flow is slightly different for newer IFS generations.

In preparation for adding support for newer IFS generations, refactor
portions of existing image loading code for reuse.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
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

