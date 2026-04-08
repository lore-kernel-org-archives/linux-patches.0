Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E5D3D890E;
	Wed,  8 Apr 2026 18:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671675; cv=none; b=tAjKGodmsgP12MZrAotmF8beiCUMMdRigjuTP2sW1RAfeOpDrcaX3EqjyHMnqIXl3FmUfZo8Pb8aeIN/0itTBMGYDLaewh/1prZdC9LIbJ9vZzZhpU1elraOfZz+7lcf0z1cPghu+h5fB6SOXkdMCs3lFFfSLXZgco5puL/gXqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671675; c=relaxed/simple;
	bh=FylNoz1CueL+lAa71kwyE19HGjApZSv2gz9bNyTObqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onT5tTotTRFreeTjsPauXmz6U2+XAZoznDk1+4RQW25yDgBhJx+8IvHpOiC69KnrBcSnnlEqmGmkDhM33K+FEOrih8q5/pKIn88EAYu5HOvSys75s3LnS5LNp577EfzX5tDg/LxT3LPdvSaZxv+5qWISxV0XLvt5y2BLVXk0UbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AeJK1gF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AeJK1gF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105F0C19425;
	Wed,  8 Apr 2026 18:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671675;
	bh=FylNoz1CueL+lAa71kwyE19HGjApZSv2gz9bNyTObqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AeJK1gF0VlOzIYzQUZpuh1UWlkzehbu6OSyjmYEX6agaouUVXOg5EFfuFyHXvWTP
	 iTKchKCjNd+cAyfDVrEcGyrqDrXRXRfmrLQroIUTt/McZiWSgDa36382gwM7ojFm4X
	 iZ/t+xo+lXJHlqvtofL3uwyg/8cRutBAH0DfOdek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/312] esp: fix skb leak with espintcp and async crypto
Date: Wed,  8 Apr 2026 19:59:02 +0200
Message-ID: <20260408175934.668405708@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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
index 70ad42826c3db..95575bf78d5c1 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -233,10 +233,13 @@ static void esp_output_done(struct crypto_async_request *base, int err)
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
index a7cc96fc7c247..76699ec883702 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -269,10 +269,13 @@ static void esp_output_done(struct crypto_async_request *base, int err)
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



