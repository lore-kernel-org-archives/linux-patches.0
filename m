Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5A048E84
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695425416; x=1726961416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WrOU0a7wgE3OYiSb3Tr3bbEuX5YDrEhEBdcjQkN5ci8=;
  b=lMqjeJM3mmZJtxPb7TTghy/n6DRieHWdTT/Dmr+ufAhIiGbhHt83rLGC
   UH9TsQNJF50YhwZshGiN2DgWrGBggS7RqCukxK6KyK3S7dwID5NPMv4Xk
   GbME4tBcZnS/cAW806wTyTyPFPxcGyzts0Px/fCW7Hf9K2YGCJOkzzafZ
   mbQ6V5N+LvJyU2lN1zmETi19JQcRRKLrBvuVVj2tvWgYQSbzvQjQxIjDh
   gclzbxTpISd83gw2hgO263m9RDHZBr/c5HYkJfgNIBaJ83FYhlQktXMf/
   8SBDm2LcYX1JDpTPm7sEx+PsOZeHds+SRSGw2uUeBTif+/1VYjGFY3tWz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="411896971"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="411896971"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="921350843"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="921350843"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:13 -0700
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
Subject: [PATCH v2 6/9] platform/x86/intel/ifs: Metadata validation for start_chunk
Date: Fri, 22 Sep 2023 16:26:03 -0700
Message-Id: <20230922232606.1928026-7-jithu.joseph@intel.com>
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

Add an additional check to validate IFS image metadata field prior to
loading the test image.

If start_chunk is not a multiple of chunks_per_stride error out.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index b09106034fac..c92d313b921f 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -291,6 +291,13 @@ static int validate_ifs_metadata(struct device *dev)
 		return ret;
 	}
 
+	if (ifs_meta->chunks_per_stride != 0 &&
+	    (ifs_meta->starting_chunk % ifs_meta->chunks_per_stride)) {
+		dev_warn(dev, "Starting chunk num %d not a multiple of chunks_per_stride %d\n",
+			 ifs_meta->starting_chunk, ifs_meta->chunks_per_stride);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.25.1

