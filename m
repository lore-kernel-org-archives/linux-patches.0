Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E3651FCD4;
	Wed, 23 Sep 2026 14:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174787; cv=none; b=qmifoCK42JY2tehtINwNwo1jK5GmSB8/LgKQJFz2R99eh5AOpmnxQy8EUwk83d0SwD4IsOOkTkuZIWQs0FS0Kowy8UgzHZi9PYVHuQeiI5ImChmgDiSizXja6+V3+Ajn/DJe4MdvtPUjF0EoZzCVPtow9+QRX4LaxQ4/vpN8HQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174787; c=relaxed/simple;
	bh=MS8gZaBpTezjFLWQ14GjnJVT7s7qgWHAMaPKHywbpOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jfw4511EKbBX+CF2n+nj0N5xETC4YUlakCTXzg8h7KqUcADLDzSUUfZpd/iWBmIE0e5bL4I7ga0GhXaSFB1dIijJVzLdmoqCby9T4+6aP0yS6hrQ8hxPbBuzDSp29gcU1T1guacz/zzvv9E6ztfHI5uQY5kQg7QlSqe06mGT3H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdCQ0GLs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdCQ0GLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9A61F00893;
	Wed, 23 Sep 2026 14:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174786;
	bh=lD73PH15P4Z+TZ8B8wHGRpH5PgIjMjZtwNkMdiww5n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdCQ0GLsnNj5kYixDPQxINhzv7qJcGk17vrFXMDDQz7mmn1qxvjwlCgf7/BjfQjtB
	 awqMbls9NmKoz2CCFAHrDWQuLUvwaZY5Ns/Fl3TQrxoeZJ6nTe7oIrD4ZcShUMOJDR
	 8sPm5tSEagIYGI+L9Lc4LJfpFiSGxQZNl+m92l7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Wyatt Feng <wf.kernel.dev@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.18 225/398] net: xfrm: reject unrepresentable espintcp transport headers
Date: Wed, 23 Sep 2026 16:04:59 +0200
Message-ID: <20260923140649.253938651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -33,7 +33,11 @@ static void handle_esp(struct sk_buff *s
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


