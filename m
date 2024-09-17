Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D444166F25;
	Tue, 17 Sep 2024 13:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726580123; cv=none; b=nHykhUtLyybfXW4LccMvPF3dZsNrpX7ezuELOjEETAwZOVa08wkAcit1/bgagIR7sKt4fUz0a2PmZJ2KmYWlGXrctYQ2Rzt5ECKdvRaaDwo26juUWWgnwPzhDEPX8ay4TfdgMTTT5epa166prMDKiMHdfldVwJUdsUbBK1sSsfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726580123; c=relaxed/simple;
	bh=S307WM4fBp/+lASi22mOCId4exfMpqwvG2aKAoPdHVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APefB5q2j+inlIYsTGwzko2yIHm2MI9K2H35vrQhP5QMgbGsYiAoAhi4dPZkcJZGouFHeDDLC8Fg1Q7nJt295c4lvAWyZYwJ5INztk+NesigDm1+DyH5Y5u2ODlycvVK5t9nnV2UkIydgVbqlLdtuhMm1/S830vYQRo8duHoKfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBh8d2Te; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBh8d2Te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170B3C4CEC5;
	Tue, 17 Sep 2024 13:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726580122;
	bh=S307WM4fBp/+lASi22mOCId4exfMpqwvG2aKAoPdHVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XBh8d2TeNKkv2qQT09HaZfgr9DTsgDMJQfdlTZpBApaTSymDhtSJ5d5eocJR/hvWc
	 scGuhyZ/DlE9geO8kG3y7ChkLPzhxEeaSh6P5K7SAYO/tH0I1GVoKBXqfjxap8CM1F
	 SYR/lN5sJoWk2bFVBX9tKDMGwksUWHeMEWUk8i2RLbIe/DtrtJWhcTM3AaHH2DppaY
	 vT+RNB/KKaW3h+BD/0P2MSMpdvCeaQAbZrifU1wW1V+DYA1qjKAUJ7jd6euly8xVFe
	 Ug4/yrTW9kyfw7BAP6hCwImD4XDLssBNpxI6efgomh2XV0vwgaWbXr9uxeyKDBt5JZ
	 Jytsk1kRikOkw==
Date: Tue, 17 Sep 2024 06:35:20 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH v2] x86/resctrl: Annotate get_mem_config functions as
 __init
Message-ID: <20240917133520.GA2360164@thelio-3990X>
References: <20240913-x86-restctrl-get_mem_config_intel-init-v2-1-bf4b645f0246@kernel.org>
 <8e34346b-9703-48e5-8923-15800fa78899@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e34346b-9703-48e5-8923-15800fa78899@intel.com>

Hi Reinette,

On Mon, Sep 16, 2024 at 02:42:09PM -0700, Reinette Chatre wrote:
> Just one nit in the subject ... this area has the custom to use "()" to
> highlight that the name refers to a function, so rather:
> 
> 	x86/resctrl: Annotate get_mem_config() functions as __init

Thanks, I am aware of this custom since I do it in the commit message
but since get_mem_config() is a function in this file and it is not
exactly touched by this change, it did not really feel appropriate to
add the parentheses there.

I can send a v3 with this fixed if so desired or perhaps whoever is
going to apply this can just do it then?

> On 9/13/24 4:27 PM, Nathan Chancellor wrote:
> > After a recent LLVM change [1] that deduces __cold on functions that
> > only call cold code (such as __init functions), there is a section
> > mismatch warning from __get_mem_config_intel(), which got moved to
> > .text.unlikely. as a result of that optimization:
> > 
> >    WARNING: modpost: vmlinux: section mismatch in reference: __get_mem_config_intel+0x77 (section: .text.unlikely.) -> thread_throttle_mode_init (section: .init.text)
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
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> 
> Thank you very much.
> With subject adjusted:
> 
> | Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Thanks a lot for the review!

Cheers,
Nathan
