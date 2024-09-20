Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5311CD2C;
	Fri, 20 Sep 2024 09:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726825045; cv=none; b=joXmeBEkkLuUeZEXITDX6thqAV6wflDZe6dDt6TaWO9xK2NdIUzwH8qWQHxUWshrduCRLQCyUGxf9+JnXzAyjZHRwZYHYNWnfYEOaWxpaeRWYX6LzME4m0AIjvIoy8UY1ofzRFGnZvrJsmQsoGfewlqAePWjHMBRgA00QyDuyKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726825045; c=relaxed/simple;
	bh=ewaE6kFipSZ+IA8El0kFSPMtzyh1oiS8KVuWRKL8rIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHaKAB4TaNuN++UR16AP/gx5ok604BnUkdSVSckoz74fRYi91ujlhmliIa1wJdCH0wnVxcJxzV9deW5RC6cS2JRpYSuixDE/nZpLO6PUoM1wlZnuDVF3/Nxe4TujbORJhD3RPxfpK0/JeM3fs7FOw080s8qSWDoVPM1CdFG4xyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eehm+ZfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eehm+ZfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F187FC4CEC3;
	Fri, 20 Sep 2024 09:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726825044;
	bh=ewaE6kFipSZ+IA8El0kFSPMtzyh1oiS8KVuWRKL8rIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eehm+ZfOpLGkoO7Al5j59uyiNdCGhe+x6BP+r7RnH4nQKp9l53LT1qp1jPOhdJGtc
	 JxDj8tDU/65utgqep0Dq9LPwfcwRN1b35IoVq9uvx+sMudi/PgqfqG0QUe2xW2iXED
	 Is00nCBHy1VyC74Awq7FcnbDvAvS0QnmWVW7jOIzS16EdVvkaGflHBw3aI5WPGTB5S
	 Topq4q6cHJcwqVrbcsDGOh7DUpBD8xkzkLN/Hj4WgYHOBbmnj7UuxukH9AzcVdLpSo
	 R2pRNTMN1vUsuD8hRAKXid57ch1owGFyxKqZpbmt+wmFApjH7EHfPCTzt9aUbyfans
	 O7C+/BIQZZTQA==
Date: Fri, 20 Sep 2024 02:37:22 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH v3] x86/resctrl: Annotate get_mem_config() functions as
 __init
Message-ID: <20240920093722.GA411564@thelio-3990X>
References: <20240917-x86-restctrl-get_mem_config_intel-init-v3-1-10d521256284@kernel.org>
 <2deb3b0c-121c-4dfb-9179-e919582f5bb4@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2deb3b0c-121c-4dfb-9179-e919582f5bb4@intel.com>

On Thu, Sep 19, 2024 at 02:15:34PM -0700, Reinette Chatre wrote:
> 
> 
> On 9/17/24 9:02 AM, Nathan Chancellor wrote:
> > After a recent LLVM change [1] that deduces __cold on functions that
> > only call cold code (such as __init functions), there is a section
> > mismatch warning from __get_mem_config_intel(), which got moved to
> > .text.unlikely. as a result of that optimization:
> > 
> >   WARNING: modpost: vmlinux: section mismatch in reference: __get_mem_config_intel+0x77 (section: .text.unlikely.) -> thread_throttle_mode_init (section: .init.text)
> > 
> > Mark __get_mem_config_intel() as __init as well since it is only called
> > from __init code, which clears up the warning.
> > 
> > While __rdt_get_mem_config_amd() does not exhibit a warning because it
> > does not call any __init code, it is a similar function that is only
> > called from __init code like __get_mem_config_intel(), so mark it __init
> > as well to keep the code symmetrical.
> > 
> > Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
> > Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> 
> If there is a re-spin I think appropriate Fixes tags can be added:
> Fixes: 05b93417ce5b ("x86/intel_rdt/mba: Add primary support for Memory Bandwidth Allocation (MBA)")
> Fixes: 4d05bf71f157 ("x86/resctrl: Introduce AMD QOS feature") 
> 
> I am not familiar with stable rules related to compiler impact but
> this may fall into the "it bothers people" category of fixes so
> a Cc: stable@vger.kernel.org sounds appropriate also.

Yes, I think it would be reasonable to have Fixes and a Cc: stable since
this can turn fatal with CONFIG_SECTION_MISMATCH_WARN_ONLY=n (even if
there should be no real issue at run time because these functions are
only called from __init code).

I'll send a v4 upon request from whoever will apply this. Otherwise,
here is a copy and pasteable block:

Cc: stable@vger.kernel.org
Fixes: 05b93417ce5b ("x86/intel_rdt/mba: Add primary support for Memory Bandwidth Allocation (MBA)")
Fixes: 4d05bf71f157 ("x86/resctrl: Introduce AMD QOS feature")

Cheers,
Nathan
