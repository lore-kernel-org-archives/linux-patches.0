Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B9663C4
	for <patches@lists.linux.dev>; Sat, 12 Nov 2022 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668277296; x=1699813296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wwkqEQzh4yC5GN7xwtnXjhYKHelJqgQDk7z/M2r8jEI=;
  b=D4eBrwoy1++mgtQ2w8LigtJ6W0lAEZ/Tvdp9kTuDbGxkerE4/UIr9irq
   L+Kdz7nm1jB+y5Q9ckntAXiOOy18ah3sc4SgTnIDShO5jOfgFsFfLXXiS
   dcr7wE/UgHxp13ib+++0OzLR7rIoHWyxEcmQQC7We1K1iUyxDOl17FPgh
   AsyQbpGpdcr2lMJYtpsOv+CBT23UBPIbq5EDszyOPujDVPv/2edOID3WD
   dY5y+RuY4TFbK7G5u77VBQOqFkniLf5M4agQbPQ5Y95abOiHyZnIHtOT1
   OxT0noZ0h/qI1IzHvQqhhPP7XHj9jnhygQa/HLz98Fa8zWXBiXS1w7A33
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10529"; a="295108322"
X-IronPort-AV: E=Sophos;i="5.96,160,1665471600"; 
   d="scan'208";a="295108322"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2022 10:21:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10529"; a="588850532"
X-IronPort-AV: E=Sophos;i="5.96,160,1665471600"; 
   d="scan'208";a="588850532"
Received: from hwfrezgh-mobl1.amr.corp.intel.com (HELO tjmaciei-mobl5.localnet) ([10.209.101.182])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2022 10:21:35 -0800
From: Thiago Macieira <thiago.macieira@intel.com>
To: Jithu Joseph <jithu.joseph@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, gregkh@linuxfoundation.org, ashok.raj@intel.com, tony.luck@intel.com, linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org, patches@lists.linux.dev, ravi.v.shankar@intel.com, athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
Subject: Re: [PATCH v2 12/14] platform/x86/intel/ifs: Add current_batch sysfs entry
Date: Sat, 12 Nov 2022 10:21:35 -0800
Message-ID: <208647816.nNe6ejF2h0@tjmaciei-mobl5>
Organization: Intel Corporation
In-Reply-To: <Y2/JNAmSoYlLKq3A@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com> <20221107225323.2733518-13-jithu.joseph@intel.com> <Y2/JNAmSoYlLKq3A@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Saturday, 12 November 2022 08:26:28 PST Borislav Petkov wrote:
> > Introduce "current_batch" file which accepts a number. Writing a
> > number to the current_batch file would load the test image file by name
> > ff-mm-ss-<xy>.scan, where <xy> is the number written to the
> > "current_batch" file in hex. Range check of the input is done to verify
> > it not greater than 0xff.
> 
> Dunno - sounds silly to me. Means one needs to go and look up which
> files are there and echo those batch numbers into sysfs and so on.

Not exactly. That's what this file is there for. It allows the algorithm to 
read the current batch file, add 1, then echo back. If the load succeeds, the 
the batch exists; if not, then the algorithm should simply go back to 0.

That's what we're implementing here:
https://github.com/opendcdiag/opendcdiag/pull/163

> What I would do is make it real trivial for the user so that latter can
> simply do:
> 
> for f in $(ls /lib/firmware/intel/ifs_0/*.scan);
> do
> 	echo $f > /sys/devices/virtual/misc/intel_ifs_0/test_file
> done
>
> and simply supply the full filename.

Unfortunately, there are other limitations that make such a simple algorithm 
not possible in the first place.

First, there's the question of the ability to see into /lib/firmware. I'm not a 
kernel dev but I'm told that request_firmware() only operates on the root 
container's filesystem view. We're expecting that the application may get 
deployed as a container (with full privileges so it can write to /sys, sure), 
so it won't be able to see the host system's /lib to know what files are 
available. It could "guess" at the file names, based on the current processor's 
family/model/stepping and a natural number, but that's sub-optimal.

Unless the driver were allowed to load any file named by the application, from 
its own view of the filesystem, permitting the firmware files being distributed 
inside the container.

Second, for electrical reasons, we expect that certain processor generations 
will need a timeout between tests before testing can be done again on a given 
core, whether the same batch or the next one. This time out can be in the 
order of many minutes, which is longer than any hyperscaler is willing to 
allocate for a system self-test hogging a core or the whole system, just 
waiting. For example, let's say that the timeout is 15 minutes and there are 4 
batches: this means the whole testing procedure takes one hour, even though 
the actual downtime for each core was less than 1 second. This is lost 
revenue.

Instead, they wish the next available maintenance window to simply resume 
testing at the point where the last one stopped. These windows need not be 
scheduled; they can also be opportunistic, when the orchestrator determines 
the machine or a subset of one is going to be idle. That's what the algorithm 
in the pull request above implements: if the current_batch's result was 
"untested", it is attempted again, otherwise it tries the next one, rolling 
back to 0 if the loading failed. This removes the need to know anything about 
the timeout on the current processor or even whether there is one, or how many 
batches there are.242

> So the kernel would simply open it, sanity-check it, if it passes, it
> would run it - otherwise it would ignore it.
> 
> A usability win-win.

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Cloud Software Architect - Intel DCAI Cloud Engineering



