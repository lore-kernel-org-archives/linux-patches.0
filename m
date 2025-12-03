Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10830305E05;
	Wed,  3 Dec 2025 16:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779993; cv=none; b=BD0mET4AGG7/I2uMigH//GDFzBWb1DKVeYZqpAgq1d4kPu6tn2/j1YrRyLa6+3mGMDrqjshn3BtEEqOUYwmUM0NFV4c82CVf50HXso6fKj7V/JrHnCyfGlcfPPVeF0uvAk+bB9SoSOHKDvMwetSzBC2uqxNW/D3y5+869ZrYQCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779993; c=relaxed/simple;
	bh=dQ73bm1OBx4QuEoCQqQvnrShB32S4Jv9HN8hRWVvsZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBHZBbahSOgwebkYgQ0LK5E629z0+1oB17/BcvJeQkN+f5K2RirQdH334ASSP24gpIBNynqecTGCgrLa0Vfmi5BVDaiqWH7Vlobl4/LevAADpdAEzHEjhPibWOU1wTZQTgBw3xzY/4SuZiUCpx7EgRlyTb6PleCUpPhe+HOViKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXUB5kp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXUB5kp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DB6C4CEF5;
	Wed,  3 Dec 2025 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779992;
	bh=dQ73bm1OBx4QuEoCQqQvnrShB32S4Jv9HN8hRWVvsZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXUB5kp6jyugxrAGqx46r+O+9S9Kxt/qwN4lJXQ48aZ5ZB+awTW9BgWOuye0WZNQ1
	 c/D3LsRXibUCIdu9a5UjRYqyd2qYnWLmO8oaiCyvYOV2Cw+dv8ImQHUDgpPXMrUEYW
	 8hy2FKt8aMQVjeZGP6xbZMBvpYGmrULogwcMEBJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Ruohan Lan <ruohanlan@aliyun.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 390/568] espintcp: fix skb leaks
Date: Wed,  3 Dec 2025 16:26:32 +0100
Message-ID: <20251203152454.975761704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

[ Upstream commit 63c1f19a3be3169e51a5812d22a6d0c879414076 ]

A few error paths are missing a kfree_skb.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
[ Minor context change fixed. ]
Signed-off-by: Ruohan Lan <ruohanlan@aliyun.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c     | 4 +++-
 net/ipv6/esp6.c     | 4 +++-
 net/xfrm/espintcp.c | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 8f5417ff355d7..a40f78a6474c6 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -152,8 +152,10 @@ static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
 
 	sk = esp_find_tcp_sk(x);
 	err = PTR_ERR_OR_ZERO(sk);
-	if (err)
+	if (err) {
+		kfree_skb(skb);
 		goto out;
+	}
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk))
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 085a83b807afd..48963fc9057bc 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -169,8 +169,10 @@ static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
 
 	sk = esp6_find_tcp_sk(x);
 	err = PTR_ERR_OR_ZERO(sk);
-	if (err)
+	if (err) {
+		kfree_skb(skb);
 		goto out;
+	}
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk))
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index d6fece1ed982d..b26fbaead7a55 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -168,8 +168,10 @@ int espintcp_queue_out(struct sock *sk, struct sk_buff *skb)
 {
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 
-	if (skb_queue_len(&ctx->out_queue) >= READ_ONCE(netdev_max_backlog))
+	if (skb_queue_len(&ctx->out_queue) >= READ_ONCE(netdev_max_backlog)) {
+		kfree_skb(skb);
 		return -ENOBUFS;
+	}
 
 	__skb_queue_tail(&ctx->out_queue, skb);
 
-- 
2.51.0



