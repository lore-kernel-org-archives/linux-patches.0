Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B543F54D1;
	Wed, 20 May 2026 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302923; cv=none; b=F1K3pKGva04OXbBpwBE4wcYPJD4Jyhva1h3e7kSqih18p+gNssVJWWn3MJ1d/JR+BYUsrxIuZuCcnjqI5MRV0K3a+tbcn9dk9LyDNja+m5+HVI8GjGDI4JmUA3gftXoDAIhDAj/jymAaiVaZbptWGcDnVAyqPdANtt47FhWfWH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302923; c=relaxed/simple;
	bh=0/8cCNPCFdfqmuME4Kb2rvSpoQCjNv5DKWkgXfwfj1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr5isFqIC2lwYibEnu+yLexmYSeCIhFle5qM9EYrX0Fnh1kOfw58wYPergEKtgJKCj9LHVA1JRNZp5mkLwKyxt+maKcXUM99xjortaf9VAQfOjuK4pdy9sW0LzjSvyi5Y1YEVMVko0DOOY8sqIuZP+vY1TugrZsR0qHFDtDvUKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9qJKoS/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9qJKoS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C701F00893;
	Wed, 20 May 2026 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302919;
	bh=ACSpHIIKWGSpzGtOzQgS9/GMG7Y1PCu6VIg1gF4Y26k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9qJKoS/ss8QoMn0DLYWRQB29DepDufA82UoTyo4gDsl0tW3Fk4LudxfZXWamenqY
	 /GIKz0Yd23sXAjfty0Zsg+p0HVM7kC2QL4V7yECLQ7mGUMfAjqPl3A3gqvMuixhz99
	 wtvrRevb3MiQbDidtHCDsSzxDsbAOg0A82pXdmCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 451/508] crypto: af_alg - Cap AEAD AD length to 0x80000000
Date: Wed, 20 May 2026 18:24:34 +0200
Message-ID: <20260520162108.367603140@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
@@ -585,6 +585,8 @@ static int af_alg_cmsg_send(struct msghd
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
 				return -EINVAL;
 			con->aead_assoclen = *(u32 *)CMSG_DATA(cmsg);
+			if (con->aead_assoclen >= 0x80000000u)
+				return -EINVAL;
 			break;
 
 		default:


