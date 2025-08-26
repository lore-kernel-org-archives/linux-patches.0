Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B03DF49;
	Tue, 26 Aug 2025 13:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213639; cv=none; b=kU6h1dOSaS3x8n+zrvNbTIc0zjuvGfE3o4jrBZHF88QmRob0Eb4zQGnMbR+ZnwSL0RF7UJ4/lB/eFop7UZo+kwwlKrEuZDd7jCLeUlSNo0ipDWg0tIO5ZG5B8pAXZMue7SJoigiGvrmOOchjZNKONufS6tgh8m4hkAIfXWr50uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213639; c=relaxed/simple;
	bh=XBT67+YyECdRKMUms5u6Tzvn5h3yWT8NWpCHg7+Zyo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBUjCFCMc/aFMUVwYXs52cmb5w2JTNR5gQWTAWXHW4lXBUj8fQFadTOFawYMAnqq4jMw27Ned2miOAhE9cNo+YphCFlCFI+91p68hLgTFGc3ixz9IhOSuUB5Lrbllylhut9LFU/yI80LM+uh43aBd2Q/w+hImNOJFEa8gMR/Wjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjeG+07/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjeG+07/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96680C4CEF1;
	Tue, 26 Aug 2025 13:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213638;
	bh=XBT67+YyECdRKMUms5u6Tzvn5h3yWT8NWpCHg7+Zyo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjeG+07/wbclJwAFsIxTVaBod569v9jp5h1Y2HLIUyu3xLGzQ7a7Zf+b603NAY2l8
	 r2stHf81bis3LJEFL/vV8AlZbRkpSHXkabbAmyAsoPLdalJ/t2RRHWLHH+IcVSApmf
	 h+4OxM1IpwELedRDZDU6aBt8bU+xuDWmzL/H9QUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 424/587] ipv6: sr: Fix MAC comparison to be constant-time
Date: Tue, 26 Aug 2025 13:09:33 +0200
Message-ID: <20250826111003.725217606@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -269,7 +270,7 @@ bool seg6_hmac_validate_skb(struct sk_bu
 	if (seg6_hmac_compute(hinfo, srh, &ipv6_hdr(skb)->saddr, hmac_output))
 		return false;
 
-	if (memcmp(hmac_output, tlv->hmac, SEG6_HMAC_FIELD_LEN) != 0)
+	if (crypto_memneq(hmac_output, tlv->hmac, SEG6_HMAC_FIELD_LEN))
 		return false;
 
 	return true;


