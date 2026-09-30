Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DB04F4755;
	Wed, 30 Sep 2026 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787609; cv=none; b=iciBFc5YNEkUyPfO/PeEo/Fpm/avZminzrUB0RhzsO2OdvV325JEdAu9SdVoRl3sSfAWVuxIh9lpJMGXYxgKDVRvaJK3VYb0yOlIONJzgZnqb+Yo1deOlALXbLIkbpGKrgJJGuHk0Nf21NrSz2xmGwEHeZmcbY9O3p8eqvEO8gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787609; c=relaxed/simple;
	bh=3jCoo0xBC77wqS0uGK/Og3qgYmE8n5CFJ3o029mCPlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOVwplWqy1VgeML08gcZkK5/eVt9N4ExODngu1Lo6LlXAb+vD9Yb9qRS3aQQbK5GNxL1TT9h3SlIQm5knGmHw9BjUL7VTLi8MNYW3rTM9cIY/0mBEN537BCyXLaDyXM2Zpnweb4Cao/wpde44KZ3CQ/j2jCz/XzlBko/e+I8Gx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jM9QlKit; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jM9QlKit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865131F000FF;
	Wed, 30 Sep 2026 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787608;
	bh=iYb0HGVxGcyRI4bYSq8KKyKbUOw8NVw6jtnwmBSbqkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jM9QlKitTKUI6X/gvby8VAGWwS7fpFwGJbcEzlEUqmAcuo+/e1RJeYojXUo0SJ4GS
	 iCiZSYiMg7g01sHg5tygTt8QlJ9+QzB1vvuDMaS+jUi8RB4Sk44OFsW6X+X/faLvu4
	 he2t75Nn2lSdYbtn4u/uS+37atcBnXF290np7C3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.2 253/457] crypto: s390/hmac - Generate intermediate CV for API partial block handling
Date: Wed, 30 Sep 2026 17:25:58 +0200
Message-ID: <20260930152351.509015796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,7 +150,10 @@ static int hash_data(const u8 *in, unsig
 
 #undef PARAM_INIT
 
-	cpacf_klmd(func, &param, in, inlen);
+	if (final)
+		cpacf_klmd(func, &param, in, inlen);
+	else
+		cpacf_kimd(func, &param, in, inlen);
 
 	memcpy(digest, &param, digestsize);
 


