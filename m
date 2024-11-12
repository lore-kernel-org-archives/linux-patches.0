Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6811F213ECF;
	Tue, 12 Nov 2024 10:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408272; cv=none; b=W4rsq3aiuvJA0TRIza+pmKo+CbJZK3x5A8ERjh6wl2RI6NQj+ReV4LxpQlNCoO1ELnyT2o7Hos3SC6EwZLkWDVtUDRVYhTOkqYzeUgaSGo9PzIDYRJYILyUGL0lOly3exawDFLqSOZZwDGHzbjpM9ElDzbWQI6+JbjrcrV1kVL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408272; c=relaxed/simple;
	bh=LWdSg7o1vDxSOzTC/EjuG9IhJPqouiyRTKWFVDNYtuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYmsn/jlI3VjK1+KCEdbECgItGqE1ynQewv+EhqQxqPGm2+CAGxsRtOCSKwe3a1tMnf+atXQmIptCQdJ3uVJGwInXwImtrNaGg7DJjuHnS4zLEoedzahH0BwI0neOdfZP8Fe11fv5e/ttQrQ8hJGb7joLILJLdRJChQ2vIMWsbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDYE2bRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDYE2bRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F0CC4CED4;
	Tue, 12 Nov 2024 10:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408272;
	bh=LWdSg7o1vDxSOzTC/EjuG9IhJPqouiyRTKWFVDNYtuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDYE2bRvaj4TSIW6zMedRWfd3dbyME3khKHwVkZ2JirmvQDX28YSdHkUD3zNmlqSd
	 36hTG5V/6R5y9TvSFtdtAPVtr5zBV9AZFzIm30jiRzoF8AeUJ18qI+9YIIpeE48Rn8
	 CphmzjtPS3me1VRPfNyrd/8ldnQLbxLIPiig9ppk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parthiban N <parthiban@linumiz.com>,
	David Gstir <david@sigma-star.at>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.11 113/184] KEYS: trusted: dcp: fix NULL dereference in AEAD crypto operation
Date: Tue, 12 Nov 2024 11:21:11 +0100
Message-ID: <20241112101905.201538619@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gstir <david@sigma-star.at>

commit 04de7589e0a95167d803ecadd115235ba2c14997 upstream.

When sealing or unsealing a key blob we currently do not wait for
the AEAD cipher operation to finish and simply return after submitting
the request. If there is some load on the system we can exit before
the cipher operation is done and the buffer we read from/write to
is already removed from the stack. This will e.g. result in NULL
pointer dereference errors in the DCP driver during blob creation.

Fix this by waiting for the AEAD cipher operation to finish before
resuming the seal and unseal calls.

Cc: stable@vger.kernel.org # v6.10+
Fixes: 0e28bf61a5f9 ("KEYS: trusted: dcp: fix leak of blob encryption key")
Reported-by: Parthiban N <parthiban@linumiz.com>
Closes: https://lore.kernel.org/keyrings/254d3bb1-6dbc-48b4-9c08-77df04baee2f@linumiz.com/
Signed-off-by: David Gstir <david@sigma-star.at>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_dcp.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/security/keys/trusted-keys/trusted_dcp.c
+++ b/security/keys/trusted-keys/trusted_dcp.c
@@ -133,6 +133,7 @@ static int do_aead_crypto(u8 *in, u8 *ou
 	struct scatterlist src_sg, dst_sg;
 	struct crypto_aead *aead;
 	int ret;
+	DECLARE_CRYPTO_WAIT(wait);
 
 	aead = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(aead)) {
@@ -163,8 +164,8 @@ static int do_aead_crypto(u8 *in, u8 *ou
 	}
 
 	aead_request_set_crypt(aead_req, &src_sg, &dst_sg, len, nonce);
-	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL,
-				  NULL);
+	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_SLEEP,
+				  crypto_req_done, &wait);
 	aead_request_set_ad(aead_req, 0);
 
 	if (crypto_aead_setkey(aead, key, AES_KEYSIZE_128)) {
@@ -174,9 +175,9 @@ static int do_aead_crypto(u8 *in, u8 *ou
 	}
 
 	if (do_encrypt)
-		ret = crypto_aead_encrypt(aead_req);
+		ret = crypto_wait_req(crypto_aead_encrypt(aead_req), &wait);
 	else
-		ret = crypto_aead_decrypt(aead_req);
+		ret = crypto_wait_req(crypto_aead_decrypt(aead_req), &wait);
 
 free_req:
 	aead_request_free(aead_req);


