Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681836AA8
	for <patches@lists.linux.dev>; Fri, 21 Oct 2022 20:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666384553; x=1697920553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0oi6a1r6EcPszIqWC+40MwHJFgZnvwStu7e0P4Y7NfE=;
  b=gs0QGDmQnvwERxrSiVtMY8eHISDzQ+LOAIDLatAwe6yAEFuRH9eyAo9m
   LRXnfzo0jLyQARIj/ZN8wim06B2DXYXDKSgaLrOqqbqY8fVxPHmwFQsZm
   ZdW0MVpc60QRUrMaJ3ZfKnxSmO6HFEaDenNYc7+OvYRvRjQld6dKuwGhq
   hEo4yMOTwv1iO7Gp+xu+AHYr2bh7ZeSpxFTAvVrLCqJoa+STKqiFUYOoj
   f4pXodr61Ml/noST25ZTmRuTFEgiocbrRI2vg3mXm/Np1XjSOiw6Ce5v5
   dSll7gxBDvYmzbVgOhJmC/d10rdCyHdHDW0vAzPJRB9uHbrGgRiq33wuF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="333675893"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="333675893"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:34 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="735701004"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="735701004"
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
Subject: [PATCH 04/14] platform/x86/intel/ifs: Remove image loading during init
Date: Fri, 21 Oct 2022 13:34:03 -0700
Message-Id: <20221021203413.1220137-5-jithu.joseph@intel.com>
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

Existing implementation loads IFS test image during the driver
init flow.

Dropping test image loading from the init path improves
module load time.

Prior to starting IFS tests, the user has to load one of
the IFS test images by writing to the current_batch sysfs file.

Removing IFS test image  loading during init also allows us to
make ifs_sem static as it is used only within sysfs.c.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h   | 2 --
 drivers/platform/x86/intel/ifs/core.c  | 6 +-----
 drivers/platform/x86/intel/ifs/sysfs.c | 2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 782bcc039ddb..be37512535f2 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -229,6 +229,4 @@ int ifs_load_firmware(struct device *dev);
 int do_core_test(int cpu, struct device *dev);
 const struct attribute_group **ifs_get_groups(void);
 
-extern struct semaphore ifs_sem;
-
 #endif
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 27204e3d674d..5fb7f655c291 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -51,12 +51,8 @@ static int __init ifs_init(void)
 	ifs_device.misc.groups = ifs_get_groups();
 
 	if ((msrval & BIT(ifs_device.data.integrity_cap_bit)) &&
-	    !misc_register(&ifs_device.misc)) {
-		down(&ifs_sem);
-		ifs_load_firmware(ifs_device.misc.this_device);
-		up(&ifs_sem);
+	    !misc_register(&ifs_device.misc))
 		return 0;
-	}
 
 	return -ENODEV;
 }
diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
index 4af4e1bea98d..766cee651bd6 100644
--- a/drivers/platform/x86/intel/ifs/sysfs.c
+++ b/drivers/platform/x86/intel/ifs/sysfs.c
@@ -13,7 +13,7 @@
  * Protects against simultaneous tests on multiple cores, or
  * reloading can file while a test is in progress
  */
-DEFINE_SEMAPHORE(ifs_sem);
+static DEFINE_SEMAPHORE(ifs_sem);
 
 /*
  * The sysfs interface to check additional details of last test
-- 
2.25.1

