Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C72D277C88;
	Wed, 20 May 2026 17:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297081; cv=none; b=bE1d5JdmA9EGdqLY3exCjao8QVVC5QIgIvNlbs/5NLTHhSfCk92d8xMJ4E1NRQf8mgoP30Kp4iKVe406sl+u1K4pWByNLmOuct9ruBn1UCmfAHW5ZnjP3LhIEeuh3YHSdb/tyYSytSIRVYRDnS1gh3yFAJhZ5B8pTdgeM3kfctc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297081; c=relaxed/simple;
	bh=zwE3xiCPCrC+4tA0wmXxIZUorIHxZzvs7GhWt5nDBSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DE5Q6IHIDcfH+Jf5KnEZ4Y4cGi4b95juf17iWXz9QYZNCZG4UOYdXW+wtIQjAIWNrUgmlRHb07/HV7LyWZzd10Gmd9LBt5tpdPtVZ5jAENNQhrldBb9ok5QMgZV+ztzQJU1pruzwE47cYFOL32TIaxXubo19B0HOgFq8+MuBfck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzt1cE4W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzt1cE4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069471F00893;
	Wed, 20 May 2026 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297080;
	bh=c/ZzdSws+wlpwmG7NuHdCClQ7v1HQIHoMkWHeQtQlsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzt1cE4WwJutCRgGn7PesagZoZ/EFHn+l9ZrtqNYFCm39REXt9+tEGoY5EO+R+k2H
	 hSPJrabMU/iuO+aPmXTqyuSV1N2RuRyAkbNyeota+4X4z2ve8lz0s8K5njhqGJAuvd
	 GlRkS5DzNeJ36htN5vuogJrhywmrfUvGB78hittA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.0 1041/1146] crypto: af_alg - Cap AEAD AD length to 0x80000000
Date: Wed, 20 May 2026 18:21:31 +0200
Message-ID: <20260520162211.790748848@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


