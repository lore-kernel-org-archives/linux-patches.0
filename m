Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720E41FDE31;
	Sat, 17 Oct 2026 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256242; cv=none; b=PGIm3GiX3Nt19AtO7mkQxLjzAXftwcQHWqn/KKSI3vV3upjZDIflumbCcrSLtQk+YyBixYP2MjdKEdsvPeEP3WWc2dP49EwAnbBtFetuC3EnHBDmSoGV+GhqycAA9oiM+YeY+Nu22zIXCc4Ed6OdOc7h8dDUPhyyg2PmUfnlQgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256242; c=relaxed/simple;
	bh=UjyBnQUVrPaHOksJpdUyQxBwo9/DnJwKvAWwEz8b/XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bravf9W1ZtI90tq5r6sHb/PMIpkNsLJfdOYGp8ntg1++kuv60+Y7kGkYOjuxJE3PS809kRh1nX/fk/rvQLvG1UOMvPs/Xj/IIFqnJynoyrEmdbCwS35vfbWDHHBzJu4dWERQbjzgwGKi2XQZ4gQSfTd4C2B2Ircpk5Jd9qUXlSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yc81i9c5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yc81i9c5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899FF1F000C4;
	Sat, 17 Oct 2026 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256241;
	bh=72VTrAn4cr+j/7q5pzVIfbJGxpA3v0zRUHVC8Tvegp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yc81i9c5Ist5YXHfXz7UUx1dfJ7fywM4O1ZBEqnryVysQWejGGTqB2/C6D1a27kBt
	 YGqwN58QufsOCmvzxWI9mGHHdUzRYDeLDvADTDvLDA2edPj2ZiNP16fieWJISUrF+Z
	 +0J6R/8aQs7GQtasC0oLMuqD3T5+qX3qe2tExegI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilkka=20Lappetel=C3=A4inen?= <ilkka.lappetelainen@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0172/1674] net/packet: prevent TX_RING byte count overflow
Date: Sat, 17 Oct 2026 17:40:44 +0200
Message-ID: <20261017160435.572578323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2917,6 +2917,9 @@ static int tpacket_snd(struct packet_soc
 						    vnet_hdr.hdr_len);
 			has_vnet_hdr = true;
 		}
+		/* Prevent the byte count from wrapping into a negative errno */
+		if (unlikely(tp_len > INT_MAX - len_sum))
+			break;
 		copylen = max_t(int, copylen, hard_header_len);
 		skb = sock_alloc_send_skb(&po->sk,
 				hlen + tlen + sizeof(struct sockaddr_ll) +


