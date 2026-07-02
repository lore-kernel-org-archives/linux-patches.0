Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0FC2DC32A;
	Thu,  2 Jul 2026 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783003190; cv=none; b=gqULMxO0lbTRN59F3berH+t9Or0mSLv9l8452bQRZCR21/tDn/JUA3ybegQUsIcJRFu/9wuBXr2O8kK/hf5KXjwoYl6U+zz3VfQKyZ9BLM9io8ba/4v2HkTFvNa6+5q/fnMPCrDbVnI0OHfayzIywkA/ihduL5WqonpkLRcG2xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783003190; c=relaxed/simple;
	bh=fYEBMirabmXKeB1v3ZmcwJ4lH8M9YpYXLzTQ7iJnCfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiA5vTsgsYHHkqwKymDOcNZPdFavXeEVsccnDbBazoNI0p/TdPi+Wjw9ylBpcTwYQYdZeeOVLq6G/JCjbSKcx5Vq6tktqlrhJSjMpHeS8ZYHSE9riPfNpaB3v4c2px1q+6uZ0Ih2rjhV1kKe9pG0VkaAXYzHwF8PWRvJFQVL9GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DsI6A1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DsI6A1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DF41F00A3A;
	Thu,  2 Jul 2026 14:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783003188;
	bh=UCUJdTJpT7f09szL+2gxcKtIDYIyqEyKIcCcY55YSM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=1DsI6A1tiaEVIklcJS7me4pfPf5WG7K+21xDxbXWZf/TnWCEv+G2NFNCXpjpxm0qy
	 t4mJDBfUNTfRVrSOCZj73++e6SzRr+uy/AcsbteWIxPrEIMAExT/lwlTjAepxz+y7w
	 e6PLLLbNhzU6rt10jVvwTthduOZCGhqvPcusoCd0=
Date: Thu, 2 Jul 2026 16:39:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lee Jones <lee@kernel.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>, David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 009/411] nfc: llcp: Fix use-after-free race in
 nfc_llcp_recv_cc()
Message-ID: <2026070215-gore-empirical-accb@gregkh>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145100.851905886@linuxfoundation.org>
 <65070920-961c-4567-badd-cd4b2f264e34@oracle.com>
 <2026061902-upside-resolute-a706@gregkh>
 <20260702143500.GQ2108533@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702143500.GQ2108533@google.com>

