Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C867E
	for <patches@lists.linux.dev>; Tue, 26 Apr 2022 18:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650998872; x=1682534872;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0hMC9FCc92/UZsP/d4xjIGjECImVMpXb8G2MfDigzBQ=;
  b=Vl1ZG90nAtJIoxeff2FXks66ibcTKw6TSHnZ9zv1QgXB54JOT/mlnVMZ
   X3fgYhCfM1GfQKhdMUA8Q3qmH1RZfQZO/8CLxez1+G/6mxYWS0ne8qY0d
   exJGnDqI9DJPwB+3n6vujV1PJn6ifsOdosaP8tBTM+qhhd9zBsumEiCnj
   OeLiYJJc/6ESYRPd2hEV9OiMh6h41P0G2hEPRdMeJjfCkecJ6daNhhS8/
   Oo3yQkzjQeGFdgUgiqVZVBQn33mAv2smvEB4Gv5Tacq/Z6LFF6KSC31/S
   6oJHoQOtdFjgrmG45D9feupEqnB0Rm07qcmymWC1aVWtw6039J/TJUUhM
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="253064936"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="253064936"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 11:47:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="580091108"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 11:47:52 -0700
Date: Tue, 26 Apr 2022 11:47:50 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
	andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
	ashok.raj@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: Re: [PATCH v4 04/10] platform/x86/intel/ifs: Read IFS firmware image
Message-ID: <Ymg+VnkW544a4La2@agluck-desk3.sc.intel.com>
References: <20220419163859.2228874-1-tony.luck@intel.com>
 <20220422200219.2843823-1-tony.luck@intel.com>
 <20220422200219.2843823-5-tony.luck@intel.com>
 <YmfNVG0qLahv7TzL@kroah.com>
 <YmgZ9d54sjKllh6U@agluck-desk3.sc.intel.com>
 <YmgfnhhCQHWPHxAw@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmgfnhhCQHWPHxAw@kroah.com>

On Tue, Apr 26, 2022 at 06:36:46PM +0200, Greg KH wrote:
> On Tue, Apr 26, 2022 at 09:12:37AM -0700, Luck, Tony wrote:
> > If it really is too much now, I can rip it out from this submission
> > and add it back when the second test is ready for public view.
> 
> Please do, thanks.

Hmmm ... maybe there were more bits than I thought.

 1 file changed, 19 insertions(+), 36 deletions(-)

core.c is now down to just 80 lines ... so that was a significant
fraction of the file.

Net change below (I'll thread it back into the patch series before reposting).

Any other comments on the series?

-Tony



diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 317ed3225307..489b77645b5e 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -9,10 +9,6 @@
 
 #include "ifs.h"
 
-enum test_types {
-	IFS_SAF,
-};
-
 #define X86_MATCH(model)				\
 	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,	\
 		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, NULL)
@@ -23,27 +19,21 @@ static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
 };
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
 
-static struct ifs_device ifs_devices[] = {
-	[IFS_SAF] = {
-		.data = {
-			.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
-		},
-		.misc = {
-			.name = "intel_ifs_0",
-			.nodename = "intel_ifs/0",
-			.minor = MISC_DYNAMIC_MINOR,
-		},
+static struct ifs_device ifs_device = {
+	.data = {
+		.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
+	},
+	.misc = {
+		.name = "intel_ifs_0",
+		.nodename = "intel_ifs/0",
+		.minor = MISC_DYNAMIC_MINOR,
 	},
 };
 
-#define IFS_NUMTESTS ARRAY_SIZE(ifs_devices)
-
 static int __init ifs_init(void)
 {
 	const struct x86_cpu_id *m;
-	int ndevices = 0;
 	u64 msrval;
-	int i;
 
 	m = x86_match_cpu(ifs_cpu_ids);
 	if (!m)
@@ -61,32 +51,25 @@ static int __init ifs_init(void)
 	if (ifs_setup_wq())
 		return -ENOMEM;
 
-	for (i = 0; i < IFS_NUMTESTS; i++) {
-		if (!(msrval & BIT(ifs_devices[i].data.integrity_cap_bit)))
-			continue;
-
-		ifs_devices[i].misc.groups = ifs_get_groups();
-		if (!misc_register(&ifs_devices[i].misc)) {
-			ndevices++;
-			down(&ifs_sem);
-			ifs_load_firmware(ifs_devices[i].misc.this_device);
-			up(&ifs_sem);
-		}
-	}
+	ifs_device.misc.groups = ifs_get_groups();
 
-	if (!ndevices)
+	if ((msrval & BIT(ifs_device.data.integrity_cap_bit)) &&
+	    !misc_register(&ifs_device.misc)) {
+		down(&ifs_sem);
+		ifs_load_firmware(ifs_device.misc.this_device);
+		up(&ifs_sem);
+	} else {
 		ifs_destroy_wq();
+		return -ENODEV;
+	}
 
-	return ndevices ? 0 : -ENODEV;
+	return 0;
 }
 
 static void __exit ifs_exit(void)
 {
-	int i;
 
-	for (i = 0; i < IFS_NUMTESTS; i++)
-		if (ifs_devices[i].misc.this_device)
-			misc_deregister(&ifs_devices[i].misc);
+	misc_deregister(&ifs_device.misc);
 	ifs_destroy_wq();
 }
 
-- 
2.35.1

