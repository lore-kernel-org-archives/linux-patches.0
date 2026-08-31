Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9CC485508;
	Mon, 31 Aug 2026 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184886; cv=none; b=rGZHtQKCFMFKF+y1ZaM3/u4G0PFIVINOMVATNWY5NCMEA6QzMz74niowubEL2wDf7Xij6JLSy2iYqgNlFyGrNjppmYxIDZntfsrdHuEFAAFMdQCFi3DnshjxKPEzbva3Vud2DaOOysyhW1FmbxerEO1gEhoksvVoCD7ogIVAfo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184886; c=relaxed/simple;
	bh=9Fkdnu4ZSMh68A6i1vQXRZW93NQSgdccndJRlnVcaB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyynMayGh6sGFs+Aw9ZDJ2jUuNJUk93CP9bGYIt/ff5rV5uaipTO9gyJ0WoNunOu+kbHqwFatIXqFjrOB69/NmiGvytai9KZ9zu31DEYV0dZzRgh9znaqXTswWGgtzqwx+HmfL/B5NRjRDtnIFJ/sffCf++ULfB9VWyBZW4ZQZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXE+axee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXE+axee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BC71F000E9;
	Mon, 31 Aug 2026 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184885;
	bh=VUwe+B0y+TSKlgXVzZJy1lmiMMKVGD3bXb6DeGRBrgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXE+axeeEHWo15ZVUds68vii2EXGHQsqscqc6Qu6a/mVukOFdi4ABidRvKfwjRtim
	 bI/jvAorhxKvMls3QQPoZTm9Unnuu4suAIj2tL2qJFkGHCS84l58rBPXDH8XLwsl6Q
	 zjLEpIACgKzk1YzckABINpVrQKL1nAgKYo+5RUDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.1 72/92] xfrm: espintcp: fix UAF during close
Date: Mon, 31 Aug 2026 15:35:10 +0200
Message-ID: <20260831133403.338266847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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
@@ -512,7 +512,8 @@ static void espintcp_close(struct sock *
 	strp_stop(&ctx->strp);
 
 	sk->sk_prot = &tcp_prot;
-	barrier();
+
+	synchronize_rcu();
 
 	cancel_work_sync(&ctx->work);
 	strp_done(&ctx->strp);


