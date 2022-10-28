Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CE47B
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 06:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AD8C433D7;
	Fri, 28 Oct 2022 06:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666937808;
	bh=Mfi5LZ/GaWrjx99WaAT9YHNlhK3pk9tYo2kxoSYkznY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PSMONs181tMM0ZRU2vqXdSZ5m+9ZIdfeSCdcl1EhUpEY2W6+SmL5pBPwuUgOmlNR5
	 7XcRkhfOLPMJ+7UYbbY83tiXSKYbJkcOBkHy2qEByFjnA3eesbRi94uZ1Bk2Ckc+c4
	 79BAaVMDYU464gcwwMJxqQ+vuUX+HvEkfu7xeoxE=
Date: Fri, 28 Oct 2022 08:17:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: sashal@kernel.org, daniel@iogearbox.net, edumazet@google.com,
	kafai@fb.com, kuniyu@amazon.co.jp, patches@lists.linux.dev,
	stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 5.10 35/79] tcp: Add num_closed_socks to struct
 sock_reuseport.
Message-ID: <Y1t0Br1mqkhqYP8U@kroah.com>
References: <20221027165055.564998662@linuxfoundation.org>
 <20221027195349.75736-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027195349.75736-1-kuniyu@amazon.com>

On Thu, Oct 27, 2022 at 12:53:49PM -0700, Kuniyuki Iwashima wrote:
> Hi Greg, Sasha,
> 
> From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Thu, 27 Oct 2022 18:55:45 +0200
> > From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > 
> > [ Upstream commit 5c040eaf5d1753aafe12989ca712175df0b9c436 ]
> > 
> > As noted in the following commit, a closed listener has to hold the
> > reference to the reuseport group for socket migration. This patch adds a
> > field (num_closed_socks) to struct sock_reuseport to manage closed sockets
> > within the same reuseport group. Moreover, this and the following commits
> > introduce some helper functions to split socks[] into two sections and keep
> > TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
> > queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
> > sockets from the end.
> > 
> >   TCP_LISTEN---------->       <-------TCP_CLOSE
> >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> >   | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
> >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> > 
> >   i = num_socks - 1
> >   j = max_socks - num_closed_socks
> >   k = max_socks - 1
> > 
> > This patch also extends reuseport_add_sock() and reuseport_grow() to
> > support num_closed_socks.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > Link: https://lore.kernel.org/bpf/20210612123224.12525-3-kuniyu@amazon.co.jp
> > Stable-dep-of: 69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I think this patch is backported due to a conflict with the cited commit
> 69421bf98482 ("udp: Update reuse->has_conns under reuseport_lock.").
> 
> The following patch seems to conflicts with some functions which are
> introduced in this patch, but the cited commit does not depend on the
> functions.
> 
> So, we can just remove the functions in this patch and resolve the
> conflict in the next patch like below. (based on the v5.10.150 branch)

so drop this "dependent" patch and just take your backport instead?

confused,

greg k-h
