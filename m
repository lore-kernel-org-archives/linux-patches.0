Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7179E25C701;
	Wed,  9 Apr 2025 08:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185656; cv=none; b=K67Q74lv14dQjkAeAtwJGUzykB/6PLCIYCfFQZYlB27gnfdoKnEsqgURgICivxN73PUWCVT5cjYih53yNnr9LENQb9/rjoUGfyK/sTTln87dM+tNSCpQ/eqlOaKATNw9NQdLAT2hEInhdAMRqnrM4Q0ZPsT5xQt3pdVjtMLObxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185656; c=relaxed/simple;
	bh=cNFbzZGQopmEWLpxIC1rvjm4WZ2C/Z37DMOuDZCtwkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bcO7vUkGEPs4Z7fCiT97ezsGMPDSNltNCTDC7UQJ6JLSIMEic4ctdgy2SVy/p7rz69pSqGED9QbyeSK5m9cwNhQTw9AHTQVrCk2u4zy3OmUO8okozQBagF1AGwfKHTJvDzcy3SWdVSRK5XCzXWM6LoI1fEHzOqDJ0b+Z088Qt18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTnmEF1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTnmEF1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7002EC4CEE7;
	Wed,  9 Apr 2025 08:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744185655;
	bh=cNFbzZGQopmEWLpxIC1rvjm4WZ2C/Z37DMOuDZCtwkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YTnmEF1sYRyFozVxUU8/0NFi/QGC8XXexSTraGqWtVVrEoGwoekya/EyHerY1sHfw
	 scUOhAhntgnIBEgel5N6BwNtdbeRccdcR53z0f5JKA6CrXZ5qIQVavkDnxP5kpWNYR
	 Rxb4Q+MWeiliWuQL+LKlPQuuomYrEs4rPJh8Bkw0=
Date: Wed, 9 Apr 2025 09:59:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 657/731] tty: serial: fsl_lpuart: use port struct
 directly to simply code
Message-ID: <2025040939-mango-aqua-e28c@gregkh>
References: <20250408104914.247897328@linuxfoundation.org>
 <20250408104929.550036400@linuxfoundation.org>
 <121a8bc5-a088-4d5c-9253-f23b197f7ef0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <121a8bc5-a088-4d5c-9253-f23b197f7ef0@kernel.org>

On Wed, Apr 09, 2025 at 08:57:58AM +0200, Jiri Slaby wrote:
> On 08. 04. 25, 12:49, Greg Kroah-Hartman wrote:
> > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sherry Sun <sherry.sun@nxp.com>
> > 
> > [ Upstream commit 3cc16ae096f164ae0c6b98416c25a01db5f3a529 ]
> > 
> > Most lpuart functions have the parameter struct uart_port *port, but
> > still use the &sport->port to get the uart_port instead of use it
> > directly, let's simply the code logic, directly use this struct instead
> > of covert it from struct sport.
> > 
> > Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
> > Link: https://lore.kernel.org/r/20250312023904.1343351-3-sherry.sun@nxp.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Stable-dep-of: e98ab45ec518 ("tty: serial: lpuart: only disable CTS instead of overwriting the whole UARTMODIR register")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/tty/serial/fsl_lpuart.c | 213 +++++++++++++++-----------------
> >   1 file changed, 102 insertions(+), 111 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
> > index 1be0bf3b2f50f..f26162d98db62 100644
> > --- a/drivers/tty/serial/fsl_lpuart.c
> > +++ b/drivers/tty/serial/fsl_lpuart.c
> ...
> > @@ -639,38 +639,36 @@ static void lpuart32_wait_bit_set(struct uart_port *port, unsigned int offset,
> >   static int lpuart_poll_init(struct uart_port *port)
> >   {
> > -	struct lpuart_port *sport = container_of(port,
> > -					struct lpuart_port, port);
> 
> Hmm, this is confusing, why does this backport embed
> 9f8fe348ac9544f6855f82565e754bf085d81f88? (And even if it does, without any
> note?)

Yeah, that is wrong.  I think it was because I fixed it up "by hand" to
get it to build properly, let me go do this properly by including both
commits to keep track of these correctly.

thanks,

greg k-h
