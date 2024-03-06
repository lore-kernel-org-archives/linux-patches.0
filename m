Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CF460250;
	Wed,  6 Mar 2024 16:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709743723; cv=none; b=O1fHKzjLr4ewtaWb5ONUi88kYoZCU7toRyRfYCNWUBoNm+rtbzV/0ZxwsDaWyDgHloSRCr8TbsBtjCM1xxNBknLEaOtLka2omHRkzWktMDuaQDI2pT08jaV90hq3fTzSPC5vxmu6N+FRvXqwZwIOf69fZO6WIwa35AA5m98IFPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709743723; c=relaxed/simple;
	bh=0QVMuhO8tv+yD3wGofv4vd1QwlfUDwn6eLrDolYC9js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGYqXe9m7Oux1HPRkRWihr3gW6o2611RFI1kM+eXWLhWU4z9u/Mn8pWk+WXqOSY1ZMPr3OeTDSgORFM+vetr8uTWSQrQQj2jO+8+YQm8NqMIeG+TCuSeyns29hknlGNK4zH7JaBXgpUbUt9Vl/6m+LuxauSqKFHepYv7i7FlwGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+XtvBMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+XtvBMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D1DC433C7;
	Wed,  6 Mar 2024 16:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709743722;
	bh=0QVMuhO8tv+yD3wGofv4vd1QwlfUDwn6eLrDolYC9js=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q+XtvBMfqHnTWiAQDZ8gmGdBrn5wJ0nauughUwkeXvnk/yXYoJIVAHxMcc/zanr7f
	 vg+r3Mgg6Z/cI2QQ44tNs16macvizUbJHML4KZ/Hkj5LnE2sUVZ4TFhN2/GvBYHUic
	 +SruEao4Ms/6vRSwBrRzsuIpWHPgqKcCbK8a2oPYC7KwLZa+Joagn22T6X2g+tnssU
	 2Pysjy4xZGG/IZ80vBiyhxntD4brOS+0Z1StfKp9ZXnbZphRrxvUA15xMdfCNvp1hO
	 NxusReLi/PpMSggNg25a8S8EMLwjkkdH0aC5mXlKQ32kbkH45ovDO/ZYgyRyXOIAio
	 uJLjHjJEVcAUw==
Date: Wed, 6 Mar 2024 09:48:40 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com, morbo@google.com,
	justinstitt@google.com, linuxppc-dev@lists.ozlabs.org,
	patches@lists.linux.dev, llvm@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] powerpc: xor_vmx: Add '-mhard-float' to CFLAGS
Message-ID: <20240306164840.GA3659677@dev-arch.thelio-3990X>
References: <20240127-ppc-xor_vmx-drop-msoft-float-v1-1-f24140e81376@kernel.org>
 <20240305224315.GA2361659@dev-arch.thelio-3990X>
 <874jdkp409.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jdkp409.fsf@mail.lhotse>

On Wed, Mar 06, 2024 at 12:01:42PM +1100, Michael Ellerman wrote:
> Nathan Chancellor <nathan@kernel.org> writes:
> > Ping? We have been applying this in our CI since it was sent, it would
> > be nice to have this upstream soon so it can start filtering through the
> > stable trees.
> 
> Sorry, I was away in January and missed this. Will pick it up.

No worries, I've done that more times than I would like to admit. Thanks
a lot for the quick response and picking it up!

Cheers,
Nathan

> > On Sat, Jan 27, 2024 at 11:07:43AM -0700, Nathan Chancellor wrote:
> >> arch/powerpc/lib/xor_vmx.o is built with '-msoft-float' (from the main
> >> powerpc Makefile) and '-maltivec' (from its CFLAGS), which causes an
> >> error when building with clang after a recent change in main:
> >> 
> >>   error: option '-msoft-float' cannot be specified with '-maltivec'
> >>   make[6]: *** [scripts/Makefile.build:243: arch/powerpc/lib/xor_vmx.o] Error 1
> >> 
> >> Explicitly add '-mhard-float' before '-maltivec' in xor_vmx.o's CFLAGS
> >> to override the previous inclusion of '-msoft-float' (as the last option
> >> wins), which matches how other areas of the kernel use '-maltivec', such
> >> as AMDGPU.
> >> 
> >> Cc: stable@vger.kernel.org
> >> Closes: https://github.com/ClangBuiltLinux/linux/issues/1986
> >> Link: https://github.com/llvm/llvm-project/commit/4792f912b232141ecba4cbae538873be3c28556c
> >> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> >> ---
> >>  arch/powerpc/lib/Makefile | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
> >> index 6eac63e79a89..0ab65eeb93ee 100644
> >> --- a/arch/powerpc/lib/Makefile
> >> +++ b/arch/powerpc/lib/Makefile
> >> @@ -76,7 +76,7 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
> >>  obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
> >>  
> >>  obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
> >> -CFLAGS_xor_vmx.o += -maltivec $(call cc-option,-mabi=altivec)
> >> +CFLAGS_xor_vmx.o += -mhard-float -maltivec $(call cc-option,-mabi=altivec)
> >>  # Enable <altivec.h>
> >>  CFLAGS_xor_vmx.o += -isystem $(shell $(CC) -print-file-name=include)
> >>  
> >> 
> >> ---
> >> base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
> >> change-id: 20240127-ppc-xor_vmx-drop-msoft-float-ad68b437f86c
> >> 
> >> Best regards,
> >> -- 
> >> Nathan Chancellor <nathan@kernel.org>
> >> 
> 
