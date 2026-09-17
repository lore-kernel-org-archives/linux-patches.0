Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D748A5AEC79;
	Thu, 17 Sep 2026 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659741; cv=none; b=naqMXurNnOJ9d7MBXTFVRlG0ABTPZQHt/W092Ah8u/op0Kj7910siYH6hmK3JVTque5EDTRBqCEt0hsmagyvR5dRM2L+khv6J+Pzbnqa/Jb21+QS0E/VmEt29PsVxJXLyOWwkf6ENZKWhNnE5jwdii43qx15rwmxK1I8IGF4rE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659741; c=relaxed/simple;
	bh=NCdOw0DlN1jbMuQ6vEWHfxvj/P3n5+XmZW5PgV2pufQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K43hPf/VxMq7IDMQ7sxu8nZqGDkgSGr6Sfjs97/XCwZNYKNkdDesH1dSC3A7F/ele3gM6RIfLfVJVVuj+ZK+9PKlxBvkrsEqr+S7PdvgHZirgEPbw1yHtgkkcWmjSIp9xTqkXfWqZM5Q8f5r67Q0JZgZLUhmgbR19QgfEE7gNc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aNdyUS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aNdyUS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812771F00898;
	Thu, 17 Sep 2026 15:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659735;
	bh=FZZIP6dw47+yzlHQD2w3Tf9PCe3Vt4ynDncFsjcxa5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1aNdyUS2VdL6F8BylMsMjEUw3BNeN7PFULeL9rxxt0wQ92fe4gCel/h6aFkZfbFel
	 ZNgbKEt8LYFInFxUs1Ncx4GaLrYl7Ldnka4unAnR9akLS9kFi9bEK3d0LaGzHgfnlg
	 e1rnbtStKxXiOIvaK5B111mmDziUndhpd2XWOnXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ce13c07d96d04716eaa2@syzkaller.appspotmail.com,
	Alice Mikityanska <alice@isovalent.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 356/733] net: ipv4: Fix UDP length overflow with PMTU discover and big MTU
Date: Thu, 17 Sep 2026 16:11:04 +0100
Message-ID: <20260917151400.462533779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit b83641e0ab8b20eefcc4cdc5a059f897375291a2 ]

This commit bounds cork->base.fragsize to IP_MAX_MTU to avoid a
possible overflow of UDP length that triggers a WARN in
udp_set_len_short when setsockopt IP_MTU_DISCOVER is set to
IP_PMTUDISC_PROBE, and a large packet is sent over a netdev with an
unusually large MTU.

Steps to reproduce:

1. Set device MTU bigger than IP_MAX_MTU + 20. cork->base.fragsize will
   be set to that MTU in ip_setup_cork.
2. Set IP_MTU_DISCOVER to IP_PMTUDISC_PROBE. It lets maxnonfragsize be
   set to device MTU (cork->fragsize) in __ip_append_data, rather than
   to IP_MAX_MTU.
3. Send 65528 bytes of payload (+8 bytes of UDP header, +20 bytes of
   IPv4 header). Device MTU allows it (it's only one byte bigger than
   IP_MAX_MTU + IPv4 header, and the device MTU is bigger than that).
4. The UDP length in the built packet is 65536, which overflows the
   16-bit length field and triggers the WARN in udp_set_len_short.

Note: IP_PMTUDISC_DO with IPv4 is safe, because ip_dst_mtu_maybe_forward
always clamps at IP_MAX_MTU, unlike ip6_dst_mtu_maybe_forward.

The Fixes tag points at the first commit where I could reproduce the
overflow with IPv4 and IP_PMTUDISC_PROBE.

Fixes: daba287b299e ("ipv4: fix DO and PROBE pmtu mode regarding local fragmentation with UFO/CORK")
Reported-by: syzbot+ce13c07d96d04716eaa2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a6a966c.86abc875.e5c3d.0054.GAE@google.com/
Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260901195714.673548-2-alice.kernel@fastmail.im
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 74e095b6b7ca0..a24cc8ee11d3e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1303,6 +1303,7 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
 
 	cork->fragsize = ip_sk_use_pmtu(sk) ?
 			 dst4_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
+	cork->fragsize = min(cork->fragsize, IP_MAX_MTU);
 
 	if (!inetdev_valid_mtu(cork->fragsize))
 		return -ENETUNREACH;
-- 
2.53.0



