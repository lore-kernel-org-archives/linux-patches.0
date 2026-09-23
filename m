Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B6B48EC6C;
	Wed, 23 Sep 2026 14:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173511; cv=none; b=JEMWqGZwlFeIFctySqJ9Y0JxnsSNWNiplMRCsGQX4oAailnrhPk3ExuE4wAcpYJH36M9VBPgJ0aQPgzLRz6xSmcc6X5arvXJ2NFg0fUy4ZktoqzJ9zZLYo9/WC8skdg5QY/jsqC3prObnhrEdO6oWpdfNdfnLOP6MpURXg4tFKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173511; c=relaxed/simple;
	bh=gZsgWdZAuOxs/2/4r3FbzhYj4nJHMoJlySf4n7+LkMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2rCyRZBm9vc2l9wjDIKZN0Rzs+fqBB9BtVDXEbv8Uq6yQF1v2Xe0z68iRvzvSEQfn7Aw4iwJfIKvhnbuUmdiAxIsIlYFpL3zruu0vW1+r0808q6S9TnVo73BSBgVfAVaJzt7dRQ1yNJ/vVh6znjhm7vZT5AnZuBMouw6MsUQXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7GjpWhN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7GjpWhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744041F000FF;
	Wed, 23 Sep 2026 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173509;
	bh=aTyC4sq3i2S4qiCK8ZthieWLIPbckIgmiPydJqqdxFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7GjpWhNx0M1HXxeQc9Hp5U06qcdHfiyThKIkCqd3ipShdERGy8VOfoeurc5IMY0i
	 onRBskVIgQ9B9FP0tNaV2prNI7D6bdgDEk1YeoMFuM3gfkRLPF5INjnn3x+aB/N2qd
	 wEz4BxU0rOW113RnKofoRZUOCzf6K17wcHmBTayg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Wyatt Feng <wf.kernel.dev@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.2 269/438] net: xfrm: reject unrepresentable espintcp transport headers
Date: Wed, 23 Sep 2026 16:04:50 +0200
Message-ID: <20260923140651.739536307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -30,7 +30,11 @@ static void handle_esp(struct sk_buff *s
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


