Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A13233722;
	Mon, 13 Apr 2026 16:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097893; cv=none; b=RyZDWHXoOgecLTdYjDYJ4L2GxgjkYFwol59f2xrw88ndDoyiV0VDhljS6kJSMNtRiNwVlVoNbg549hfNE63S8sbJzt7eyEXqD5XU9KERpRVuOsryry1B9BI8XONbBOeF7JJYeLjah6uqN7GHDZcwdA4tqWIsBNINvLGYf/w8bFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097893; c=relaxed/simple;
	bh=B5B6UE3iQ0pFLUIA1uHfqWjp1qxDNDrtU2MDd3MISKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fopLeJy8twHJi9TVzZKUGTGW0h/Wc/SlPPWRsR3UWCctB0lkeF2l4pk91R0Pq8I9QqvRmsRbjoq5vr5JL4TGzW89LYzv4PEwnxO9jQEnWtB+McerFE6rCdRyK4qAFSPxhOGgRtDOBjB3GJIrIub78Ms38iKs8axriYqiCt5Hh7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tC6kFzdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tC6kFzdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB49C2BCB3;
	Mon, 13 Apr 2026 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097893;
	bh=B5B6UE3iQ0pFLUIA1uHfqWjp1qxDNDrtU2MDd3MISKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC6kFzdhnv9PSihtrAO37bm6CDDpJsweJwHzGzbVvhRJFI1CimbagyWfEPsXTgcVx
	 EthVjwaN5P2GJWc+UdTc1xmOFh+8zwHDgeYkTyi17C99ul8zZYuVDGVp08b8OC/cc5
	 tmARiFiiU6E3v0G8Cg7BpOVLrmxkJm5Up60Joy/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 314/570] esp: fix skb leak with espintcp and async crypto
Date: Mon, 13 Apr 2026 17:57:25 +0200
Message-ID: <20260413155842.258457440@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 0c0eef8ccd2413b0a10eb6bbd3442333b1e64dd2 ]

When the TX queue for espintcp is full, esp_output_tail_tcp will
return an error and not free the skb, because with synchronous crypto,
the common xfrm output code will drop the packet for us.

With async crypto (esp_output_done), we need to drop the skb when
esp_output_tail_tcp returns an error.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 9 ++++++---
 net/ipv6/esp6.c | 9 ++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 272b64fd09eed..c69cee3feff00 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -275,10 +275,13 @@ static void esp_output_done(struct crypto_async_request *base, int err)
 		xfrm_dev_resume(skb);
 	} else {
 		if (!err &&
-		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
-			esp_output_tail_tcp(x, skb);
-		else
+		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP) {
+			err = esp_output_tail_tcp(x, skb);
+			if (err != -EINPROGRESS)
+				kfree_skb(skb);
+		} else {
 			xfrm_output_resume(skb_to_full_sk(skb), skb, err);
+		}
 	}
 }
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 57e48dd905a48..e87f3f8f06818 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -312,10 +312,13 @@ static void esp_output_done(struct crypto_async_request *base, int err)
 		xfrm_dev_resume(skb);
 	} else {
 		if (!err &&
-		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
-			esp_output_tail_tcp(x, skb);
-		else
+		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP) {
+			err = esp_output_tail_tcp(x, skb);
+			if (err != -EINPROGRESS)
+				kfree_skb(skb);
+		} else {
 			xfrm_output_resume(skb_to_full_sk(skb), skb, err);
+		}
 	}
 }
 
-- 
2.51.0



