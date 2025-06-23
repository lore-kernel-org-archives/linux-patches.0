Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F5D136348;
	Mon, 23 Jun 2025 21:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715484; cv=none; b=L8u7OGZDXoe+tlAZfY4ukIVEK+iseGMmmnt1ST/xcbwWx0kojVfxv5rk0N8KIQqyN+3VuQ6zCGt0y9XKihQ0yb+Tb6jvKeIOhCI8pWiwMalM6stNjUouSP5DY4I+jWwyVJrtkOxzHizNtDMRzGi8TS2/WTSdqJZprAlWGX1jYJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715484; c=relaxed/simple;
	bh=LHsfskMnFBmo/VMPKa7fk9yNsA59gPhVon71kWbiLJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tMcbF8Mz2UjSPdcyPQzIWVB1KYp7lyArdOoVGF4X851fMBWqmeKT4eNhDOgRKoSGvgDkZ+wChnQbYUN5qecgb91PKCebA7Zckk7gny9s6C1HYsE9/PqFwIlwcZLCAFP2Xs5o8cieslRT0drO2iW0fpSCxP/yfrOqnMjHJta0Hjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzUoY/LJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzUoY/LJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFCBC4CEEA;
	Mon, 23 Jun 2025 21:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715484;
	bh=LHsfskMnFBmo/VMPKa7fk9yNsA59gPhVon71kWbiLJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzUoY/LJmfS96dyDe50g3YAEu30BS78/Bp2Ah0OxdyJWP3FGcowrQ+s++9aiuLV5m
	 283oNpHcpjmYKrHcRzEa6RLzqbqQSZ5DtcXQS8hZ1jJ6exYJ7RQHynzCon3rgxCOmQ
	 nQrxsMcDVFptIB3Q7BXELutJVQkBf9h0ZDnYleMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.15 482/592] selinux: fix selinux_xfrm_alloc_user() to set correct ctx_len
Date: Mon, 23 Jun 2025 15:07:20 +0200
Message-ID: <20250623130711.899295666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit 86c8db86af43f52f682e53a0f2f0828683be1e52 upstream.

We should count the terminating NUL byte as part of the ctx_len.
Otherwise, UBSAN logs a warning:
  UBSAN: array-index-out-of-bounds in security/selinux/xfrm.c:99:14
  index 60 is out of range for type 'char [*]'

The allocation itself is correct so there is no actual out of bounds
indexing, just a warning.

Cc: stable@vger.kernel.org
Suggested-by: Christian Göttsche <cgzones@googlemail.com>
Link: https://lore.kernel.org/selinux/CAEjxPJ6tA5+LxsGfOJokzdPeRomBHjKLBVR6zbrg+_w3ZZbM3A@mail.gmail.com/
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/xfrm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -94,7 +94,7 @@ static int selinux_xfrm_alloc_user(struc
 
 	ctx->ctx_doi = XFRM_SC_DOI_LSM;
 	ctx->ctx_alg = XFRM_SC_ALG_SELINUX;
-	ctx->ctx_len = str_len;
+	ctx->ctx_len = str_len + 1;
 	memcpy(ctx->ctx_str, &uctx[1], str_len);
 	ctx->ctx_str[str_len] = '\0';
 	rc = security_context_to_sid(ctx->ctx_str, str_len,


