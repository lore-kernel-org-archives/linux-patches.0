Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FBB3EC2DE;
	Thu, 18 Jun 2026 11:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781781062; cv=none; b=uZp899LNMDAHFAaJ/E5Z0t9P9MUlt+JQABC5fTKy2gLBFllP1hyInSul/JwYTL+xIoFPZQ8bHE6XzxcpEt1XgTcgfKz02biTeKcTat6vAz24e+27crRFqaIKE9dhGEKarjmUyzNbFFhhiiDyy7Ra5BuOoJJr1Z+PQJHTtGiM5zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781781062; c=relaxed/simple;
	bh=VHc08RQlm2skduyrGOzG6Sm5yYaIzrhPqYDsLBcegZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVFg2SZKBLaHrW9DggraBSLmY67K8zKy99TcCz2nzOtfjOW8lYWy88ot60RSpQGI3FDprmkYeX4KieQmeJ33VuyJCtKgyqvgWffWJ1XvfDmERLoK/FG5yosZmutg1WXwuGurk/TMYyFCwNulMqMz2vLTrN3A2n+Oh9qA+iDuSH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjWnCt5x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjWnCt5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F921F00A3A;
	Thu, 18 Jun 2026 11:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781781060;
	bh=83dxZpVPhXc1E3WQioF1CMaRijrM+LA2h9R+oXG5gRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DjWnCt5xWeN/blgB9dJlM+hKZe21UmZp8qbZbZqThhns+P0STUwOciuSkkAiWD5Wf
	 P0miwIWqzb7JfANCL+kXT7BtZvVQVqEaRgesmlBudiyGBQ6hMsxT+g56ZqwQyleEUn
	 ealzZqVBwyKNDDH77l5DVqku+oMMi8H/LyZXU/h4=
Date: Thu, 18 Jun 2026 13:11:13 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>, Xiang Mei <xmei5@asu.edu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.12 100/261] netfilter: nf_log: validate MAC header was
 set before dumping it
Message-ID: <2026061823-film-pastrami-44cf@gregkh>
References: <20260616145044.869532709@linuxfoundation.org>
 <20260616145049.667194632@linuxfoundation.org>
 <ed09740a-561f-41e4-8d7b-ade8f6ae0763@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed09740a-561f-41e4-8d7b-ade8f6ae0763@oracle.com>

On Thu, Jun 18, 2026 at 04:27:58PM +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> On 16/06/26 20:28, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Xiang Mei <xmei5@asu.edu>
> > 
> > [ Upstream commit a84b6fedbc97078788be78dbdd7517d143ad1a77 ]
> > 
> > The fallback path of dump_mac_header() guards the MAC header access
> > only with "skb->mac_header != skb->network_header", without checking
> > skb_mac_header_was_set(). When the MAC header is unset, mac_header is
> > 0xffff, so the test passes and skb_mac_header(skb) returns
> > skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
> > dev->hard_header_len bytes out of bounds into the kernel log.
> > 
> > This is reachable via the netdev logger: nf_log_unknown_packet() calls
> > dump_mac_header() unconditionally, and an skb sent through AF_PACKET
> > with PACKET_QDISC_BYPASS reaches the egress hook with mac_header still
> > unset (__dev_queue_xmit(), which would reset it, is bypassed).
> > 
> 
> I have run an AI assisted backport review and it spotted an issue: I
> have taken a look and the issue goes like:
> 
> Upstream has this before the eth_hdr() users in dump_mac_header():
> 
>     if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
>         return;
> 
>     nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
>                    eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
> 
> 
> but 6.12.y still has:
> 
>       nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
>                      eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
>       nf_log_dump_vlan(m, skb);
> 
> 
> 
> 
> > Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
> > uses, and replace the open-coded MAC header length test with
> > skb_mac_header_len(). Only skbs with an unset MAC header are affected;
> > valid ones are dumped as before.
> ...
> 
> The posted backport fixes the fallback MAC dump path, but upstream only
> assumes the Ethernet decode path is already safe because of 62443dc21114
> ("netfilter: require Ethernet MAC header before using eth_hdr()"). I donot
> see that commit in 6.12.y, so NF_LOG_MACDECODE can still reach
> eth_hdr(skb) without proving the MAC header was set and long enough.
> 
> I think 6.12.y misses commit: 62443dc21114 ("netfilter: require
> Ethernet MAC header before using eth_hdr()") so this backport might not
> be complete, thoughts?
> 
> Maybe we need to backport 62443dc21114 ("netfilter: require
> Ethernet MAC header before using eth_hdr()") as well ?

So that would need to be backported to all stable queues, as that commit
showed up in 7.1, right?

Note, it was part of the AUTOSEL group, but those were dropped en-mass
as people were complaining about them.

thanks,

greg k-h
