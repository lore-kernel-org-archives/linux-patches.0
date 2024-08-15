Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA5417BEAD;
	Thu, 15 Aug 2024 14:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731982; cv=none; b=rLmQ3nuM/HTlsOcgZg5/y7dY2uigl6DgBpls7ZktAgMnrj8qsqsuD3BUPw6wtPjdDClB9RO1ngz1lE0rnOq5lMVd6Gg0iEbqBDNHbyFiPfoFgxrlhSNRxy5isynLuVUMaXc2qADFnQaS51YdPH6ijywJKayjRx/mBD96NgZ9vGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731982; c=relaxed/simple;
	bh=v2Djgr7jNyMEXFgHy0GCoY/BU3QtnqSrg7xHSnnHw88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eg0XZLwDVMl/n0pcIVYSaGOdkZapRodzlWGXkvwC7oPAHlPASEM5PzJRQ35/DXtiD90UBKTDFHkSPAr2H6hmuSHPdrNDrGWgHAn8rb37h5yUwTM8f9QR/OgyUJjWhlldpEUKU0QH7I6IfoROr3EPH/Ae4/3cywfMEFqMozmMuEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGsIkEpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGsIkEpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0DEC32786;
	Thu, 15 Aug 2024 14:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731981;
	bh=v2Djgr7jNyMEXFgHy0GCoY/BU3QtnqSrg7xHSnnHw88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGsIkEpIBeI9sHRDdye7OzKJkPaK+EmBNL4H+PnmOE7/buw0QzodlcAJSvFWUDMWe
	 varap+bwQRa5vf/yCeUcF8vGKpqg7aOluHv9vhA+KGt/C7dm088RdHr+HtI0RbHiRO
	 43/5fXh+fIQ1Zv38HSAz0VlIdOcTWYFQGohnIsKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/352] net: esp: cleanup esp_output_tail_tcp() in case of unsupported ESPINTCP
Date: Thu, 15 Aug 2024 15:21:43 +0200
Message-ID: <20240815131920.664686957@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 412a3c153cad3..adfefcd88bbcc 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -239,8 +239,7 @@ static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
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
index fddc811bbde1f..39154531d4559 100644
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