On Thu, Jul 02, 2026 at 03:35:00PM +0100, Lee Jones wrote:
> On Fri, 19 Jun 2026, Greg Kroah-Hartman wrote:
> 
> > On Thu, Jun 18, 2026 at 10:56:13PM +0530, Harshit Mogalapalli wrote:
> > > Hi Greg/Sasha,
> > > 
> > > 
> > > On 16/06/26 20:24, Greg Kroah-Hartman wrote:
> > > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Lee Jones <lee@kernel.org>
> > > > 
> > > > [ Upstream commit b493ea2765cc17cb8aa7e7544a4b6dcb05b6ed77 ]
> > > > 
> > > > A race condition exists in the NFC LLCP connection state machine where
> > > > the connection acceptance packet (CC) can be processed concurrently with
> > > > socket release.  This can lead to a use-after-free of the socket object.
> > > > 
> > > 
> > > ^^ let's remember this: race between acceptance packet(receive) and socket
> > > release.
> > > 
> > > > When nfc_llcp_recv_cc() moves the socket from the connecting_sockets
> > > > list to the sockets list, it does so without holding the socket lock.
> > > > If llcp_sock_release() is executing concurrently, it might have already
> > > > unlinked the socket and dropped its references, which can result in
> > > > nfc_llcp_recv_cc() linking a freed socket into the live list.
> > > > 
> > > > Fix this by holding lock_sock() during the state transition and list
> > > > movement in nfc_llcp_recv_cc().  After acquiring the lock, check if
> > > > the socket is still hashed to ensure it hasn't already been unlinked
> > > > and marked for destruction by the release path.  This aligns the locking
> > > > pattern with recv_hdlc() and recv_disc().
> > > > 
> > > > Fixes: a69f32af86e3 ("NFC: Socket linked list")
> > > > Signed-off-by: Lee Jones <lee@kernel.org>
> > > > Reviewed-by: Simon Horman <horms@kernel.org>
> > > > Link: https://patch.msgid.link/20260429134115.3558604-2-lee@kernel.org
> > > > Signed-off-by: David Heidelberg <david@ixit.cz>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >   net/nfc/llcp_core.c | 11 +++++++++++
> > > >   1 file changed, 11 insertions(+)
> > > > 
> > > > diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
> > > > index e04634f22b49f4..c7de44637e0187 100644
> > > > --- a/net/nfc/llcp_core.c
> > > > +++ b/net/nfc/llcp_core.c
> > > > @@ -1225,6 +1225,15 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
> > > >   	sk = &llcp_sock->sk;
> > > > +	lock_sock(sk);
> > > > +
> > > > +	/* Check if socket was destroyed whilst waiting for the lock */
> > > > +	if (!sk_hashed(sk)) {
> > > > +		release_sock(sk);
> > > > +		nfc_llcp_sock_put(llcp_sock);
> > > > +		return;
> > > > +	}
> > > > +
> > > >   	/* Unlink from connecting and link to the client array */
> > > >   	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
> > > >   	nfc_llcp_sock_link(&local->sockets, sk);
> > > > @@ -1236,6 +1245,8 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
> > > >   	sk->sk_state = LLCP_CONNECTED;
> > > >   	sk->sk_state_change(sk);
> > > > +	release_sock(sk);
> > > > +
> > > 
> > > 
> > > I ran an AI assisted backport review over the 5.15.210 queue and then
> > > checked this one manually. I think the 5.15.y backport of:
> > > 
> > > This backport is still incomplete.
> > > 
> > > Upstream b493ea2765cc has the release-side list unlink covered by
> > > lock_sock(sk):
> > > 
> > > net/nfc/llcp_sock.c:    .release        = llcp_sock_release,
> > > ^ release socket function
> > > 
> > > lets see: llcp_sock_release()
> > > 
> > >         lock_sock(sk);
> > > 
> > >         if (sock->type == SOCK_RAW)
> > >                 nfc_llcp_sock_unlink(&local->raw_sockets, sk);
> > >         else if (sk->sk_state == LLCP_CONNECTING)
> > >                 nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
> > >         else
> > >                 nfc_llcp_sock_unlink(&local->sockets, sk);
> > > 
> > >         release_sock(sk);
> > > 
> > > So unlinking happened within lock_sock()
> > > 
> > > But final 5.15.y still drops the socket lock before the unlink:
> > > 
> > >         release_sock(sk);
> > > 
> > >         if (sk->sk_state == LLCP_DISCONNECTING)
> > >                 return err;
> > > 
> > >         if (sock->type == SOCK_RAW)
> > >                 nfc_llcp_sock_unlink(&local->raw_sockets, sk);
> > >         else if (sk->sk_state == LLCP_CONNECTING)
> > >                 nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
> > >         else
> > >                 nfc_llcp_sock_unlink(&local->sockets, sk);
> > > 
> > >                 nfc_llcp_sock_unlink(&local->sockets, sk);
> > > 
> > >         release_sock(sk);
> > > 
> > > The receive-side part of the patch now takes lock_sock(sk) and checks
> > > sk_hashed(), but that only closes the race if release-side unlinking is
> > > serialized by the same socket lock.
> > > 
> > > In 5.15.y there is still a window after release_sock(sk) and before the
> > > unlink where nfc_llcp_recv_cc() can acquire the lock, see the socket as
> > > hashed ? I think we don;'t have this backport: commit: a06b8044169f ("nfc:
> > > llcp: protect nfc_llcp_sock_unlink() calls") in 5.15.y which might be needed
> > > I think. This is only 5.18 +. Maybe we could queue up this for future stable
> > > release ?
> > 
> > Yes, odd, it's only queued up for 5.10.y, and the backport there doesn't
> > apply here either.  Can someone provide a working copy for 5.15.y as
> > well?
> 
> Oh, that's odd!  Looks like a processing error.
> 
> Look what it does to my scanner:
> 
> stable/linux-5.10.y:
> df55a16dd855 nfc: llcp: protect nfc_llcp_sock_unlink() calls [5.10.259]
> 
> stable/linux-5.15.y:
> [5.15.210]                                                   <---- WHAT?
> 
> stable/linux-6.1.y:
> a06b8044169f nfc: llcp: protect nfc_llcp_sock_unlink() calls
> 
> stable/linux-6.6.y:
> a06b8044169f nfc: llcp: protect nfc_llcp_sock_unlink() calls
> 
> stable/linux-6.12.y:
> a06b8044169f nfc: llcp: protect nfc_llcp_sock_unlink() calls
> 
> stable/linux-6.18.y:
> a06b8044169f nfc: llcp: protect nfc_llcp_sock_unlink() calls
> 
> stable/master:
> a06b8044169f nfc: llcp: protect nfc_llcp_sock_unlink() calls
> 
> So it appears as though the fix made it into the Stable queue, was aimed
> at v5.15.210, but never actually appeared in Stable.

I see it now in the 5.15.210 release as commit bd08bb7443c5 ("nfc: llcp:
Fix use-after-free race in nfc_llcp_recv_cc()")
