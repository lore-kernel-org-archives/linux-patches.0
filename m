Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D572D2E4;
	Mon, 15 May 2023 20:06:34 +0000 (UTC)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id F033392009C; Mon, 15 May 2023 21:57:30 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id E95C492009B;
	Mon, 15 May 2023 20:57:30 +0100 (BST)
Date: Mon, 15 May 2023 20:57:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Nathan Chancellor <nathan@kernel.org>
cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, ndesaulniers@google.com, 
    trix@redhat.com, linux-mips@vger.kernel.org, llvm@lists.linux.dev, 
    patches@lists.linux.dev
Subject: Re: [PATCH] MIPS: Drop unused positional parameter in
 local_irq_{dis,en}able
In-Reply-To: <20230404-mips-unused-named-parameters-v1-1-71d6c656f1de@kernel.org>
Message-ID: <alpine.DEB.2.21.2305150228520.11892@angie.orcam.me.uk>
References: <20230404-mips-unused-named-parameters-v1-1-71d6c656f1de@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 4 Apr 2023, Nathan Chancellor wrote:

> When building with clang's integrated assembler, it points out that the
> CONFIG_CPU_HAS_DIEI versions of local_irq_enable and local_irq_disable
> have a named parameter that is not used in the body of the macro and it
> thinks that $8 is a positional parameter, rather than a register:
> 
>   arch/mips/include/asm/asmmacro.h:48:2: warning: macro defined with named
> parameters which are not used in macro body, possible positional parameter found
> in body which will have no effect
>    .macro local_irq_enable reg=$8
>    ^
> 
> The comment above the function that performs this check in LLVM notes
> that the warning may trigger in this case, even though it is not
> problematic. It is easy enough to clean this up by just omitting the
> named parameter for this version of the macro, as it is entirely unused.

 You need to remove the argument from the !CONFIG_CPU_HAS_DIEI versions of 
the macros then too or otherwise we now have an inconsistent API between 
kernel configurations.

 AFAICT the only call site is in arch/mips/kernel/entry.S (and for
`local_irq_enable' only), and it doesn't supply the argument, which is why 
you could have removed it for CONFIG_CPU_HAS_DIEI at all.

 FWIW I find your reported warning questionable, there are valid reasons, 
such as the very situation here, why an argument might not be used.  It is 
only a macro after all, effectively a source code transformation tool.  
Similarly the C preprocessor does not warn about unused macro arguments.

 So IMHO your change has crippled reasonable code just to paper over a 
tool's deficiency.

  Maciej
