Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D5A15C90
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 22:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861687; x=1699397687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dcr0ozJ6OYs4trai4as92Ss4tTrZMrxeoFkgWXi5vd8=;
  b=cgV7K0avQKEpx5AgP1UkDr6NPJvIItSN/r7t0TFPMlRAbD3lSujettqo
   M7IEB4hm8B2n3FpE4ZY85oQJ/qz5pnkmkNLB7IpCeaxaKZ1864wO96Nkv
   ZOwJZ+owPwdZfXmuWSBYs8ZP3mgKMa8HLPXRN0rlg3RrJ/YzbvXC8D6dj
   ogBfUGhNWNrWO9L+YNvLU8q+7awVVMnXAGodRKt0QyTdlrecIyikLgB45
   V0yT7JancqI3xHgJ6jR6xQGxBxpUZM26zVk4EIcnoalN9v82Vg2hxhbbJ
   9G0vonOh5kc4i2Ja26EdKj4i7H8h93O3QxPj4QwPdcXrrCNKa6SpRtKpE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311697394"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311697394"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811012960"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811012960"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:45 -0800
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
Subject: [PATCH v2 03/14] platform/x86/intel/ifs: Remove image loading during init
Date: Mon,  7 Nov 2022 14:53:12 -0800
Message-Id: <20221107225323.2733518-4-jithu.joseph@intel.com>
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

IFS test image is unnecessarily loaded during driver initialization.
Drop image loading during ifs_init() and improve module load time.
With this change, user has to load one when starting the tests.

As a consequence, make ifs_sem static as it is only used within sysfs.c

Reviewed-by: Tony Luck <tony.luck@intel.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h   | 2 --
 drivers/platform/x86/intel/ifs/core.c  | 6 +-----
 drivers/platform/x86/intel/ifs/sysfs.c | 2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 73c8e91cf144..3ff1d9aaeaa9 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -229,6 +229,4 @@ void ifs_load_firmware(struct device *dev);
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
index 37d8380d6fa8..65dd6fea5342 100644
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

