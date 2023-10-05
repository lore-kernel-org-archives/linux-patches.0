Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B8441766
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="icGAIKW5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696535749; x=1728071749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GOHBkM4E1xt6ifRLwPO4brJgQO1Uu7WIe/PQmNjPNOU=;
  b=icGAIKW5uOUov23O9e1cCLBlMQ/6Tt03WqUVpYp8TkkmxfXQwKzBLsVG
   u8Fvyjy+OCKG/8DKa1bUp0I+QUMKpD7J+P0hCz2W2v1ete/ZmvXIFMYxv
   3Q5tP7ybKMNP2aUbNEy9V7z+qfIGq48lZ8LJzGkPxNlaChNaGir0RxjNI
   CDZpdKWqpbYgmAVWYk3ugxZ/U088VodawBF5qBYwYg/uzH0SOArO7TpW2
   CXq5MHybuRl6iJ/KoMWmGO0OglRr7QwTBI0sBydGbU6enSaTZKFJnnV7k
   j88nLHd4gGG4TDqh5SjfzChG5M38qWouhfco3kqgrDC68SjvFQamkS2fp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="386432556"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="386432556"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="755600129"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="755600129"
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
Subject: [PATCH v4 5/9] platform/x86/intel/ifs: Validate image size
Date: Thu,  5 Oct 2023 12:51:33 -0700
Message-Id: <20231005195137.3117166-6-jithu.joseph@intel.com>
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

Perform additional validation prior to loading IFS image.

Error out if the size of the file being loaded doesn't match the size
specified in the header.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 6b827247945b..582f1801aaaa 100644
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
+		dev_err(dev, "File size mismatch (expected %u, actual %zu). Corrupted IFS image.\n",
+			expected_size, fw->size);
+		return -EINVAL;
+	}
+
 	ret = image_sanity_check(dev, (struct microcode_header_intel *)fw->data);
 	if (ret)
 		goto release;
-- 
2.25.1

