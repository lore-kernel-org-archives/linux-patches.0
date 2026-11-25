Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623907;
	b=aSSS6qAW8p7/ZrpbQ1lZSWXDR6L3P6M4dScs2ZUzjXbhVraf9uRvwOK5ugmeovMUcMfl
	 XZmBtn42m/HY2hNx+sRtADyjLZdq8ID8+ujnt1LUoWdMU/WjjBNsQW3CR3H/hSyWwwTYG
	 oSdRc3vcVS4R88NktORHEUIYQWf3dKwGKSNhFUMFwfI1jUNfGhHyILrLBWTD/nbt7sTer
	 Q/QnbdEfwcJlNFvfinl6p4jGRir2a6ebIuckWIm/qnxp8TbBrog6eUfx8YxVh7KNffCHu
	 yzidaocz3nh4tVCvsvUV7U2dNwGfx1NWzkmbhyPjdNreYmzGw+QXrTYt7xocQw5U+9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L1TZOSObYU7IIqP/oAILl5WEpXxZIXHamQFRR3BNxbs=;
	b=v+1qGSy+Icdz9oR4TOgWUb48dJ2dACMfzNSsbu5EjxgTjE3sOrY9HrBh+021xOrpQadY
	 WSR4CsKFiaJdIh0cWYBKQ7fTKWIADKjhLT/bQvf1l7G6uuP5+3rwce/qyUUtPRJ91So52
	 fEbV4vfDBE7Y7V+phqsPvgq1VUizPnKge8kyaJQhO0+6opz6Po+F2rf12GviDZSmfz6NH
	 8trAeSoL2gqtelHCifAwmJ1GHG9XBIUx4XK/nPlCHA0PjNPb7OC5obBKxvk3vC7Ky+D2D
	 pRTZvgcERDN38RLBbhoy9u9SjrJmKLd/wymzC1u052Hz/lYpJ5cXA4CU8poNHu7q6lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEeZ1qg7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8962606A323;
	Wed, 25 Nov 2026 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEeZ1qg7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262321F000C4;
	Wed, 25 Nov 2026 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623907;
	bh=L1TZOSObYU7IIqP/oAILl5WEpXxZIXHamQFRR3BNxbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEeZ1qg7fx8pTzbYEP6ORZKAR8G2qdfEWKMYDLMD3kryDggPJ7cGDbKkZYaCFEi3j
	 M24OU4eWbx6iIoZ+srjZRZ2Mo9ZuBFCobQ1FPiLIt1gva1eo8jm1vGPar/9ihG5SIU
	 m+Zqw9V+s7FS2qDRsDE6xI0aJZyNwEdt58TdOh4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/816] ax25: drop a message being reassembled when a new one starts
Date: Wed, 25 Nov 2026 15:26:11 +0100
Message-ID: <20261125143849.752945530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



