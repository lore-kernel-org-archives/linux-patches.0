Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9653B531A;
	Mon, 23 Mar 2026 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278717; cv=none; b=MrosA2PvXmGIHhrpbe1n8MnEfM0C7BBMZCSXO7yD9Bm40RC8kzvpZZeZLwG3OE7tynoTOolb9OeMh9KRbc3TUtzRV/HN8yTp1uyHXhXjgEprPCY8hXtaUYPFo4fGsBnQ/zLjvGmO5mPz/i57NcgrKg8OBIwnp2XYJE3bqYqX4eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278717; c=relaxed/simple;
	bh=K0jD7xMg1bh3NwQ5MFVQV9x3saN5jrseb+RIMhGA6mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvTaVG/BLOrls2Q93I/oc+9np24OjaPG08IS9qrK6o4AECye3V6GdDxsuAvo5fGIhORbZlZ4wUTLQYpvO8yC08mYouyF/i5lULozyM9w6gxhFw2Cgfo5kRPBrxFPmQ2P4apM9bEtj0eA8vEYnWgP7yEpinnfkWi4o5r5sjstPuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2T3reylY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2T3reylY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCC5C4CEF7;
	Mon, 23 Mar 2026 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278717;
	bh=K0jD7xMg1bh3NwQ5MFVQV9x3saN5jrseb+RIMhGA6mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2T3reylYcobJFmfKCmIp+RLzZ1TN+xZS+UTVqWQLcGILBboT5A/6/vF/CwIy6f3e5
	 H4ZsvCl0c+3YVhz1v1k+gltkJE+B3CjgIvIS+I4YI8h8PJmbqnbwaE2JcmFoTcrmc9
	 y6aRvyh+DZ/jGk7ViodVsqVmlE0HTHg4Ll4mqQpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 397/567] net/tcp-md5: Fix MAC comparison to be constant-time
Date: Mon, 23 Mar 2026 14:45:17 +0100
Message-ID: <20260323134543.681524944@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4556,7 +4557,7 @@ tcp_inbound_md5_hash(const struct sock *
 							 hash_expected,
 							 NULL, skb);
 
-	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+	if (genhash || crypto_memneq(hash_location, newhash, 16)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		if (family == AF_INET) {
 			net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -80,6 +80,7 @@
 #include <linux/btf_ids.h>
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -776,7 +777,7 @@ static void tcp_v4_send_reset(const stru
 
 
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+		if (genhash || crypto_memneq(hash_location, newhash, 16))
 			goto out;
 
 	}
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -64,6 +64,7 @@
 #include <linux/seq_file.h>
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -1035,7 +1036,7 @@ static void tcp_v6_send_reset(const stru
 			goto out;
 
 		genhash = tcp_v6_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+		if (genhash || crypto_memneq(hash_location, newhash, 16))
 			goto out;
 	}
 #endif


