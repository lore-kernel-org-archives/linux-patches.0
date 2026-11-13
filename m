Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590092;
	b=33bVnzjsWsJGa+VAEui+lbZVrHSPZ8ud/1IFzDgogdvaP1xwr5x+IpM42mbSvl8cQCic
	 hNpzjvXUANMGSsprbm80t7gbvKb+FMuwkUrs9FqIRTOqTOYyGLcvZmKPPSHW9mK9ztWmy
	 /chUARczRMe+9UA7GQDxbbpKiQR+Hdbxnhwr8UfLPHsBrivwUqTnyZ+HEUhuFACOu46YC
	 TlO2X03PO4Ar531RaC/OKfz/5RZ+Qt0/saHDlCZgLnBYzgvsTWUCx8DjwbaoG8wJZSsYk
	 Xy6xavU6sg7eet2d+zYgNRgM/2wH1uQxxcZdFYKbmCH35a+QUyh8+8aLPW+EGr0agBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5tMZGlE585DLiKk8ZIcO0+Eg3/XpPXCvg3d+9lb22WQ=;
	b=0WQ0vrzSWa1/vewAJfZPmZQOG9Yx71c1eZZl599CHhxXbJSfRumDYbRSdXpFt6zG0922
	 ZJivmkVhbIrZ2WTEeRxs6DWziLCe/9EG/FKr3mRPMlzJZXh1YHqpHovgaZEk4vs2z9t61
	 WulONmrcV9l3izOkyGfyFeIWfdsuTyytVd/VANtDwI9m/zbNhWL7KRJlikOHz9pOYzNjb
	 YGMb9M7Rc8ijKIWWP2p/KqktsbFXWao5lulkLTHmiB28O4OzTzj/J7M+WfK9NwrxEZNB+
	 hd4WHF/vNLRcd/D3hnG8+tzDKVoUp/lrTB4BQ7ycgv38m3HegHCfsC4/k/JahjsAGIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4SlgyUX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF17606C0BC;
	Fri, 13 Nov 2026 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4SlgyUX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB981F000C4;
	Fri, 13 Nov 2026 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590091;
	bh=5tMZGlE585DLiKk8ZIcO0+Eg3/XpPXCvg3d+9lb22WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4SlgyUXxAHBzrsqb7uDUCAz6f6yEUL9wwLfBmrM/Zkk1twschZ6sXfszMqUj22P8
	 rBEd3YhksQe3Lpm4P0GB6L98+agErABpYL2oOfn6o3xVqY6TIvFQ6GAC7qMGt3320I
	 2z4C1dTjfDuXYxd/uaOo7i6OOd/ejuNo1r8kVRp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/686] ax25: free the old digipeater path of a listed socket under ax25_list_lock
Date: Fri, 13 Nov 2026 10:44:11 -0500
Message-ID: <20261113153824.832635198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

ax25_connect() frees the digipeater path left by a previous connect()
with only the socket lock held. A bound socket is on ax25_list, where
__ax25_find_cb() on the receive path and ax25_info_show() for
/proc/net/ax25 read ax25->digipeat under ax25_list_lock, without the
socket lock. The path can thus be freed while one of them walks it.

Take the old path off the socket under ax25_list_lock before freeing
it, and set the new destination and path under the same lock, so that
a reader on the list never sees a freed path, nor a destination with
the path of another one.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, ax0 on mkiss):
a bound SOCK_SEQPACKET socket calls an absent station via 8
digipeaters six times, each new non-blocking connect() freeing the path
of the previous one, while a thread reads /proc/net/ax25 in a loop:

  before: 18 reports such as
          BUG: KASAN: slab-use-after-free in ax25_info_show
          BUG: KASAN: slab-use-after-free in ax2asc
          (90 with an mdelay(300) after the kfree())
  after:  no report, five runs out of five, and none with the mdelay

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 5aa967bbd20401af3415cd4fe056fca6624698f2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 64a24543d7f42..e1a47489c601f 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1247,7 +1247,7 @@ static int __must_check ax25_connect(struct socket *sock,
 	struct sock *sk = sock->sk;
 	ax25_cb *ax25 = sk_to_ax25(sk), *ax25t;
 	struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 *)uaddr;
-	ax25_digi *digi = NULL;
+	ax25_digi *digi = NULL, *old_digi;
 	int ct = 0, err = 0;
 
 	/*
@@ -1299,8 +1299,16 @@ static int __must_check ax25_connect(struct socket *sock,
 	sk->sk_state   = TCP_CLOSE;
 	sock->state = SS_UNCONNECTED;
 
-	kfree(ax25->digipeat);
+	/*
+	 * A bound socket is on ax25_list, where the receive path and
+	 * /proc/net/ax25 read its digipeater path under ax25_list_lock:
+	 * take the old path off under that lock before freeing it.
+	 */
+	spin_lock_bh(&ax25_list_lock);
+	old_digi = ax25->digipeat;
 	ax25->digipeat = NULL;
+	spin_unlock_bh(&ax25_list_lock);
+	kfree(old_digi);
 
 	/*
 	 *	Handle digi-peaters to be used.
@@ -1360,8 +1368,10 @@ static int __must_check ax25_connect(struct socket *sock,
 		goto out_release;
 	}
 
+	spin_lock_bh(&ax25_list_lock);
 	ax25->dest_addr = fsa->fsa_ax25.sax25_call;
 	ax25->digipeat  = digi;
+	spin_unlock_bh(&ax25_list_lock);
 
 	/* First the easy one */
 	if (sk->sk_type != SOCK_SEQPACKET) {
-- 
2.53.0



