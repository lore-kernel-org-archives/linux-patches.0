Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E849D2D9ECB;
	Thu, 15 Jan 2026 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498902; cv=none; b=HI9RCeLHshCaFsqpoA+CdsX+JhKLc1HO0iy9gR21BY77vld/c+l1difSJGnTBqE3BcUKTX4P0V7OOd2SKwqConotHCgGnFCDv3LhtueiyrcrZ9SebnAeHvL5tg/0uXkUTLrelu7JiY67FKr3cE3eKjmIBR0tOXOp0zYZx2t8CZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498902; c=relaxed/simple;
	bh=qOx1LIiKtvW5qb7091zDI3CdjRD9I55RX5pMUChATuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfiBoTSZf5kYb/hn1379chkpb6+pp5fG+C/daqKXCQ/MzAZ/38S/KVxJBVPuX9uOV178c3CvMmLvbVw++R+aWnMO+/lVuygQ7S026peZrEq8Gp3EtaOUSZNnMknRMObiC74iEaT5cMXPXGshtJPWdW1tuPjjoDYj8zZReXVKK5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHadsEk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHadsEk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E37C116D0;
	Thu, 15 Jan 2026 17:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498901;
	bh=qOx1LIiKtvW5qb7091zDI3CdjRD9I55RX5pMUChATuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHadsEk6O1x9FOmMU7Kg9S9tMIpQB18ntbSqufe862OfKnJV4wc8NNdPUiPLotGO1
	 7UpquIfvPbVGn/JDS3mWqoSLmr/deq4WI8BAtFcujR6/ZTk2w07pmR3ccO6w6cTFyj
	 +LwTqK4cS7KhKtL/BVdhYub9TvvZf0Hj3Xd2kJNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/451] crypto: asymmetric_keys - prevent overflow in asymmetric_key_generate_id
Date: Thu, 15 Jan 2026 17:43:59 +0100
Message-ID: <20260115164232.269904863@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index 33e77d846caa8..ef0e56642a078 100644
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
@@ -138,12 +139,17 @@ struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
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



