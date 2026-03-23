Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0403AEF20;
	Mon, 23 Mar 2026 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276828; cv=none; b=TYcs8HWOZKB3MUrsEPb2AmnFxCAoUvJj+BYzyfhpjFLOkW+XhZuOj9PonA5BjTbbWMTZnHiQwMajFyxHgKQc1XCAOReztYGJpOHHxvUn5xmdeu1kdRA0+Zw0oL7taSbBDz6FC8ryboqUqLakOrIHVbPvTdxZIzTpjUE5igi226M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276828; c=relaxed/simple;
	bh=KAyy3VjeB29MjnepHnzIP0JOvyPLAPxOTmzyGlZ6gfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWO0i556jbeJ+adbk14s4G4cKq8Snm1jHGf2IG3p++7l0orKSjMr6z0055HpPdA+/ub50YvJS3Sa/0CsxzSbF1VyBwi5GC6tp4A10s+64zTCnOvMuEUrIEczE5DutlGW5KDnbfYAQMAC3bYNELeRabIQkcCVdv0OJoCwIjTuNzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHTGiFIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHTGiFIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A77FC4CEF7;
	Mon, 23 Mar 2026 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276828;
	bh=KAyy3VjeB29MjnepHnzIP0JOvyPLAPxOTmzyGlZ6gfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHTGiFIRlmwitESgLHxphJ+35qoU8L6ztnqzIyhsdvnRnd2KUUdwrt+TwAk1Etf9h
	 g26Eg+TImfX5AE2h0SHgUDNEjSbRpx/4FNSmlNH/Wbu2NyPWLXlT0ClBi2L9F0M2gs
	 sLn6FPK5DFcV5ebCVTYQW011IzW3mQS9JpEM8V4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 219/460] net/tcp-md5: Fix MAC comparison to be constant-time
Date: Mon, 23 Mar 2026 14:43:35 +0100
Message-ID: <20260323134531.880402254@linuxfoundation.org>
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

commit 46d0d6f50dab706637f4c18a470aac20a21900d3 upstream.

To prevent timing attacks, MACs need to be compared in constant
time.  Use the appropriate helper function for this.

Fixes: cfb6eeb4c860 ("[TCP]: MD5 Signature Option (RFC2385) support.")
Fixes: 658ddaaf6694 ("tcp: md5: RST: getting md5 key from listener")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Link: https://patch.msgid.link/20260302203409.13388-1-ebiggers@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c      |    3 ++-
 net/ipv4/tcp_ipv4.c |    3 ++-
 net/ipv6/tcp_ipv6.c |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -244,6 +244,7 @@
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -4783,7 +4784,7 @@ tcp_inbound_md5_hash(const struct sock *
 	else
 		genhash = tp->af_specific->calc_md5_hash(newhash, key,
 							 NULL, skb);
-	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+	if (genhash || crypto_memneq(hash_location, newhash, 16)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		trace_tcp_hash_md5_mismatch(sk, skb);
 		return SKB_DROP_REASON_TCP_MD5FAILURE;
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -82,6 +82,7 @@
 #include <linux/skbuff_ref.h>
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -839,7 +840,7 @@ static void tcp_v4_send_reset(const stru
 
 
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(md5_hash_location, newhash, 16) != 0)
+		if (genhash || crypto_memneq(md5_hash_location, newhash, 16))
 			goto out;
 
 	}
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -66,6 +66,7 @@
 #include <linux/seq_file.h>
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -1084,7 +1085,7 @@ static void tcp_v6_send_reset(const stru
 		key.type = TCP_KEY_MD5;
 
 		genhash = tcp_v6_md5_hash_skb(newhash, key.md5_key, NULL, skb);
-		if (genhash || memcmp(md5_hash_location, newhash, 16) != 0)
+		if (genhash || crypto_memneq(md5_hash_location, newhash, 16))
 			goto out;
 	}
 #endif


