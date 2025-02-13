Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B7723A98F;
	Thu, 13 Feb 2025 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457645; cv=none; b=Qd6qq6U7NgoYIpNESD0q5zdxIfr7Tz/VRX4EU270LEN+pe2ca5BmetCg9YluOfOxIv120L7cVfulAHM+cPZb6mb40BVcZJ7RojLYNr0pHVZlhJ0sx0PcYjOz9VjWbIac2xnInRqMvwdgsX9KiCmv0d3J+SzPusXhr6P2hzSkVzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457645; c=relaxed/simple;
	bh=qry/jwhwpA4xztcGgQQ9em4mvBLoSgf8foY+Ugr4eKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ql8pNn8dXbblcpmwTIr6Y9iuTdfOh/ui//Ly9N2qaVwhzuXXv0Czi4PobCEL6dpoBCiJb67bOfvSQKn1HHwpcNJP//uM9kxC/BwvkxJN4zVDdA+EjLcyrVKxJxH83miF2FLbwwfkFo/zL1dOYvRcpxgLLZ6T/RzRKcmfjZx/htI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dgs8O1Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dgs8O1Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7361BC4CED1;
	Thu, 13 Feb 2025 14:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457644;
	bh=qry/jwhwpA4xztcGgQQ9em4mvBLoSgf8foY+Ugr4eKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dgs8O1KpAnz71NDNV4B9qgIfaqAMBTOzAOVlMpDH00UF886EzyorP2Dkl2fZ+bazA
	 BbZeuNPeQ87XEgM8LAu+vV5r5Bsd9E5fZhshlCHKlpgyV3YkIgbg+nCJBYhogKMAm4
	 7NC5Xxv0glv1gQ0tMiov39oB5CxMSZg/cOeU5Qes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gstir <david@sigma-star.at>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 172/422] KEYS: trusted: dcp: fix improper sg use with CONFIG_VMAP_STACK=y
Date: Thu, 13 Feb 2025 15:25:21 +0100
Message-ID: <20250213142443.180676808@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gstir <david@sigma-star.at>

commit e8d9fab39d1f87b52932646b2f1e7877aa3fc0f4 upstream.

With vmalloc stack addresses enabled (CONFIG_VMAP_STACK=y) DCP trusted
keys can crash during en- and decryption of the blob encryption key via
the DCP crypto driver. This is caused by improperly using sg_init_one()
with vmalloc'd stack buffers (plain_key_blob).

Fix this by always using kmalloc() for buffers we give to the DCP crypto
driver.

Cc: stable@vger.kernel.org # v6.10+
Fixes: 0e28bf61a5f9 ("KEYS: trusted: dcp: fix leak of blob encryption key")
Signed-off-by: David Gstir <david@sigma-star.at>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_dcp.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_dcp.c b/security/keys/trusted-keys/trusted_dcp.c
index e908c53a803c..7b6eb655df0c 100644
--- a/security/keys/trusted-keys/trusted_dcp.c
+++ b/security/keys/trusted-keys/trusted_dcp.c
@@ -201,12 +201,16 @@ static int trusted_dcp_seal(struct trusted_key_payload *p, char *datablob)
 {
 	struct dcp_blob_fmt *b = (struct dcp_blob_fmt *)p->blob;
 	int blen, ret;
-	u8 plain_blob_key[AES_KEYSIZE_128];
+	u8 *plain_blob_key;
 
 	blen = calc_blob_len(p->key_len);
 	if (blen > MAX_BLOB_SIZE)
 		return -E2BIG;
 
+	plain_blob_key = kmalloc(AES_KEYSIZE_128, GFP_KERNEL);
+	if (!plain_blob_key)
+		return -ENOMEM;
+
 	b->fmt_version = DCP_BLOB_VERSION;
 	get_random_bytes(b->nonce, AES_KEYSIZE_128);
 	get_random_bytes(plain_blob_key, AES_KEYSIZE_128);
@@ -229,7 +233,8 @@ static int trusted_dcp_seal(struct trusted_key_payload *p, char *datablob)
 	ret = 0;
 
 out:
-	memzero_explicit(plain_blob_key, sizeof(plain_blob_key));
+	memzero_explicit(plain_blob_key, AES_KEYSIZE_128);
+	kfree(plain_blob_key);
 
 	return ret;
 }
@@ -238,7 +243,7 @@ static int trusted_dcp_unseal(struct trusted_key_payload *p, char *datablob)
 {
 	struct dcp_blob_fmt *b = (struct dcp_blob_fmt *)p->blob;
 	int blen, ret;
-	u8 plain_blob_key[AES_KEYSIZE_128];
+	u8 *plain_blob_key = NULL;
 
 	if (b->fmt_version != DCP_BLOB_VERSION) {
 		pr_err("DCP blob has bad version: %i, expected %i\n",
@@ -256,6 +261,12 @@ static int trusted_dcp_unseal(struct trusted_key_payload *p, char *datablob)
 		goto out;
 	}
 
+	plain_blob_key = kmalloc(AES_KEYSIZE_128, GFP_KERNEL);
+	if (!plain_blob_key) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	ret = decrypt_blob_key(b->blob_key, plain_blob_key);
 	if (ret) {
 		pr_err("Unable to decrypt blob key: %i\n", ret);
@@ -271,7 +282,10 @@ static int trusted_dcp_unseal(struct trusted_key_payload *p, char *datablob)
 
 	ret = 0;
 out:
-	memzero_explicit(plain_blob_key, sizeof(plain_blob_key));
+	if (plain_blob_key) {
+		memzero_explicit(plain_blob_key, AES_KEYSIZE_128);
+		kfree(plain_blob_key);
+	}
 
 	return ret;
 }
-- 
2.48.1



