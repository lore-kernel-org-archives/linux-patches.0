Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C715234B197;
	Tue, 16 Dec 2025 11:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885235; cv=none; b=BSXFZ1BHIg34VN5kQkSULLPlkLAF5qmB3Cg0VPBDhjKlAIq60CFGMn4hFWHt0gwm/WpOpt0YdNjpeFDzqjY3+DoW4K4I9BWxXJGEOzguO5bWQYgUuNU5EEfHJcm4HNTij1Z1jv9MbiAJXVGDZ3Jd6EsYRuArLEEhocRU/hbO7/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885235; c=relaxed/simple;
	bh=W+y4C1srKr9Cq/KjFjV3P0FGiUiRkXCYhYazVkek7/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjgU6Iqc5vYoZp3e1Ubjy8clO/TU8XHuiJKbsdq/LJ3snMbVYz6bWnJ5jrDzUG/+uPrN0O+p2dojviAQOtusMgfvS0fHohRtXSFUD4uPypemMd9M94JNWNTmZC1Aoy4Y6haO4XXVVbrglBQI7X3FxvfrAgwzedwmRdgG6sMUMvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8g4vicW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8g4vicW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2991FC16AAE;
	Tue, 16 Dec 2025 11:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885235;
	bh=W+y4C1srKr9Cq/KjFjV3P0FGiUiRkXCYhYazVkek7/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8g4vicWE7sD7XoRPihlsld3U/aNPO27wflAJgvNC0rSQysgX758EL7HtpgO+Bdkh
	 Q96yXGvfRbkDUF2ofba+hOWHcCT6Qs7YoSlBvnaO18O6RdL9bREVFSQtCrvZMaQVyh
	 SzMUojkymHwg+T+Mj8Q47pY6U1bfxs51U0GHn0pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 079/507] crypto: asymmetric_keys - prevent overflow in asymmetric_key_generate_id
Date: Tue, 16 Dec 2025 12:08:40 +0100
Message-ID: <20251216111348.404321946@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit df0845cf447ae1556c3440b8b155de0926cbaa56 ]

Use check_add_overflow() to guard against potential integer overflows
when adding the binary blob lengths and the size of an asymmetric_key_id
structure and return ERR_PTR(-EOVERFLOW) accordingly. This prevents a
possible buffer overflow when copying data from potentially malicious
X.509 certificate fields that can be arbitrarily large, such as ASN.1
INTEGER serial numbers, issuer names, etc.

Fixes: 7901c1a8effb ("KEYS: Implement binary asymmetric key ID handling")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/asymmetric_type.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index ba2d9d1ea235a..348966ea2175c 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -11,6 +11,7 @@
 #include <crypto/public_key.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
+#include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <keys/system_keyring.h>
@@ -141,12 +142,17 @@ struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
 						     size_t len_2)
 {
 	struct asymmetric_key_id *kid;
-
-	kid = kmalloc(sizeof(struct asymmetric_key_id) + len_1 + len_2,
-		      GFP_KERNEL);
+	size_t kid_sz;
+	size_t len;
+
+	if (check_add_overflow(len_1, len_2, &len))
+		return ERR_PTR(-EOVERFLOW);
+	if (check_add_overflow(sizeof(struct asymmetric_key_id), len, &kid_sz))
+		return ERR_PTR(-EOVERFLOW);
+	kid = kmalloc(kid_sz, GFP_KERNEL);
 	if (!kid)
 		return ERR_PTR(-ENOMEM);
-	kid->len = len_1 + len_2;
+	kid->len = len;
 	memcpy(kid->data, val_1, len_1);
 	memcpy(kid->data + len_1, val_2, len_2);
 	return kid;
-- 
2.51.0



