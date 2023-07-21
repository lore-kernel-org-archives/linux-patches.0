Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1F91F94B
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WW6rE243GptC8mF8RM4dMsbNq7YIDXyvERTMDtrcyAg=; b=Xtv+oYbeCJaBchs8+/OHcz3931
	f7ySrjUckRT/MxPg2BL8YDiSJWRrbEzbzUW+GWzuZa2IOZ2kQAPXccZGyNK5b3tmLsK/DYLYdGN4o
	87MR+2hK7MFzDxT41eul0OJ74c5SlbzXS/MYQBANNWLK18qnUJ34WXDBbxbkPs4DfxuJvmOJ4F7JO
	UxZ/Q2fryE9SI7kTcrXzMk9Z1jXXQluBX4ayk7VBj2pHEn+pbBXBnxS/33nVpNOQzp3CTlqaqTbYS
	OXkHbxJoHEZ9VUQNMKD7hgHyiVR0PIRR89nRsvOQdT17O9mkvgTZ7SWNYiRGvbV18ZGNJN45YQcsO
	60w/IR5g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qMvE0-001NCG-2v; Fri, 21 Jul 2023 18:51:36 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EDF223001FD;
	Fri, 21 Jul 2023 20:51:35 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id D0A5C27D9BEA3; Fri, 21 Jul 2023 20:51:35 +0200 (CEST)
Date: Fri, 21 Jul 2023 20:51:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Milburn, Alyssa" <alyssa.milburn@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.4 067/292] x86/fineibt: Poison ENDBR at +0
Message-ID: <20230721185135.GQ4253@hirez.programming.kicks-ass.net>
References: <20230721160528.800311148@linuxfoundation.org>
 <20230721160531.667102163@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721160531.667102163@linuxfoundation.org>

On Fri, Jul 21, 2023 at 06:02:56PM +0200, Greg Kroah-Hartman wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> [ Upstream commit 04505bbbbb15da950ea0239e328a76a3ad2376e0 ]
> 
> Alyssa noticed that when building the kernel with CFI_CLANG+IBT and
> booting on IBT enabled hardware to obtain FineIBT, the indirect
> functions look like:
> 
>   __cfi_foo:
> 	endbr64
> 	subl	$hash, %r10d
> 	jz	1f
> 	ud2
> 	nop
>   1:
>   foo:
> 	endbr64
> 
> This is because the compiler generates code for kCFI+IBT. In that case
> the caller does the hash check and will jump to +0, so there must be
> an ENDBR there. The compiler doesn't know about FineIBT at all; also
> it is possible to actually use kCFI+IBT when booting with 'cfi=kcfi'
> on IBT enabled hardware.
> 
> Having this second ENDBR however makes it possible to elide the CFI
> check. Therefore, we should poison this second ENDBR when switching to
> FineIBT mode.
> 
> Fixes: 931ab63664f0 ("x86/ibt: Implement FineIBT")
> Reported-by: "Milburn, Alyssa" <alyssa.milburn@intel.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
> Link: https://lore.kernel.org/r/20230615193722.194131053@infradead.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>

If you take this patch you should also take the patches from Brian that
moves ret_from_fork() into C, otherwise you end up with a non-bootable
kernel.
