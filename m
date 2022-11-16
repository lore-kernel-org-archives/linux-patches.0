Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB3315B0
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 17:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668619585; x=1700155585;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=o1iIaX+edOL6x2mU3GukuAAteHiHRtQuPyP7zogbaFQ=;
  b=JcFI1skjUNelL5aRuSOpedI+oDGKUyugmOdHJzoEAcsClHuOjMltocK5
   4K7/SNhus2nrzyJMNfqsu1D35hH8q7AkrXAzAN5v3Mgf7Aou6I4tWM6C3
   nH54aPYfhPg5ePU+i/CaY+UjopV+9tl73PzO9mnqBbeiBA/SX8GVuQqto
   p11M23xtzjay043ONfSBfD7OsMuOkV1eXA2XRpGszhn2r41key0BdMPG8
   v0svYX8vIzkcVejNf270mPgJHmz2vDjB8bz8pDU/58SiOi9614xVgJxPr
   SUIovscvRFr5jzwkWsTYm0RMCDNYpbizc0n2zWzgFWLf8aGRRkkBwcDcP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="339427118"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="339427118"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 09:26:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="617253213"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="617253213"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 09:26:21 -0800
Date: Wed, 16 Nov 2022 09:26:19 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jithu Joseph <jithu.joseph@intel.com>, hdegoede@redhat.com,
	markgross@kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	gregkh@linuxfoundation.org, ashok.raj@intel.com,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev, ravi.v.shankar@intel.com,
	thiago.macieira@intel.com, athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: Re: [PATCH v2 09/14] platform/x86/intel/ifs: Use generic microcode
 headers and functions
Message-ID: <Y3UdO8/oaEnlEk7s@agluck-desk3.sc.intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-10-jithu.joseph@intel.com>
 <Y253FKtLnmV3r7Kj@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y253FKtLnmV3r7Kj@zn.tnic>

On Fri, Nov 11, 2022 at 05:23:48PM +0100, Borislav Petkov wrote:
> On Mon, Nov 07, 2022 at 02:53:18PM -0800, Jithu Joseph wrote:
> >  static int scan_chunks_sanity_check(struct device *dev)
> >  {
> > -	int metadata_size, curr_pkg, cpu, ret = -ENOMEM;
> >  	struct ifs_data *ifsd = ifs_get_data(dev);
> > +	int curr_pkg, cpu, ret = -ENOMEM;
> >  	bool *package_authenticated;
> >  	struct ifs_work local_work;
> > -	char *test_ptr;
> >  
> >  	package_authenticated = kcalloc(topology_max_packages(), sizeof(bool), GFP_KERNEL);
> >  	if (!package_authenticated)
> >  		return ret;
> 
> Bah, how big is that thing so that you can't simply do a bitfield on the
> stack here instead of kcalloc-ing?

Kernel is built with gcc options that prevent a variable sized local
array. So:

	DECLARE_BITMAP(auth, topology_max_packages());

grumbles:

drivers/platform/x86/intel/ifs/load.c:196:2: warning: ISO C90 forbids variable length array ‘ifs_auth2’ [-Wvla]

We could pick a likely big enough static number:

#define MAX_SUPPORTED_PACKAGES	128

	DECLARE_BITMAP(auth, MAX_SUPPORTED_PACKAGES);

and error out of this code if SGI or someone build a monster machine:

	if (topology_max_packages() > MAX_SUPPORTED_PACKAGES) {
		pr_error_once("IFS driver needs update to support this machine\n");
		return -E2BIG;
	}

That avoids the kcalloc() and making sure to kfree() in all error paths.

But seems a bit hacky.  Other ideas?

-Tony
