Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063987C
	for <patches@lists.linux.dev>; Wed, 14 Dec 2022 00:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670977550; x=1702513550;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mLXEzoSwM14S/kiHtmzzux6iUbcUUXezKFN/hACEsUg=;
  b=CvdA9LkMkfj5N68GlVcvU17hQYV4ct+GE6SO3to4ajDQimW376T1Fbdx
   g5KPEwa625fSLbch2g/S3cLfjAgLE3XmwyZ+fEappDfhTo/Glj5goYl+R
   /v3uPIOLehGLWvjQ6l/TD59N/XEgIFlmNM/SoD91/A5i2GZEEBdka7q7N
   FFJzRXYiuH4rFzovmQCUNUJuto0x1eEPC6NgdRwkGQibkb4LpPiPv0w9G
   YynsUkmMJxBnVzQcDJ13fSra8QppeZBMZ0eF9PIC5jboiJpT0b+UGJWz1
   /XSiq2boLWOK97XvnCX16mso+44iwqELEsslTTNw89NwPqwKAEfV+WTKv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="404540215"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="404540215"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="823084778"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="823084778"
Received: from mesplin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.37.170])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:49 -0800
Subject: [ndctl PATCH 5/5] cxl/test: More backtrace detection
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, vishal.l.verma@intel.com, patches@lists.linux.dev
Date: Tue, 13 Dec 2022 16:25:49 -0800
Message-ID: <167097754909.1189953.2852545346689990149.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167097752151.1189953.3189708700022130101.stgit@dwillia2-xfh.jf.intel.com>
References: <167097752151.1189953.3189708700022130101.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Make sure that backtraces are attributed to the expected test, and add more
backtrace detection to other tests.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/common               |    1 +
 test/cxl-create-region.sh |    2 ++
 test/cxl-labels.sh        |    2 ++
 3 files changed, 5 insertions(+)

diff --git a/test/common b/test/common
index 44cc352f6009..248ca3eaa485 100644
--- a/test/common
+++ b/test/common
@@ -138,6 +138,7 @@ json2var()
 check_dmesg()
 {
 	# validate no WARN or lockdep report during the run
+	sleep 1
 	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
 	grep -q "Call Trace" <<< $log && err $1
 	true
diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index 02161661b28f..658b9b8ff58a 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -149,4 +149,6 @@ for mem in ${mems[@]}; do
 	create_subregions "$mem"
 done
 
+check_dmesg "$LINENO"
+
 modprobe -r cxl_test
diff --git a/test/cxl-labels.sh b/test/cxl-labels.sh
index b38ca2f4693f..36b0341c8039 100644
--- a/test/cxl-labels.sh
+++ b/test/cxl-labels.sh
@@ -66,4 +66,6 @@ for nmem in ${nmems[@]}; do
 	test_label_ops "$nmem"
 done
 
+check_dmesg "$LINENO"
+
 modprobe -r cxl_test

