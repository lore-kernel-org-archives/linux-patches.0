Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95712329E4B;
	Tue, 31 Mar 2026 16:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974312; cv=none; b=R0E0mS61HAFMBlmy+23z0cFeCQfB3a22TJNo6ToOEs4sYGwEqoLkQ2pk3zrzJGI2DCTsH9YSe5QSa9XEy2OfPrX42BJ7CahyypnzI1y7c0t33cu70y2OU1KIWOXGQ7b33pko4GnSpv3LpMqPdN0LWRkQXVnhJ4UChZHpgxkQxJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974312; c=relaxed/simple;
	bh=UZpOYb94TcREFhk2q/fVyU+Ly2cBprIA4HD3pnS5/2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEojrCq8t+p/zPZ5tpW6/UAByJ/PYYV0y5Sh3ghI6sY2rhq32AuD9pZXZbUxFJVHRlGAA0/edzso7fMaLfs8ZVUCGoh9nS83T3oEktNgzzzIwjjUdFfpbRDCwUY1UlRsh3ugHj8ysph2aO1p/hvatld6koBQ3Y5KdkU7iJCgEtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x43xVD9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x43xVD9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A3AC19423;
	Tue, 31 Mar 2026 16:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974312;
	bh=UZpOYb94TcREFhk2q/fVyU+Ly2cBprIA4HD3pnS5/2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x43xVD9QAhRuchczjP9ynyTD9fAcUryMF1XQPGa9QM+SiFokOudlSHvmSRYscNTvx
	 l4A+0VvhW4VIlyuXlmOncVqwWY4oly8DNbEWpjiO6ajUbQDEWdch6H/HJI+6tKAbqE
	 0aNRsHrKKpLoeuMXYuGITENGmpI9x9N+oZk1Ad80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/175] esp: fix skb leak with espintcp and async crypto
Date: Tue, 31 Mar 2026 18:20:19 +0200
Message-ID: <20260331161731.075270641@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 85e24dc42f2f3..4256c7ee59397 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -233,10 +233,13 @@ static void esp_output_done(void *data, int err)
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
index be8e2e5b439ed..f3305154745ec 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -269,10 +269,13 @@ static void esp_output_done(void *data, int err)
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



