Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC6B39184F;
	Fri,  9 Oct 2026 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555374; cv=none; b=HgruiEHwxAPeKUAaKtueOI/6g+zIBDXApuA5js9iMWBJw5EYvh4I2tx0tP6t2ixlI7HMyCcx1iBXfv9+uxHTBYHH77g+kv84nSclOmzDuki8fwKcNKNlT+Z8jfHn889HsasySeRmXUsyLbgac5DUCsVGGJjfiKUInSUu+ifAdQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555374; c=relaxed/simple;
	bh=gNG4XHiY9XbVJ3rrxFTGVHNU7NztQLzv/7ELkEi3ek4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAkD7kVD9aysPadPBC8678D9qEoB/Jyrof9lcFkcC1YEx2vjv5tcGNEQE0QWA20NP7DRLXJIBx2Xoi0dy8xi+m3ktWe7C8uFJHRNVWEbuju2BqH6PivGnur2wTtQR8cmv2MGucWhLbpStkhX0sWd9zipDNirwqLA7i+izT2zS2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WzwEJ9+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WzwEJ9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8241F000FF;
	Fri,  9 Oct 2026 14:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555370;
	bh=WmiWbihq6lLbblnmZve3zSZ/XiU89Las2ojnw4oAXhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WzwEJ9+Vy2WDi5jf+fkY10eL6tJPhpWMwNF+LV3cuaQsvJSsCIwH9qnacbUC2N/l
	 IW9kGM/AC5zEp/EBaZxoGIMr6N8yoq+ukQpM8G+zWC891xNDJHQi6zYTL27H8XPFsR
	 NsWt7AuVeQPip7zJHjCdzQxLZeWqIcJ8xenPjUDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilkka=20Lappetel=C3=A4inen?= <ilkka.lappetelainen@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 035/403] net/packet: prevent TX_RING byte count overflow
Date: Fri,  9 Oct 2026 16:06:36 +0200
Message-ID: <20261009140952.932183371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2873,6 +2873,9 @@ static int tpacket_snd(struct packet_soc
 						    vnet_hdr.hdr_len);
 			has_vnet_hdr = true;
 		}
+		/* Prevent the byte count from wrapping into a negative errno */
+		if (unlikely(tp_len > INT_MAX - len_sum))
+			break;
 		copylen = max_t(int, copylen, hard_header_len);
 		skb = sock_alloc_send_skb(&po->sk,
 				hlen + tlen + sizeof(struct sockaddr_ll) +


