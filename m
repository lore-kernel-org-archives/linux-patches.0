Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C352D14AD0D;
	Thu, 23 May 2024 13:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470446; cv=none; b=PjP2hVXNmHi9yTaS1wS9t6Fr1mu1C8QkdigFaJlPwjD98aZi14PcaHrHEI8x/vBq6ua3zlcLduDoCUd7Zwxpwf6QeGHLOcml6Q/TaHcVOgVjvP38TISM5jVC8MYiidW7HSPS2SLZhi/19CWnt9oEZXENkz+n9zOF5tEQCYJ/9Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470446; c=relaxed/simple;
	bh=YDFVYAtHsGJPBDJfTYzJSUco0Rj3jjGNGPtDs54RfX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O74FSbBZjuHo3TSZexmFxds0jJEEC2WR8T2OEfuQD80dIBcbPfP+jepESRJxO0UsiEmh4dT2ApKgvJYzGlqLiNSaVFvZopZAtynxQdisbQjtPl5otteBx2GJ4gdYuvWJRyEljAstEmgfHs7TirjTwQYWlv96s5fk+II/I3gZJXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIYyUlB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIYyUlB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8FBC2BD10;
	Thu, 23 May 2024 13:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470446;
	bh=YDFVYAtHsGJPBDJfTYzJSUco0Rj3jjGNGPtDs54RfX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIYyUlB86IX8S//GB2OZNZGlNsraat+Y7jEUkDVGuZDns2+80kTZOcfs4jKj+8jn4
	 71gzeajz2PfoEN3QJBW9qp/ChB6xpevYNHLjwrxlPxLEomfvFi8sHwIkklNfLEB9iE
	 Nm9sSzRj40W4T6KU6XHFgv+Qr5/8sF5Hdqt7mJpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 08/45] KEYS: trusted: Fix memory leak in tpm2_key_encode()
Date: Thu, 23 May 2024 15:12:59 +0200
Message-ID: <20240523130332.811570267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


