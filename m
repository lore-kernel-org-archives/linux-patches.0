Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589DA1D362B;
	Tue,  8 Oct 2024 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394798; cv=none; b=mbGim7zPXnqOcYJScqPLex4hQTRuNh5VeA+HmTQ499eBaexRx7pvuf2H2NaZCt2yEZnrpzbQqm0UlViOJ+oS8xOx0SXPnTK0uYjsxOlN2uAYm772+q4ARh7yUhNAeY6Z1dhqMemQheXQOJNHXvTz5drBVQLNo+ZceuujEpMbbOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394798; c=relaxed/simple;
	bh=D3zMX+nGIlOON+28O/pmYT+Fu3bkr9vHmFGcJlFRjRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6sCe2mQwXiMRTSHjOrQPsTqgGj2IdFHUsNLpJ21rfsu2HdSoCc2OrYT7YnziWiyKV8/U71Uvas/5IPErbIvTM03w7tc3sACLcLdbAxR7PpCXDJJKpN6Rzf2AeiTLFY4O/L0261VWcFPrKMQXwpoqywgQeKAO7+q35QNCa9t974=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RMHLtQSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RMHLtQSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441AEC4CECC;
	Tue,  8 Oct 2024 13:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728394797;
	bh=D3zMX+nGIlOON+28O/pmYT+Fu3bkr9vHmFGcJlFRjRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RMHLtQSvncaYoVgNIdgxSoX0o70ZrDxc+PIUIYuwdcx+dXhx5hA9/n7PUUZk14Pc4
	 Kn+3OMabgZ/Q4luLUeXa2jhlyNXQQov1IY9w8zI06NPNeW9YRQQiroliL5ZGwy9SEG
	 EUbmOz3CxwdQ5f3XdzxexYAZjlrHxZXGCqs++cDZIFuJWeyGfhAH1+XyTZPy+A5jge
	 fmtZ3a8bjfX0g1WMlnTP6MGcM88nm5eSAi4eJR5lUpAxEQ+/0tsfD+X5CnsM88g4GQ
	 Q6GsDj59n0KEWuX7WTccnQlUeeK5k1uMzCSpVKihyuRXGqCgmwkZZgdNKHsbi4n5S4
	 tSJFGXP4f65Pw==
Date: Tue, 8 Oct 2024 06:39:55 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Keith Packard <keithp@keithp.com>, linuxppc-dev@lists.ozlabs.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 2/3] powerpc: Adjust adding stack protector flags to
 KBUILD_CLAGS for clang
Message-ID: <20241008133955.GA3504203@thelio-3990X>
References: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
 <20241007-powerpc-fix-stackprotector-test-clang-v1-2-08c15b2694e4@kernel.org>
 <331cc7ba-ed5e-4dd3-8175-b51bacb65186@csgroup.eu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <331cc7ba-ed5e-4dd3-8175-b51bacb65186@csgroup.eu>

Hi Christophe,

First of all, thanks a lot for the quick review.

On Tue, Oct 08, 2024 at 07:10:36AM +0200, Christophe Leroy wrote:
> Le 08/10/2024 à 06:22, Nathan Chancellor a écrit :
> > After fixing the HAVE_STACKPROTECTER checks for clang's in-progress
> > per-task stack protector support [1], the build fails during prepare0
> > because '-mstack-protector-guard-offset' has not been added to
> > KBUILD_CFLAGS yet but the other '-mstack-protector-guard' flags have.
> > 
> >    clang: error: '-mstack-protector-guard=tls' is used without '-mstack-protector-guard-offset', and there is no default
> >    clang: error: '-mstack-protector-guard=tls' is used without '-mstack-protector-guard-offset', and there is no default
> >    make[4]: *** [scripts/Makefile.build:229: scripts/mod/empty.o] Error 1
> >    make[4]: *** [scripts/Makefile.build:102: scripts/mod/devicetable-offsets.s] Error 1
> > 
> > Mirror other architectures and add all '-mstack-protector-guard' flags
> > to KBUILD_CFLAGS atomically during stack_protector_prepare, which
> > resolves the issue and allows clang's implementation to fully work with
> > the kernel.
> > 
> > Link: https://github.com/llvm/llvm-project/pull/110928 [1]
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Is it worth a Fixes: tag so that it gets applied on stable, or wont CLANG 20
> be used with kernels older than 6.13 ?

Yes, I did consider adding Fixes: + Cc: stable. I think it is probably
worth doing since the fixes are rather benign. Do you have a suggestion
for a good Fixes: commit? It always feels somewhat wrong to blame a
commit for not having foresight into how a future implementation might
do things differently :)

> > -	$(eval KBUILD_CFLAGS += -mstack-protector-guard-offset=$(shell awk '{if ($$2 == "PACA_CANARY") print $$3;}' include/generated/asm-offsets.h))
> > +	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls \
> > +				-mstack-protector-guard-reg=r13 \
> 
> Can you put both above lines on a single line to avoid having too many lines
> at the end:
> 
> +	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls -mstack-protector-guard-reg=r13 \

Ack, I have made this change locally for v2.

Cheers,
Nathan
