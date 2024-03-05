Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607FC12D1FD;
	Tue,  5 Mar 2024 22:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709678598; cv=none; b=Z5whS3qiHD/LBd2x7tD1ua7rNU8aXXprR87bAPVMeE7WZo+cbyPR3BUdYA+7sFD2TAIqYcGsPL8sVdA+hsvMQyowH6MLvuyRiMz0D0BQWW5GGbSmiFRy8dk8ajCoRAdbjxQS+zu98vPhNfRYw2mJ1pTpOXsdZ8FnO54EiOkd/5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709678598; c=relaxed/simple;
	bh=dQ1pJAIiavjdmCx57q0B9xSQYGoGPYdjft4ZmROG2sI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pnt2qmZTIhyWq3517cbZXPnFVTr1LY8CF/d647LInIgP+JpLgfrec2plBQ7oYoQ0jGa++mPltcL28JvA0y3nqMemgCv2UY2kbgPQoE+CWxVvJZDktP6yLYar4BSfSkByCQUbpUgm1FJM2B/Lz9NQmxFSN2OQNslAVIkOC3xZJX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grtqyePr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grtqyePr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7158EC433F1;
	Tue,  5 Mar 2024 22:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709678598;
	bh=dQ1pJAIiavjdmCx57q0B9xSQYGoGPYdjft4ZmROG2sI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=grtqyePrDLKoRLaMF/691CTWvRljtN0XrIwLHTHblVWNNnspKCBQfcrPz5KaqGlIT
	 wNL1ocYuCO8GaC/9C4HwOzamXHadXRDycP2V9OcBBWl1oSCyrF9FWBb0s2zNK0bjdd
	 HbekNWMkCcw9QGdpSCdFkhS/bzuiI+e3xRHGV/VdaPKMcel77jYDN5QWWxo+lsCsvn
	 HSA4z1yjaMEd/QgQaWpwin9eOEVvbDcAz1CmjAkBcwo6gblPZ8TVgaRJU98SxGQTWG
	 WILvMUZSTd7Gx+a9RwLbG2sAuQMUTgf8wsxMdVTP0G8ExnGJdJQ6Z+bnv2/pjJCjiC
	 wNKUwrjAs8B+A==
Date: Tue, 5 Mar 2024 15:43:15 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: mpe@ellerman.id.au
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com, morbo@google.com,
	justinstitt@google.com, linuxppc-dev@lists.ozlabs.org,
	patches@lists.linux.dev, llvm@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] powerpc: xor_vmx: Add '-mhard-float' to CFLAGS
Message-ID: <20240305224315.GA2361659@dev-arch.thelio-3990X>
References: <20240127-ppc-xor_vmx-drop-msoft-float-v1-1-f24140e81376@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240127-ppc-xor_vmx-drop-msoft-float-v1-1-f24140e81376@kernel.org>

Ping? We have been applying this in our CI since it was sent, it would
be nice to have this upstream soon so it can start filtering through the
stable trees.

On Sat, Jan 27, 2024 at 11:07:43AM -0700, Nathan Chancellor wrote:
> arch/powerpc/lib/xor_vmx.o is built with '-msoft-float' (from the main
> powerpc Makefile) and '-maltivec' (from its CFLAGS), which causes an
> error when building with clang after a recent change in main:
> 
>   error: option '-msoft-float' cannot be specified with '-maltivec'
>   make[6]: *** [scripts/Makefile.build:243: arch/powerpc/lib/xor_vmx.o] Error 1
> 
> Explicitly add '-mhard-float' before '-maltivec' in xor_vmx.o's CFLAGS
> to override the previous inclusion of '-msoft-float' (as the last option
> wins), which matches how other areas of the kernel use '-maltivec', such
> as AMDGPU.
> 
> Cc: stable@vger.kernel.org
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1986
> Link: https://github.com/llvm/llvm-project/commit/4792f912b232141ecba4cbae538873be3c28556c
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/powerpc/lib/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
> index 6eac63e79a89..0ab65eeb93ee 100644
> --- a/arch/powerpc/lib/Makefile
> +++ b/arch/powerpc/lib/Makefile
> @@ -76,7 +76,7 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
>  obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
>  
>  obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
> -CFLAGS_xor_vmx.o += -maltivec $(call cc-option,-mabi=altivec)
> +CFLAGS_xor_vmx.o += -mhard-float -maltivec $(call cc-option,-mabi=altivec)
>  # Enable <altivec.h>
>  CFLAGS_xor_vmx.o += -isystem $(shell $(CC) -print-file-name=include)
>  
> 
> ---
> base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
> change-id: 20240127-ppc-xor_vmx-drop-msoft-float-ad68b437f86c
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
