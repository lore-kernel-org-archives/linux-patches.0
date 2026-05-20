Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE77329B8D0;
	Wed, 20 May 2026 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299725; cv=none; b=MIZohEo6ZhN8Z6jw5ONdsk3cm5BPLFkT6T7DksAli6dy9I0C6BhcSqd/9TggSm8Kp+uiXNLo0yVonpulEUZutjIPIdLpgbH+w4tWkZIVxIRm/jFhgWZFWCyNjM852FAtBcsmXRDUYq0F/wsnJwCXIfgiGVY8tJoeWYCcyFoIFrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299725; c=relaxed/simple;
	bh=TRfhDIlK+LoKEe/fdvypiIkezBEFsQaIjEemcHZz0E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCNF36q6KTCYpCmlGpxRmA0pKpBcZWOSrXa37Bv2797PeJDscyXOArGF6Hpz6OetZnYOvvz/url4Kgp+QUoR9M34d+lACimknRZ28w1duWehb1tcqS8XGQ3UFYz/DpblNs9nma+flwP25+h3rfJ/XxY8IX8EfT3eVthsXheELLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeQZdT4L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeQZdT4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC3F1F000E9;
	Wed, 20 May 2026 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299724;
	bh=t46jlYE4HU8U0yUGT9e9YR68IoQAPEl3VIACj58hqao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeQZdT4LPagzUwExpLYvHDtasod1lcd5BZ2/GqpYOslQwrzKT4LGPXA8gJfsGmg/B
	 5SiE9AHHswNhCASWySfJ2i/Aq5NLfafmLocDrp83Pb3j6lvGXCjgkjYHFhK3JgWfYc
	 axwMKzbsRUNUFjQR/aDUT05crE+cVnbNR1ZPQhBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 879/957] crypto: af_alg - Cap AEAD AD length to 0x80000000
Date: Wed, 20 May 2026 18:22:42 +0200
Message-ID: <20260520162153.627654939@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

commit e4c06479d7059888adf2f22bc1ebcf053bf691a2 upstream.

In order to prevent arithmetic overflows when checking the TX
buffer size, cap the associated data length to 0x80000000.

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 400c40cf78da ("crypto: algif - add AEAD support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/af_alg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -586,6 +586,8 @@ static int af_alg_cmsg_send(struct msghd
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
 				return -EINVAL;
 			con->aead_assoclen = *(u32 *)CMSG_DATA(cmsg);
+			if (con->aead_assoclen >= 0x80000000u)
+				return -EINVAL;
 			break;
 
 		default:


