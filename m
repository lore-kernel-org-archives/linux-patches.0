Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9B6185B
	for <patches@lists.linux.dev>; Wed, 20 Apr 2022 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650469715; x=1682005715;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/aT/uybwZGUBqHJAa/El+PMS98PqvKBE4Ru4gZtuJEU=;
  b=LaFpz1nmgTapOvNJFTAHtH0+IXJsG2X1zIN0KYh5U4jN67lYCGD/FtoZ
   gEQD+BZWAorR0Yf9lNSkIY2Zc4AMSx/P5molXzaZ7CVHT1K8URWeYUf0f
   w+Tl3YkxOvDyR0FGy1CDMraFXElLP+jFWFF5VtWBnX6AkU5gfaZRE28ZF
   uGoaEvVj2luZJAU1/GRS/mVJ3aNWN2ygUBWoy5Xr631eELMcgTw5/1BQY
   OsHC5/Al5xIWjcX9Bl7z0SnMYfaxSpdbAy4bm/y4bDppC7aL+cLkwi4Py
   IwDeMzWhWTVuvm9kHE315IFWWaDqyVEzmbcSLVH6+RNvO3YtExIF01h4g
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="263824934"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="263824934"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 08:27:55 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="647705664"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 08:27:54 -0700
Date: Wed, 20 Apr 2022 08:27:53 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Doc Mailing List <linux-doc@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	Ravi V Shankar <ravi.v.shankar@intel.com>
Subject: Re: [PATCH v3 03/11] platform/x86/intel/ifs: Create device for Intel
 IFS (In Field Scan)
Message-ID: <YmAmebezoc8m6n2E@agluck-desk3.sc.intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220419163859.2228874-1-tony.luck@intel.com>
 <20220419163859.2228874-4-tony.luck@intel.com>
 <Yl7npfrVTPFEIivC@kroah.com>
 <CAPcyv4jzscs3Dg4QN0+XHRYdekBeqy1=dRX-mWCj1OXo8jS2vQ@mail.gmail.com>
 <Yl+66oyQhI0AkEDC@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl+66oyQhI0AkEDC@kroah.com>

On Wed, Apr 20, 2022 at 09:48:58AM +0200, Greg KH wrote:
> Don't write code today for stuff you do not have right now, you all know
> that.  We can always revisit it in the future.

Direction check on the virtual device option. Is this what
you are asking for in "core.c"?

The second test type is happening internally right away ... so I
put in some example code of how it can be added. Upstream submission
will just have the one test that exists today.

Static definition of:

 static struct ifs_data ifs_data[IFS_NUMTESTS];

keeps the code simpler (no need to have code to
cleanup if dynamic allocation of this small structure
fails). But if you feel strongly that all static allocation
is bad, then I can kzallloc() per enumerated test type.

With this change it is no longer a platform driver. So maybe
doesn't belong in drivers/platform/x86/intel/ifs/*

Any thoughts on where I should move it to?

-Tony

---- core.c ---

// SPDX-License-Identifier: GPL-2.0-only
/* Copyright(c) 2022 Intel Corporation. */

#include <linux/module.h>
#include <linux/device.h>
#include <linux/kdev_t.h>
#include <linux/semaphore.h>

#include <asm/cpu_device_id.h>

#include "ifs.h"

enum test_types {
	IFS_SAF,
	IFS_ANOTHER,
	IFS_NUMTESTS
};

static struct class *ifs_class;
static struct ifs_data ifs_data[IFS_NUMTESTS];

#define MSR_IA32_CORE_CAPS_INTEGRITY_BIT	2
#define MSR_IA32_CORE_CAPS_INTEGRITY		BIT(MSR_IA32_CORE_CAPS_INTEGRITY_BIT)

#define X86_MATCH(model)				\
	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,	\
		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, NULL)

static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
	X86_MATCH(SAPPHIRERAPIDS_X),
	{}
};
MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);

static int ifs_device_unregister(struct device *dev, void *data)
{
	device_unregister(dev);

	return 0;
}

static int __init ifs_init(void)
{
	const struct x86_cpu_id *m;
	u64 ia32_core_caps;
	struct device *dev;
	int ndevices = 0;
	int ret = 0;

	m = x86_match_cpu(ifs_cpu_ids);
	if (!m)
		return -ENODEV;

	if (rdmsrl_safe(MSR_IA32_CORE_CAPS, &ia32_core_caps))
		return -ENODEV;

	ifs_class = class_create(THIS_MODULE, "intel_ifs");
	if (IS_ERR(ifs_class))
		return PTR_ERR(ifs_class);

	ret = ifs_setup_wq();
	if (ret)
		goto class_cleanup;

	if (ia32_core_caps & MSR_IA32_CORE_CAPS_INTEGRITY) {
		dev = device_create_with_groups(ifs_class, NULL, MKDEV(0, 0), &ifs_data[IFS_SAF],
					        plat_ifs_groups, "ifs%d", IFS_SAF);
		if (dev) {
			ndevices++;

			down(&ifs_sem);
			ifs_data[IFS_SAF].loaded = !ifs_load_firmware(dev);
			up(&ifs_sem);
		}
	}

	if (1) { // placeholder to test 2nd test
		dev = device_create_with_groups(ifs_class, NULL, MKDEV(0, 0), &ifs_data[IFS_ANOTHER],
					        plat_ifs_groups, "ifs%d", IFS_ANOTHER);
		if (dev)
			ndevices++;
	}

	if (ndevices)
		goto done;

	ret = -ENODEV;

	class_for_each_device(ifs_class, NULL, NULL, ifs_device_unregister);

class_cleanup:
	class_destroy(ifs_class);
done:
	return ret;
}

static void __exit ifs_exit(void)
{
	class_for_each_device(ifs_class, NULL, NULL, ifs_device_unregister);
	class_destroy(ifs_class);
	ifs_destroy_wq();
}

module_init(ifs_init);
module_exit(ifs_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Intel In Field Scan (IFS) driver");
