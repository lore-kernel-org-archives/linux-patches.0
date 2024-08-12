Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849CD17F374;
	Mon, 12 Aug 2024 14:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472100; cv=none; b=Vpo/muQMxky4utbSSt/KMj3v3Dop5JKmUXjwgfmlrOLUN1bpHpp//9+xHIFQ/F56SA789rw/JwRShS9MY+yRYcTPSfsWZLDHj8sxpWfj8mIyyRI9gbhC9heU2bw0erOStsdurSZqERktVkZ7F+tp7JmgxfmpsMo4PmSd80QWmdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472100; c=relaxed/simple;
	bh=Mf9MWhFyYbzVINlzv6FKeHPyHTmdX3u5SbDSoZNTbcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uklM85HJV0fCwmQbZbwXpMYusFeWJxgwNZRqxtOYpkUQRzNFKEH5HV2zZ3Kc4E20auPrIa5+QtBg6z8yQngCeKPx/YMFle5w5xbQy4ibhRJi1RX/uEhhLSsWVGEalzew9oTahvGkzpLVKaU/tuCXhclSOTmswgqksNJDD7sUlEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6K2wy+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6K2wy+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6988EC4AF09;
	Mon, 12 Aug 2024 14:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723472100;
	bh=Mf9MWhFyYbzVINlzv6FKeHPyHTmdX3u5SbDSoZNTbcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c6K2wy+rQqVrEa/c5Oh0ml+VhsrGEJRwt0p/R7TDip+BGbiVGXMDMmkTBsVz5f25b
	 mzeU674AV8b9uIuwMaHJtkaOUT1i0Knuqw0tC5hgQQTXKoUhIE68AHqPnSzpQtGN1U
	 1s0TfH1kTsWm6BPLnzoojQAmYDas5SETQM04ZusA=
Date: Mon, 12 Aug 2024 16:14:57 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, cve@kernel.org, patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Yves-Alexis Perez <corsac@debian.org>,
	David Hildenbrand <david@redhat.com>,
	Christoph Lameter <cl@linux.com>, Jiri Slaby <jirislaby@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.10 534/809] mm: huge_memory: use !CONFIG_64BIT to relax
 huge page alignment on 32 bit machines
Message-ID: <2024081236-cane-protract-7ea8@gregkh>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151745.829576651@linuxfoundation.org>
 <d294468326cb036ca5f47697e28860530de12ce7.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d294468326cb036ca5f47697e28860530de12ce7.camel@decadent.org.uk>

On Sun, Aug 04, 2024 at 01:46:45AM +0200, Ben Hutchings wrote:
> On Tue, 2024-07-30 at 17:46 +0200, Greg Kroah-Hartman wrote:
> > 6.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Yang Shi <yang@os.amperecomputing.com>
> > 
> > commit d9592025000b3cf26c742f3505da7b83aedc26d5 upstream.
> > 
> > Yves-Alexis Perez reported commit 4ef9ad19e176 ("mm: huge_memory: don't
> > force huge page alignment on 32 bit") didn't work for x86_32 [1].  It is
> > because x86_32 uses CONFIG_X86_32 instead of CONFIG_32BIT.
> > 
> > !CONFIG_64BIT should cover all 32 bit machines.
> > 
> > [1] https://lore.kernel.org/linux-mm/CAHbLzkr1LwH3pcTgM+aGQ31ip2bKqiqEQ8=FQB+t2c3dhNKNHA@mail.gmail.com/
> > 
> > Link: https://lkml.kernel.org/r/20240712155855.1130330-1-yang@os.amperecomputing.com
> > Fixes: 4ef9ad19e176 ("mm: huge_memory: don't force huge page alignment on 32 bit")
> [...]
> 
> The original breakage actually occurred in 5.18 with this commit:
> 
> commit 1854bc6e2420472676c5c90d3d6b15f6cd640e40
> Author: William Kucharski <william.kucharski@oracle.com>
> Date:   Sun Sep 22 08:43:15 2019 -0400
>  
>     mm/readahead: Align file mappings for non-DAX
> 
> The previous fix referred to above (commit 4ef9ad19e176) was already
> backported to 6.1 and 6.7, and CVE-2024-26621 was assigned to the bug.
> 
> This new fix also needs to be applied to 6.1.  *Both* fixes need to be
> applied to 6.6 since the previous fix missed this branch.
> 
> I believe a new CVE ID also needs to be assigned to cover the
> architectures missed in the previous fix.  So far as I can see, the
> only architectures supporting huge pages on 32-bit CPUs (as of
> 6.11-rc1) are arc, arm, mips, and x86.  Of those only mips defines
> CONFIG_32BIT in 32-bit configurations, and was covered by the previous
> fix.  The other three are covered by the new fix.
> 
> To summarise:
> 
> CVE-2024-26621:
> - covers 64-bit compat and mips32 native
> - fixed by commit 4ef9ad19e176
> - fix is needed in 6.6

Now queued up for 6.6.y, thanks.

> CVE ID to be assigned:
> - covers arc, arm, and x86_32 native
> - fixed by commit d9592025000b
> - fix is needed in 6.1 and 6.6

Now queued up, I'll go assign a CVE now, thanks!

greg k-h
