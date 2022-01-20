Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D64B173
	for <patches@lists.linux.dev>; Thu, 20 Jan 2022 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642701719; x=1674237719;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TF7EhkH6yB6RnHB40fIMGf6Q1t1Vymj4PS+rdAdW8zU=;
  b=hwW72D+rUiuCiZt6ndQysizntTGp0VpilNKXblOMl9/+MWoHb3p3dBfX
   2ZwbtMDnRxhhr8sGYUoRpI4hLj7PM4hGd7GD1LvcUzirZnwlByIEbHK04
   LjYLwbEcMpOH29W7guy5V2M/PF8RkGdchrOhBM9+/Qsq/LmcQAYjFQL6I
   M32tDGiB/aumH8LzBS3hoSq90/d/fSTodM9USoh2aA3JMi64cux0r2sk+
   pWfmMTpP2S2uhdw0HnvBHFLuch5QdstnrclNn5HZE30W4qrYIBKkA0I4w
   eJwLECiXUi5B9kF6wL9r9a8qnWK5/hcAb7gfD3sZtBBCopMjVA4zIE05v
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="245371283"
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="245371283"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 10:01:52 -0800
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="672633592"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 10:01:52 -0800
Date: Thu, 20 Jan 2022 10:01:51 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, patches@lists.linux.dev
Subject: Re: [PATCH 5/5] x86/sysfs: Add PPIN in sysfs under cpu topology
Message-ID: <Yemjj26elXuOcegg@agluck-desk2.amr.corp.intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220107225442.1690165-6-tony.luck@intel.com>
 <YellN/3VCasDI3OD@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YellN/3VCasDI3OD@zn.tnic>

On Thu, Jan 20, 2022 at 02:35:51PM +0100, Borislav Petkov wrote:
> On Fri, Jan 07, 2022 at 02:54:42PM -0800, Tony Luck wrote:
> > +#define topology_ppin(cpu)			(cpu_data(cpu).ppin)
> 
> That looks unused. No need to add it.


It "looks" unused, But thanks to the obscurity of CPP macros using ## to
concatenate tokens it is needed.

This harmless looking line:

define_id_show_func(ppin, "%llx");

is transmogrified by this:

#define define_id_show_func(name, fmt)					\
static ssize_t name##_show(struct device *dev,				\
			   struct device_attribute *attr, char *buf)	\
{									\
	return sysfs_emit(buf, fmt "\n", topology_##name(dev->id));	\
                                         ^^^^^^^^^^^^^^^

                                         This becomes topology_ppin
}


Will fix the other stuff and rebase to latest so part 4 applies.

Thanks for the review.

-Tony
