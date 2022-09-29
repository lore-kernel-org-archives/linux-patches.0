Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C7E53A6;
	Thu, 29 Sep 2022 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664470005; x=1696006005;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fBbdNADC85MnM4nWzTQ1ZPxOGkqpvuHTPqhCZMdkZkw=;
  b=Luq9ASvVx8eR+6UE6ljIYxIh4u21KOQCNuZXSKxTVe2sXb3iwEhY2LtC
   UbS2+D9wsVy0CXMIYot/ux61loYsBPfA0+BAXaa2FSdm4A+qLFHEJHoml
   Cfq3UPjvdoAHw+bnjV5T9dTyVcmiXxxJkC0PoSUkZr/l4Ltct60+RM13a
   mr916QKv0F3eI9XH9K72ZZ6Me6DLHxEThwI0C/wsco0I3ouBjCFG5RX6r
   eNJ1w4jhRgzyG4Njx/bXFg5Jl8sC8o1stP8loIPWlp6bZml0BFBdW7WIp
   CdsL3j4EibzpBcT42NtZ/3FVk7/V3Qd24HGV48d6rvuQolDUFiEs+sdPj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="289118440"
X-IronPort-AV: E=Sophos;i="5.93,355,1654585200"; 
   d="scan'208";a="289118440"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 09:46:40 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="655622271"
X-IronPort-AV: E=Sophos;i="5.93,355,1654585200"; 
   d="scan'208";a="655622271"
Received: from ashyti-mobl2.igk.intel.com (HELO intel.com) ([172.28.182.72])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 09:46:36 -0700
Date: Thu, 29 Sep 2022 18:46:34 +0200
From: Andi Shyti <andi.shyti@linux.intel.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, llvm@lists.linux.dev,
	Tom Rix <trix@redhat.com>, intel-gfx@lists.freedesktop.org,
	Nick Desaulniers <ndesaulniers@google.com>, patches@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Fix CFI violations in gt_sysfs
Message-ID: <YzXL6v3VAVUMiYO0@ashyti-mobl2.lan>
References: <20220922195127.2607496-1-nathan@kernel.org>
 <202209232143.172BCCDC4@keescook>
 <Yy/bglnYjnFfjDDI@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yy/bglnYjnFfjDDI@dev-arch.thelio-3990X>

Hi Nathan,

thanks for this refactoring... looks good even though i would
have split it in more patches as this is doing quite many things.

But I will not be stubborn, I understand that it's not trivial to
have things split. I will give my r-b for now but I will check it
again before applying it as it's very easy to get tangled-up in
between all those defines:

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

For now I'm quite surprised to see how easily our CI gives green
lights :-P

On Sat, Sep 24, 2022 at 09:39:30PM -0700, Nathan Chancellor wrote:
> On Fri, Sep 23, 2022 at 09:57:47PM -0700, Kees Cook wrote:
> > On Thu, Sep 22, 2022 at 12:51:27PM -0700, Nathan Chancellor wrote:
> > > [...]
> > > To make everything work properly, adjust certain functions to match the
> > > type of the ->show() and ->store() members in 'struct kobj_attribute'.
> > > Add a macro to generate functions for that can be called via both
> > > dev_attr_{show,store}() or kobj_attr_{show,store}() so that they can be
> > > called through both kobject locations without violating kCFI and adjust
> > > the attribute groups to account for this.
> > 
> > This was quite a roller coaster! I think the solution looks good, even
> > if I'm suspicious of the original design that has the same stuff
> > available twice in different places. (I have a dim memory of rdma
> > needing a refactoring like this too?)
> 
> Right, I noticed this comment in intel_gt_sysfs_register() once I fully
> saw what was going on:
> 
> 	/*
> 	 * We need to make things right with the
> 	 * ABI compatibility. The files were originally
> 	 * generated under the parent directory.
> 	 *
> 	 * We generate the files only for gt 0
> 	 * to avoid duplicates.
> 	 */
> 
> Makes it seem like there will be userspace breakage if these files do
> not exist? I figured this was the cleanest solution within those
> parameters.

i915 went multi-gt (multitile) so that some interfaces, like the
power management files, have effect only on one of the tiles.
This means that we needed to move some of the files inside the
newly created gt0/gt1 directory.

But, because some of those files are part of an ABI
specification, we can't simply transfer them from the original
position so that we needed to make a "hard" copy (actually the
original files now take the role of affecting all the GTs instead
of only one).

The complexity of this file comes from the necessity of
minimizing code duplication, otherwise we could have had two
perfectly identical files (which looking at the final result it
wouldn't have been a completely bad idea after all).

Thanks again, will let you know when I will get this into our
branch.

Andi

> > Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> Thanks for looking it over!
> 
> Cheers,
> Nathan
