Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CD74C10DD;
	Wed, 30 Sep 2026 18:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793491; cv=none; b=AHZABFJFN1vZJEekvO50R/5ys8tol6rmEG3Ls2yS1rk9PD8Er4xjPRFK40JN1NfaXVNTTYXsAy9x5sk6wrrDY+QjyLBXIq/gtFegJ73IVltSFwoZHVIRrd7gZX4meQTk07tgcFoabI01hRXZgCwb7+3C6Fp/YrmJX+b0huE1TQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793491; c=relaxed/simple;
	bh=DX9iq7lqAeXU58Xa2ncN+mc9VXjAo37WCTzh4TkRRtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmDFRk/Sv2OWC5dNDmWczGGwf+s3uHcKuFzh1GXpD2gPmkJ/TI0S14G2pazBUHv93yl3Po7ZS05pDASsf0DnvlyGAAWMKLPmEGe00H/w1w16bPHlHj/eyvNsD0Tc28bYDTNEEw6ffPQtUq5IXn0g6azj6HL01i7eKrm/mv5sFl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8lKfP2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8lKfP2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FBC1F000FF;
	Wed, 30 Sep 2026 18:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793489;
	bh=Lz5WVigjeGePC4D4W3tlcVgF7jPnJf2uC5whwJiHO+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8lKfP2+HFB5zcQ+P8Jjai+cWPRQwuG2ancnZ9Dz+TR4H6qLQn8su+z5LcmbGy/6k
	 Zz2H8KynQeDb/FyA7reOLOQorOTb2Nnubeq+HRr3pZk+6OQh6U4ChOEzfDC3UJvgMn
	 d17mXSs7GVTEAxtvkQVcExGpEXrww6uzRb2TN1Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 218/395] crypto: s390/hmac - Generate intermediate CV for API partial block handling
Date: Wed, 30 Sep 2026 17:28:00 +0200
Message-ID: <20260930152345.389658796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Holger Dengler <dengler@linux.ibm.com>

commit 10396a2d6d41d594975b6ece712278570c3c970c upstream.

The API partial block handling requires a intermediate chaining
value (CV). The internal function hash_data() sets the function code
correctly, so also call cpacf_kimd() instruction for intermediate CV
generation, as cpacf_klmd() always generate the final hash value.

Cc: stable@vger.kernel.org # 6.15+
Fixes: 08811169ac01 ("crypto: s390/hmac - Use API partial block handling")
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/hmac_s390.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/s390/crypto/hmac_s390.c
+++ b/arch/s390/crypto/hmac_s390.c
@@ -151,7 +151,10 @@ static int hash_data(const u8 *in, unsig
 
 #undef PARAM_INIT
 
-	cpacf_klmd(func, &param, in, inlen);
+	if (final)
+		cpacf_klmd(func, &param, in, inlen);
+	else
+		cpacf_kimd(func, &param, in, inlen);
 
 	memcpy(digest, &param, digestsize);
 


