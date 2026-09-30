Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE66037A825;
	Wed, 30 Sep 2026 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785987; cv=none; b=qucvlCzaK6USIi3F6C4eonPhBYmqqQjDT5b4tu4n5+3u8BC7+sZEc7yGPot4m7WQQf60j415a5XO0r7x36FaJktGSpkvCe3QC10chUte1GkImEiiKncWWOSsdIJ4Nj5fQXSklRAZ6ymW24+Fi76YU/97+mSZZ3np9J8iGCH1GoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785987; c=relaxed/simple;
	bh=w7Y6vNcdMT0QVwsNwxUYAmaZaAA53fbWph+gR8sv/94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIyBL2rB0lcBtAc9dfNaFeP/+4MF74w1hM1zSiATyxq3tId4Mg/7jIRozbXpzE9gJKgKgfhEPpWEbrxvJgdfJcAryYJ1wQkRr+wVPqWGBVDNEpmi/cvWoYvowFXTT+vWog13mOoMmL9M46eNffyGy/ArBIzUkpkmCMMzPZX5XoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWUxyHgK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWUxyHgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BD71F000FF;
	Wed, 30 Sep 2026 16:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785985;
	bh=+3Ubjp0PTkH46lnM/6/K4a7dVmRWBwqHUd7Qz24b2pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWUxyHgK7EIEVb/kTbyz6rTnFX1qRoOBIofbFD1wz51mgJsM0XSow92qU6ncw7p8S
	 oYHaEK3AfA/KOBW4+QGDez2bXEDjGqowv+I4BwrUVjolsIKb+MJIc3akUcS9tWV0RH
	 6XJ2UdpktQsMgF2eI3iL3NDRanFSH1Qi9LU2XOik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Wyatt Feng <wf.kernel.dev@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.1 703/982] net: xfrm: reject unrepresentable espintcp transport headers
Date: Wed, 30 Sep 2026 17:23:59 +0200
Message-ID: <20260930152431.858519371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wyatt Feng <wf.kernel.dev@gmail.com>

commit 96f01b53c2d05e003b040892256de54a586e8529 upstream.

ESP-in-TCP can hand xfrm packets whose transport header offset no longer
fits after the stream parser trims the TCP envelope. The plain transport
header reset truncates that offset and triggers the skb warning path.

Use the careful transport-header helper and drop the skb through the
existing XFRM error path when the offset cannot be represented.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <wf.kernel.dev@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/espintcp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -31,7 +31,11 @@ static void handle_esp(struct sk_buff *s
 {
 	struct tcp_skb_cb *tcp_cb = (struct tcp_skb_cb *)skb->cb;
 
-	skb_reset_transport_header(skb);
+	if (!skb_reset_transport_header_careful(skb)) {
+		XFRM_INC_STATS(sock_net(sk), LINUX_MIB_XFRMINERROR);
+		kfree_skb(skb);
+		return;
+	}
 
 	/* restore IP CB, we need at least IP6CB->nhoff */
 	memmove(skb->cb, &tcp_cb->header, sizeof(tcp_cb->header));


