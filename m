Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A0A368D50;
	Fri, 19 Jun 2026 09:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781862460; cv=none; b=ZoOigBGzGsIlhjonJc6bs0XaQWORHy2LKBAfPIYOJTPE5txAcMQxZXElcYd43vZoc/0KanQfXjJCaAa0N8Mr3WU8XOrBVWjkUh0AGS//Tm+iUL4S9418/fH+Kp7+IBrF3jmXs+qhRQFNLMftiygHruqqoVXtSpLBWb004wtm0K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781862460; c=relaxed/simple;
	bh=ZjGZz97bts9x23vlxD6rAPcICjkxcr/8Lla/mojmJR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gnqgl83wHMMV5y+Dt+HMMFEMgiVsrc1MD3qMzQ83PyUEZOycr/KSfekuXXzWl+wDvr7uLwZl3bx4P8s5jFGzea02UbyK+YBW/9h2sANnf6oReg0qom75xPWMDj+OD+/GeQoUd1DRyw7G/me+V7SzTA3o3aJDM0eESGnHX7bPECk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QtQL8jN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QtQL8jN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2921F1F000E9;
	Fri, 19 Jun 2026 09:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781862453;
	bh=QEMo0EZhEJJGpmMRR680Dyf19MrtzkD+WeDdFbsfCJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=0QtQL8jNkm5I3ucIPQinQQGdPaz3Ybc+iWOD6GB7oN4OwgRDYV3O/owETstFnn/cf
	 C0i08bdYbH1/4CFgd7YvZTsi+q5GsBT4mfGKei7w5qRaYBohWS56NA+lDfFF6oBuq+
	 45991b9EPcNERKqkbxrxTl87EsAAdP7kOEW44l4w=
Date: Fri, 19 Jun 2026 11:46:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>, Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>, Sasha Levin <sashal@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 009/411] nfc: llcp: Fix use-after-free race in
 nfc_llcp_recv_cc()
Message-ID: <2026061902-upside-resolute-a706@gregkh>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145100.851905886@linuxfoundation.org>
 <65070920-961c-4567-badd-cd4b2f264e34@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65070920-961c-4567-badd-cd4b2f264e34@oracle.com>

On Thu, Jun 18, 2026 at 10:56:13PM +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> 
> On 16/06/26 20:24, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Lee Jones <lee@kernel.org>
> > 
> > [ Upstream commit b493ea2765cc17cb8aa7e7544a4b6dcb05b6ed77 ]
> > 
> > A race condition exists in the NFC LLCP connection state machine where
> > the connection acceptance packet (CC) can be processed concurrently with
> > socket release.  This can lead to a use-after-free of the socket object.
> > 
> 
> ^^ let's remember this: race between acceptance packet(receive) and socket
> release.
> 
> > When nfc_llcp_recv_cc() moves the socket from the connecting_sockets
> > list to the sockets list, it does so without holding the socket lock.
> > If llcp_sock_release() is executing concurrently, it might have already
> > unlinked the socket and dropped its references, which can result in
> > nfc_llcp_recv_cc() linking a freed socket into the live list.
> > 
> > Fix this by holding lock_sock() during the state transition and list
> > movement in nfc_llcp_recv_cc().  After acquiring the lock, check if
> > the socket is still hashed to ensure it hasn't already been unlinked
> > and marked for destruction by the release path.  This aligns the locking
> > pattern with recv_hdlc() and recv_disc().
> > 
> > Fixes: a69f32af86e3 ("NFC: Socket linked list")
> > Signed-off-by: Lee Jones <lee@kernel.org>
> > Reviewed-by: Simon Horman <horms@kernel.org>
> > Link: https://patch.msgid.link/20260429134115.3558604-2-lee@kernel.org
> > Signed-off-by: David Heidelberg <david@ixit.cz>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   net/nfc/llcp_core.c | 11 +++++++++++
> >   1 file changed, 11 insertions(+)
> > 
> > diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
> > index e04634f22b49f4..c7de44637e0187 100644
> > --- a/net/nfc/llcp_core.c
> > +++ b/net/nfc/llcp_core.c
> > @@ -1225,6 +1225,15 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
> >   	sk = &llcp_sock->sk;
> > +	lock_sock(sk);
> > +
> > +	/* Check if socket was destroyed whilst waiting for the lock */
> > +	if (!sk_hashed(sk)) {
> > +		release_sock(sk);
> > +		nfc_llcp_sock_put(llcp_sock);
> > +		return;
> > +	}
> > +
> >   	/* Unlink from connecting and link to the client array */
> >   	nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
> >   	nfc_llcp_sock_link(&local->sockets, sk);
> > @@ -1236,6 +1245,8 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local,
> >   	sk->sk_state = LLCP_CONNECTED;
> >   	sk->sk_state_change(sk);
> > +	release_sock(sk);
> > +
> 
> 
> I ran an AI assisted backport review over the 5.15.210 queue and then
> checked this one manually. I think the 5.15.y backport of:
> 
> This backport is still incomplete.
> 
> Upstream b493ea2765cc has the release-side list unlink covered by
> lock_sock(sk):
> 
> net/nfc/llcp_sock.c:    .release        = llcp_sock_release,
> ^ release socket function
> 
> lets see: llcp_sock_release()
> 
>         lock_sock(sk);
> 
>         if (sock->type == SOCK_RAW)
>                 nfc_llcp_sock_unlink(&local->raw_sockets, sk);
>         else if (sk->sk_state == LLCP_CONNECTING)
>                 nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
>         else
>                 nfc_llcp_sock_unlink(&local->sockets, sk);
> 
>         release_sock(sk);
> 
> So unlinking happened within lock_sock()
> 
> But final 5.15.y still drops the socket lock before the unlink:
> 
>         release_sock(sk);
> 
>         if (sk->sk_state == LLCP_DISCONNECTING)
>                 return err;
> 
>         if (sock->type == SOCK_RAW)
>                 nfc_llcp_sock_unlink(&local->raw_sockets, sk);
>         else if (sk->sk_state == LLCP_CONNECTING)
>                 nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
>         else
>                 nfc_llcp_sock_unlink(&local->sockets, sk);
> 
>                 nfc_llcp_sock_unlink(&local->sockets, sk);
> 
>         release_sock(sk);
> 
> The receive-side part of the patch now takes lock_sock(sk) and checks
> sk_hashed(), but that only closes the race if release-side unlinking is
> serialized by the same socket lock.
> 
> In 5.15.y there is still a window after release_sock(sk) and before the
> unlink where nfc_llcp_recv_cc() can acquire the lock, see the socket as
> hashed ? I think we don;'t have this backport: commit: a06b8044169f ("nfc:
> llcp: protect nfc_llcp_sock_unlink() calls") in 5.15.y which might be needed
> I think. This is only 5.18 +. Maybe we could queue up this for future stable
> release ?

Yes, odd, it's only queued up for 5.10.y, and the backport there doesn't
apply here either.  Can someone provide a working copy for 5.15.y as
well?

thanks,

greg k-h
