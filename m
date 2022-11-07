Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D4A15C99
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 22:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861692; x=1699397692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w7zyU0EMZtiBlCMi0pWV2TZ8XEkOY6y3ce2a9bhJ6dI=;
  b=OrFZ+K+PpqlmvjbesPyPu1+ncvsjglVzo2WbUKK4hPFN/yB2MBtuiIXw
   HwnNkl857kugwNgEhVL4dxuHXekQYYG5lhxttXqidqfOAx3UQMPW6F0PO
   0uhd31N0pNxE/l73c7fF6rmT9khrRAqgUmZiJW7EBeWRrSgYKbHB7Eq83
   hf6mNCFl+EcODvYDf9lgzsKQGungvpMPvUnYWghqf7/SVAl4yQRCUedL9
   DAdDWxlroCGv3NNPlEAGzTBEWanZeHzX03NnT7zDlRocqyhA5Z7oi1cq8
   1UkubRq9V4Uw6MbN1gEBISYV/Sd6IGD4WUU3zdXNSyA46/ZFYWZ98oqBE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311697426"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311697426"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811012991"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811012991"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:48 -0800
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
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH v2 11/14] platform/x86/intel/ifs: Remove reload sysfs entry
Date: Mon,  7 Nov 2022 14:53:20 -0800
Message-Id: <20221107225323.2733518-12-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107225323.2733518-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reload sysfs entry will be replaced by current_batch, drop it.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/sysfs.c | 29 --------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
index 65dd6fea5342..e077910c5d28 100644
--- a/drivers/platform/x86/intel/ifs/sysfs.c
+++ b/drivers/platform/x86/intel/ifs/sysfs.c
@@ -87,34 +87,6 @@ static ssize_t run_test_store(struct device *dev,
 
 static DEVICE_ATTR_WO(run_test);
 
-/*
- * Reload the IFS image. When user wants to install new IFS image
- */
-static ssize_t reload_store(struct device *dev,
-			    struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	struct ifs_data *ifsd = ifs_get_data(dev);
-	bool res;
-
-
-	if (kstrtobool(buf, &res))
-		return -EINVAL;
-	if (!res)
-		return count;
-
-	if (down_interruptible(&ifs_sem))
-		return -EINTR;
-
-	ifs_load_firmware(dev);
-
-	up(&ifs_sem);
-
-	return ifsd->loaded ? count : -ENODEV;
-}
-
-static DEVICE_ATTR_WO(reload);
-
 /*
  * Display currently loaded IFS image version.
  */
@@ -136,7 +108,6 @@ static struct attribute *plat_ifs_attrs[] = {
 	&dev_attr_details.attr,
 	&dev_attr_status.attr,
 	&dev_attr_run_test.attr,
-	&dev_attr_reload.attr,
 	&dev_attr_image_version.attr,
 	NULL
 };
-- 
2.25.1

