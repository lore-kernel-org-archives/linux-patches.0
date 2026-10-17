Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991673BFE3C;
	Sat, 17 Oct 2026 16:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255666; cv=none; b=ubztry6KeF6fYfX/Fy1vbqaBo8j7bQaA50KioAHQBIjEGvlwfcBX5CCG2mXPVoWRzaKMW88HO3RfuaR1xjOMIxh3bWG/VmfdmM1nKKZ+G4K6eNhz/sgWihvriXxxVFw4Q8/8AijOvtYsDxwhBob6B6suVCImYigADJsE8Z7FLf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255666; c=relaxed/simple;
	bh=XPBNuj/IZqYznZO1xSLVKnLdOy9Hq7ZYIas0g++F9yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFcUMICzXrxBlgU1wR9xV8GehzsBkrG67DiZghOH+fIocb7b2WU6M5Cn6D7uW8pXYb6C1ners1UX1OxpP5rWBJdPBVJSYdhwGkHSZxqPoTwLwpdVnyFl6w790PgxkaJGAaYvYLgg5fPXN6ZpatQOwSJRYawbiiEj8k+R5dj8T2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYGOuS6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYGOuS6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D381F000C4;
	Sat, 17 Oct 2026 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255665;
	bh=5qFRy0E4fA4TeEbhEBT7HJMjXsFi/DKVlQmP36hNH1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYGOuS6Ah0zLQcMx6wA3kDdU8gmADvd80JqWlJrLTLUhD2u/wiVByadUzzPzt+GaK
	 awDKjtYZWfF5oxTCvWHEIVxvxt7WQeQ4Zw1dPbLuDl5hbIs7cEuAhI4j1ZZBJLwn4e
	 tSVG3gnwob/yLTci//oGfFpFs+68OEU8ydPEp8iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 852/869] Revert "esp: do not unref managed frag pages in esp_ssg_unref()"
Date: Sat, 17 Oct 2026 18:01:33 +0200
Message-ID: <20261017160058.708310094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 0fda52de8bbd4ca9a852c8a7ef6536cf82bd71fd ]

This reverts commit 21697720ff43b8dfa25b8e8d9ca7f56f4597fc80.

The patch does not fix the issue completely, so revert for
now and wait for an updated version.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 7 -------
 net/ipv6/esp6.c | 7 -------
 2 files changed, 14 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 8944f812e4b55..fb78dc6b7e148 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -104,13 +104,6 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	struct aead_request *req;
 	struct scatterlist *sg;
 
-	/* Managed frags are owned by the zerocopy ubuf; the skb holds no
-	 * per-frag page reference, so we must not drop one here.  Mirrors
-	 * the SKBFL_MANAGED_FRAG_REFS handling in skb_release_data().
-	 */
-	if (skb_zcopy_managed(skb))
-		return;
-
 	if (x->props.flags & XFRM_STATE_ESN)
 		extralen += sizeof(struct esp_output_extra);
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 3061e74799170..7411aac0707b2 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -121,13 +121,6 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	struct aead_request *req;
 	struct scatterlist *sg;
 
-	/* Managed frags are owned by the zerocopy ubuf; the skb holds no
-	 * per-frag page reference, so we must not drop one here.  Mirrors
-	 * the SKBFL_MANAGED_FRAG_REFS handling in skb_release_data().
-	 */
-	if (skb_zcopy_managed(skb))
-		return;
-
 	if (x->props.flags & XFRM_STATE_ESN)
 		extralen += sizeof(struct esp_output_extra);
 
-- 
2.53.0



