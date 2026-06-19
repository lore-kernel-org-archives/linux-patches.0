Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE50369991;
	Fri, 19 Jun 2026 09:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781863027; cv=none; b=Rr1l/GZ5UBIuTWGk/gpi7xOVsM6yvc6C2C9Cm4MTBIjB8wXDG+uMfwPjVZZTDcArgPnC7+8KPigfg0QjZNGcckeFGXAKcYyWyhdap2JsGjeRJ6cb2QXPIsSJR2njToT6SZeTRO1u55X9pk2qCf1ACgW9nipRwQ8mQedW83iXPFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781863027; c=relaxed/simple;
	bh=5nn0vOFfEC8IB7QEw+QjZpLzYA1Lz8v2GLiPO0g9xsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vEwrhz4wadRzdetUSSL13UfN5QBHesNEVIlLpnHgDhXfs+RRWwMzkrdzkVIz+0yfI1y7cB7DJYjcnRQT3w0Y8iizxWyWhsKum2p4iMAOZgvFU51NW6PjXkTWVVXneSsrZ2w5qWJ7igWf70zQV2uiGZ3cn7OHISJXbJSmc1O+m+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1GC+9f7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1GC+9f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AFB1F000E9;
	Fri, 19 Jun 2026 09:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781863020;
	bh=DiFPSAGm3QGqD5XdKFqj9fbqyoJ+B1hzp8sXWp75HQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I1GC+9f7yX3P3COKWIaUtw1Eb2qTl4squBDTA0mNPUZdzie+DoBKGfyNe7Fwe8VUH
	 hwqyaAI2x0WWuJJCe24F8dYSZwW0XbDcBhBICqV069Jcp0ypuTWj/eS1LNXsshWS41
	 zwNml85wJ2PfaRbVoTP3DK0mp1HX1aiokJ9kAmPw=
Date: Fri, 19 Jun 2026 11:55:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>, Xiang Mei <xmei5@asu.edu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 193/411] netfilter: nf_log: validate MAC header was
 set before dumping it
Message-ID: <2026061924-treat-enjoyably-08c8@gregkh>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145110.984893387@linuxfoundation.org>
 <167562b4-4472-4ead-a107-6eb83275825c@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167562b4-4472-4ead-a107-6eb83275825c@oracle.com>

On Fri, Jun 19, 2026 at 10:58:54AM +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> 
> On 16/06/26 20:27, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
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
> > Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
> > uses, and replace the open-coded MAC header length test with
> > skb_mac_header_len(). Only skbs with an unset MAC header are affected;
> > valid ones are dumped as before.
> > 
> >   BUG: KASAN: slab-out-of-bounds in dump_mac_header (net/netfilter/nf_log_syslog.c:831)
> >   Read of size 1 at addr ffff88800ea49d3f by task exploit/148
> >   Call Trace:
> >    kasan_report (mm/kasan/report.c:595)
> >    dump_mac_header (net/netfilter/nf_log_syslog.c:831)
> >    nf_log_netdev_packet (net/netfilter/nf_log_syslog.c:938 net/netfilter/nf_log_syslog.c:963)
> >    nf_log_packet (net/netfilter/nf_log.c:260)
> >    nft_log_eval (net/netfilter/nft_log.c:60)
> >    nft_do_chain (net/netfilter/nf_tables_core.c:285)
> >    nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:307)
> >    nf_hook_slow (net/netfilter/core.c:619)
> >    nf_hook_direct_egress (net/packet/af_packet.c:257)
> >    packet_xmit (net/packet/af_packet.c:280)
> >    packet_sendmsg (net/packet/af_packet.c:3114)
> >    __sys_sendto (net/socket.c:2265)
> > 
> > Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> 
> I ran an AI assisted backport review over the 5.15.210 queue, and thr report
> looks valid to me:
> 
> this 5.15.y backport fixed the IPv4 split helper but missed the equivalent
> IPv6 helper.
> 
> So we would need a 5.15.y backport slightly deviate from upstream patch.
> 
> Upstream a84b6fedbc97 uses this guard before dumping fallback MAC bytes:
> 
>         if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
>             skb_mac_header_len(skb) != 0) {
>                 const unsigned char *p = skb_mac_header(skb);
> 
> The 5.15.y IPv4 helper has that guard, but final 5.15.y still has this in
> dump_ipv6_mac_header():
> 
>         if (dev->hard_header_len &&
>             skb->mac_header != skb->network_header) {
>                 const unsigned char *p = skb_mac_header(skb);
> 
> Upstream has one shared helper, so the new guard covers both IPv4 and IPv6.
> 5.15.y still has split helpers, and the backport mapped the fix only to the
> IPv4 side. The IPv6 netdev logging path can therefore still call
> skb_mac_header(skb) after the old unsafe fallback predicate.
> 
> I think 5.15.y needs the same skb_mac_header_was_set() /
> skb_mac_header_len() guard added to dump_ipv6_mac_header(), thoughts?
> 
> And this is because 5.15.y doesn't have commit: 39ab798fc14d ("netfilter:
> nf_log_syslog: Merge MAC header dumpers") so we need a similar adaption in
> 5.15.y
> 
> I am still thinking having a TODO for these sorts of things might be worth
> it, particularly because we will miss these easily where upstream commit is
> backported(so nothing to backport from a git perspective) but that doesn't
> fit downstream perfectly(so more work to do). Btw, its just a thought :)

Yes, a TODO would be great for this type of thing, if you can come up
with a way it can be tracked/handled, I'd be all for it.

tanks,

greg k-h
