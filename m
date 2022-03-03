Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADE336B
	for <patches@lists.linux.dev>; Thu,  3 Mar 2022 19:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646337551; x=1677873551;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Pwhtk1GrrqE/4VynDFryxgHiiPKn9d6coiqO1HnGW5Q=;
  b=OmGVZFYFcXO+tJ6/3MaWUS28fo0lAi+Y9BaYXdmDcfybzKZaVwpXd5Ym
   z6e04e7ASfcU5mAeR2a4b753gnFfnCBn76eG9C6WSjDI8oLgoWzb6vW9m
   LeEP+M1EB4JGabyifndBSxAnNrsWz2bHjq9d6VManZfHe2XjeEm4Fvkll
   +pTEK3/dGYSUuKGtidLM4vbu8ltXCen+8rSaUKMT4zXZ9me2vQgSWqIw0
   45SoWsOgl10GqTiFb1m0DRvQnXQZol2xWirDP6fAPxr8f9kHkTfv35d8A
   rLk3OfWXynFq7L/Z7EpcJJcN+cS5HMtmrYHPObjeyTvi/7l0J7L0hs+eP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="252621370"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="252621370"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 11:59:10 -0800
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="630922010"
Received: from agluck-desk3.sc.intel.com ([172.25.222.60])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 11:59:10 -0800
Date: Thu, 3 Mar 2022 11:59:09 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC 07/10] platform/x86/intel/ifs: Create kthreads for online
 cpus for scan test
Message-ID: <YiEeDfuQyqperN9x@agluck-desk3.sc.intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-8-jithu.joseph@intel.com>
 <09b5b05018a8600ca8fab896790ab16827c80e4e.camel@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09b5b05018a8600ca8fab896790ab16827c80e4e.camel@intel.com>

On Wed, Mar 02, 2022 at 08:17:32PM -0800, Williams, Dan J wrote:

> What is this requirement to try to synchronize CPU execution? Comments
> should explain the "why", the code usually explains the "what".

I need to put some more bits into the Documentation/x86/ifs.rst
because if I had explained the IFS feature better there, you wouldn't
have had to ask this (and some other questions).

IFS works on one CORE at a time. But with HT enabled there are two
logical CPUs that are on that core.

Entering IFS test mode is done by all HT threads writing to the
ACTIVATE_SCAN MSR "together". The microcode for that MSR will
make the first logical CPU to write wait for a while. User can
choose how many cycles to wait with some of the bits in the value
written to the MSR ... in this driver we hard coded 5 milli-seconds.
That seemed plenty to allow for the bottom half of interrupts, or
a perf NMI to knock the HT threads a little bit out of sync with
each other.

So the code flow when running a test is to wake the kthreads for
the logical CPUs that share the core. The threads may wake at
different times, so there is the software sync to get them close
enough.

Then comes the loop to execute the test ... it is a loop because
the core may not complete all "chunks" in one ACTIVATE_SCAN
MSR write ... if it doesn't, the loop restarts execution from
the chunk where IFS execution stopped.

Interrupts are only blocked during the ACTIVATE_SCAN to
increase the chances of completion. But preemption is
disabled for the whole loop so that the threads won't
get too far out of sync.

-Tony
