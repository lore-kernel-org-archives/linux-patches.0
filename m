Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAA42D12F7;
	Wed, 13 Aug 2025 08:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755072364; cv=none; b=dqzWEmgriH6EAxdpR/3k8g7Nw+39VoBIAKtX5ZfRkyM8ijM7Dut5E5FHTM67nNZ0k41StWHtTRhovbYKqMuAjC2DiwGLZhKQaB8JhX3PFFCCkHqDGTTWGvWIpPhx3A1Z5sYaxwG2IpzQNRcByu4vJat4yD3MoaSMuunTSvalskM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755072364; c=relaxed/simple;
	bh=eeluwFsguHI154LohyPllRNSeqspnUZCRnrHmBIVPHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzz6UC2a5l2zk1qQnMhn8x2u1ny3+33dS8bBEC6Bv+1xqOIw+gbno9AbBcg8uxSz8lhJGgJVzRN9TcwfEtFqlv7T+QLFww5C7sgEbT1iCBRI0rNfaYKXiQquaASZt6G+cByN3v7SGbVctyyqfTABN004aeJJZ2djqPAO8/A/JJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b57shFIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b57shFIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08ECC4CEF1;
	Wed, 13 Aug 2025 08:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755072363;
	bh=eeluwFsguHI154LohyPllRNSeqspnUZCRnrHmBIVPHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b57shFIc7eKS9yti8AUBcvU9VkfJiClltdj5B8/bnY8FgDe0YoHdnr8mcy394aWsV
	 uFIlFk7D6zgGKilwqIca1wCxqIFebJ8GMVL0BHfK6h2GvsxoP5Wm3bbcrfuC4qGKHJ
	 2ozF+PccwATLDv7nSYLr1AvVD1TzdBV5n1uBuy1o=
Date: Wed, 13 Aug 2025 10:06:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 028/627] erofs: fix build error with
 CONFIG_EROFS_FS_ZIP_ACCEL=y
Message-ID: <2025081346-mobilize-bobbed-5bff@gregkh>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173420.398660113@linuxfoundation.org>
 <d0af351b-715c-4f32-b33a-77d2459c2932@kernel.org>
 <ca432b9e-e016-4d2d-b137-79def0aaca85@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca432b9e-e016-4d2d-b137-79def0aaca85@kernel.org>

On Wed, Aug 13, 2025 at 08:36:10AM +0200, Jiri Slaby wrote:
> On 13. 08. 25, 8:32, Jiri Slaby wrote:
> > On 12. 08. 25, 19:25, Greg Kroah-Hartman wrote:
> > > 6.16-stable review patch.  If anyone has any objections, please let
> > > me know.
> > > 
> > > ------------------
> > > 
> > > From: Bo Liu (OpenAnolis) <liubo03@inspur.com>
> > > 
> > > [ Upstream commit 5e0bf36fd156b8d9b09f8481ee6daa6cdba1b064 ]
> > > 
> > > fix build err:
> > >   ld.lld: error: undefined symbol: crypto_req_done
> > >     referenced by decompressor_crypto.c
> > >         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress)
> > > in archive vmlinux.a
> > >     referenced by decompressor_crypto.c
> > >         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress)
> > > in archive vmlinux.a
> > > 
> > >   ld.lld: error: undefined symbol: crypto_acomp_decompress
> > >     referenced by decompressor_crypto.c
> > >         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress)
> > > in archive vmlinux.a
> > > 
> > >   ld.lld: error: undefined symbol: crypto_alloc_acomp
> > >     referenced by decompressor_crypto.c
> > >        
> > > fs/erofs/decompressor_crypto.o:(z_erofs_crypto_enable_engine) in
> > > archive vmlinux.a
> > > 
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/oe-kbuild-all/202507161032.QholMPtn-
> > > lkp@intel.com/
> > > Fixes: b4a29efc5146 ("erofs: support DEFLATE decompression by using
> > > Intel QAT")
> > > Signed-off-by: Bo Liu (OpenAnolis) <liubo03@inspur.com>
> > > Link: https://lore.kernel.org/r/20250718033039.3609-1-liubo03@inspur.com
> > > Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >   fs/erofs/Kconfig | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
> > > index 6beeb7063871..7b26efc271ee 100644
> > > --- a/fs/erofs/Kconfig
> > > +++ b/fs/erofs/Kconfig
> > > @@ -147,6 +147,8 @@ config EROFS_FS_ZIP_ZSTD
> > >   config EROFS_FS_ZIP_ACCEL
> > >       bool "EROFS hardware decompression support"
> > >       depends on EROFS_FS_ZIP
> > > +    select CRYPTO
> > > +    select CRYPTO_DEFLATE
> > 
> > This is not correct as it forces CRYPTO=y and CRYPTO_DEFLATE=y even if
> > EROFS=m.
> > 
> > The upstream is bad, not only this stable patch.
> 
> -next is fixed by:
> 
> commit 8f11edd645782b767ea1fc845adc30e057f25184
> Author: Geert Uytterhoeven <geert+renesas@glider.be>
> Date:   Wed Jul 30 14:44:49 2025 +0200
> 
>     erofs: Do not select tristate symbols from bool symbols
> 
> I suggest postponing this patch until the above is merged and picked too...

Thanks, I'll go drop this now.

greg k-h
