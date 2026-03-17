Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615423F54D7;
	Tue, 17 Mar 2026 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766530; cv=none; b=jTqwnWmsewStnVx84Mw6xYaQxXBME17Pi15XjeP60lJsGqBcSTH4fwixPWXCkYdM0BGkjNpGHovnw8+KPpDP1kWHsKTCJux6z0wzv9Q9/Gs/n62G7Mpmuc/jM8UFENNMg6wM7npNmzNSaM27MwmnC8pMhiV0TGSS3f93a1a1L3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766530; c=relaxed/simple;
	bh=LBr+0j2Cu25FqgRbNo3WTr42ki9eS5Bor/46vYb+WBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcxNH3jS7GoOsDYJEiPb/wWqYFn4OsfFbKbFD4EXSTmmJcpDtueUMxqYIguUzGKM8PGDo+rAe4gHDH+yyOjVReZQuGl0v6lvHt+BAfNN5vB/SBWVtNMAHNpIKJ5oH6Gp/7R4LIBFQ2IfnWyL0ApYrmSgbElF3eJ0KF/8UD7rLcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzRghdN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzRghdN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC0AC2BC86;
	Tue, 17 Mar 2026 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766530;
	bh=LBr+0j2Cu25FqgRbNo3WTr42ki9eS5Bor/46vYb+WBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzRghdN19d74uG6Qtjstj2Hsv1l45kgxoETsf84ChrWRihcpG9frJf4l8QZNvMAJ+
	 VQkeqb0NEpjSKQ0VeV7kLgEcllV2Oli+Y4LoWd3kroLSjDjZAB7MwxmUzfABoxWoLv
	 aygszwKQv+nLqkE2rbZx9+sQ55ksCxq7lshExNi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 264/378] net/tcp-ao: Fix MAC comparison to be constant-time
Date: Tue, 17 Mar 2026 17:33:41 +0100
Message-ID: <20260317163016.724607772@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 67edfec516d30d3e62925c397be4a1e5185802fc upstream.

To prevent timing attacks, MACs need to be compared in constant
time.  Use the appropriate helper function for this.

Fixes: 0a3a809089eb ("net/tcp: Verify inbound TCP-AO signed segments")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20260302203600.13561-1-ebiggers@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/Kconfig  |    1 +
 net/ipv4/tcp_ao.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -748,6 +748,7 @@ config TCP_SIGPOOL
 config TCP_AO
 	bool "TCP: Authentication Option (RFC5925)"
 	select CRYPTO
+	select CRYPTO_LIB_UTILS
 	select TCP_SIGPOOL
 	depends on 64BIT && IPV6 != m # seq-number extension needs WRITE_ONCE(u64)
 	help
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -10,6 +10,7 @@
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/inetdevice.h>
 #include <linux/tcp.h>
 
@@ -922,7 +923,7 @@ tcp_ao_verify_hash(const struct sock *sk
 	/* XXX: make it per-AF callback? */
 	tcp_ao_hash_skb(family, hash_buf, key, sk, skb, traffic_key,
 			(phash - (u8 *)th), sne);
-	if (memcmp(phash, hash_buf, maclen)) {
+	if (crypto_memneq(phash, hash_buf, maclen)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);


