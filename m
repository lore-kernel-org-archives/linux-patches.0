Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EE223C8
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 18:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BD5C433C9;
	Mon, 17 Jul 2023 18:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689619990;
	bh=kBxBgrZN90x1NHlKRmZ7hlwufVEjGXosjxSlmKhxlTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rqvh+9sRM2Zb4usYiuBm+VJ6mqoPHT+W1YKupoH66rkt/k+IGnknqbK1LxKNXrEeQ
	 QhwA/daNeFykYwXFhYmka9+RU4NBKtHbJLzn8hDj1DmsLJOX1zqwMOlZDb+BQkzcJF
	 XFoNs6jpKxj0mafW2HJO+17Q7Qq9AJJ5vgVLyg1s=
Date: Mon, 17 Jul 2023 20:53:06 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>, linux-stable <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Jakub Kacinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6.4 118/800] net/handshake: Unpin sock->file if a
 handshake is cancelled
Message-ID: <2023071713-composer-consensus-7283@gregkh>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716194951.848894569@linuxfoundation.org>
 <6B82BD28-1891-499A-8721-1567612EF553@oracle.com>
 <2023071733-eligibly-altitude-4050@gregkh>
 <1043C933-AE94-4B30-A4BD-4174AA9FCC33@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1043C933-AE94-4B30-A4BD-4174AA9FCC33@oracle.com>

On Mon, Jul 17, 2023 at 05:55:46PM +0000, Chuck Lever III wrote:
> 
> 
> > On Jul 17, 2023, at 1:10 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > On Sun, Jul 16, 2023 at 08:43:58PM +0000, Chuck Lever III wrote:
> >> 
> >> 
> >>> On Jul 16, 2023, at 3:39 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >>> 
> >>> From: Chuck Lever <chuck.lever@oracle.com>
> >>> 
> >>> [ Upstream commit f921bd41001ccff2249f5f443f2917f7ef937daf ]
> >>> 
> >>> If user space never calls DONE, sock->file's reference count remains
> >>> elevated. Enable sock->file to be freed eventually in this case.
> >>> 
> >>> Reported-by: Jakub Kacinski <kuba@kernel.org>
> >>> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> >>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> >>> Signed-off-by: David S. Miller <davem@davemloft.net>
> >>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >>> ---
> >>> net/handshake/handshake.h | 1 +
> >>> net/handshake/request.c   | 4 ++++
> >>> 2 files changed, 5 insertions(+)
> >>> 
> >>> diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
> >>> index 4dac965c99df0..8aeaadca844fd 100644
> >>> --- a/net/handshake/handshake.h
> >>> +++ b/net/handshake/handshake.h
> >>> @@ -31,6 +31,7 @@ struct handshake_req {
> >>> struct list_head hr_list;
> >>> struct rhash_head hr_rhash;
> >>> unsigned long hr_flags;
> >>> + struct file *hr_file;
> >>> const struct handshake_proto *hr_proto;
> >>> struct sock *hr_sk;
> >>> void (*hr_odestruct)(struct sock *sk);
> >>> diff --git a/net/handshake/request.c b/net/handshake/request.c
> >>> index 94d5cef3e048b..d78d41abb3d99 100644
> >>> --- a/net/handshake/request.c
> >>> +++ b/net/handshake/request.c
> >>> @@ -239,6 +239,7 @@ int handshake_req_submit(struct socket *sock, struct handshake_req *req,
> >>> }
> >>> req->hr_odestruct = req->hr_sk->sk_destruct;
> >>> req->hr_sk->sk_destruct = handshake_sk_destruct;
> >>> + req->hr_file = sock->file;
> >>> 
> >>> ret = -EOPNOTSUPP;
> >>> net = sock_net(req->hr_sk);
> >>> @@ -334,6 +335,9 @@ bool handshake_req_cancel(struct sock *sk)
> >>> return false;
> >>> }
> >>> 
> >>> + /* Request accepted and waiting for DONE */
> >>> + fput(req->hr_file);
> >>> +
> >>> out_true:
> >>> trace_handshake_cancel(net, req, sk);
> >>> 
> >>> -- 
> >>> 2.39.2
> >>> 
> >>> 
> >>> 
> >> 
> >> Don't take this one. It's fixed by a later commit:
> >> 
> >> 361b6889ae636926cdff517add240c3c8e24593a
> >> 
> >> that reverts it.
> > 
> > How?  That commit is in 6.4 already, yet this commit, is from 6.5-rc1.
> 
> I do not see f921bd41001ccff2249f5f443f2917f7ef937daf in v6.5-rc2.
> Whatever that is, it's not in upstream.

