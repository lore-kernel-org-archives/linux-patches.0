Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2955B36403D;
	Fri, 19 Jun 2026 09:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781862367; cv=none; b=VX5TVerasx8Ifr9tbsqMBe7LBll2DUCRe2wIB+eux7gQGFakcHWCxz1Yp1z6L1F+3nj8urBLgl3xL673MFj4vPtzl+LrtrtYnlBRgwuXUxpuJkNwdPFA7vjZdDxP8cE6TiOQjeSEJoHNzCKmLHBVud9Z/++ZnZ1+R5+mQDdZ43g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781862367; c=relaxed/simple;
	bh=S9tmeL/1OjUCkFqc0VOZaamZ0oBbkjxMHXAHz+MGng0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6sfE9laDzY/5V/fbj4pkeEmj3e5/GH0eBvKOQQBbz5Oaoh092leCl+hp+fmx1gRJhBoOsl5to0ZwVyqz+ITaQYoy9mbyQtwhV0nc4wdV9e0hjrXc5GUFvwbXUzqmUcEnhELnW8d+LI9a+BTq9J4svmJi56iBu7BtZv9JdyEHkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3jxWC+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3jxWC+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF301F000E9;
	Fri, 19 Jun 2026 09:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781862363;
	bh=GF96XdAU6NzVdsopvuqGtO9HUofAIZoRNQMtaxnrKHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V3jxWC+y+8Y8WzAhNuGOBDSLDJ/q6U/1K2QWs2AOnAJUqNOqilM582MHamXu6yQCs
	 27pSx/bw5qh0+uZhdBD8PZnsPOBmMByTTTmcLbLwcMi6Syr1739k6AlABNBWGObIm+
	 pmCn16U29Sdrg+r35n0Ifp7kg6OH+vVonZYj1vF4=
Date: Fri, 19 Jun 2026 11:44:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 208/522] net: Annotate sk->sk_write_space() for UDP
 SOCKMAP.
Message-ID: <2026061944-vaseline-essence-0008@gregkh>
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145135.793184452@linuxfoundation.org>
 <6f805abf1f8b058c1b1241e8568d7539185145df.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f805abf1f8b058c1b1241e8568d7539185145df.camel@decadent.org.uk>

On Thu, Jun 18, 2026 at 04:33:49PM +0200, Ben Hutchings wrote:
> On Tue, 2026-06-16 at 20:25 +0530, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Kuniyuki Iwashima <kuniyu@google.com>
> > 
> > [ Upstream commit b748765019fe9e9234660327090fc1a9665cdbdd ]
> > 
> > UDP TX skb->destructor() is sock_wfree(), and UDP holds lock_sock()
> > only for UDP_CORK / MSG_MORE sendmsg().
> > 
> > Otherwise, sk->sk_write_space() may be read locklessly while SOCKMAP
> > rewrites sk->sk_write_space().
> > 
> > Let's use WRITE_ONCE() and READ_ONCE() for sk->sk_write_space().
> > 
> > Note that the write side is annotated by commit 2ef2b20cf4e0
> > ("net: annotate data-races around sk->sk_{data_ready,write_space}").
> [...]
> 
> That other commit hasn't yet been backported to 6.1, so this is not a
> complete fix.

True, someone needs to provide that backport as well :)

thanks,

greg k-h
