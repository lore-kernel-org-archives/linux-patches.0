Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C953BC4F2;
	Thu, 15 Jan 2026 17:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497350; cv=none; b=Pv2rwVtJ6MhRafr/wBlUCHuWR9lO67jpN6c4vQSJ4mafL7GHJqkaXpSyl7oUmnJBLb+sdGZtJMQmPz6iNa126J8oDn5tM97JBcEVks6Cjlwvcd2h2pHxXKPh1FN5MUlSRQ3Fkup8cL/yRXPV+Dy+JZE+cws9VYb4u8w+603WGeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497350; c=relaxed/simple;
	bh=Vv2X/lvmrD3ayq8PiJcaXExpDTtzD0NuAwLf6sLKDf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVtkvai6JChJxLLVkRkZ3dST7rTlpSptauScU2/53UhpyFz2dz4qRLkVvO+jeVNjig1hyQboiJBJewkVLTPwgChmr6h80/Im/0ERqdco65mLQ5rFNwgTArPLi/BcQhlmGgdRKt2DTTb3ypQsKhp2IoUCD9fWaEwgWaT5T2UquqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHms6C1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHms6C1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCE7C116D0;
	Thu, 15 Jan 2026 17:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497350;
	bh=Vv2X/lvmrD3ayq8PiJcaXExpDTtzD0NuAwLf6sLKDf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHms6C1rpnNRbT46Yogu3ROId0krJmQ2d7isLEdaQgIuKB/DB9d+IbSbtUZrkt8zM
	 1HKUQQBtMj98+vhYQbCjonJycUTr3HrRpi2ImezEduEJfld33xqO7E5we8bBrTnfjX
	 K5g99cCYz82+Py7eFgkV1ljF1+yJOIU3UisBHjo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/554] crypto: asymmetric_keys - prevent overflow in asymmetric_key_generate_id
Date: Thu, 15 Jan 2026 17:41:56 +0100
Message-ID: <20260115164248.056332639@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index ad8af3d70ac04..2e3fa520d6eb1 100644
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



