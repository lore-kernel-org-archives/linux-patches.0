Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7ED94CC63A;
	Wed, 30 Sep 2026 18:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793360; cv=none; b=H+VVB+aygL8YaPTpLrFt22/h3c9f1x1PC/MoNRTutLWZx2LVGAFVyQ6TZCsT0MXB+ySWZMMuLUhDDIPv3pwQxdDwbj/NQRbc6lv3WTWtxk3RHTzjQWR0uAcWI+xSGNjUCjL++esHqgoOaYJeR7qU1ksqAOm9zbBdg6F0P6pDBd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793360; c=relaxed/simple;
	bh=XTFiW4wJARHVRMwNc38KjMjkEQ/Ex2iFRI9NI3OEA7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2wuCkbQfJSQVPsLix4ZVR7ATcNUvCvQJHhA/luXnPSF5HkS4vZyJJTZuakfFwDFF0E7YfgX5pvetvlPQ6wJrqrVjzNoiKe/rEeswUmaTKbCyufMIRsvCO1rUo0rcZyac1+R4gdozir1OWVg3iWmK282mXAs/Lklh82GUwlSdPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQuAGTcg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQuAGTcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8271F000FF;
	Wed, 30 Sep 2026 18:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793358;
	bh=+/71TVI93DA1xcqtYHNJe2gndGRMXJDWK7nOJYtR0Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xQuAGTcguVulC+vBs80+BqC7xOcKjBmuYiVuHj77ZPM+CyuVGCegWaOgLcK8worf2
	 xd+YZAbKze+Zmcahg4Gt8/uMGiz6+CbLiT5M8/G/IMjyR9MzVmEnAL50fzD/UUNoTg
	 5ZTkBH7lcZjCCycUjanJwn/mlHRL1Ro02+8QtMI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Eric Dumazet <edumazet@google.com>,
	Norbert Szetei <norbert@doyensec.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 228/395] ipv6: do not let ipv6_find_hdr() return an offset past the packet end
Date: Wed, 30 Sep 2026 17:28:10 +0200
Message-ID: <20260930152345.609739136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit ee319bd3a0e976af5087cbe59ebc50a66f31d202 upstream.

ipv6_find_hdr() walks the extension header chain, skipping each header by
the length that header itself declares.  ipv6_optlen() returns up to 2048,
and the skip is never checked against skb->len, so the offset stored in
*offset can point past the end of the packet.

openvswitch installs that offset as the transport header, and
update_ipv6_checksum() then reads and writes the transport checksum field
out of bounds:

  BUG: KASAN: slab-use-after-free in inet_proto_csum_replace16+0x445/0x470
  Read of size 2 at addr ffff88810b754b06 by task ovs_ipv6_oob/629
  CPU: 4 UID: 1000 PID: 629 Comm: ovs_ipv6_oob Tainted: G N 7.3.0-rc3+ #348
  Call Trace:
   inet_proto_csum_replace16+0x445/0x470
   set_ipv6_addr+0x3dd/0x460
   do_execute_actions+0x6a3d/0x7c40
   ovs_execute_actions+0xfd/0x480
   ovs_packet_cmd_execute+0xc38/0xf20
   genl_rcv_msg+0x59e/0x870
   netlink_rcv_skb+0x18b/0x450
   genl_rcv+0x2d/0x40
   netlink_unicast+0x6bc/0xa20

  The buggy address belongs to the object at ffff88810b754980
   which belongs to the cache skbuff_small_head of size 704
  The buggy address is located 390 bytes inside of
   freed 704-byte region [ffff88810b754980, ffff88810b754c40)

Other callers use that offset too, so bound it here rather than in one
caller.

Reject a header whose declared length does not fit in the packet.
ipv6_find_hdr() already fails with -EBADMSG on a malformed chain, so this
adds no new failure mode.

Fixes: f8f626754ebe ("ipv6: Move ipv6_find_hdr() out of Netfilter code.")
Suggested-by: Ilya Maximets <i.maximets@ovn.org>
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/8F80BA1A-DDFD-432D-9075-242A3435FEB5@doyensec.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -271,6 +271,9 @@ int ipv6_find_hdr(const struct sk_buff *
 			hdrlen = ipv6_optlen(hp);
 
 		if (!found) {
+			if (skb->len - start < hdrlen)
+				return -EBADMSG;
+
 			nexthdr = hp->nexthdr;
 			start += hdrlen;
 		}