I see it:
	$ git describe --contains f921bd41001ccff2249f5f443f2917f7ef937daf
	v6.5-rc1~163^2~292^2~1
	$ git show --oneline f921bd41001ccff2249f5f443f2917f7ef937daf | head -n 1
	f921bd41001c net/handshake: Unpin sock->file if a handshake is cancelled

	$ git describe  --contains 361b6889ae636926cdff517add240c3c8e24593a
	v6.4-rc7~17^2~14
	$ git show --oneline 361b6889ae636926cdff517add240c3c8e24593a | head -n 1
	361b6889ae63 net/handshake: remove fput() that causes use-after-free

So commit 361b6889ae63 ("net/handshake: remove fput() that causes
use-after-free") came into 6.4-rc7, and commit f921bd41001c
("net/handshake: Unpin sock->file if a handshake is cancelled") came
into 6.5-rc1.

> [cel@manet server-development]$ git log --pretty=oneline v6.5-rc2 -- net/handshake/
> 173780ff18a93298ca84224cc79df69f9cc198ce Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
> 361b6889ae636926cdff517add240c3c8e24593a net/handshake: remove fput() that causes use-after-free
> 9b66ee06e5ca2698d0ba12a7ad7188cb724279e7 net: ynl: prefix uAPI header include with uapi/
> 26fb5480a27d34975cc2b680b77af189620dd740 net/handshake: Enable the SNI extension to work properly
> 1ce77c998f0415d7d9d91cb9bd7665e25c8f75f1 net/handshake: Unpin sock->file if a handshake is cancelled
> fc490880e39d86c65ab2bcbd357af1950fa55e48 net/handshake: handshake_genl_notify() shouldn't ignore @flags
> 7afc6d0a107ffbd448c96eb2458b9e64a5af7860 net/handshake: Fix uninitialized local variable
> 7ea9c1ec66bc099b0bfba961a8a46dfe25d7d8e4 net/handshake: Fix handshake_dup() ref counting
> a095326e2c0f33743ce8e887d5b90edf3f36cced net/handshake: Remove unneeded check from handshake_dup()
> 18c40a1cc1d990c51381ef48cd93fdb31d5cd903 net/handshake: Fix sock->file allocation
> b21c7ba6d9a5532add3827a3b49f49cbc0cb9779 net/handshake: Squelch allocation warning during Kunit test
> 6aa445e39693bff9c98b12f960e66b4e18c7378b net/handshake: Fix section mismatch in handshake_exit
> 88232ec1ec5ecf4aa5de439cff3d5e2b7adcac93 net/handshake: Add Kunit tests for the handshake consumer API
> 2fd5532044a89d2403b543520b4902e196f7d165 net/handshake: Add a kernel API for requesting a TLSv1.3 handshake
> 3b3009ea8abb713b022d94fba95ec270cf6e7eae net/handshake: Create a NETLINK service for handling handshake requests
> [cel@manet server-development]$
> 
> But I do see 1ce77c998f0415d7d9d91cb9bd7665e25c8f75f1 and the
> commit that reverts it, 361b6889ae636926cdff517add240c3c8e24593a.

Very strange.  As this is confusing, I'll just drop it for now until
someone can straighten it out :)

thanks,

greg k-h
