Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6584D227EBF;
	Wed, 12 Mar 2025 07:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741765662; cv=none; b=TDw4DTDORjFNKsSLDiXu6ugJLpfGk3ISwCii3SulvYplPcNPneLSVPV8z91o5T//CjlugtvygvV64uL9OQdWWdVTtRlE0pivblfr03PRnv5eYcAxTfRTGVKKc/LInBsn9YEONR0vzrZ5ZiIdkXMht8oCLnYknKrGNNmUcrmPfWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741765662; c=relaxed/simple;
	bh=BP9G0qTmZPYH3B4bTHizt2Jx3HTmCOMSB/BGpNY9oxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U93fjxt4QpP+7sqn0aM5AXPwEYP+l6N0Ag7+bsq6uHOBvVwvJ8DSOSZaAEkl/t13TanffWqRNDlKQ8pFNhz2TejRUB7qiIO6zufgvQ9zkJHIyy8akbLKANbPOjSn78n/eTjTZ55vfppoymu5kzJTADm/2qn6U9UfoF9USzYC3eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDo0Vgb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDo0Vgb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77366C4CEE3;
	Wed, 12 Mar 2025 07:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741765661;
	bh=BP9G0qTmZPYH3B4bTHizt2Jx3HTmCOMSB/BGpNY9oxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LDo0Vgb8eX5iUtE7KljL74Ux34udNYPADsu1cic0Vn3/XCsbFRteJIG2ebGG7/xEt
	 UljCSNSd/5RETiRpeLx9aqqvsOnplUrxE2SvL/5KVKJh9J4VbpKfJ2t6L1HSObDur7
	 3R2qrPCgLvqznyFaAwTwumBa53t1ocKDjFqzYNa4=
Date: Wed, 12 Mar 2025 08:47:39 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>, Baoquan He <bhe@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Ard Biesheuvel <ardb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] [PATCH 6.13 089/443] x86/kexec: Allocate PGD for
 x86_64 transition page tables separately
Message-ID: <2025031203-scoring-overpass-0e1a@gregkh>
References: <20250213142440.609878115@linuxfoundation.org>
 <20250213142444.044525855@linuxfoundation.org>
 <c4a1af46f7edcdf20274e384ec3b48781a350aaa.camel@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4a1af46f7edcdf20274e384ec3b48781a350aaa.camel@infradead.org>

On Tue, Mar 11, 2025 at 04:45:26PM +0100, David Woodhouse wrote:
> On Thu, 2025-02-13 at 15:24 +0100, Greg Kroah-Hartman wrote:
> > 6.13-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: David Woodhouse <dwmw@amazon.co.uk>
> > 
> > [ Upstream commit 4b5bc2ec9a239bce261ffeafdd63571134102323 ]
> > 
> > Now that the following fix:
> > 
> >   d0ceea662d45 ("x86/mm: Add _PAGE_NOPTISHADOW bit to avoid updating userspace page tables")
> > 
> > stops kernel_ident_mapping_init() from scribbling over the end of a
> > 4KiB PGD by assuming the following 4KiB will be a userspace PGD,
> > there's no good reason for the kexec PGD to be part of a single
> > 8KiB allocation with the control_code_page.
> > 
> > ( It's not clear that that was the reason for x86_64 kexec doing it that
> >   way in the first place either; there were no comments to that effect and
> >   it seems to have been the case even before PTI came along. It looks like
> >   it was just a happy accident which prevented memory corruption on kexec. )
> > 
> > Either way, it definitely isn't needed now. Just allocate the PGD
> > separately on x86_64, like i386 already does.
> 
> No objection (which is just as well given how late I am in replying)
> but I'm just not sure *why*. This doesn't fix a real bug; it's just a
> cleanup.
> 
> Does this mean I should have written my original commit message better,
> to make it clearer that this *isn't* a bugfix?

Yes, that's why it was picked up.

