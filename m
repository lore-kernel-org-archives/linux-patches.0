Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117642F0C64;
	Mon, 22 Sep 2025 19:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570171; cv=none; b=ctbI7ybUoB1hOGPxv7hXwQQ7c5ZOcK7Fj4vbz8rwDSovt69TUIYwbuSSikFxsdWH/92vpRIDqPin05rnWNZyJDKnL1xzNYwxbeBpvZOcKzcJb7SKUX3ecnJ63iFHjHvSlBRNWNHPBskpp88cP8mueaFcCbsMFejrhTJ4qvLcnq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570171; c=relaxed/simple;
	bh=MR98S/aQkfF9bfIBrFEVEFKJBw8s6fzHhAlyNDEkZC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/Lh1kTu4fdv0BZr8UlYLE9obdApcvrJYX/rseUZAQICxIZqMTNPe3uYTbxF2Xvy/IYydiYclQgHqsAVRk0QT5pckEsmm9RybYsW7CGCADJR2YU+cdEXs38naWtoNyUluYSk9z8qmQvrU0x9rjW9gLttUhVQiR480SF1hS2YN2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1m8+yq8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1m8+yq8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E53FC4CEF0;
	Mon, 22 Sep 2025 19:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570170;
	bh=MR98S/aQkfF9bfIBrFEVEFKJBw8s6fzHhAlyNDEkZC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1m8+yq8enRHCP8unXJMJyqW4q/m5qXss/5c64pCgy4OUipXht48upVgQzQFBp2Ajf
	 9OTTb8Vr/dyfLiUzE0iRl7zWJ9uDGLj5IxHHARaWsEzzH9zr5BkbgNpGEGZ32FkP+2
	 UQqeSR2qezHJVOZ23ecE8KOC+03x9Gy1/z5EutNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 023/149] net: dst_metadata: fix IP_DF bit not extracted from tunnel headers
Date: Mon, 22 Sep 2025 21:28:43 +0200
Message-ID: <20250922192413.456801456@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit a9888628cb2c768202a4530e2816da1889cc3165 ]

Both OVS and TC flower allow extracting and matching on the DF bit of
the outer IP header via OVS_TUNNEL_KEY_ATTR_DONT_FRAGMENT in the
OVS_KEY_ATTR_TUNNEL and TCA_FLOWER_KEY_FLAGS_TUNNEL_DONT_FRAGMENT in
the TCA_FLOWER_KEY_ENC_FLAGS respectively.  Flow dissector extracts
this information as FLOW_DIS_F_TUNNEL_DONT_FRAGMENT from the tunnel
info key.

However, the IP_TUNNEL_DONT_FRAGMENT_BIT in the tunnel key is never
actually set, because the tunneling code doesn't actually extract it
from the IP header.  OAM and CRIT_OPT are extracted by the tunnel
implementation code, same code also sets the KEY flag, if present.
UDP tunnel core takes care of setting the CSUM flag if the checksum
is present in the UDP header, but the DONT_FRAGMENT is not handled at
any layer.

Fix that by checking the bit and setting the corresponding flag while
populating the tunnel info in the IP layer where it belongs.

Not using __assign_bit as we don't really need to clear the bit in a
just initialized field.  It also doesn't seem like using __assign_bit
will make the code look better.

Clearly, users didn't rely on this functionality for anything very
important until now.  The reason why this doesn't break OVS logic is
that it only matches on what kernel previously parsed out and if kernel
consistently reports this bit as zero, OVS will only match on it to be
zero, which sort of works.  But it is still a bug that the uAPI reports
and allows matching on the field that is not actually checked in the
packet.  And this is causing misleading -df reporting in OVS datapath
flows, while the tunnel traffic actually has the bit set in most cases.

This may also cause issues if a hardware properly implements support
for tunnel flag matching as it will disagree with the implementation
in a software path of TC flower.

Fixes: 7d5437c709de ("openvswitch: Add tunneling interface.")
Fixes: 1d17568e74de ("net/sched: cls_flower: add support for matching tunnel control flags")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250909165440.229890-2-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst_metadata.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 4160731dcb6e3..1fc2fb03ce3f9 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -3,6 +3,7 @@
 #define __NET_DST_METADATA_H 1
 
 #include <linux/skbuff.h>
+#include <net/ip.h>
 #include <net/ip_tunnels.h>
 #include <net/macsec.h>
 #include <net/dst.h>
@@ -220,9 +221,15 @@ static inline struct metadata_dst *ip_tun_rx_dst(struct sk_buff *skb,
 						 int md_size)
 {
 	const struct iphdr *iph = ip_hdr(skb);
+	struct metadata_dst *tun_dst;
+
+	tun_dst = __ip_tun_set_dst(iph->saddr, iph->daddr, iph->tos, iph->ttl,
+				   0, flags, tunnel_id, md_size);
 
-	return __ip_tun_set_dst(iph->saddr, iph->daddr, iph->tos, iph->ttl,
-				0, flags, tunnel_id, md_size);
+	if (tun_dst && (iph->frag_off & htons(IP_DF)))
+		__set_bit(IP_TUNNEL_DONT_FRAGMENT_BIT,
+			  tun_dst->u.tun_info.key.tun_flags);
+	return tun_dst;
 }
 
 static inline struct metadata_dst *__ipv6_tun_set_dst(const struct in6_addr *saddr,
-- 
2.51.0



