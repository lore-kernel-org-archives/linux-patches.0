Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BB5511E8F;
	Mon, 31 Aug 2026 13:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183784; cv=none; b=H+1Z4GMzW00T7SNdr0ivHvVgg3vChgos3D2niXpw/xPQ6HoO2TvsdZKyfNZ826CdVanj2/uGlShg9bYupnviJt6Va+2+baQzbB5Oz7VpQZy/ebi6j8C03iLKui4d4mvMnvu3dVAhP3QXnQF8TJN9vJiL3ROOt7CStFZfoHegPvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183784; c=relaxed/simple;
	bh=4lSmKx7Az8BuFzr1SOZErnp2DA8BTtaf14Yi+04W1es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1CxzpRjTnFqOhBZxp1IlzGu+bKGZnYTTnA42CxTOsa7mUrMxzv8ju4nPCHeOCGr6vnzqG8znKaOUtYdNsTpi+R/DKrBfXfFg8g104ng7rVigE+L3D3+QPNjXYh+52nk1i/oMbrG3G15hgjjxCiUTYGhXGicjgBKjf5kcKJ5rj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9z0xVN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9z0xVN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C221F00A3D;
	Mon, 31 Aug 2026 13:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183782;
	bh=5fAP+drLXHdu17teRaYHEZUQ4jlD9ts5h7yeDKyu6RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9z0xVN7KkgJHYiZ4ZrxMJnoWBc1ZPXfe3t7ZyzPRHc0/yS8RabddfN08l3mOYuD/
	 OVQ3NXFooIERgFJYs50vLqfaaYaKn5o4gx+9Xa3uhnddlRm4t7vXzFTqfq1K0LsAWB
	 D7rwn2JsUPwJZgZK3Yz1E3kTgHXW3crEZF2g7/bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.1 40/76] xfrm: espintcp: fix UAF during close
Date: Mon, 31 Aug 2026 15:34:12 +0200
Message-ID: <20260831133401.495133877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

commit deb232e884877bf10b4ce2580909eedec986c284 upstream.

ZDI reported and analyzed a race condition during close for espintcp
sockets:

    espintcp_close() frees emsg->skb via kfree_skb() without holding
    any socket lock. Concurrently, the xfrm_trans_reinject work queue
    invokes esp_output_tcp_finish() -> espintcp_push_skb() ->
    espintcp_push_msgs() -> skb_send_sock_locked(), which reads the
    same skb as a data source.

Fix this by adding a synchronize_rcu() call after resetting sk_prot,
since esp_output_tcp_finish() runs under RCU and won't use a socket
with sk_prot == &tcp_prot.  Simply taking the socket lock in
espintcp_close() could lead to leaks, if esp_output_tcp_finish()
re-adds an skb in the slot we just freed. After this, the existing
barrier() is no longer needed.

Cc: stable@vger.kernel.org
Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: zdi-disclosures@trendmicro.com
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/espintcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -515,7 +515,8 @@ static void espintcp_close(struct sock *
 	strp_stop(&ctx->strp);
 
 	sk->sk_prot = &tcp_prot;
-	barrier();
+
+	synchronize_rcu();
 
 	disable_work_sync(&ctx->work);
 	strp_done(&ctx->strp);


