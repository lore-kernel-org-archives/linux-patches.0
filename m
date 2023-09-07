Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0862ED7
	for <patches@lists.linux.dev>; Thu,  7 Sep 2023 05:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694064545; x=1725600545;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+GKVNJ5i63FwLD00A6L49LahYAqMl5s1qC9HtyRI4M8=;
  b=bo6nV2ECWSCaTky1xU5C8OCLr03LtcboHSE+tWQJEE6/5lZCfuzq9n3g
   X72/A5HnyyEBwix8VA+9QgIz258Q5Ru7xuSPGvsUba0Wo/iPnzzocO6Bx
   mN/kgfvdokRrlkiY3xNBIALaYegQOe2jpOJq8Au46qAQ0g/L8hlOhQClP
   TB8GAIk55H2Lpv/w4hmcbVgBGleMCrHVJTrWJLkftg8jOW680y1azTk3S
   /qZjwkPC5NODUXA/WiCyLz/5dOxI6ahaOyHu44xHc1pWScX/+4x6hUaOF
   xFgDzTWW/AYMPJLy8uDEbSn6IZiBUNFOFCCKjcUYEVOROUYwsz4iMVtzT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="376166872"
X-IronPort-AV: E=Sophos;i="6.02,234,1688454000"; 
   d="scan'208";a="376166872"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 22:29:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="718547175"
X-IronPort-AV: E=Sophos;i="6.02,234,1688454000"; 
   d="scan'208";a="718547175"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 06 Sep 2023 22:29:02 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
	id C5ED9177; Thu,  7 Sep 2023 08:29:00 +0300 (EEST)
Date: Thu, 7 Sep 2023 08:29:00 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v2 3/3] platform/x86: intel_scu_ipc: Fail IPC send if
 still busy
Message-ID: <20230907052900.GG1599918@black.fi.intel.com>
References: <20230906180944.2197111-1-swboyd@chromium.org>
 <20230906180944.2197111-4-swboyd@chromium.org>
 <ZPjdZ3xNmBEBvNiS@smile.fi.intel.com>
 <CAE-0n53iGCL3q=CsDKZr28eMjx40miLNG6+-jf12JKMxuAKkKg@mail.gmail.com>
 <ZPjlIhDykHd44YTz@smile.fi.intel.com>
 <CAE-0n500OCS0nh_7v_FL1rtTccAJxKhoD8vuBE7AER1fwWihsQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE-0n500OCS0nh_7v_FL1rtTccAJxKhoD8vuBE7AER1fwWihsQ@mail.gmail.com>

On Wed, Sep 06, 2023 at 03:59:33PM -0500, Stephen Boyd wrote:
> Quoting Andy Shevchenko (2023-09-06 13:46:26)
> > On Wed, Sep 06, 2023 at 03:22:43PM -0500, Stephen Boyd wrote:
> > > Quoting Andy Shevchenko (2023-09-06 13:13:27)
> > > > On Wed, Sep 06, 2023 at 11:09:43AM -0700, Stephen Boyd wrote:
> >
> > ...
> >
> > > > > @@ -450,6 +468,12 @@ int intel_scu_ipc_dev_simple_command(struct intel_scu_ipc_dev *scu, int cmd,
> > > > >               return -ENODEV;
> > > > >       }
> > > >
> > > > >       scu = ipcdev;
> > > >
> > > > Side observation: Isn't this a bug? We should not override the supplied parameter.
> > >
> > > If it is a bug that would be great to know. I wanted to make an API that
> > > got the scu if it wasn't busy but then I ran across this code that
> > > replaced the scu with ipcdev.
> >
> > To me this seems like a bug, because in other similar code we don't do that.
> > And even reading this one, why do we have a parameter if it's always being
> > rewritten?
> 
> Yes. From what I can tell looking at commit f57fa18583f5 ("platform/x86:
> intel_scu_ipc: Introduce new SCU IPC API") it was an unintentional bug
> to leave that line there.

Indeed it is. Good catch Andy!
