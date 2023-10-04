Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88498219EF
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 19:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m67+ql9A"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696446254; x=1727982254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9rEhsAdm4qprufCY9YFBrMJoK6i9PZwnuJiNdBtxSWU=;
  b=m67+ql9A/+xqQEzFpZDrCpdf4eH0sSSFaCVTWu1G4V5Yp/wU93QemSmA
   g5DE9DglETUMPHLkQJypQt9he8rQHFCXKm07gloInEZWUinsHnbhGr3hG
   A/DXWwtJ/E/37je1ALV2iXv8wqVMo8dFijtVAvEJyiJbUo9E5azlKHNb4
   P4W/AgQGd4GF3tae/mktarsJcKsHC6zzemEkhUWMS9EoOZcPz3iYFsAlP
   VE+n0LgN0uOr1pjTi9noODT3epuzI3B6TCsI8TpJ9ZNVSIckmRlylnjqt
   EHaR98ctJuvBaDtnhA80viMMmFvU8kgXFUWphRi6Aq7cWQoMfjemfu3A6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="4838620"
X-IronPort-AV: E=Sophos;i="6.03,201,1694761200"; 
   d="scan'208";a="4838620"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 12:04:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="745098524"
X-IronPort-AV: E=Sophos;i="6.03,201,1694761200"; 
   d="scan'208";a="745098524"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 12:04:12 -0700
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
Subject: [PATCH v3 6/9] platform/x86/intel/ifs: Metadata validation for start_chunk
Date: Wed,  4 Oct 2023 12:00:09 -0700
Message-Id: <20231004190009.3028495-1-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <e8bcbdcc-8cba-57ec-b0fc-4d66305d5aed@linux.intel.com>
References: <e8bcbdcc-8cba-57ec-b0fc-4d66305d5aed@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add an additional check to validate IFS image metadata field prior to
loading the test image.

If start_chunk is not a multiple of chunks_per_stride error out.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 - changed the dev_warn printk format specifiers (Ilpo Järvinen)

 drivers/platform/x86/intel/ifs/load.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 582f1801aaaa..959b1878cae6 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -291,6 +291,13 @@ static int validate_ifs_metadata(struct device *dev)
 		return ret;
 	}
 
+	if (ifs_meta->chunks_per_stride &&
+	    (ifs_meta->starting_chunk % ifs_meta->chunks_per_stride != 0)) {
+		dev_warn(dev, "Starting chunk num %u not a multiple of chunks_per_stride %u\n",
+			 ifs_meta->starting_chunk, ifs_meta->chunks_per_stride);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.25.1

