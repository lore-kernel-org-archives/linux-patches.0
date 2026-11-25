Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624952;
	b=OelNwx+K2cEOGNXe+XvPRFlcWInJrav3cEmbjXJgClrecdMhEyKYFKNIAJfcEgw2z8s7
	 sPZSKbO+U/fvPZ6mbpgYylRIx0PQ13NLGnj4lAnfSPB2V3C9FmOMhW9mKgtlzPIxIEbix
	 6/WjY3RP0HWvtjYs0REacJKNL2Wxltegg4mcjHl83I0G94f8v6zHlT/d8lKA9/5/PvOCo
	 7qPadlPx0iUprYSCrZZipiJIb8rOade9mP6jIm9Ry75HupNRDyCQxtxVJ9YtRzX5gY/BQ
	 qc1+ASqWsT2gZc/CdoTpUcmBr9ctW3w3PjcQAFuNqURqxxZK53spLc0bpFGErCUUcJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4njji7eOQbpQrqC6enwA3dO5JbwYBQ8l6UcviUMBVP8=;
	b=DNGJvVl5xBo/cRmVocPXmnOpMnRoprztRC24rE3AtTlAyZGgkwqkxYcoNkX0ZMRS/a8j
	 hDM8yzgainzFtC+aPla/A2CUpC+ZaWHsZUqtq3blX2QxNsclQTppJOYHkxcydcYJe791e
	 R/yDSuIAHTKQiaSS48qZ/Vi+1OCPyM6TWca0Jl+1T7jcmxE31Rm1BHzZ0rVtfVsE78JQK
	 Hl+Gfnd/n0eVLpoRkg9GDfSNe+L5APOrz18ZhT0ulOUR/ubFFfi+dk7slbQD1BwMxMrl2
	 KrnvJww1mts3e/x1FXoQ4ZmrUVCsMvHePnY68XbKclQe60UI3Ob+ydPE6z7X8RBlesg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igHNzpLB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456D0606A32D;
	Wed, 25 Nov 2026 16:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igHNzpLB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861271F000C0;
	Wed, 25 Nov 2026 16:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624952;
	bh=4njji7eOQbpQrqC6enwA3dO5JbwYBQ8l6UcviUMBVP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igHNzpLBPlYJMyO+gbjaAewfEHVWO7ad8HdU41MIJNrxljR5KJNR6UkCUBkX3jTEe
	 wU+UUclPsXMZGrFPBorOABewIWdJyJUnbymIO/BpOohN21QaHNpcuTN05satCToHsW
	 8bvZAAzg4dpW8fyOV+i4BRJi4Laf4I52eW+X+hBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Benc <jbenc@redhat.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 357/816] nsh: limit recursion in nsh_gso_segment()
Date: Wed, 25 Nov 2026 15:31:45 +0100
Message-ID: <20261125143857.462724372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 3921fb102d78a6d7aa61b8d273e097a1a8026b90 ]

nsh_gso_segment() calls skb_mac_gso_segment() for the inner packet,
which calls nsh_gso_segment() again when the next protocol is NSH,
either directly or behind an inner Ethernet header (ETH_P_TEB).

Nothing limits the depth: a GSO packet made of stacked 8-byte NSH
headers recurses once per header, and a 64KB packet can hold about
8000 of them, overflowing the kernel stack.

Such a packet can be injected with a packet socket using
PACKET_VNET_HDR, or with tun/tap or virtio_net, as nothing checks
that a GSO packet with VIRTIO_NET_HDR_F_NEEDS_CSUM carries the
protocol it claims. It is then segmented in software if the output
device does not support the GSO type:

BUG: TASK stack guard page was hit at ffffcad5c0ab3ff8 (stack is ffffcad5c0ab4000..ffffcad5c0ab8000)
Oops: stack guard page: 0000 [#1] SMP NOPTI
CPU: 3 UID: 0 PID: 337 Comm: nsh_gso Tainted: G            E       7.4.0-rc1+ #118 PREEMPT(lazy)
RIP: 0010:lock_acquire (kernel/locking/lockdep.c:5902)
Call Trace:
 <TASK>
 skb_mac_gso_segment (include/linux/rcupdate.h:309 include/linux/rcupdate.h:849 net/core/gso.c:50)
 nsh_gso_segment (net/nsh/nsh.c:110) nsh
 skb_mac_gso_segment (net/core/gso.c:53)
 nsh_gso_segment (net/nsh/nsh.c:110) nsh
 [...]
 skb_mac_gso_segment (net/core/gso.c:53)
 __skb_gso_segment (net/core/gso.c:129)
 validate_xmit_skb (net/core/dev.c:4238)
 __dev_queue_xmit (net/core/dev.c:5087)
 packet_sendmsg (net/packet/af_packet.c:3157 net/packet/af_packet.c:3189)
 __sys_sendto (net/socket.c:800 net/socket.c:818 net/socket.c:2283)
 __x64_sys_sendto (net/socket.c:2290 net/socket.c:2286 net/socket.c:2286)
 do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Use gso_recursion_inc_test(), added in commit 006c8b834aed ("net: gso:
limit recursive IP-in-IP segmentation"), with the same limit as IPv4
and IPv6. The counter is shared with them: a packet with four NSH
headers in front of an IPv4 header is still segmented, one more NSH
header and it is dropped.

The NSH -> ETH_P_TEB -> NSH route is covered as well, as each round
goes through nsh_gso_segment().

Fixes: c411ed854584 ("nsh: add GSO support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netdev/179443691180.2199510.148246238688217560@kernel.org/
Cc: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiri Benc <jbenc@redhat.com>
Link: https://patch.msgid.link/20261112102001.3744643-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/gso.h | 2 +-
 net/nsh/nsh.c     | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/gso.h b/include/net/gso.h
index 0749230d414ec..e311a8f5b5a72 100644
--- a/include/net/gso.h
+++ b/include/net/gso.h
@@ -19,7 +19,7 @@ struct skb_gso_cb {
 	int	encap_level;
 	__wsum	csum;
 	__u16	csum_start;
-	/* Number of IPv4/IPv6 GSO handler entries for this packet. */
+	/* Number of IPv4/IPv6/NSH GSO handler entries for this packet. */
 	u8	recursion_counter;
 };
 #define SKB_GSO_CB_OFFSET	32
diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index bfb7758063f31..dd4de50fc38c3 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -9,6 +9,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <net/gso.h>
+#include <net/ip_tunnels.h>
 #include <net/nsh.h>
 #include <net/tun_proto.h>
 
@@ -84,6 +85,12 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 
 	skb_reset_network_header(skb);
 
+	/* NSH can carry NSH (directly, or in an inner Ethernet frame):
+	 * limit the recursion, as IPv4 and IPv6 do.
+	 */
+	if (unlikely(gso_recursion_inc_test(skb, IP_TUNNEL_RECURSION_LIMIT)))
+		goto out;
+
 	outer_proto = skb->protocol;
 	outer_hlen = skb_mac_header_len(skb);
 	mac_len = skb->mac_len;
-- 
2.53.0



