Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0AE378838;
	Fri,  4 Sep 2026 06:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501651; cv=none; b=QH9QOox511r898H/jwbprWl6X3xcfuvK2sGxH/LkmdLwiayhmkgqkUMA5X7s9b3IVU/uNyFtKUEHRy8jhEH1nw5mPB2tbY5iltok469oAo5fo/he0GsIutEZxfS7cuV08ZoIEgN4QCxGyp6K3hJUEdYtXkkXfUxUhPkyD+TTKeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501651; c=relaxed/simple;
	bh=LSCKFHhOqckvhbesdrQWMW47qJ0ENzJwZ2fsv91ZLWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjgJWfLEa4TXGE9X8ktarGS7To2wRoILHMQ48yH2wCdlq5vyJmV1HgwJxUKm1tfRb/HX8OtS3Gbsz/i2QjVbC/vPRYU/AOC1+rgiEC9dfk+6HJWucWKK06BaOA0wOmlZ5v1IoMp6l46fTn9bMAaGb7kkZ/tRfQQTc2adyrsMwP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWBC4AEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWBC4AEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7795F1F00A3D;
	Fri,  4 Sep 2026 06:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501650;
	bh=s/lQK1qKIZfVHcJYm9VJrWEk6VDv6SrkqGUSlDDYaWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWBC4AEGZyNlTXjnlF4j7pQ14KEDiHkwaoVfAltx93n+scJck3S3aS2jPU4cnL58g
	 UC4oePTILGY9HuHFh1eYHffOoLqxM9SDNem6kBzdWLAMr6Fb09A2i++uF7WSiyphje
	 DC4B2nBsmRndOsqXpXeBtsb2BTOUVeWVRpuuRyOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.18 482/552] seg6: reset IP6CB after IPv6 decapsulation
Date: Fri,  4 Sep 2026 07:00:39 +0200
Message-ID: <20260904045801.601998072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit f967455fb2a5a2079b9eb5823e9ccf359174bf9f upstream.

decap_and_validate() pulls the outer SRv6 headers and makes the inner
packet the skb network header. The IPv6 control block still contains
values collected while parsing the outer packet, including nhoff and
extension-header flags.

End.DX6 and End.DT6 route the inner IPv6 packet directly to the IPv6
input path. An unprivileged user can reach End.DT6 from a user and net
namespace by installing a local SID and injecting an outer packet with
Hop-by-Hop and Destination Options headers followed by an SRH and a
minimal inner IPv6 packet.

The outer extension headers leave a large nhoff in IP6CB. After
decapsulation, ip6_protocol_deliver_rcu() uses that stale offset on the
inner packet and reads beyond the skb head. KASAN reports:

  BUG: KASAN: slab-out-of-bounds in ip6_protocol_deliver_rcu
  ip6_protocol_deliver_rcu+0x1118/0x1450
  ip6_input_finish+0x11b/0x240
  seg6_local_input_core+0xed/0x2e0
  lwtunnel_input+0x1e9/0x4e0
  ipv6_rthdr_rcv+0x525f/0x6c50
  ip6_protocol_deliver_rcu+0xcb7/0x1450

Before clearing IP6CB for an inner IPv6 packet, save its incoming
interface index and L3 slave state. Restore both after the clear and set
nhoff to the inner IPv6 base-header nexthdr field.

Use IP6CB(skb)->iif rather than skb->skb_iif because VRF processing can
replace skb_iif with the L3 master while IP6CB keeps the receiving
interface. Preserve IP6SKB_L3SLAVE for the same reason.

Fixes: d7a669dd2f8b ("ipv6: sr: add helper functions for seg6local")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_local.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -261,6 +261,15 @@ static bool decap_and_validate(struct sk
 
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		IPCB(skb)->iif = iif;
+	} else if (proto == IPPROTO_IPV6) {
+		bool l3slave = ipv6_l3mdev_skb(IP6CB(skb)->flags);
+		int iif = IP6CB(skb)->iif;
+
+		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+		IP6CB(skb)->iif = iif;
+		IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
+		if (l3slave)
+			IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
 	}
 
 	return true;


