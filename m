Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B4D27B359;
	Wed,  4 Feb 2026 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216649; cv=none; b=OLudgxpmNOVXP31m4B6nodwHHSSRE9LXd+RFXOj0umS03dah97eiwUc75x1PevVJVRf8M41sNS2WlCny7tmZCP37Z8zwA7VwypRhpPtDM3+ZaH3nFwdJX8EG0UhsivQlpC7zNP6a/mdQjjDUrWV65KJb/AtSR0/Cxg3G2QvwKsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216649; c=relaxed/simple;
	bh=hZEmJ90tDCHW8m/TB82OUIUczNQ8MeBK50EmQ2rCg3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcXwpGui5xFDMG9EwyWwMto6jhbY+x0ia9hsKeTdNKEcKgpUIch0qP0BhaW6k8fU7viuuNxhRrStzenlmZD8QtK2sXOqkYlS0nMla5mi6k30lrmrUeeN3ieBGPpQ+7YGxcI9nYYjdrdqSeWcEr3mBzlBQduVlHy4W+kJ3bCNfnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCPc6gvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCPc6gvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C08C4CEF7;
	Wed,  4 Feb 2026 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216648;
	bh=hZEmJ90tDCHW8m/TB82OUIUczNQ8MeBK50EmQ2rCg3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCPc6gvqAriw+kWpp2hDn+FrbcmgSzJWM/LlkPBRuVC69v6azslLSZyFptQSRgVqc
	 9jGGTqmHXHJSZ0o+2SzP4TpP+zvbiRuLO3piHi8ywZ9sylzT+FxoRHixE24tTIDxMl
	 pam3fR3kzBoPc8PvqPXj02/9AHpYIZF0JIDkXg68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 5.10 152/161] ipv6: sr: Fix MAC comparison to be constant-time
Date: Wed,  4 Feb 2026 15:40:15 +0100
Message-ID: <20260204143857.217232162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Include crypto/algapi.h instead of crypto/utils.h in v5.10.y. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_hmac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -36,6 +36,7 @@
 
 #include <crypto/hash.h>
 #include <crypto/sha.h>
+#include <crypto/algapi.h>
 #include <net/seg6.h>
 #include <net/genetlink.h>
 #include <net/seg6_hmac.h>
@@ -270,7 +271,7 @@ bool seg6_hmac_validate_skb(struct sk_bu
 	if (seg6_hmac_compute(hinfo, srh, &ipv6_hdr(skb)->saddr, hmac_output))
 		return false;
 
-	if (memcmp(hmac_output, tlv->hmac, SEG6_HMAC_FIELD_LEN) != 0)
+	if (crypto_memneq(hmac_output, tlv->hmac, SEG6_HMAC_FIELD_LEN))
 		return false;
 
 	return true;


