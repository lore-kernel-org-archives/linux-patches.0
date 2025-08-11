Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE382E2F01;
	Mon, 11 Aug 2025 21:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754946552; cv=none; b=RXmXdStqUUWrtX4W7Ku0mRB6aaLmJnjwRAsDhXTf4dkd7+u/tCRdlJdkaErZkHI5ag1RdEbZ1suhHG6TrAVCKzFct1UneTH/iVRhCgvJFWA9iqr9neDgZryPpM5C333GqXKqIuhpE/1K7eiESdHa/yU2p+CRD0UdPoUureCKfgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754946552; c=relaxed/simple;
	bh=6ax/s84qpXwB/a1KR32uE9HFa8Yea7etDg3dw4sZKEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXynUo6bwKNbIhrhOGVKqVUSP2LSGmRRgltq5HnRtvbT6DI8jhGEB6G2P7PXwunUJj/5XLFaOT/c7P2xbpwVwU436koi0/2evcxjrWwSON1mNGSAVazZJBZGNtwZoeCif2Ql/sAmoGoDDCGPfkRyG/DB0kUjhps1M7k+cArsCHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qZB42YIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qZB42YIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7301C4CEED;
	Mon, 11 Aug 2025 21:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754946551;
	bh=6ax/s84qpXwB/a1KR32uE9HFa8Yea7etDg3dw4sZKEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qZB42YIuCZS9uBL/0ojyW53obuWCfv0vJfd+m7By1McLWKL3JNh5lNcpuJ/eqhiry
	 rZGwDTyrxLBEU9VeVW45lLU/hFTrxeeaSMLEuXQZNMzFkJBtPQSk0YuNZuhq0LJlxA
	 /G2MeVoLm3vFntPZoUNKtOgec9DOIhBcK4VWHlZkPNpzzwsLFbadJREOh+i08jLYCc
	 zzz4CWDbijgT6JnaCyQ8r6bJZyI/mE++h4It/pD4DN5PSl4EOeKwIFHxk1grw7plI5
	 2VzvOBr4dIITizMjS024NGblubMwzgh0pWcUU1CtudE4GAa9kFlagP+yuSMLnM5VUU
	 6fFJE/RtHNo1A==
Date: Mon, 11 Aug 2025 14:09:06 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] hardening: Require clang 20.1.0 for __counted_by
Message-ID: <20250811210906.GA924329@ax162>
References: <20250807-fix-counted_by-clang-19-v1-1-902c86c1d515@kernel.org>
 <a9c64598-41e9-4ec8-8ec1-add5a5f903b4@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9c64598-41e9-4ec8-8ec1-add5a5f903b4@intel.com>

On Mon, Aug 11, 2025 at 04:21:32PM +0200, Alexander Lobakin wrote:
> From: Nathan Chancellor <nathan@kernel.org>
> Date: Thu, 07 Aug 2025 14:36:28 -0700
> 
> > After an innocuous change in -next that modified a structure that
> > contains __counted_by, clang-19 start crashing when building certain
> > files in drivers/gpu/drm/xe. When assertions are enabled, the more
> > descriptive failure is:
> > 
> >   clang: clang/lib/AST/RecordLayoutBuilder.cpp:3335: const ASTRecordLayout &clang::ASTContext::getASTRecordLayout(const RecordDecl *) const: Assertion `D && "Cannot get layout of forward declarations!"' failed.
> > 
> > According to a reverse bisect, a tangential change to the LLVM IR
> > generation phase of clang during the LLVM 20 development cycle [1]
> > resolves this problem. Bump the version of clang that enables
> > CONFIG_CC_HAS_COUNTED_BY to 20.1.0 to ensure that this issue cannot be
> > hit.
> 
> Any chance for this to go to the next 19.x (if it's planned at all)?
> I always use the latest HEAD from llvm-project, but 19 is still widely
> used across distros etc =\

Unfortunately not, LLVM does not maintain more than one branch at a
time, so LLVM 19 has been unsupported since LLVM 20.1.0-rc1 was
released back in February :/

Some distros may be willing to patch that in but there is not really a
good way for us to check for that here, so I am not sure it helps much.

Kees and Bill may have thoughts around working around this in the one
spot we know it happens but in my opinion, I would rather do the big
hammer. The deployment of __counted_by in the kernel is only growing so
it is totally possible for us to fix this one instance then run into
another case in a few months, which is more painful for clang than GCC
since it has been supported for a bigger number of releases.

Cheers,
Nathan
