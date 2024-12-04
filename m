Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA201A724C;
	Wed,  4 Dec 2024 10:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308479; cv=none; b=sOAxKd6epvoqJqF2ovoKG1Zufmx7eGlCeeCVtYqnhcy/oJEmvS+vUdqIf+fqSEt9FcZIFcOuQNhWAdhMINa10DKpDLkfefhMKE9Js156u9IEoOIq5CExhXLnB0ExEPHsWhu9nMltftsrM1hDQSJ7+TGQQlJ4EasigTofuTV5SdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308479; c=relaxed/simple;
	bh=ZmW39cuXdgUBVsyYOe3pr+CBI6V1hxq70ePe7MrH5qw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fuk393Inx/b0MA83D5w4AvBluvdBdZBjUAcpq7T9i5vbk2qvgUDYHd1lapDjMApQg1cGcgL4djZiy6DyGcsnzvnclFw0sSSOudHYFQm7RlCLtvIU1gjyroNnrWM5qnbcb2TNdxTLjp9htUO3PYClSsDA9ufeZ6qN93/rR8WO6cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETyChfSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETyChfSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABAEC4CED1;
	Wed,  4 Dec 2024 10:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733308479;
	bh=ZmW39cuXdgUBVsyYOe3pr+CBI6V1hxq70ePe7MrH5qw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ETyChfSf984dCBCXO5nIzjeETxqeafOVoLWtmfJHmwcuVv/9RULTl6/pao+i9Oyje
	 oSzjuuwPxqILpk0jUdGN+FJtU3Bq0NPEZQ+wQcvt7Beo/k1Yfa8G7c/wUgC+rga36Z
	 CKQORky1G6pC7DYtI/riqD4z4nCSsEa/OAdt+TtE=
Date: Wed, 4 Dec 2024 11:34:35 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Danny Tsen <dtsen@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 043/826] crypto: powerpc/p10-aes-gcm - Register
 modules as SIMD
Message-ID: <2024120417-flattop-unpaired-fcf8@gregkh>
References: <20241203144743.428732212@linuxfoundation.org>
 <20241203144745.143525056@linuxfoundation.org>
 <2a720dd0-56a0-4781-81d3-118368613792@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a720dd0-56a0-4781-81d3-118368613792@kernel.org>

On Wed, Dec 04, 2024 at 11:00:34AM +0100, Jiri Slaby wrote:
> Hi,
> 
> On 03. 12. 24, 15:36, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Danny Tsen <dtsen@linux.ibm.com>
> > 
> > [ Upstream commit c954b252dee956d33ee59f594710af28fb3037d9 ]
> > 
> > This patch is to fix an issue when simd is not usable that data mismatch
> > may occur. The fix is to register algs as SIMD modules so that the
> > algorithm is excecuted when SIMD instructions is usable.  Called
> > gcm_update() to generate the final digest if needed.
> > 
> > A new module rfc4106(gcm(aes)) is also added.
> > 
> > Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")
> > 
> > Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   arch/powerpc/crypto/aes-gcm-p10-glue.c | 141 +++++++++++++++++++++----
> >   1 file changed, 118 insertions(+), 23 deletions(-)
> > 
> > diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> > index f66ad56e765f0..4a029d2fe06ce 100644
> > --- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
> > +++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> ...
> > @@ -281,6 +295,7 @@ static int p10_aes_gcm_crypt(struct aead_request *req, int enc)
> >   	/* Finalize hash */
> >   	vsx_begin();
> > +	gcm_update(gctx->iv, hash->Htable);
> 
> Now I get:
> ERROR: modpost: "gcm_update" [arch/powerpc/crypto/aes-gcm-p10-crypto.ko]
> undefined!
> 
> Only this:
> commit 7aa747edcb266490f93651dd749c69b7eb8541d9
> Author: Danny Tsen <dtsen@linux.ibm.com>
> Date:   Mon Sep 23 09:30:38 2024 -0400
> 
>     crypto: powerpc/p10-aes-gcm - Re-write AES/GCM stitched implementation
> 
> 
> 
> added that function...

Ah, thanks, I'll go drop this patch from everywhere.

greg k-h
