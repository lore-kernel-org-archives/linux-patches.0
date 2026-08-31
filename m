Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9A443BDA8;
	Mon, 31 Aug 2026 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184636; cv=none; b=rk9wpcilJa+nf0VHGoBLy0KEvMtirdnE72rmzTzmQNutYj0vn+DZed4E8twFRq7iL/3suR2Rdfap2rPh2YuHrk1yzGXy5AzJQEOr/NT7d7ERlp5rlPALCkzAFBRhD9tpdm9WYSIiWRmrK8HFh0T3BdQtKuNyqE2+CmqGrk6+qvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184636; c=relaxed/simple;
	bh=idyYsEhQKux7qmHIIMt7QuguGndm7KjF6BNH4nZkygs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgM1Hl9NLzAMJwtjf7S8E2DTXPlw7a/+qcocIYRIARYM5EGdrw7Q7O4b4wQ7nJWCFSESDUZuPlm9xWMzs6Xba8FOFQFXJ0gtUXSWqsM7n7kiNrcjO6gVN23TUR/471tgrDAvBEBGbqZwmwBln/V0kVW1xk+ayDWHf817HJvSUww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6LGSzuE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6LGSzuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563981F000E9;
	Mon, 31 Aug 2026 13:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184634;
	bh=sc32BmjViipSB4zbzzwnj+VhU1xvZjht73YrpnYMeTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6LGSzuEAAJi8pX7i1fnijfoPDaCeKIzbBEZEPnj03fvMEjHy5LsDcUJFRNUmwQD3
	 +4ATq9lRSsSv1P/CeEdlTPf2ptDY+7mhFpUzP+5YJiMzkmVGfrebyjfYTM1zKpWiRh
	 /kdvYDs4x2X6y9a150wP5hsHrwATUut704lml5MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 77/91] ipv6: seg6: clear IPv4 control block on IPIP decapsulation
Date: Mon, 31 Aug 2026 15:35:05 +0200
Message-ID: <20260831133403.583308141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit 44930446dde45a7a90fe1446fa38eb0e2c561646 upstream.

End.DX4 and End.DT4 decapsulate an IPv4 packet through
decap_and_validate() and send it directly to IPv4 routing. The inner
packet therefore bypasses ip_rcv_core(), which normally clears IPCB
before IPv4 interprets skb->cb.

The skb instead retains IP6CB data from the outer packet. IP6CB and
IPCB use the same skb->cb storage, so IP6CB(skb)->lastopt overlaps
IPCB(skb)->opt.optlen and srr, while IP6CB(skb)->nhoff overlaps rr and
ts.

The sender can make the stale optlen byte nonzero with a valid outer
extension-header chain. The reproducers put an eight-byte Destination
Options header immediately after the 40-byte IPv6 header and before the
Segment Routing Header. ipv6_destopt_rcv() records the sender-controlled
Destination Options offset in both lastopt and nhoff, setting them to
40. On the reproduced little-endian x86-64 kernel, IPv4 therefore sees
optlen = 40 and rr = 40.

Both tcp_v4_save_options() and __ip_options_echo() skip option copying
when optlen is zero. Here optlen is 40, so the TCP SYN path allocates
room for 40 bytes of option data and calls __ip_options_echo(). The
stale rr value makes that function read inner packet byte 41 as the
Record Route option length. The reproducers set that sender-controlled
byte to 255, so __ip_options_echo() copies 255 bytes into the 40-byte
option-data area.

Separate End.DX4 and End.DT4 reproducers on the unpatched v7.2-rc5
kernel both produced:

  BUG: KASAN: slab-out-of-bounds in __ip_options_echo()
  Write of size 255

The relevant End.DX4 call path is:

  __ip_options_echo
  tcp_v4_route_req
  tcp_conn_request
  tcp_v4_conn_request
  tcp_rcv_state_process
  tcp_v4_do_rcv
  tcp_v4_rcv
  ip_protocol_deliver_rcu
  ip_local_deliver_finish
  ip_local_deliver
  input_action_end_dx4_finish
  input_action_end_dx4

The relevant End.DT4 call path is:

  __ip_options_echo
  tcp_v4_route_req
  tcp_conn_request
  tcp_v4_conn_request
  tcp_rcv_state_process
  tcp_v4_do_rcv
  tcp_v4_rcv
  ip_protocol_deliver_rcu
  ip_local_deliver_finish
  ip_local_deliver
  input_action_end_dt4

tcp_v4_save_options() is inlined into the tcp_v4_route_req() path, so
it does not appear as a separate frame.

When decap_and_validate() handles IPPROTO_IPIP, save the ingress
interface from IP6CB, clear IPCB, and restore the saved value. Doing
this in the common decapsulation path covers End.DX4, End.DT4, and
End.DT46's IPv4 arm.

Use IP6CB(skb)->iif rather than skb->skb_iif. These actions run after
l3mdev processing, which can replace skb_iif with the L3 master;
IP6CB iif still records the receiving interface set at IPv6 ingress.

Fixes: 891ef8dd2a8d ("ipv6: sr: implement additional seg6local actions")
Cc: stable@vger.kernel.org
Suggested-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260817085839.946321-1-david.lee@trailofbits.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_local.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -256,6 +256,13 @@ static bool decap_and_validate(struct sk
 	if (iptunnel_pull_offloads(skb))
 		return false;
 
+	if (proto == IPPROTO_IPIP) {
+		int iif = IP6CB(skb)->iif;
+
+		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
+		IPCB(skb)->iif = iif;
+	}
+
 	return true;
 }
 


