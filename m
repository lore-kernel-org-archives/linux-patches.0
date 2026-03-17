Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1463B2459DC;
	Tue, 17 Mar 2026 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768044; cv=none; b=mU3dsMrR3g7xw5F/zAow+C+KI+lzbhIp7tU4YFptSgwahjKcefwHer/d7Zlfrp2IkBBPJp4fszpF07LeY2V9e6pPj0bsMjVQ9/kJUudVnkq9xvO3IvTZZ7MRoP8N1Aot15uE7uDz58m2+Hxh6k3Fr80mBgehGAP3bFg09B/I23I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768044; c=relaxed/simple;
	bh=XfoDR59MjLdS/o+PhimC68aV56tbAVhuh0RxqXQtibA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtTmn/mXkGz11SUhf7pVWDUoHwyByCZI3YHQ/+u5Bno1H+Qq9rtL0jZ1ARvtrjyLJdWA+086JdfNieuzdtLlboPN3xOHNBoVY+iSgCHvb2NU1yG5dTVZs+1BawRtFZXu1boeycirHjPQPZuKgkXB8ZHHCjcS1y5hud1Ay42lEyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYxrp/XU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYxrp/XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A50C2BCB1;
	Tue, 17 Mar 2026 17:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768044;
	bh=XfoDR59MjLdS/o+PhimC68aV56tbAVhuh0RxqXQtibA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYxrp/XUMkzZ9Vr1BpPV7VnapEy4MkUaNWwcMYD9cicb7e2ox2mxzDWWdUz+GyqK/
	 LRkZyV0PPr5V/CUskOfXWuTl0AacfZxnVGFsYqhSu928aOw/Qbxl69y+2m0vOwPRcD
	 BjautJgG/anwoN8HP0Ztkm8BBdTdEPQM8maH+v7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 219/333] net/tcp-ao: Fix MAC comparison to be constant-time
Date: Tue, 17 Mar 2026 17:34:08 +0100
Message-ID: <20260317163007.486723787@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


