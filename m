Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6699D317153;
	Mon, 13 Apr 2026 16:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099282; cv=none; b=iNdM1Do2m9tvEuaxf/H1jJgh95AltogWv4BDsvBU2ZEUhrzpRAKTzuhddKfZHI+8WP17/mDmlP1kUpz8ZxnOZptMgWxUyZKcXo2dTf2f3sFpCqI/xwNBOZuO07z1xOy5u8YIBmOeOaM5YqhLMTVSEPHHhp+hfqM9x6K3fZTmFYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099282; c=relaxed/simple;
	bh=0Q2zLR/7iAcuJbvJv883TNLjdT8++aKZoDLHhKGqZMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYo9VD43Y4nLnHqQ7pWjQ+kiStfWr7i2RhkBwqdlwE41TxP+Sgv5tp/UyO7+Mq2OpoEWF/HDTNi/4deU7amDWhiUuqJUo3czx/jAawbgQn8l4e73joLun3sDF7jF2Zi5dW8mHH/N7XIMebIvQqsItXpJPsipUXIqhnBKKeoneAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PviloeDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PviloeDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD887C2BCAF;
	Mon, 13 Apr 2026 16:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099282;
	bh=0Q2zLR/7iAcuJbvJv883TNLjdT8++aKZoDLHhKGqZMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PviloeDXp6yzyyQRSCozO8HZ+mUvqvlz6v5sT5A6Df7Uq1/QJZzwp1+N/RtQv3IGh
	 Wzk3yggArJ4pPLGGod/oGmXTwq5YtwB7ZDRDvTweQrvPgsMfNVS1rhPuCY4wzPZrAr
	 7qalSkRmmsHS+u8r+9+w8zbg5dEFmfeBwXVgSPm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/491] esp: fix skb leak with espintcp and async crypto
Date: Mon, 13 Apr 2026 17:58:14 +0200
Message-ID: <20260413155828.377595764@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 295bc1799002a..0d5fc4f8c6adb 100644
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
index 9df910dfc348a..a1d20dd4be3c7 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -310,10 +310,13 @@ static void esp_output_done(struct crypto_async_request *base, int err)
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



