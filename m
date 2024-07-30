Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EE6188006;
	Tue, 30 Jul 2024 16:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355343; cv=none; b=DKwwqZb/JsLZ0jjqKhFt7bob1KaDlaer0ZPZYuFwd0VuEuE2yZ8rI3XJ0YrvYN5dy9XP+VeZfT9fUqywYe25WRUL16/JPHS8IwOTU+ok2JJcTZvwIuJDBeyZm12fVtADl86RoFmbfQJJhV9D4vr+F3A2YUkPj3fm4pQMnJCbgAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355343; c=relaxed/simple;
	bh=IQ3dUP+phDZmSWLv5o85+Xzl3HGtnh3Rc9rDLn4eurY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eovaDdsxnzf3YH2bPDVE6PEiiDGkUP7pWuWiK1/MUjL4NDIwimE534e9EtqSFNwmh81szL70PrCL2vMD6MQBxOKSi025c19TRhboCBnGNe4zHpQMGTUDknvQx7YzpAVZ4GtuievnoEsRgDc7Nb4k/jJoWTK/oEbCuLZBY0YHwTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G102StLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G102StLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2543FC32782;
	Tue, 30 Jul 2024 16:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355343;
	bh=IQ3dUP+phDZmSWLv5o85+Xzl3HGtnh3Rc9rDLn4eurY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G102StLp6tf1f608eKqc139SUDj7csnMuNtaLX1YyfMcTF4Z3DcnhnJAyC53YtmNu
	 AAfTxv7qi20yO5wypozie7XgRzhwBKZn5mlMp7Czaph1BrEo6xpMt9lzrlnLyfyXL1
	 Vsn1r67vvUumclJDr0uqzLfz32zkNg2Vg9RoVn6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/440] net: esp: cleanup esp_output_tail_tcp() in case of unsupported ESPINTCP
Date: Tue, 30 Jul 2024 17:45:18 +0200
Message-ID: <20240730151619.079859099@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e2546961add3e..419969b268225 100644
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
index c2dcb5c613b6b..a021c88d3d9b8 100644
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



