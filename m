Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612EC1A6190;
	Tue, 30 Jul 2024 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356315; cv=none; b=uyaHV7VMI4jtasSqjt4Y/CT+O4ub1e4rQRL95dn6P9DvTjI9ibtSexZ5RgRVJo06pV5qxG3PG5koutHvSTLo2s0w+mnq4gf3UxSkXBGaD4kIGqJLthSqNteH0lcG8hBRNE9EgeTlxzCeaiPAMvQ1XqeTEb14Ic39dp6oS4jKkcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356315; c=relaxed/simple;
	bh=v2z8FmgzjPj+Mk5g5BX3vUW35J5JC4sX/qd/XkQkrQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8v3L11rYCqRq1AWNtO6y6i9YXrao9/RH+6jBeODGQ+bJAZjWeyaPzxodF6sf8tNQtDdhXh77dRKFdhP13FoskJy/2geLR/hjqUMkz+UMK5gLdt66JFYmInXUyyNR0x3mT8upwJot5aeRj8yd9t5GFeHhV/a9TAhf503ex95EKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyqUAWkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyqUAWkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655AFC4AF0C;
	Tue, 30 Jul 2024 16:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356315;
	bh=v2z8FmgzjPj+Mk5g5BX3vUW35J5JC4sX/qd/XkQkrQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyqUAWkZ0zWoDDpHeZjBiZj1F9/HB3kcVn2DMQwimhHECfnd+lsAe52clzQN5dS9k
	 6oYurEwDaEQrc6YL3mxL+1Ao9t6aApWqW3j+7OOMp+Q8Vw6k5iHOvy5lDzXqeDSzKo
	 E07/I1UbMSiyNfA2Bijw7XByB6bDJlNmOMmdlOXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/568] net: esp: cleanup esp_output_tail_tcp() in case of unsupported ESPINTCP
Date: Tue, 30 Jul 2024 17:43:42 +0200
Message-ID: <20240730151644.370743996@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fe501d2186bcf..eeace9b509cec 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -238,8 +238,7 @@ static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
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
index a3fa3eda388a4..62bb9651133c4 100644
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



