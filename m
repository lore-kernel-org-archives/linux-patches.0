Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4DA1E497;
	Thu, 23 May 2024 13:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470539; cv=none; b=daCg+A6hnssDTlcyBpwUL0KowTIHdEtTVqaMATCvXERzF65ancNBwUH7bXZ31PCOKouqGRho6r+ouzdLMCTLSOgDQvZgVSIQYSK7v8X7KmSsYNMtrPqZAWP5zoNADyBJYEqQxAByi1wT9Th4NYlIC4/7C1uGnt4sEzIPIC1ijL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470539; c=relaxed/simple;
	bh=8AN3wU9iD8K4Oo0CwUBVw9UwAJymIglGc49c+zBFqyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLAa+8HlXwsEvlAmsVkTv0i4htvQxXwxadZsk+oovpNVbeRXPV6EYbNcH06pFag0Wi/E4gc5iPVP8ZPNPRGFPiOzN8P8GHQK107jaOtiKFaG61DSqs6PvKWsEnwQeZiUALpj3gj/VrCQ4aOm9tnVXdp6qRxE+llS5O2fiLsDQAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NewIAUvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NewIAUvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348A7C3277B;
	Thu, 23 May 2024 13:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470538;
	bh=8AN3wU9iD8K4Oo0CwUBVw9UwAJymIglGc49c+zBFqyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NewIAUvPB87Z70qTurCe15cFwRiWrQqsAHxE82jH+jJCgOUXjUoLaFvhVgx9bWIEa
	 tSJCV/OZnnvFc0otfU9vjn9YEUW1INakhzPPvsGgSk4vcFRd6qC+s4GPOEBZyHvw8y
	 Urjm4nUbuzddg7bF8vY1loTV/SqKoawFJnJCYxOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.8 07/23] KEYS: trusted: Fix memory leak in tpm2_key_encode()
Date: Thu, 23 May 2024 15:13:34 +0200
Message-ID: <20240523130330.024423583@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

commit ffcaa2172cc1a85ddb8b783de96d38ca8855e248 upstream.

'scratch' is never freed. Fix this by calling kfree() in the success, and
in the error case.

Cc: stable@vger.kernel.org # +v5.13
Fixes: f2219745250f ("security: keys: trusted: use ASN.1 TPM2 key format for the blobs")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm2.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -38,6 +38,7 @@ static int tpm2_key_encode(struct truste
 	u8 *end_work = scratch + SCRATCH_SIZE;
 	u8 *priv, *pub;
 	u16 priv_len, pub_len;
+	int ret;
 
 	priv_len = get_unaligned_be16(src) + 2;
 	priv = src;
@@ -57,8 +58,10 @@ static int tpm2_key_encode(struct truste
 		unsigned char bool[3], *w = bool;
 		/* tag 0 is emptyAuth */
 		w = asn1_encode_boolean(w, w + sizeof(bool), true);
-		if (WARN(IS_ERR(w), "BUG: Boolean failed to encode"))
-			return PTR_ERR(w);
+		if (WARN(IS_ERR(w), "BUG: Boolean failed to encode")) {
+			ret = PTR_ERR(w);
+			goto err;
+		}
 		work = asn1_encode_tag(work, end_work, 0, bool, w - bool);
 	}
 
@@ -69,8 +72,10 @@ static int tpm2_key_encode(struct truste
 	 * trigger, so if it does there's something nefarious going on
 	 */
 	if (WARN(work - scratch + pub_len + priv_len + 14 > SCRATCH_SIZE,
-		 "BUG: scratch buffer is too small"))
-		return -EINVAL;
+		 "BUG: scratch buffer is too small")) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	work = asn1_encode_integer(work, end_work, options->keyhandle);
 	work = asn1_encode_octet_string(work, end_work, pub, pub_len);
@@ -79,10 +84,17 @@ static int tpm2_key_encode(struct truste
 	work1 = payload->blob;
 	work1 = asn1_encode_sequence(work1, work1 + sizeof(payload->blob),
 				     scratch, work - scratch);
-	if (WARN(IS_ERR(work1), "BUG: ASN.1 encoder failed"))
-		return PTR_ERR(work1);
+	if (WARN(IS_ERR(work1), "BUG: ASN.1 encoder failed")) {
+		ret = PTR_ERR(work1);
+		goto err;
+	}
 
+	kfree(scratch);
 	return work1 - payload->blob;
+
+err:
+	kfree(scratch);
+	return ret;
 }
 
 struct tpm2_key_context {


