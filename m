Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208522;
	b=txJU6IeS14gFoQAdQ/9o9VZI7V/C252R8q58cy5ji6jB5ndTiCknL8gIpqoQKGoD2SXf
	 x+PIxIFqqHWv5DOHpRLg4Z+MqsWAUbzbe93vYTKbpx6JdkDLUyrfH3iryC/yipFRqpg3u
	 yH1Gmf/eWRIC1eLyxDlotE6Pk27uKCgB7u+KA/Fr4C/6/ijleuJpBxojh8MoQHBvy5I8R
	 Gqg1qie59L4UYEK73q7LsnLJzYtOGa4qTCOn/BDCbkbzIs/CNxmBGzGoT2Ve8C8/327CP
	 w53CQG6wFu3RRycMvXBPB0AQy9YU8em4DswYxJTidvmh8FbVtgtt0snOg6QE+pI34iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oisb49U8Bvvx4q/VGUVBJR0mba4q/tUQG1F2t+Vp2Ts=;
	b=ztU6o9NSsJVIDb1kLxDPSVvVgFAjZlT2oJ8TXKBBpNDSghivbyjpiEyFSTh7gnf1vzUW
	 AEqk05YpwAGBRtk9+JcAPuc2ooE4H5Qql08i2rB4t4dQYt+KlP+0sBRxKdvi4oyD1yzIP
	 7sTRVYpThK0dGmL4IwRZIhnB+70qvPLbwi1JAvwUkxoHf6D23S+9JVoRl4eOCRBxstH1t
	 x/FbhF9Y/wkIgHdTkuGT5BC4lDPm8ZJYr9eUkV7zCOfudxH5UKb6hN8/tNpA9KIQe63rT
	 vRd9EJAOIJ7CqCEFDj5vbfUrL3S1F3kSwawQguAY2q/1aeR92bdK/SkGhaOrKzbTQNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z2p0vq6m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57646606A31A;
	Wed, 28 Oct 2026 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z2p0vq6m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CE11F01825;
	Wed, 28 Oct 2026 17:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208522;
	bh=oisb49U8Bvvx4q/VGUVBJR0mba4q/tUQG1F2t+Vp2Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2p0vq6mLLDa5aKkBTSxTsfboG6fMB4nTClYcH8qv54RhJ0l/PAkFnIwY+JLVQuBU
	 aZVE1N9mBC2w7tFi1CU0c3KOoY6v3XwH0sVhczrN9STybHE22JWRnqiVq0BenoS8PX
	 j4IYs1E0Lnw5kzbz8tCeXsy6VMN8iEMI45GUE1wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilkka=20Lappetel=C3=A4inen?= <ilkka.lappetelainen@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 142/516] net/packet: prevent TX_RING byte count overflow
Date: Wed, 28 Oct 2026 17:54:54 +0100
Message-ID: <20261028170006.873509161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2867,6 +2867,9 @@ static int tpacket_snd(struct packet_soc
 						    vnet_hdr.hdr_len);
 			has_vnet_hdr = true;
 		}
+		/* Prevent the byte count from wrapping into a negative errno */
+		if (unlikely(tp_len > INT_MAX - len_sum))
+			break;
 		copylen = max_t(int, copylen, hard_header_len);
 		skb = sock_alloc_send_skb(&po->sk,
 				hlen + tlen + sizeof(struct sockaddr_ll) +


