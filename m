Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3314C8F62
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 20:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696020320; x=1727556320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o0NPgjek+yICKBayQpefXYkdLE9/OZrQjlimuyKug84=;
  b=ZBS6wN/KuOGcfjpwG0urdHu/3CBnl20xCsWJy/ZZCivdEgiWlIUaIF9J
   k9SBrNlqtCZlAT7Jw2IcJ9501J63kxycCeMHq9Mje+X6ThwJ+Vnrxb/6Z
   FXrFEECKTwt5cFTyFhWNzUWXW5nM+a8K5SFh06sJhuZ/J68zB0fRbXHOQ
   O0YXmF1r1HO7gynw7pjOE+yFuwMpk0MLj+34NVPfMh/cmtJYSPHsp2RTk
   4AKaAvJ4CnOiH9KDnCScSHDZGA2sncA58fWriYW4Hgo7zoyUzH9bf636H
   61ZzCkPVKAv++g68xQD/VT4uSEnhSN2g/cpmQJ65NFXaSQkr0hx0LJAjH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="468654465"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="468654465"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 13:28:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="893539248"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="893539248"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 13:27:30 -0700
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
Date: Fri, 29 Sep 2023 13:24:33 -0700
Message-Id: <20230929202436.2850388-7-jithu.joseph@intel.com>
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
index da54fd060878..6f8abb4729e9 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -291,6 +291,13 @@ static int validate_ifs_metadata(struct device *dev)
 		return ret;
 	}
 
+	if (ifs_meta->chunks_per_stride &&
+	    (ifs_meta->starting_chunk % ifs_meta->chunks_per_stride != 0)) {
+		dev_warn(dev, "Starting chunk num %d not a multiple of chunks_per_stride %d\n",
+			 ifs_meta->starting_chunk, ifs_meta->chunks_per_stride);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.25.1

