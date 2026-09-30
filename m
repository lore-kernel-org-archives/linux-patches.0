Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5393AE71C;
	Wed, 30 Sep 2026 18:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792068; cv=none; b=H7R3DUnvy+mXsfOo6t1YgIl7Pw3Ky7XcR4go60v0zwRnQeonhy1vrF+HEP0mFrRFICzCeP6tiMNuByyrXpE1wjTVQzJYlbTREcdG3HqInmYunWny91/5yGlA4V9o3OpfwrYJyPXNYmm63njCRNlk9Riim6i9ZdO8pqiHZdgZLco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792068; c=relaxed/simple;
	bh=VgQJTmSmEuJ3ZmBt4z59RDV88qQrXHYJgewaTwLsf2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOmykMl2BA5UJeo0brZiKpjJaYvJE+VoXjXr2aipMNNGac1MbUdYbbydQLhhOZ6luqqykkCn/jiqvnr1yUv4uE/8fdVhOV3hjjM7D+L1hXylSccYx2cx+GmsxPqfrAtUYT4wyW86fDA5/ioQMsnHDAPaf7Tmj77HaZy7DZ0+kYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwNlxKgK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwNlxKgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F601F000FF;
	Wed, 30 Sep 2026 18:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792067;
	bh=i5UxAcLrJQUgnM3EMvIVhsfyYWKhmWQOF0av0ih7pbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DwNlxKgKAZX4D4IP1nVEKSjWj6go2fWQUbfVU83y+AbVneWoc+s/KQnosFzKEz1Yy
	 lHtuXPvonGWIUkABF2elhb4428xwutKnU3jHnUeZsdikHs1rBeOifMaa2l2xbTOlBC
	 hk8egjDMyVteaRZwKuNaHeamO8Nh2Q1Q70pZuyHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Wyatt Feng <wf.kernel.dev@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.15 525/752] net: xfrm: reject unrepresentable espintcp transport headers
Date: Wed, 30 Sep 2026 17:26:35 +0200
Message-ID: <20260930152409.615218778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


