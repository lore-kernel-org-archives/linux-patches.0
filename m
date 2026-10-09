Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5184E77EA;
	Fri,  9 Oct 2026 14:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555632; cv=none; b=BqFdUQ4GnsyzZHqnxTUg+90u/bd2gcZVE4f9mgDhMmoIkGaj4VC1kpY4cQPhmRiuBSLCTzJScj6Mbd70yHp0bJht1UtKZ1lcTmeQn5b0NvSg5rr1Cm6uziXk/RlVKSGkuIdWPrurPNlTAletxGCId9i90QSRYSHtj0eblh8wzwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555632; c=relaxed/simple;
	bh=ee1vYGTFIg4qOZYxXfeRNG0C8II65UDoC6kXSWwg93w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+8oYrMXA3zNfpJX0meSMnXWGV0B4XnyHLuA47RaBCg4onyH6/KpskSAgcI9f+FgPfs7RueJxdihvzyN2Fdqt2t72hm2CYAVZJRGrO7seU1/LeeXNyutAx6Jn7q08EaNL9lvRU/+NDkq4xGnjtmKPIKAHpcX25+opXfisoIp8GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYsLwEjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYsLwEjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370DD1F000FF;
	Fri,  9 Oct 2026 14:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555625;
	bh=1NTM6SPDhHepmr39KHbr5KaKbnrx4zjEwZX+qYgr5qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYsLwEjVOjqJQ+nbVnQTSKxiXZwBkCVsH1fyJKNUTDjwkX08xYEXrxLqXpFmGgkVb
	 AJ7gJ4CAl/PjHsQGChrmDY3mNMnFOBAL6oIW8OvQnZZjLB+x0ja3MGHfGBckNl90Om
	 Bh5dJ2+XH9uCT/gtZJZjyMVSsgr/WPC6ttRaJGjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilkka=20Lappetel=C3=A4inen?= <ilkka.lappetelainen@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 039/428] net/packet: prevent TX_RING byte count overflow
Date: Fri,  9 Oct 2026 16:06:16 +0200
Message-ID: <20261009140946.952675617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilkka Lappeteläinen <ilkka.lappetelainen@gmail.com>

commit 2cf81fc9505b148b1b70068303ea6ea4b1212403 upstream.

tpacket_snd() drains every SEND_REQUEST frame in a TX ring and adds
each valid packet length to the signed int len_sum. Userspace can
recycle completed frames concurrently, so a single blocking send call
is not bounded by the ring size.

After enough successful transmissions len_sum wraps into the negative
range. In particular, 65536 65535-byte frames followed by a 65007-byte
frame produce 0xfffffdef, or -EIOCBQUEUED. sock_sendmsg_nosec() treats
that as an impossible return and triggers a BUG. On systems configured
to panic on oops, a CAP_NET_RAW holder can panic the host kernel.

Stop before the next frame would make the byte count exceed INT_MAX.
The positive short count leaves that frame pending for a later send
call.

A two-thread TPACKET_V2 reproducer triggered the BUG on an arm64 build
of Linux 7.3-rc4. With this change, the same reproducer returned the
expected positive short count without an oops.

Fixes: 69e3c75f4d54 ("net: TX_RING and packet mmap")
Cc: stable@vger.kernel.org
Signed-off-by: Ilkka Lappeteläinen <ilkka.lappetelainen@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260925124829.6595-1-ilkka.lappetelainen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2874,6 +2874,9 @@ static int tpacket_snd(struct packet_soc
 						    vnet_hdr.hdr_len);
 			has_vnet_hdr = true;
 		}
+		/* Prevent the byte count from wrapping into a negative errno */
+		if (unlikely(tp_len > INT_MAX - len_sum))
+			break;
 		copylen = max_t(int, copylen, hard_header_len);
 		skb = sock_alloc_send_skb(&po->sk,
 				hlen + tlen + sizeof(struct sockaddr_ll) +


