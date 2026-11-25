Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620827;
	b=A80BzMILOTGwRpYDeAqULCRvuZ8sxXyNRI1VqlNls+80+iVQUN0WYUxLFmfA+HRWn1NE
	 qXIJe+86NvdhNjbRt4u71wQLhZ1C8YMex2iToXOO475Dq8ucFh/fk/Zo76NAfnQe3bNen
	 7iVdHGtAPHj5m2lpCEOxRxxKTm0JdimZwZpr2NGdYb2uTA7HxL+hV5zWtDAJtNNdko//K
	 +888oFQdd/kfeW+A7uDyILv0+Dmrl6Ibh4F9EWrDpFYZFtRzT82YKN4RPXn/DBGIunWtl
	 9RPyzs13suP3nSy30q8ttYnhvAmlJl93ArYsBeZyq0aLdecrGGTSlh7hMWvBgMsWHNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JYhAwUXO0+ZNrpowCebGy+gF5B4X2cK1W7Y0sayaCj8=;
	b=ONHOcNbF5ZUYaCx3cACu6xQiIrxzo0jt/PX6A3vl0QpsgP7HuHOmb/uMmCNCg/zHLMSH
	 leiGoga8QGilAlO2YPS/jeoaNjo7Di4/djrmY7EV6wSEdRMBub2MRXm/SJfIN16CtRW05
	 IgIPjv+OL8lpeoTDW1zdUECY8MX3yTI9hb9LEtQIHYm0S/AnB464JV9qsVzBeRfX4bNOB
	 cHtR+1HD2ZBrrPxkXnFtUvEUZhHJk/N2mi0oG+IgFXImyJvqUAG0rEa9KNj3xWQu4FISg
	 aEZWbfGIE8zW3qYyULavN2z7z0vb4yTk6EC31YE5jVXHjQO9M5pSC6mEsnenAeRnzkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YhRHJpUT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6070C606A31E;
	Wed, 25 Nov 2026 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YhRHJpUT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2DC1F000CA;
	Wed, 25 Nov 2026 15:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620827;
	bh=JYhAwUXO0+ZNrpowCebGy+gF5B4X2cK1W7Y0sayaCj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhRHJpUT9Ft2FA3Kvc4fqeTb6Ce6sNvnbyoFxanEfXxvHFfWHADhmiegreWjbWWtW
	 x995awuK6jZZhw34YJujPem17on49+Vcbn/rWvxvrpIGdQoqYc2S4q+P+g4KEaGn5q
	 qgCioMU87OWEkENAqqqACROvONEQn+BO6b384p+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/990] ax25: drop a message being reassembled when a new one starts
Date: Wed, 25 Nov 2026 15:23:22 +0100
Message-ID: <20261125143822.911089681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

ax25_rx_fragment() only accepts, while a message is being reassembled
(fragno != 0), the segment numbered fragno - 1. A new first segment, or
a segment with another number, falls through to "return 0" and is
freed, but fragno keeps its value. Since every first segment is then
refused, and no segment can ever match fragno - 1 again, every later
segmented message of the connection is thrown away, until the
connection is closed. The I frames carrying them have already been
acknowledged, so the sender has no way to know.

This happens whenever the peer gives up a message half way, for
instance a station on an older kernel that interleaves the segments of
two messages, or one that fails to allocate a segment in the middle of
a message.

When a segment does not continue the message being reassembled, purge
the queue and reset fragno and fraglen. A first segment then starts a
new message; any other segment is dropped as before.

Tested in two QEMU guests (6.12.94, KASAN and lockdep) linked over a
serial mkiss port; one guest builds the segments itself on an AX.25
socket with AX25_PIDINCL and sends: a 2 segment message, the first
segment of a 3 segment message and nothing more, a 2 segment message,
a 3 segment message without its second segment, a 2 segment message and
an unsegmented one. Before, the receiver got the first message and the
unsegmented one only; after, it gets the three complete segmented
messages and the unsegmented one. No kernel report.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit bb9180c5adfc874ec340caca45b5f3f4d448fcf8)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_in.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index fd8669e5b7313..068f0c6c54cef 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -87,16 +87,26 @@ static int ax25_rx_fragment(ax25_cb *ax25, struct sk_buff *skb)
 				return 1;
 			}
 		}
-	} else {
-		/* First fragment received */
-		if (*skb->data & AX25_SEG_FIRST) {
-			skb_queue_purge(&ax25->frag_queue);
-			ax25->fragno = *skb->data & AX25_SEG_REM;
-			skb_pull(skb, 1);		/* skip fragno */
-			ax25->fraglen = skb->len;
-			skb_queue_tail(&ax25->frag_queue, skb);
-			return 1;
-		}
+
+		/*
+		 * A new first segment, or a segment out of order: the message
+		 * being reassembled can no longer be completed. Drop it, or
+		 * fragno would never come back to 0 and every later segmented
+		 * message of this connection would be thrown away as well.
+		 */
+		skb_queue_purge(&ax25->frag_queue);
+		ax25->fragno = 0;
+		ax25->fraglen = 0;
+	}
+
+	/* First fragment received */
+	if (*skb->data & AX25_SEG_FIRST) {
+		skb_queue_purge(&ax25->frag_queue);
+		ax25->fragno = *skb->data & AX25_SEG_REM;
+		skb_pull(skb, 1);		/* skip fragno */
+		ax25->fraglen = skb->len;
+		skb_queue_tail(&ax25->frag_queue, skb);
+		return 1;
 	}
 
 	return 0;
-- 
2.53.0



