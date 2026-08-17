Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAFD3AAF76;
	Mon, 17 Aug 2026 14:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975531; cv=none; b=pBLv4en+OO5v+sBKKeG6hecUQwcZ9JJjnMStvR+hPdZED1Ks4OvA81efYfNWM1D4QAbbEkKSd+E8xGdQCKOJ8z8sK8S9FCcSSC7cwz0+tNbHBq1Jvg5K7Pe/Z+NQk54wkLOBLS7AwpaOKVZS8s4h1060BpWx0u4EmmR0q0n+QXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975531; c=relaxed/simple;
	bh=+g6Tc5EeAZqiY99T9dyXDuL4e5akRRm/k6Yd60u9T8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3QwDAHNKvTp07eBzh4mzQzALvITR2v0IsLz3XKlqHffp+/jdMm2+b+BjgaXmTpHq4WOkDLQh0Dn6TvANVqCa7BW6cVBucKqEPq/zShEaJPuiSebwidSziXyrmnuPgNNR58hmHuPbOI/HfHksPCju1dSkxeGEDeDIaEPl7nMtf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYFy3YZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYFy3YZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EA51F000E9;
	Mon, 17 Aug 2026 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975529;
	bh=7PGr0lEKtt5sGoIopmILj2b0hAFnHEvNnHvoTMKaG14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYFy3YZ1y3pOAnr8exkSuCiZo4GSQrj7b3X+jCVUsMCblMAoz4+iiCejdIu0oNB/w
	 mzBYwI3gLg2ZRQerR41Od128dwDxBKAA6qqUoQWuysI4lJqcSJeAtetBT7mtT7cJg5
	 r+UnxZdVPTP6hCiV5LS+0I3FA/d6lIUdjTJWF2pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/389] crypto: rsa-pkcs1pad: Dont WARN on an empty digest
Date: Mon, 17 Aug 2026 15:28:17 +0200
Message-ID: <20260817132541.337811553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

KEYCTL_PKEY_VERIFY lets an unprivileged caller supply a zero-length
digest (in_len == 0).  keyctl_pkey_params_get_2() accepts the zero
length and the request reaches pkcs1pad_verify(), where the empty
digest is rejected but only after being passed through
WARN_ON(!req->dst_len).  The warning is therefore directly
user-triggerable, and on kernels built with panic_on_warn=1 an
unprivileged process can panic the machine -- a local denial of
service.  Reproduced as UID 65534 in a setuid sandbox.

Keep rejecting the invalid request with -EINVAL, but do not emit a
warning for the user-controlled length.

This is the 5.10.y/5.15.y form of the fix, where the length is read
directly from req->dst_len rather than cached in a digest_size local.
Mainline does not contain this code path; commit 1e562deacecc
("crypto: rsassa-pkcs1 - Migrate to sig_alg backend") removed
pkcs1pad_verify() in v6.13-rc1.  This is a minimal fix for the
affected stable branches.  The 6.1.y/6.6.y/6.12.y form
(WARN_ON(!digest_size)) is sent as a separate patch.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/rsa-pkcs1pad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index a4ebbb889274eb..1cde1e7c9ae43d 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -535,7 +535,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	int err;
 
 	if (WARN_ON(req->dst) ||
-	    WARN_ON(!req->dst_len) ||
+	    !req->dst_len ||
 	    !ctx->key_size || req->src_len != ctx->key_size)
 		return -EINVAL;
 
-- 
2.53.0



