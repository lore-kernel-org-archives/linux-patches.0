Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7991016D9BF;
	Mon, 23 Jun 2025 22:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717241; cv=none; b=KbAYW0yUt8jKiR1LPmbj64mRSkBLjjJPIkoUi9DfMsDaUTo8sBTmle+RERialixiCTC6XwxBfQVBbKHFA5fpdM5HegaIo5bj2YVpS41ET0Aa9qzfKqEt29j4kZlyr/DVu4e7zsyVKhvy19G7w7fRjqEHZze2Uvs/an8tVtsd1y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717241; c=relaxed/simple;
	bh=J4tlI1bxdpAVE5lnY85MIZ0bQES8xQ0pJbBwRSIi7s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bh0nY1b6Nwi9HkEy7Im3JGQQ/XxJMa3u0cHQnxjECnarf19MIRxDLaPKCGWcrBMvNip9vkbATEoUiPRjAb823XZhKf+eEuvO1+XQjIQkMuQwqquyOpuKScJZlKRkl01uU2/KvUdpxnuLO1SIGHaAfZHYECFLeBjkw2lEULoTh9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gA66YJn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gA66YJn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B6CC4CEEA;
	Mon, 23 Jun 2025 22:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717241;
	bh=J4tlI1bxdpAVE5lnY85MIZ0bQES8xQ0pJbBwRSIi7s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gA66YJn+opucuGkI2fxuDJsUgRAJrA1TPhg9mwOaWBX/MLCSKubz4PTHG2tuA7kGd
	 wwkm4cDjY7zh0iztFzVxJvh7hCsHn3zuQVm06+bc9y1AKws2j1w45jN2P7s7Z81STu
	 PSiiSNWZezuyVtogMIVV5ly01S5TaRSqqL5kUqR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 321/414] selinux: fix selinux_xfrm_alloc_user() to set correct ctx_len
Date: Mon, 23 Jun 2025 15:07:38 +0200
Message-ID: <20250623130650.019961055@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


