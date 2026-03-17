Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366A23C6612;
	Tue, 17 Mar 2026 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766539; cv=none; b=rM3aJsQj3+JHQoDYjCVJbnKO9iYfyhW+BDtdhAYdpI3ZSClIF9qnafz6HL8Slxd865yzxQgqv7BtS2vpGpBmtsBUZ5sNCH4oX+XJhpiXiwcL9II06lyif2Dlnc65vqZrh1Y0qtf9lf1yrS/MLtwEznZmjiQNBV/s2R6eLhpPX2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766539; c=relaxed/simple;
	bh=QLTZza9WrUZ6zySGgWz+QDsVjiTLEpVrHnF5motGdcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b++onKgfEwW7QzIpfQiqEnHc4I35j9PSYCWkWYT6REJQU53m0W8e4HO1C4PinlH+RQm9TJ241Ln7ezONlwcpJvtKpvfy7h5pi7VoxPcGsWNL4qGTI8Xj0YYb2eQGzizw2lTQaF9fOu/+03bnTUrCesQevgCe/iG+OJ8XRNSD7bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gxbf6vX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gxbf6vX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB13DC4CEF7;
	Tue, 17 Mar 2026 16:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766539;
	bh=QLTZza9WrUZ6zySGgWz+QDsVjiTLEpVrHnF5motGdcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Gxbf6vXE/tDmzTgCY9jhFR4PxkKsyyCWH3mFLQ0/lfVksF5jXGDRTlo4b5PPgubH
	 2GhV2cKzYs+TwOMEbmkGHe15enZb3AENIRekSR/GvfDW73VSmLiTwSjVc7Ng0MhKYJ
	 HYBZjc2cu6KeUxRj75Rns90kZbdI238h3KH1RptY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 266/378] net/tcp-md5: Fix MAC comparison to be constant-time
Date: Tue, 17 Mar 2026 17:33:43 +0100
Message-ID: <20260317163016.798471937@linuxfoundation.org>
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
 net/ipv4/Kconfig    |    1 +
 net/ipv4/tcp.c      |    3 ++-
 net/ipv4/tcp_ipv4.c |    3 ++-
 net/ipv6/tcp_ipv6.c |    3 ++-
 4 files changed, 7 insertions(+), 3 deletions(-)

--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -762,6 +762,7 @@ config TCP_AO
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
 	select CRYPTO_LIB_MD5
+	select CRYPTO_LIB_UTILS
 	help
 	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
 	  Its main (only?) use is to protect BGP sessions between core routers
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -244,6 +244,7 @@
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <crypto/md5.h>
+#include <crypto/utils.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -4912,7 +4913,7 @@ tcp_inbound_md5_hash(const struct sock *
 		tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
 	else
 		tp->af_specific->calc_md5_hash(newhash, key, NULL, skb);
-	if (memcmp(hash_location, newhash, 16) != 0) {
+	if (crypto_memneq(hash_location, newhash, 16)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		trace_tcp_hash_md5_mismatch(sk, skb);
 		return SKB_DROP_REASON_TCP_MD5FAILURE;
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -88,6 +88,7 @@
 #include <linux/skbuff_ref.h>
 
 #include <crypto/md5.h>
+#include <crypto/utils.h>
 
 #include <trace/events/tcp.h>
 
@@ -838,7 +839,7 @@ static void tcp_v4_send_reset(const stru
 			goto out;
 
 		tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (memcmp(md5_hash_location, newhash, 16) != 0)
+		if (crypto_memneq(md5_hash_location, newhash, 16))
 			goto out;
 	}
 
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -68,6 +68,7 @@
 #include <linux/seq_file.h>
 
 #include <crypto/md5.h>
+#include <crypto/utils.h>
 
 #include <trace/events/tcp.h>
 
@@ -1043,7 +1044,7 @@ static void tcp_v6_send_reset(const stru
 		key.type = TCP_KEY_MD5;
 
 		tcp_v6_md5_hash_skb(newhash, key.md5_key, NULL, skb);
-		if (memcmp(md5_hash_location, newhash, 16) != 0)
+		if (crypto_memneq(md5_hash_location, newhash, 16))
 			goto out;
 	}
 #endif


