Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B042F90E0;
	Sat, 30 May 2026 18:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164748; cv=none; b=Z2UkqDdS0V7DmUOoKNnWWd85NpPPmYfOV6IQYHeiXXyX8rT2ryxBpP5/KiKbdN49hxqpaTf9D221B8O1/a5CPin6kgMsDEt0y+OjuuQ2gZFndpLUj7kTJvNCW9+j/qE5jtMJFx6SR0mI156xSYPseoGZRSsVwyUM4VKKFS2Pqd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164748; c=relaxed/simple;
	bh=dZHNY3XiYUoVawVq17VrL0mfv3THxmTU9XwgSU6P4dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD3FCeHqnwZdoSNAyvkTT0WH+QTMVVi8XTzzcyKW2NoAwWqxEsKQ/p/1/kSNqmGOVeY6En2dkpcM6EE9KY6WnpG9iRNeLWZjGhj8/S9wBsbFVEcHgNUjObjAzqW+Fg6Dg2O1erSN8uC/B74IX1RsShLVHOs+WedcVjyvsFfynUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvBZwT5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvBZwT5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB8E1F00893;
	Sat, 30 May 2026 18:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164747;
	bh=F4lGDOfmwmys98jEB6oR/Ic6egBsvFmUbNq9cMnNXQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvBZwT5zpSsdFI6Y3N0KgbLiHLTR/aRSqopxRprExTH6o48tiwgiI4I++EcXttj18
	 halto3pIiMD/2U8BLTyfLKPpOBO2CDGrRe1X46sbQOJ/OWXZ923CQnZDY5/JTo5jFG
	 0WBA4LWEDc+YNXR2TKFrX0+K9E4AmriuAAMmERpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 647/776] crypto: af_alg - Cap AEAD AD length to 0x80000000
Date: Sat, 30 May 2026 18:06:01 +0200
Message-ID: <20260530160256.655473817@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -478,6 +478,8 @@ static int af_alg_cmsg_send(struct msghd
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
 				return -EINVAL;
 			con->aead_assoclen = *(u32 *)CMSG_DATA(cmsg);
+			if (con->aead_assoclen >= 0x80000000u)
+				return -EINVAL;
 			break;
 
 		default:


