Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6429117332C;
	Tue, 26 Aug 2025 11:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207484; cv=none; b=dCq+AdT7arVJfwxT3Z722JOsj9HCNV5Uek3rJqf/rVYw3GPl8fsIHIoN41IFm52fjf4GiHroYK8cTm9pjBZuFZd/R4Roo5WrFXrdmWIGYkkJpShRPNSonHLQXCkiDqribZXVJpeRvJdXC5+IOlOys728YrE28BUxzYEEpgLspZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207484; c=relaxed/simple;
	bh=qihUaS04Kp0Z/0myL/UrEaXMzU1B6dLu84UcX9mfE2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+rJrg6S9rAxZebdUfr41mdDQdOtfUiI0aAE87gNe4vV/+Ok/TOWyxlCC20CWut4/C3Fes4VhaxFrcBlwkkkdSI2gbxIS8Vw9OXok0z5r01lBW35wQBVr5yTqAOYJ0EC0k6S+8qWxNsmVkQWUdaVAutVFam2Jhb3xt3HpVoLt+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuL5VKUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuL5VKUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA585C4CEF1;
	Tue, 26 Aug 2025 11:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207484;
	bh=qihUaS04Kp0Z/0myL/UrEaXMzU1B6dLu84UcX9mfE2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuL5VKUjBc1rINqijYWGUfPnywsXkqrZck0s0NemocMwtofdiJJlKOaSPBxlPHFbE
	 7lvBloUdoMwWhecN6Tlx84E+NG1TnYR9pUShDIKQIr7LYD4FUTmQGfVSeGxH9+4+k9
	 rTqYklNBzqgPYpErrmZpWC7LfQTivKt0u8Hdp4SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 199/457] ipv6: sr: Fix MAC comparison to be constant-time
Date: Tue, 26 Aug 2025 13:08:03 +0200
Message-ID: <20250826110942.286051347@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit a458b2902115b26a25d67393b12ddd57d1216aaa upstream.

To prevent timing attacks, MACs need to be compared in constant time.
Use the appropriate helper function for this.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20250818202724.15713-1-ebiggers@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_hmac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -35,6 +35,7 @@
 #include <net/xfrm.h>
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <net/seg6.h>
 #include <net/genetlink.h>
 #include <net/seg6_hmac.h>
@@ -280,7 +281,7 @@ bool seg6_hmac_validate_skb(struct sk_bu
 	if (seg6_hmac_compute(hinfo, srh, &ipv6_hdr(skb)->saddr, hmac_output))
 		return false;
 
-	if (memcmp(hmac_output, tlv->hmac, SEG6_HMAC_FIELD_LEN) != 0)
+	if (crypto_memneq(hmac_output, tlv->hmac, SEG6_HMAC_FIELD_LEN))
 		return false;
 
 	return true;


