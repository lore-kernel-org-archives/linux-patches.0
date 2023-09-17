Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB61663BB
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEB4C433C8;
	Sun, 17 Sep 2023 19:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979386;
	bh=jhnVTkp4lCpWAAILiQ1dkgSZczDzHzLwlo12sSPD1ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDTzAiRlYcV7rYoVGeZ8UR7JRVKaz9VX/w7IZEas6yC2dZ48snrNSBJ8SfII/CvbK
	 WJAIYfJrypuMQRpPTGmcFjovLu+m3jmBr0ayYXtj4PY89Q+q3NU1yCCYZ5CBb4MWNX
	 8h2fOneEP/9q3PA9CwMkDV76eMu3UEdPNkxkjH8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thore Sommer <public@thson.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 297/406] X.509: if signature is unsupported skip validation
Date: Sun, 17 Sep 2023 21:12:31 +0200
Message-ID: <20230917191109.154205434@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thore Sommer <public@thson.de>

commit ef5b52a631f8c18353e80ccab8408b963305510c upstream.

When the hash algorithm for the signature is not available the digest size
is 0 and the signature in the certificate is marked as unsupported.

When validating a self-signed certificate, this needs to be checked,
because otherwise trying to validate the signature will fail with an
warning:

Loading compiled-in X.509 certificates
WARNING: CPU: 0 PID: 1 at crypto/rsa-pkcs1pad.c:537 \
pkcs1pad_verify+0x46/0x12c
...
Problem loading in-kernel X.509 certificate (-22)

Signed-off-by: Thore Sommer <public@thson.de>
Cc: stable@vger.kernel.org # v4.7+
Fixes: 6c2dc5ae4ab7 ("X.509: Extract signature digest and make self-signed cert checks earlier")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/x509_public_key.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -132,6 +132,11 @@ int x509_check_for_self_signed(struct x5
 	if (strcmp(cert->pub->pkey_algo, cert->sig->pkey_algo) != 0)
 		goto out;
 
+	if (cert->unsupported_sig) {
+		ret = 0;
+		goto out;
+	}
+
 	ret = public_key_verify_signature(cert->pub, cert->sig);
 	if (ret < 0) {
 		if (ret == -ENOPKG) {


