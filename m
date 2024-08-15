Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD13A19DF9C;
	Thu, 15 Aug 2024 13:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729278; cv=none; b=mwq2bvmhBQkp0CJx/K1OYxtswzUX98Zy6zUCzIFuyZsxWb6Mve7EHb9+ftcxBmMTfnMBKdcm78uQ1KN/SpFPWnD+kEhn+ayyzeo0n7kGAdY87A5bHJ9sDenl5CNhPWHzw2cZD2Abk/s/tA57g4gXccYELFtYy+i+AGwF0CDkrM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729278; c=relaxed/simple;
	bh=dEW+ee2XcwDmbaFx+XFddTKMbNVV6XA/DZj5HknuZ0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwBTwpk0Fs6wazFu5l6os2OCizPuGQOttNLuIX3Qax1FMYf3zWfszhnQSEUHsKem4c8xAzWpaXzes7esgLonju00k9ioBfW/7oxlMYu/jM9alUiYk2uWf7VA6YInziv8gLgDPggfqbblTdXWqqpj+q4ZRO99Zkg6M1n5LlKuCVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=encJBlz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="encJBlz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52956C32786;
	Thu, 15 Aug 2024 13:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729278;
	bh=dEW+ee2XcwDmbaFx+XFddTKMbNVV6XA/DZj5HknuZ0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=encJBlz/fJ6Sgbqm3WpXx1TbUCXUyRzlAv4DjOFN91SrlBz42iipZweckxhq+yS0G
	 0Z+E/dmugZHeusjcqIA/6UmijGkPtwoQ2VAry3lHMcP79wWHnk+K0HwG6VYlkpzPRA
	 YFnZJM1A6V55IX1t7l9istKYjLINOVO29O2Ri3QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/484] net: esp: cleanup esp_output_tail_tcp() in case of unsupported ESPINTCP
Date: Thu, 15 Aug 2024 15:18:25 +0200
Message-ID: <20240815131943.097916503@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hagar Hemdan <hagarhem@amazon.com>

[ Upstream commit 96f887a612e4cda89efc3f54bc10c1997e3ab0e9 ]

xmit() functions should consume skb or return error codes in error
paths.
When the configuration "CONFIG_INET_ESPINTCP" is not set, the
implementation of the function "esp_output_tail_tcp" violates this rule.
The function frees the skb and returns the error code.
This change removes the kfree_skb from both functions, for both
esp4 and esp6.
WARN_ON is added because esp_output_tail_tcp() should never be called if
CONFIG_INET_ESPINTCP is not set.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 3 +--
 net/ipv6/esp6.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index ca0cd94eb22d1..e578d065d9046 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -237,8 +237,7 @@ static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
 #else
 static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
 {
-	kfree_skb(skb);
-
+	WARN_ON(1);
 	return -EOPNOTSUPP;
 }
 #endif
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 26d476494676e..a4b8c70ae5275 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -255,8 +255,7 @@ static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
 #else
 static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
 {
-	kfree_skb(skb);
-
+	WARN_ON(1);
 	return -EOPNOTSUPP;
 }
 #endif
-- 
2.43.0



