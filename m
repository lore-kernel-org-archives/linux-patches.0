Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EE52E6125;
	Sun, 19 Oct 2025 12:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760875294; cv=none; b=mhPE4hkmQ94lxqakC7uBy0S1lNBg/AuG/3D8kagoWKySHl8sqm8BoCoNnaqQHe6SG+AmItCPNAAz+l/kaZnURyJBUAVgYwYHRKN/vwoVp61l3K24D2M8RQ2bGTDat90kMSAkURpgQp71BVfEiQkI5L6FXIUYIAlsvarrci8FfI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760875294; c=relaxed/simple;
	bh=TTxwvQyOVqErAIoH8fxE+YSwdCFMmjrOadeq4ArpzsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/9DyrrvRBc3plKwSmF3dcpm+OhyELAm1Ni0nP3iqc3eAUV/lB6ml6IBJzZs7sgVocfX4nmjFvMa5an6ou3Oyfl3QryfdKj9kYtf7V/DrLbeKzd1XmuJQytkB/aWmoxC2ZABZUlGWzKVxotF1r8vY7NtfK++gBxFwMGvwpLhyfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hy6w/A3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hy6w/A3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1905AC4CEE7;
	Sun, 19 Oct 2025 12:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760875293;
	bh=TTxwvQyOVqErAIoH8fxE+YSwdCFMmjrOadeq4ArpzsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hy6w/A3kZUQABhEawPKHqWNJpMuER8aYAv2rffpVe3g/5dt8A21mxw9dVJrCFGQ+n
	 wlFXUrXouDMIQ5rp5BkMKb2aAEM19syXpePjQk+HJvOOmfk9Yhlv8NcGz9qSpH/RQZ
	 tudCyFdM2vX86U1vKyxuMREA25ACoZiUs2FGARMY=
Date: Sun, 19 Oct 2025 14:01:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.17 254/371] riscv: use an atomic xchg in
 pudp_huge_get_and_clear()
Message-ID: <2025101916-oppressed-musket-dcc6@gregkh>
References: <20251017145201.780251198@linuxfoundation.org>
 <20251017145211.272190287@linuxfoundation.org>
 <ad3fbd1a-2226-40fa-97be-f5364aa917d1@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad3fbd1a-2226-40fa-97be-f5364aa917d1@kernel.org>

On Fri, Oct 17, 2025 at 08:13:27PM +0200, Jiri Slaby wrote:
> On 17. 10. 25, 16:53, Greg Kroah-Hartman wrote:
> > 6.17-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Alexandre Ghiti <alexghiti@rivosinc.com>
> > 
> > commit 668208b161a0b679427e7d0f34c0a65fd7d23979 upstream.
> > 
> > Make sure we return the right pud value and not a value that could have
> > been overwritten in between by a different core.
> > 
> > Link: https://lkml.kernel.org/r/20250814-dev-alex-thp_pud_xchg-v1-1-b4704dfae206@rivosinc.com
> > Fixes: c3cc2a4a3a23 ("riscv: Add support for PUD THP")
> > Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> > Cc: Andrew Donnellan <ajd@linux.ibm.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   arch/riscv/include/asm/pgtable.h |   11 +++++++++++
> >   1 file changed, 11 insertions(+)
> > 
> > --- a/arch/riscv/include/asm/pgtable.h
> > +++ b/arch/riscv/include/asm/pgtable.h
> > @@ -959,6 +959,17 @@ static inline pud_t pudp_huge_get_and_cl
> >   	return pud;
> >   }
> > +#define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
> > +static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
> > +					    unsigned long address, pud_t *pudp)
> > +{
> > +	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
> > +
> > +	page_table_check_pud_clear(mm, pud);
> > +
> > +	return pud;
> > +}
> 
> With the above, I see:
> [  321s] In file included from ../include/linux/pgtable.h:6,
> [  321s]                  from ../include/linux/mm.h:31,
> [  321s]                  from ../arch/riscv/kernel/asm-offsets.c:8:
> [  321s] ../arch/riscv/include/asm/pgtable.h:963:21: error: redefinition of
> ‘pudp_huge_get_and_clear’
> [  321s]   963 | static inline pud_t pudp_huge_get_and_clear(struct
> mm_struct *mm,
> [  321s]       |                     ^~~~~~~~~~~~~~~~~~~~~~~
> [  321s] ../arch/riscv/include/asm/pgtable.h:946:21: note: previous
> definition of ‘pudp_huge_get_and_clear’ with type ‘pud_t(struct mm_struct *,
> long unsigned int,  pud_t *)’
> [  321s]   946 | static inline pud_t pudp_huge_get_and_clear(struct
> mm_struct *mm,
> [  321s]       |                     ^~~~~~~~~~~~~~~~~~~~~~~
> 

Ick, not good, I'll go drop this patch from the queue now, thanks!

greg k-h
