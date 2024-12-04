Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF261AF0A6;
	Wed,  4 Dec 2024 12:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733315091; cv=none; b=uoDExQfHBTcWanxWbPCZ1GK/c9P/rdOKSW0BlTZOFgFkffAPsR3BhSCGJdC5nBI/DCGaQrXVsPBlviA+408EmT9+M7w+y8Vg9kdwbxtwYCOb+TF3hV1Y+Y1moft3GALSQbetSLzbUassrtoNctobxjeBcuojyyvx7jWCSoSdPJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733315091; c=relaxed/simple;
	bh=RkNNygw7XCw7JUqiz54zg1qFks2WK0FKwWgqQMVbIz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KYPcltvGtmLtIlesOZJcOgGVTFOvRIOwRZojpyWxVZXhivQ+9Sb+xO5fRs9bHvbvfOxM5JlIOM1tRV1fIw99eKeki3TXGCiTLFNGNiGEDnC9epyfQg9oLF+SZQ3bwp2sVg3cN0mJ9lHf6Pa4WCznpjN8bll95bRHTOKJB56I6hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwMh0kot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwMh0kot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DB2C4CED1;
	Wed,  4 Dec 2024 12:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733315091;
	bh=RkNNygw7XCw7JUqiz54zg1qFks2WK0FKwWgqQMVbIz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BwMh0kotEqBwMw6RpqGwLr2MCwOJRv/lCd+ymZ1aCBgw4XstCtl7Z2B1rQp3LxMlt
	 Mj9qQpnAUlgm9U6THkwMB6IeIhwCeYZzJwGg9643wB4yH533AFyGcTz0tmKeXf55FJ
	 49loypaKRRj3bW74iZJZoKT2m4lPel6FQFjbEPTE=
Date: Wed, 4 Dec 2024 13:24:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Danny Tsen <dtsen@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 043/826] crypto: powerpc/p10-aes-gcm - Register
 modules as SIMD
Message-ID: <2024120421-coming-snore-e6fc@gregkh>
References: <20241203144743.428732212@linuxfoundation.org>
 <20241203144745.143525056@linuxfoundation.org>
 <2a720dd0-56a0-4781-81d3-118368613792@kernel.org>
 <2024120417-flattop-unpaired-fcf8@gregkh>
 <92315b46-db52-4640-b8b9-c2ddbef38a17@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92315b46-db52-4640-b8b9-c2ddbef38a17@kernel.org>

On Wed, Dec 04, 2024 at 11:45:05AM +0100, Jiri Slaby wrote:
> On 04. 12. 24, 11:34, Greg Kroah-Hartman wrote:
> > On Wed, Dec 04, 2024 at 11:00:34AM +0100, Jiri Slaby wrote:
> > > Hi,
> > > 
> > > On 03. 12. 24, 15:36, Greg Kroah-Hartman wrote:
> > > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Danny Tsen <dtsen@linux.ibm.com>
> > > > 
> > > > [ Upstream commit c954b252dee956d33ee59f594710af28fb3037d9 ]
> > > > 
> > > > This patch is to fix an issue when simd is not usable that data mismatch
> > > > may occur. The fix is to register algs as SIMD modules so that the
> > > > algorithm is excecuted when SIMD instructions is usable.  Called
> > > > gcm_update() to generate the final digest if needed.
> > > > 
> > > > A new module rfc4106(gcm(aes)) is also added.
> > > > 
> > > > Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")
> > > > 
> > > > Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
> > > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >    arch/powerpc/crypto/aes-gcm-p10-glue.c | 141 +++++++++++++++++++++----
> > > >    1 file changed, 118 insertions(+), 23 deletions(-)
> > > > 
> > > > diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> > > > index f66ad56e765f0..4a029d2fe06ce 100644
> > > > --- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
> > > > +++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> > > ...
> > > > @@ -281,6 +295,7 @@ static int p10_aes_gcm_crypt(struct aead_request *req, int enc)
> > > >    	/* Finalize hash */
> > > >    	vsx_begin();
> > > > +	gcm_update(gctx->iv, hash->Htable);
> > > 
> > > Now I get:
> > > ERROR: modpost: "gcm_update" [arch/powerpc/crypto/aes-gcm-p10-crypto.ko]
> > > undefined!
> > > 
> > > Only this:
> > > commit 7aa747edcb266490f93651dd749c69b7eb8541d9
> > > Author: Danny Tsen <dtsen@linux.ibm.com>
> > > Date:   Mon Sep 23 09:30:38 2024 -0400
> > > 
> > >      crypto: powerpc/p10-aes-gcm - Re-write AES/GCM stitched implementation
> > > 
> > > 
> > > 
> > > added that function...
> > 
> > Ah, thanks, I'll go drop this patch from everywhere.
> 
> OK.
> 
> Looking at the queue, it looks like a prereq for un-BROKEN-ing the module in
> the next patch:
>   8b6c1e466eec crypto: powerpc/p10-aes-gcm - Add dependency on
> CRYPTO_SIMDand re-enable CRYPTO_AES_GCM_P10

No, I don't see a conflict here.  Are you sure you are?

> Dropping the two, this one has to be dropped too:
> 3574a5168ff3 crypto: aes-gcm-p10 - Use the correct bit to test for P10

I already dropped this one when I dropped the first.

thanks,

greg k-h
