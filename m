Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CC2253CD
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 19:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E71C433C8;
	Mon, 17 Jul 2023 19:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689621604;
	bh=yQ03Pj8w9c5kxd+GGd4sj5+8eCj5b/jcdqbOwa4XQOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cvWHW2NEIvq9Rm+OnrSpwbFzSfwd8FtYrcWe1cz8INzFjiqAcYU7vYoPbd6Hmfr8A
	 29YuTtWyKicfY9nj6s8JCjJhAV2ZAaDdzyiyCZw+W2ce8qslBtPBEC153+4g1kuJGk
	 yHHue+ULpb7f3ErouJVHT5W5Kcex67e1DPnWKig0=
Date: Mon, 17 Jul 2023 21:20:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>, linux-stable <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Jakub Kacinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6.4 118/800] net/handshake: Unpin sock->file if a
 handshake is cancelled
Message-ID: <2023071704-grimacing-railroad-3ee3@gregkh>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716194951.848894569@linuxfoundation.org>
 <6B82BD28-1891-499A-8721-1567612EF553@oracle.com>
 <2023071733-eligibly-altitude-4050@gregkh>
 <1043C933-AE94-4B30-A4BD-4174AA9FCC33@oracle.com>
 <2023071713-composer-consensus-7283@gregkh>
 <FFF06800-6943-4EE4-ACB8-DDA20EE0339A@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FFF06800-6943-4EE4-ACB8-DDA20EE0339A@oracle.com>

On Mon, Jul 17, 2023 at 07:06:37PM +0000, Chuck Lever III wrote:
> 
> 
> > On Jul 17, 2023, at 2:53 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > On Mon, Jul 17, 2023 at 05:55:46PM +0000, Chuck Lever III wrote:
> >> 
> >> 
> >>> On Jul 17, 2023, at 1:10 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >>> 
> >>> On Sun, Jul 16, 2023 at 08:43:58PM +0000, Chuck Lever III wrote:
> >>>> 
> >>>> 
> >>>>> On Jul 16, 2023, at 3:39 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >>>>> 
> >>>>> From: Chuck Lever <chuck.lever@oracle.com>
> >>>>> 
> >>>>> [ Upstream commit f921bd41001ccff2249f5f443f2917f7ef937daf ]
> >>>>> 
> >>>>> If user space never calls DONE, sock->file's reference count remains
> >>>>> elevated. Enable sock->file to be freed eventually in this case.
> >>>>> 
> >>>>> Reported-by: Jakub Kacinski <kuba@kernel.org>
> >>>>> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> >>>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> >>>>> Signed-off-by: David S. Miller <davem@davemloft.net>
> >>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >>>>> ---
> >>>>> net/handshake/handshake.h | 1 +
> >>>>> net/handshake/request.c   | 4 ++++
> >>>>> 2 files changed, 5 insertions(+)
> >>>>> 
> >>>>> diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
> >>>>> index 4dac965c99df0..8aeaadca844fd 100644
> >>>>> --- a/net/handshake/handshake.h
> >>>>> +++ b/net/handshake/handshake.h
> >>>>> @@ -31,6 +31,7 @@ struct handshake_req {
> >>>>> struct list_head hr_list;
> >>>>> struct rhash_head hr_rhash;
> >>>>> unsigned long hr_flags;
> >>>>> + struct file *hr_file;
> >>>>> const struct handshake_proto *hr_proto;
> >>>>> struct sock *hr_sk;
> >>>>> void (*hr_odestruct)(struct sock *sk);
> >>>>> diff --git a/net/handshake/request.c b/net/handshake/request.c
> >>>>> index 94d5cef3e048b..d78d41abb3d99 100644
> >>>>> --- a/net/handshake/request.c
> >>>>> +++ b/net/handshake/request.c
> >>>>> @@ -239,6 +239,7 @@ int handshake_req_submit(struct socket *sock, struct handshake_req *req,
> >>>>> }
> >>>>> req->hr_odestruct = req->hr_sk->sk_destruct;
> >>>>> req->hr_sk->sk_destruct = handshake_sk_destruct;
> >>>>> + req->hr_file = sock->file;
> >>>>> 
> >>>>> ret = -EOPNOTSUPP;
> >>>>> net = sock_net(req->hr_sk);
> >>>>> @@ -334,6 +335,9 @@ bool handshake_req_cancel(struct sock *sk)
> >>>>> return false;
> >>>>> }
> >>>>> 
> >>>>> + /* Request accepted and waiting for DONE */
> >>>>> + fput(req->hr_file);
> >>>>> +
> >>>>> out_true:
> >>>>> trace_handshake_cancel(net, req, sk);
> >>>>> 
> >>>>> -- 
> >>>>> 2.39.2
> >>>>> 
> >>>>> 
> >>>>> 
> >>>> 
> >>>> Don't take this one. It's fixed by a later commit:
> >>>> 
> >>>> 361b6889ae636926cdff517add240c3c8e24593a
> >>>> 
> >>>> that reverts it.
> >>> 
> >>> How?  That commit is in 6.4 already, yet this commit, is from 6.5-rc1.
> >> 
> >> I do not see f921bd41001ccff2249f5f443f2917f7ef937daf in v6.5-rc2.
> >> Whatever that is, it's not in upstream.
> > 
> > I see it:
> > $ git describe --contains f921bd41001ccff2249f5f443f2917f7ef937daf
> > v6.5-rc1~163^2~292^2~1
> > $ git show --oneline f921bd41001ccff2249f5f443f2917f7ef937daf | head -n 1
> > f921bd41001c net/handshake: Unpin sock->file if a handshake is cancelled
> 
> Yes, I see it too, it's in the repo. But it's not in the commit
> history of tag v6.5-rc2, and the source tree, as of v6.5-rc2,
> does not have that change.
> 
> 
> > $ git describe  --contains 361b6889ae636926cdff517add240c3c8e24593a
> > v6.4-rc7~17^2~14
> > $ git show --oneline 361b6889ae636926cdff517add240c3c8e24593a | head -n 1
> > 361b6889ae63 net/handshake: remove fput() that causes use-after-free
> > 
> > So commit 361b6889ae63 ("net/handshake: remove fput() that causes
> > use-after-free") came into 6.4-rc7, and commit f921bd41001c
> > ("net/handshake: Unpin sock->file if a handshake is cancelled") came
> > into 6.5-rc1.
> 
> f921bd41001c isn't in 6.5-rc at all, according to the commit history.
> 
> 
> >> [cel@manet server-development]$ git log --pretty=oneline v6.5-rc2 -- net/handshake/

I think the issue is that you are comparing it to the current state of
net/handshake, if you look overall at the log, you will see it:

$ git log --pretty=oneline v6.5-rc2 | grep f921bd41001ccff2249f5f443f2917f7ef937daf
f921bd41001ccff2249f5f443f2917f7ef937daf net/handshake: Unpin sock->file if a handshake is cancelled

Or just a normal "git log" will also show it.

There is a way to say "ignore the current state of the directory I'm
asking for the log for, and just give me all the commits that touched
it" but I can't ever remember the option to git log for it.

Ah, it's the --full-history option:

$ git log --pretty=oneline --full-history v6.5-rc2 -- net/handshake/ | grep f921bd41001ccff2249f5f443f2917f7ef937daf 
f921bd41001ccff2249f5f443f2917f7ef937daf net/handshake: Unpin sock->file if a handshake is cancelled

So yes, it's really there.  Read the "History Simplification" section in
the git log manpage for all the details as to why it didn't show up in
your command.  And one day I'll actually remember that option...

thanks,

greg k-h
