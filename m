Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333B72343D2;
	Mon, 23 Mar 2026 14:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275604; cv=none; b=poRQpW3wlTRqERA7a+f+4TEFC/fbOeCCQ7zV21HZvaWxhhDV+JpAsIHowLC1Gj0+4GjXbAu3kEMiCxH/+zN0LyYx3Y2d3P6sETWNI2xeIf81Lqy922t5KqluvFuIfKYUX25kn9RjyuiyGHcMIJD7lRt7IwFRy9pdbV41JC/Emlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275604; c=relaxed/simple;
	bh=hOV/R3fccmtyNoCoNLw+jnOUDWeIfPtQfJS1QQLKKg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ge0AZAo/UbdeZ2T9tKLiGUQTKc3qJMvzRAa6FcgBu9Ez1MYvXW7chVeHePeL+dQAcVQ7NJcxjK4jZcnjilj3u5p16ChwR3IfGTtJDgYz6kzXWm7np90zKNFZQUK/z0UpNS7wcOJpqbdS20mj6i2gofaniI8DDurnTvk95/Vt2q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItaV2v7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItaV2v7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551D0C2BC9E;
	Mon, 23 Mar 2026 14:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275603;
	bh=hOV/R3fccmtyNoCoNLw+jnOUDWeIfPtQfJS1QQLKKg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItaV2v7Tix3mo6v4/fviJEtrBPVnjqL+APgM7ewULF8X84+jCW3AUPHWWUxTMsNZ0
	 Q0YHyxTjcIAQ9BgUKSGhYchh3q3SmMAA1xYHROTVII+Rc6hDRvPVHEcE7LndYgR4tE
	 rKBwgetfYtVEzOflBXPJ4H9QaTeroQGXlOv77b50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 158/460] net/tcp-ao: Fix MAC comparison to be constant-time
Date: Mon, 23 Mar 2026 14:42:34 +0100
Message-ID: <20260323134530.444731097@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
 
@@ -923,7 +924,7 @@ tcp_ao_verify_hash(const struct sock *sk
 	/* XXX: make it per-AF callback? */
 	tcp_ao_hash_skb(family, hash_buf, key, sk, skb, traffic_key,
 			(phash - (u8 *)th), sne);
-	if (memcmp(phash, hash_buf, maclen)) {
+	if (crypto_memneq(phash, hash_buf, maclen)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);


