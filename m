Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826758;
	b=UHvQ7V6WikGc+qbffzNuj9KGCB/97i9Mo0H/XT3NPFdyH3qMZiIuKJX19K4y6lG5jbQ0
	 d50z3teT0y0LM0E6PVkig2LvnadhtEl/UYnHRr58Hs2UKDTuxqXkofFvipXRzcPqXlCS2
	 K3czwXnOzmcg09grM6tsIjggzEIF20bnktiR4lQS/M5rni+BCk+tiEYXLmhkPFLQuCap3
	 l9g6/Wgtwg7b/5GqUwli+y82ROvDjMM3yx36XAzxXKDvHRcah67G1hXnbAftCTlhKAVMR
	 yaDjbhVPSRGtyl80BCnsOQk4gzeeIDpER4p954HY/I7uD7U+QlUg70ylbxzrlPN8nBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AG80wjyOkN6gki8rvbpxJxiiA3qzzQFuVmZcydaz1M4=;
	b=MeyxvwahokgjQ/72WpJt3lKrQkNhimsFsC2irpaqcL9JxmXjgDroTv0Jb2GfUBVcbuAJ
	 okoDH7cdlRsiY9CczIo76qxPsYUcToA1T/SoLfetptfcxUn4UD0HnLiyROsQk7cVFKfg4
	 10RTiwazpEFOIUXgC2j0NzKJHVz3PqUKQHX0LuCrH0IRiymfuJGWJorocc56zwkQzpUBB
	 0TYNDymtCRqtLlTjk/hnUZerny+jRzSgC1tPLJicbNRd85LFmAXPLH+94dwKPbXJlj74j
	 QdB3G2xpDDrH3AD4YwqV4zxdUIF/RWf2tvnZB33OYwXZkoZJV4epi/3eSJZOLujafKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkbqx0Lj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AD260ABCD1;
	Wed,  4 Nov 2026 21:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkbqx0Lj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F39F1F00A1D;
	Wed,  4 Nov 2026 21:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826758;
	bh=AG80wjyOkN6gki8rvbpxJxiiA3qzzQFuVmZcydaz1M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkbqx0Lj5vYpX0/EaaScL42HlHQqksTiPNOAUEi259T2lvXV3c61fjMIGjwQj1wZD
	 jFOj78iPSnBhOj2BWTjN5wEfg+S9QrEaqcsw8TtMCSreesuiwWNPxzNb16DlXe06nk
	 t8rgq9vESG+irQKDJq7CXo1WxxgEX+0U2XL7kVCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zizhen Liu <pointerliu@126.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 001/547] net: skbuff: propagate shared-frag marker in skb_zerocopy()
Date: Wed,  4 Nov 2026 16:03:05 -0500
Message-ID: <20261104211038.447751006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhen Liu <pointerliu@126.com>

commit 79dc34beb1fdb3da79753e51e15c68591a2561fe upstream.

skb_zerocopy() moves frag descriptors from @from into @to and takes a
reference on each frag, but it does not copy skb_shinfo(from)->flags into
skb_shinfo(to)->flags.  A destination skb holding the same page-cache
backed frags as the source therefore reports skb_has_shared_frag() as
false.

That breaks the invariant relied on by later in-place writers.  ESP input
checks skb_has_shared_frag() before deciding whether an uncloned
nonlinear skb can skip skb_cow_data(); with the marker lost, an skb that
skb_zerocopy() built for nfnetlink_queue or for an openvswitch upcall is
decrypted in place, letting an unprivileged user write into the page
cache of a root-owned read-only file.

Propagate SKBFL_SHARED_FRAG when frag descriptors are copied, as done for
the other frag-transfer helpers.

Fixes: af2806f8f90a ("net: Export skb_zerocopy() to zerocopy from one skb to another")
Fixes: f4c50a4034e6 ("xfrm: esp: avoid in-place decrypt on shared skb frags")
Cc: stable@kernel.org
Signed-off-by: Zizhen Liu <pointerliu@126.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261022104217.1852191-1-pointerliu@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3942,6 +3942,8 @@ skb_zerocopy(struct sk_buff *to, struct
 	}
 	skb_shinfo(to)->nr_frags = j;
 
+	skb_shinfo(to)->flags |= skb_shinfo(from)->flags & SKBFL_SHARED_FRAG;
+
 	if (i > 0 && from->unreadable)
 		to->unreadable = 1;
 


