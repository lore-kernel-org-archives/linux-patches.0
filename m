Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E962618455E;
	Tue, 30 Jul 2024 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356726; cv=none; b=aIi/iV2U/F6GZ1gEKZXwZ785Zm4ucot1k2UfjV0Qp6FTJxbWltVicoXxrid1tGxKPYiPcCwdvFkCen1pXt/qgnKRZMD4nW/mnisNuNzMWoJn0c/lwpvZKs39sLtQCOKoTJwVSYuMZ9UU/76KoprYGIbqUCMXrzwaU6qb3aHA+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356726; c=relaxed/simple;
	bh=YHcksEueiBxFP8vZcPgtnNeXTNK4RwV8kA8VPycS5d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hASpewTCAG7IJgouUOHvNUxu18l+YcsS/DiMojoWAYMokmqwLNfdOP/z/doNmgV2lpIvXCi3+2dkKFriP8g50S1oo1vqw5lARBDHT9J2+nA4Zg4FoAyRvm1HBOkHG8wCWCknjUHbYUeZlkVHG0Hiundr8kv346Zw2zAXbCn4wiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0cbMpwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0cbMpwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B30C4AF0F;
	Tue, 30 Jul 2024 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356725;
	bh=YHcksEueiBxFP8vZcPgtnNeXTNK4RwV8kA8VPycS5d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0cbMpwfw59rI3Pf8YUeqA9z73stEhIATu3Y0iWtHfcZEi7FaoOgRA5ybJhcBxTR5
	 VQFHY0jGODe+1FMstSbpfRVHNit7DSOw6HqXLOA5vhMOHlVvhKVQvrtIXH8ry+2G8b
	 VMkPs4qCgjFA3gVrc0vLYpvLltZSNr8+0+2xDVU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 158/809] net: esp: cleanup esp_output_tail_tcp() in case of unsupported ESPINTCP
Date: Tue, 30 Jul 2024 17:40:34 +0200
Message-ID: <20240730151730.844365816@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3968d3f98e083..619a4df7be1e8 100644
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
index 34a9a5b9ed00b..3920e8aa1031e 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -256,8 +256,7 @@ static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
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



 inline int __down_read_trylock(struct rw_semaphore *sem)
 /*
  * lock for writing
  */
-static inline int __down_write_common(struct rw_semaphore *sem, int state)
+static __always_inline int __down_write_common(struct rw_semaphore *sem, int state)
 {
 	int ret = 0;
 
@@ -1310,12 +1310,12 @@ static inline int __down_write_common(struct rw_semaphore *sem, int state)
 	return ret;
 }
 
-static inline void __down_write(struct rw_semaphore *sem)
+static __always_inline void __down_write(struct rw_semaphore *sem)
 {
 	__down_write_common(sem, TASK_UNINTERRUPTIBLE);
 }
 
-static inline int __down_write_killable(struct rw_semaphore *sem)
+static __always_inline int __down_write_killable(struct rw_semaphore *sem)
 {
 	return __down_write_common(sem, TASK_KILLABLE);
 }
-- 
2.43.0



