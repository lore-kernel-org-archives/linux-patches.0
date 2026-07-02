Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0EB32861E;
	Thu,  2 Jul 2026 23:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783033228; cv=none; b=dgjip4LkTntZM0aeYCvzLHz6wwL0CG375/g8sHO/7IV1xxM2efUzVdnANvdGosrW7275SFCDiioidtwchamgn/pIJz7AcONJzCbrcs7+hWGgBcIWtt3fETlVI4LPEmoYKFobuetELrRSkdDY9GUQvzjwwnwECRavV44/CfGvoY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783033228; c=relaxed/simple;
	bh=dO/2GrxBamnuGtEIhr1XGZygv4vW+r10f4u4+O0zxhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=teR+MA5hrxC7ZFur/b6+ni83LvtjQhgDY3TyZ58KSlBCSDjDEuvZIYcezHtt3VC4gbrCa2Uw/kPK2Y3I2rhJ8nTGY6Gz5i3zb/xBHa5IXaCaQktYz5pQaGEQ2FIw1TWMIj7f04bbjKnbIhD/h8w1XAmOjDnpKnEGDbpT3R9AchY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FXPlH3Bj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FXPlH3Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41F91F000E9;
	Thu,  2 Jul 2026 23:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783033227;
	bh=rNCJIqq7oZ3aV3nqe1kJEXiHDsjYb5l4i4bcN/Niynk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FXPlH3BjVEgBYRg7iXzKV2rf1nHPMsRpwikJMZWITWAwZb5yZDnzKMxPJP8Xs24Jq
	 Sppcr6SBNMJdE3rP+912474YuzuR1aatgo7x0kl4rvCCy370GQLsApiTgq0VyxjCNC
	 PFSoAMMc5U73yLAg74RUUkmisOM+Mcf4Qjfg4HHZWapntnr0p7IYUdwejwi4Ib3Zri
	 UE9JruN2kf9PM/KhLt6EjGzGYAKSB16G/JfBl9GFqlc1r1FeRCBlCPoHFmRSLcRHXJ
	 BDf1ELyHj7gNDRUkDodY703i+JgiuI9j0GB1z5QCoEyYmudKtH34FoUQWtvIGvSIhj
	 hu0vOgEZOnWiQ==
Date: Thu, 2 Jul 2026 16:00:22 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 375/522] net: ipv4: stop checking
 crypto_ahash_alignmask
Message-ID: <20260702230022.GB116181@quark>
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145143.326415700@linuxfoundation.org>
 <6218e66138c5c1c5fb02bd653c8b91d6ff8c3abd.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6218e66138c5c1c5fb02bd653c8b91d6ff8c3abd.camel@decadent.org.uk>

On Wed, Jun 24, 2026 at 06:24:48PM +0200, Ben Hutchings wrote:
> On Tue, 2026-06-16 at 20:28 +0530, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > [ Upstream commit e77f5dd701381cef35b9ea8b6dea6e62c8a7f9f3 ]
> > 
> > Now that the alignmask for ahash and shash algorithms is always 0,
> > crypto_ahash_alignmask() always returns 0 and will be removed.
> [...]
> 
> But that is only true after the earlier changes in the series from which
> this was cherry-picked!  To avoid a regression, it would be necessary to
> backport at least the driver changes to support unaligned buffers:
> 
> 9924003807a9 "crypto: sparc/crc32c - stop using the shash alignmask"
> f35a4e237f4e "crypto: omap-sham - stop setting alignmask for ahashes"
> 8c87553e2db6 "crypto: starfive - remove unnecessary alignmask for ahashes"
> 
> However I think it makes more sense to revert this and its ipv6
> counterpart and to fix up whatever the conflict was.

Well, I pointed this out at
https://lore.kernel.org/stable/20260513175122.GC2128@quark/ too but just
got ignored, just as you got ignored too.  This should have been
resolved properly, but since AH is used only for exploits anyway it
probably doesn't matter.

- Eric
