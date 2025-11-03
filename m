Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4416184524;
	Mon,  3 Nov 2025 02:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762136449; cv=none; b=nd07IyVs6AFi97lMrF1qV5ZoTwhauL83k1I6I2gUi5/KwCmQVwKpYMsoAzAQ5LcSI1jZ/a5uaDYkrWsNnddOV1iKJCBVqcHsU4C3NlCN4mHc2NQem5Imn8st6cJbSd721RxaNluKb+M8r5f3e8llt2n+SaItlQGdYDN2z/fy300=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762136449; c=relaxed/simple;
	bh=H9ejpGuiydKsVCBiNNFXQ10EpvTe+9KqNORn+4PKpMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cTZauljf/K9O6mocqEhtFmIBEhIpmRdqZQ+JBLNc9zjjm3j1wzh/mfUPxQxYWoIlbVNsDeTbl9cZePJ+XlPByEiTS47QxOexIFDGGZgTtgxkbSiGZqO1YQDotoZTrJfoXV+QrL38hCqgd8ybBVT2Ryh8iSNfOcmTwbAyBjvO95M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkprWU6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkprWU6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC22C4CEF7;
	Mon,  3 Nov 2025 02:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762136449;
	bh=H9ejpGuiydKsVCBiNNFXQ10EpvTe+9KqNORn+4PKpMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GkprWU6zM8wfBITJqRsFeWJnjZEASCUZUERIrA5KYQ0CqG6eAwUcYpyeU8mYPVuJ/
	 IgvkTzBnG8kIkIdLAOO2urhfpk9JWVa5g9zba5LipVIC8dt4YypOkR0GJuzjx8RQVr
	 syGGvl3jC3SNw4XEIsi33gbfpS5NQe+p47AzweS7Ta0XNqmFm5XnNOJ583EPmVSnwG
	 TpBSnd7oaA9Lya/uxvU7ABHaCHEoSo78xRjR7pPYO9eTFmkNamQw3+iRIIPlK25acd
	 yLtNSF5VUbVOoOpzUnMNayf3FrggEFjQnuqXmyMfy/q0UCRmk6+AjBGxNaZAkaRhXQ
	 BE+aMMeQiSiLw==
Date: Sun, 2 Nov 2025 21:20:44 -0500
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
	patches@lists.linux.dev, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 5.10 171/332] lib/crypto/curve25519-hacl64: Disable KASAN
 with clang-17 and older
Message-ID: <20251103022044.GA2193668@ax162>
References: <20251027183524.611456697@linuxfoundation.org>
 <20251027183529.142271445@linuxfoundation.org>
 <67ef17680d4e107847c688f9bb7fa45f4e6b51a3.camel@decadent.org.uk>
 <2025110304-footbath-unearned-6bfb@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025110304-footbath-unearned-6bfb@gregkh>

On Mon, Nov 03, 2025 at 10:42:14AM +0900, Greg Kroah-Hartman wrote:
> On Fri, Oct 31, 2025 at 08:47:23PM +0100, Ben Hutchings wrote:
> > On Mon, 2025-10-27 at 19:33 +0100, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Nathan Chancellor <nathan@kernel.org>
> > > 
> > > commit 2f13daee2a72bb962f5fd356c3a263a6f16da965 upstream.
> > [...]
> > > --- a/lib/crypto/Makefile
> > > +++ b/lib/crypto/Makefile
> > > @@ -22,6 +22,10 @@ obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENER
> > >  libcurve25519-generic-y				:= curve25519-fiat32.o
> > >  libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
> > >  libcurve25519-generic-y				+= curve25519-generic.o
> > > +# clang versions prior to 18 may blow out the stack with KASAN
> > > +ifeq ($(call clang-min-version, 180000),)
> > [...]
> > 
> > The clang-min-version macro isn't defined in 5.10 or 5.15, so this test
> > doesn't work as intended.
> 
> So should I revert it?

No, we should backport clang-min-version and friends because these
macros may be used in future backports. It should not be too hard. I can
work on that tomorrow.

Additionally, now that I am looking at this change again, this disables
KASAN for this file with GCC because clang-min-version will always
evaluate to nothing for GCC. I'll send a fix for this upstream then it
can be backported later.

Cheers,
Nathan
