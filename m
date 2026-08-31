Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E0A4A49BB;
	Mon, 31 Aug 2026 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183813; cv=none; b=P/zITlHXHZLeQS81b2UtpHTZnVZMzs1LRtitiOZqt9Fvcvb8HHl6ZNGYC0qOuJ9rCg6qOKvAR/Rtj2wnLLWyTQZSY3vdUv9j6fs/ZfYZsXmOa+19NfqqLLx06J2dvbCvhY56ZnG+fqL99fxshLeaM6zNBSj0DiJVYAMrllwkWM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183813; c=relaxed/simple;
	bh=VSrPqwm3bLeTIdQ5fw/PrZJ/V7FGujnT2+pOHGllZx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPOmv7jxO+HvNeEO6T0+67nccNINP/alC2v1/YIQy1WHp44Df/BxYHyohanp52ckrm2hcEtpDYf05PwyMiuNe4Da8EO6dpreil0NjtCv1G6AmAHzVQjoK5xeNvjZf8OWGAZzQHoReYnytPfu/EKmgWQkisM7xe7ThuC1Sb10VCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8cagU6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8cagU6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463EC1F00A3E;
	Mon, 31 Aug 2026 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183810;
	bh=wsedlHiHlHhxBXDFYn0JxCRVHuy/99PFmpQnZ2HINoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8cagU6kjX5SsCeJYPovkLjUrl/m4sUmEQmHAVYV/iOXNe3l79hJXNKqg05eTJthL
	 07m3CB8JlTgtoiDlKqYEKwCkIHK6/jjlGlYsKScLMWETSJcppGDsT6ws/A/cScJIP5
	 Gt4k/H04UHgi8jRaEXpdV06/YgHk8ssNd1uoj/bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 49/76] ipv6: seg6: clear IPv4 control block on IPIP decapsulation
Date: Mon, 31 Aug 2026 15:34:21 +0200
Message-ID: <20260831133401.967708511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


