Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A2B155C87;
	Mon, 23 Jun 2025 21:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713550; cv=none; b=ltz2xG9ForrqdQFzcUVHUokv8VRqCOGnwOcf+ZjFResguMSj8OQNdWz7t3x+glOVbpHRnVfM12QuS/evRjAFKkVytza8032e0dri3gRT3jPZTghtqE7OIXXG0XAbTIxN9uWR2/7uHcOg2WDAHsljvHkZWPTGr6MvF6dIWcqZDZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713550; c=relaxed/simple;
	bh=LSVAvqn5PSvniXmbKCP3Kmu9MPQSPuev4WSVkYKRRUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R59+wuNrK7zMOb7cIVnpvZJzPhNYm8B2kFWQHQy5Od0rOh3HoxGmM0uE2WxctXNMrosayrBU+TtOp3bA3PcdGGB8rE72J012Av+Eq+sTBmAu4Ip5Gff7AiyufLCFDW8kaHiMQLmywIAZHeFu5b7dmtG9KGDGxiO7aZ62Cp3UYDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0tOnykc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0tOnykc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F629C4CEEA;
	Mon, 23 Jun 2025 21:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713550;
	bh=LSVAvqn5PSvniXmbKCP3Kmu9MPQSPuev4WSVkYKRRUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0tOnykc8bfZfRqcbbyGiZHGYdnF4xTSbjLHMCKPxB1GS6HheE8pGv7rJ0rUuArCV
	 7coftGggrX9fGBl/v9ry8xU6WKXUWIX2jO31HJVaQP+amYjvl+8mtBbfPjXUdoN+bt
	 ePUtcAwoLIdrYHhgW/+bTB4cKE3h4PNBQ7j6xKB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 192/222] selinux: fix selinux_xfrm_alloc_user() to set correct ctx_len
Date: Mon, 23 Jun 2025 15:08:47 +0200
Message-ID: <20250623130618.006011370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -95,7 +95,7 @@ static int selinux_xfrm_alloc_user(struc
 
 	ctx->ctx_doi = XFRM_SC_DOI_LSM;
 	ctx->ctx_alg = XFRM_SC_ALG_SELINUX;
-	ctx->ctx_len = str_len;
+	ctx->ctx_len = str_len + 1;
 	memcpy(ctx->ctx_str, &uctx[1], str_len);
 	ctx->ctx_str[str_len] = '\0';
 	rc = security_context_to_sid(&selinux_state, ctx->ctx_str, str_len,


