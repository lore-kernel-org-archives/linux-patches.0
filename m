Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590924;
	b=nBPcyACmbHAv2FvNWo7kUwaORksBVLL1cW2Ka8UWN4IDXkdbebtsmVeweUJa8cxquziN
	 UgsDC/2S8YgmXWdSNw+IdAelNr9ancEWbb9wbB6iBm4N8O9Lax9SC1XZ5iaRmPGUcBdMM
	 wLmi9YiSfrKDMdCtYG/rWeYhBxG/2CFg53BbvBxJJ9BstDqcdWhkKQTVmc8dRrsKqoINF
	 GUfdRlFwu7dTcNwJnRDyPdEJN/ce66xJZB7taoDDrNs9/hi7HlrXhIxQspJi/4UxTQ+cL
	 qoh2KsS+sSmAkFkoD8ooA/IzQkHaY6i2g3r19MgOP9b99wdtzdZuYvFoL0lX4x6zD/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DhpfDa2A3yAEXiIFRTH7yuVp4xfyFPT/FPtMeIiI2Zc=;
	b=M2KX/JEoq/Hy9NO+57KGewj5OwcRkuX/JgtZkagZxWbStlEA5mG41726Jl1Ve3touZWx
	 P6P/5NMX7+FBQQLwoN87ezv972C59Fqso5z+MOWfQzMe6jPnroDVt8fZlStFuEuiV8lb9
	 Bc6Eq7kjDT1NbdmKQ5R1VA9126fK/jzy16LuE7r79TEjgiIMrp7bL/DyjvIYUbhc/Yt8s
	 vNKIbP18/Lkcx3mtxF39OlR6JtJHMCnJl3cJHm4CFkkT9rGdWYeQVWXQTiGX95BCTVeFL
	 tZWUhFy4JvuSCu1xe5elab6t87pIj7Gg+/aY2QapR2AuzyQGezxIzZDTMLDF6q/Swpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypU4X2Xr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704FF606E677;
	Fri, 13 Nov 2026 17:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypU4X2Xr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE441F000C4;
	Fri, 13 Nov 2026 17:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590924;
	bh=DhpfDa2A3yAEXiIFRTH7yuVp4xfyFPT/FPtMeIiI2Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypU4X2XrUvFO6r5BKDBv5LpiJKdr8zXtLrYHtI+bRt0S+SotPj07d3CRwaO4DtSbH
	 qkcvOB8O92mDSxGmWEluyAjicOLh/R7Fkgpv8Oa3es5PDNK30KGxFacbPEKLQiYE0e
	 Fs/98jRB7gfuLd4CBbqF7d+dhY0cyXV61tAks8To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/670] ax25: dont build a frame header from an uninitialised digipeater list
Date: Fri, 13 Nov 2026 10:44:36 -0500
Message-ID: <20261113153815.640763124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

ax25_sendmsg() reads the digipeaters given with the destination only
when the address is a full_sockaddr_ax25, but it then points dp at its
local ax25_digi whenever sax25_ndigis is not zero. sax25_ndigis is part
of the 16 byte struct sockaddr_ax25 as well, so a sendto() with that
short address and a non-zero sax25_ndigis makes ax25_sendmsg() build
the header from an ax25_digi that was never written: ax25_addr_size()
and ax25_addr_build() use whatever ndigi and calls[] the stack holds.

On a datagram socket the frame then goes out with kernel stack bytes as
digipeater calls, or skb_push() is asked for more than the headroom and
the kernel stops in skb_under_panic(). Any local user who can bind an
AX.25 socket can do it, and bind() is open to all with the default uid
policy. Kernels built with CONFIG_INIT_STACK_ALL_ZERO hide it, ndigi
is then 0.

Point dp at the local list only once the digipeaters have been read
into it. A short address now sends without digipeaters, as connect()
already does with the same address.

Tested on a QEMU bench (6.12.94 with KASAN, ax0 on mkiss, the frames
recorded on the serial line): ten sendto() with a full address and 8
digipeaters, each followed by one with a 16 byte address and
sax25_ndigis = 8, ax25 built with -ftrivial-auto-var-init=pattern as
with CONFIG_INIT_STACK_ALL_PATTERN:

  before: skb_under_panic (put:1793), kernel BUG on the first short one
  after:  20 frames, the short ones without digipeaters, the full ones
          with their 8 digipeaters, no KASAN report

With the zero init used by most distribution kernels, and on this bench
without any init, the stack held 0 there and the short frames already
went out without digipeaters before the change.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 15f2d99ffa155d65e591fb171f3df048d3d3802c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index a3bfc14a249ce..abb7621d03e04 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1569,7 +1569,7 @@ static int ax25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sock *sk = sock->sk;
 	struct sockaddr_ax25 sax;
 	struct sk_buff *skb;
-	ax25_digi dtmp, *dp;
+	ax25_digi dtmp, *dp = NULL;
 	ax25_cb *ax25;
 	size_t size;
 	int lv, err, addr_len = msg->msg_namelen;
@@ -1644,6 +1644,7 @@ static int ax25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			}
 
 			dtmp.lastrepeat = 0;
+			dp = &dtmp;
 		}
 
 		sax = *usax;
@@ -1652,10 +1653,6 @@ static int ax25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			err = -EISCONN;
 			goto out;
 		}
-		if (usax->sax25_ndigis == 0)
-			dp = NULL;
-		else
-			dp = &dtmp;
 	} else {
 		/*
 		 *	FIXME: 1003.1g - if the socket is like this because
-- 
2.53.0



