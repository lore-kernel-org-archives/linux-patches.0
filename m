Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB85F38F623
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302160; cv=none; b=spfzUH6rnB5Y9eJk8ewxkpRhVUl3sCLsP1NAcFDvLTcaKp+DenEcMiWKTdPKu23DGked/fPC01keV93twC6hs3tPx4vit82v11XZnlgBrrxwYkvWUbs1ivV/sWoGQjaLWLa/21Ll8egrROSe/EXbsaVFEn3CbNSlnIN8rS3xlt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302160; c=relaxed/simple;
	bh=6PD4jM3iWP5fLp5Bx5vVJw9tvd4/pcVDkK34PoV9WME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVZWVbim88bGpJIFfbzSRdPOIpCfvTsT6hSTVFZNFWPWAZIjQ8KkmKfATIwyjJnNgDo6XsdsVIvItZ/wlwEiiE0ba9SgW5Z2w8Lk/0Q5kxq0ammg+/OwUJL5KmvT/K+ZLjPc9F9ShewtOoBOeWRQHtlfcn1crUM11/mOS/UILm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6BI7vdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6BI7vdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B37C19423;
	Sat, 28 Feb 2026 18:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302160;
	bh=6PD4jM3iWP5fLp5Bx5vVJw9tvd4/pcVDkK34PoV9WME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6BI7vdTuAcIGl+YWG8jSrhX8osPGuqjtoFV0DGee/D1dN84uCIHaaUmqByy93E6S
	 gjQcvK2f9EyB12as5kHT0F6Re+6ySAbMwVLXiV2+0KigmYmESoQyYh31DvZ7wdtimR
	 fLotMZlHiojvEfK5TlbIwrJwuRf3+b8gDtMnx0tzLH2wlQp78oHuP1NOgCbZ+8hT0a
	 81MKvXWCc2R82JpdUPbMrfUIWASrCNCShu9GhE8IhwncqIbLEgFVNz0ox3lvM59Qbj
	 mxKpzRu9I3RBcVRZhU/7Kv+SFRaiA/8kz/kV4VMqUOZK1yjuG1Ml2qCpDTQGczFalf
	 e+qssfcu+Hi+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+e738404dcd14b620923c@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/283] xfrm: fix ip_rt_bug race in icmp_route_lookup reverse path
Date: Sat, 28 Feb 2026 13:04:58 -0500
Message-ID: <20260228180709.1583486-156-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 81b84de32bb27ae1ae2eb9acf0420e9d0d14bf00 ]

icmp_route_lookup() performs multiple route lookups to find a suitable
route for sending ICMP error messages, with special handling for XFRM
(IPsec) policies.

The lookup sequence is:
1. First, lookup output route for ICMP reply (dst = original src)
2. Pass through xfrm_lookup() for policy check
3. If blocked (-EPERM) or dst is not local, enter "reverse path"
4. In reverse path, call xfrm_decode_session_reverse() to get fl4_dec
   which reverses the original packet's flow (saddr<->daddr swapped)
5. If fl4_dec.saddr is local (we are the original destination), use
   __ip_route_output_key() for output route lookup
6. If fl4_dec.saddr is NOT local (we are a forwarding node), use
   ip_route_input() to simulate the reverse packet's input path
7. Finally, pass rt2 through xfrm_lookup() with XFRM_LOOKUP_ICMP flag

The bug occurs in step 6: ip_route_input() is called with fl4_dec.daddr
(original packet's source) as destination. If this address becomes local
between the initial check and ip_route_input() call (e.g., due to
concurrent "ip addr add"), ip_route_input() returns a LOCAL route with
dst.output set to ip_rt_bug.

This route is then used for ICMP output, causing dst_output() to call
ip_rt_bug(), triggering a WARN_ON:

 ------------[ cut here ]------------
 WARNING: net/ipv4/route.c:1275 at ip_rt_bug+0x21/0x30, CPU#1
 Call Trace:
  <TASK>
  ip_push_pending_frames+0x202/0x240
  icmp_push_reply+0x30d/0x430
  __icmp_send+0x1149/0x24f0
  ip_options_compile+0xa2/0xd0
  ip_rcv_finish_core+0x829/0x1950
  ip_rcv+0x2d7/0x420
  __netif_receive_skb_one_core+0x185/0x1f0
  netif_receive_skb+0x90/0x450
  tun_get_user+0x3413/0x3fb0
  tun_chr_write_iter+0xe4/0x220
  ...

Fix this by checking rt2->rt_type after ip_route_input(). If it's
RTN_LOCAL, the route cannot be used for output, so treat it as an error.

The reproducer requires kernel modification to widen the race window,
making it unsuitable as a selftest. It is available at:

  https://gist.github.com/mrpre/eae853b72ac6a750f5d45d64ddac1e81

Reported-by: syzbot+e738404dcd14b620923c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000b1060905eada8881@google.com/T/
Closes: https://lore.kernel.org/r/20260128090523.356953-1-jiayuan.chen@linux.dev
Fixes: 8b7817f3a959 ("[IPSEC]: Add ICMP host relookup support")
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260206050220.59642-1-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index efa589a1e7a38..9653ef1281a46 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -555,6 +555,21 @@ static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
 		/* steal dst entry from skb_in, don't drop refcnt */
 		skb_dstref_steal(skb_in);
 		skb_dstref_restore(skb_in, orefdst);
+
+		/*
+		 * At this point, fl4_dec.daddr should NOT be local (we
+		 * checked fl4_dec.saddr above). However, a race condition
+		 * may occur if the address is added to the interface
+		 * concurrently. In that case, ip_route_input() returns a
+		 * LOCAL route with dst.output=ip_rt_bug, which must not
+		 * be used for output.
+		 */
+		if (!err && rt2 && rt2->rt_type == RTN_LOCAL) {
+			net_warn_ratelimited("detected local route for %pI4 during ICMP sending, src %pI4\n",
+					     &fl4_dec.daddr, &fl4_dec.saddr);
+			dst_release(&rt2->dst);
+			err = -EINVAL;
+		}
 	}
 
 	if (err)
-- 
2.51.0

