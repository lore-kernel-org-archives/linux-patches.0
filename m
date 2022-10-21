Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141C67B
	for <patches@lists.linux.dev>; Fri, 21 Oct 2022 20:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666384553; x=1697920553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DYEJTVshqR8fRd94F4Nb8k1S6Du/B4ywdW9auP0/9mk=;
  b=LJ9a5zMKyKP1+knqMdxKEvXPWzgwN5LucEXuUP1N+HcZEHxHoQfTSC3f
   WL1OTIJtm2TCSfzlPGpXvt1+gmz+AH7cP3V2DekELg8Bd3EMAPx7rp+fO
   pHqR+j31m/UUP7nFSrs433yn7dQ7K2SQQXPg8qrP0tAMfH9VnSkQIPvIL
   N+9EabVrkv0Z67rcZdnPxZ+GYVakjTW5EHW31MWEryQCXF80XI5z6Tnkj
   ebIphlfhzr4SPoeWunKixtAjnxz1Ja8vKLDlcgB8z2YsHQwgvt3iaBQ7g
   dC5ONw+Kp99UAl9DuBnzxBbuC2/pefFa8UQitsZOFaySB3iEumcivlPHw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="333675889"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="333675889"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:34 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="735701001"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="735701001"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:34 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com
Subject: [PATCH 03/14] platform/x86/intel/ifs: return a more appropriate Error code
Date: Fri, 21 Oct 2022 13:34:02 -0700
Message-Id: <20221021203413.1220137-4-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021203413.1220137-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scan_chunks_sanity_check() was returning -ENOMEM if it encounters
an error while copying IFS test image from memory to Secure Memory.

Return -EIO in this scenario, as it is more appropriate.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index ebaa1d6a2b18..b88db0765311 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -157,8 +157,10 @@ static int scan_chunks_sanity_check(struct device *dev)
 		INIT_WORK(&local_work.w, copy_hashes_authenticate_chunks);
 		schedule_work_on(cpu, &local_work.w);
 		wait_for_completion(&ifs_done);
-		if (ifsd->loading_error)
+		if (ifsd->loading_error) {
+			ret = -EIO;
 			goto out;
+		}
 		package_authenticated[curr_pkg] = 1;
 	}
 	ret = 0;
-- 
2.25.1

