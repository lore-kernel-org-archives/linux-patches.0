Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210761;
	b=lY54RvRzGBNiR1cBDt0lutoKaxVWxX8CDkYzDEXL/7FR5IYJaQ4xqeGktuHK2YSUErZQ
	 k3YDFLyH48jE4l8UzPJTV9LnJSz6eRk9IKjIGy4rqHHmPfSOVfLU1KLS87vQp5i+mZsMm
	 rp79Qu/L2ggwzmFrOv2eZlCLbzCb6zP32LJpIUSpMObLfa/tOG55VUqOnz48oF+KGz01s
	 ZX6UCsumrjOXS/fVY2Jly0CGzYRvFp4WcAbBsmbWQYoxTKNweqag7reEI3JGWNRbuqHnC
	 EQXBTYYDxUcy8CzakjC049/tJKXK8dNE8JqDDLQhVWgifeJPVa8S0KjtNCRLmTnokeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZjKfSpf2VafU+ScNRCk9GBjk5XzhXhU/DNrS3l4lDD4=;
	b=pGAKW5EuKfaeDAFK19DbW8XmYINKrRNPYCy9VIM974xfO+e+p3cHUgIAGG5iZb6M7qFF
	 YPpsadp6K2OrqEXfSKm4veg+HJ/BCCSoZmmZDu5LYJply0aqYiXLB1yO3Z7Fn9xC4VBfz
	 vrvJlOjNwB5IQFmLohIdozxSAzMAjUwpNFnQ+uizTMdhusDtKYsueOL3pivtV8JEUmOLC
	 5SyJaxNH5BR8IWb/2BWfWRoQFFv03Ec636RsVLeS36326MnyMRaRPaND0/qa98hT45AyW
	 Q8joH/I4RTvNM7Fn/mipfUvAzI8drR5IC4ouce2WnarH0b3XzJxKQ+xKeiIJ8yHqUhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lNgp2ny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59D0606A322;
	Wed, 28 Oct 2026 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lNgp2ny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDB61F01825;
	Wed, 28 Oct 2026 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210760;
	bh=ZjKfSpf2VafU+ScNRCk9GBjk5XzhXhU/DNrS3l4lDD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lNgp2nyE98TQvWFvETcEaC2ZLZtvdrm5G9m5e4DGLBMuvCaPzqtdY52SKjU6bfKQ
	 DFzaRy0w/M/cSY5YYUTfRp0OkCUUpbwcMXoSviMb28sC7JAfeeD8+aT38wbQ7IDpuK
	 zwPZLusgdCtbX9wKMTStghToHuM3+2GZkbv3f8Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilkka=20Lappetel=C3=A4inen?= <ilkka.lappetelainen@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 140/571] net/packet: prevent TX_RING byte count overflow
Date: Wed, 28 Oct 2026 17:54:47 +0100
Message-ID: <20261028170011.338961067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2871,6 +2871,9 @@ static int tpacket_snd(struct packet_soc
 						    vnet_hdr.hdr_len);
 			has_vnet_hdr = true;
 		}
+		/* Prevent the byte count from wrapping into a negative errno */
+		if (unlikely(tp_len > INT_MAX - len_sum))
+			break;
 		copylen = max_t(int, copylen, hard_header_len);
 		skb = sock_alloc_send_skb(&po->sk,
 				hlen + tlen + sizeof(struct sockaddr_ll) +


