Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B921E497;
	Thu, 23 May 2024 13:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470346; cv=none; b=j0fn3tpHrcmvVB2gqdA7CnjTLIa9WOUU5Xl0V30EDYo/ocUQkWmUvl8+2mbkWHyVuaLqry8T2OzlwvwlmhwwvvBsXYM/4ML2bR5Bg4qG0832y+0lo03iTZvzbLkWNuz/6MIq3i8Mp7eHlaxBWTlmWmWm2sJOOPBYCyVytybkCzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470346; c=relaxed/simple;
	bh=2BdwpiaPjOMPc2qA7EsE5fJHFe9Iq6vQ0Uhlggx8tNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKhMTvWGW576Froa9vBDcftabQbfynf0uRuzB1c9/HNphS8wBlO1S/Q0XYgPG0prHV4OSsTLNuD6vxuDsqpFAJcuL6c4b6ViFTRPr3iGt4g4nYn6vpuC/llRH9wDSNxI79NuY7mYA7UWbQEMjPncr53VV/W42QFUM/FiB6/g+7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gw3h28Hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gw3h28Hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732D1C2BD10;
	Thu, 23 May 2024 13:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470345;
	bh=2BdwpiaPjOMPc2qA7EsE5fJHFe9Iq6vQ0Uhlggx8tNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gw3h28HrANMAaigEVNuEn02mpu74tH+o6TGWqFODOpnymxSqi4y0AXqBqUxIPa07f
	 IfL2dP5IQdDovcCHGXl8ZmZpddBGBsqic3DubJYJt85EBEk3G4u/lIB5FKrYhvjGgN
	 O1K9tfpI8TsnKuvUOQnB2tK05oHcYTKvaRLik5z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 21/23] KEYS: trusted: Do not use WARN when encode fails
Date: Thu, 23 May 2024 15:13:17 +0200
Message-ID: <20240523130328.750122646@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 050bf3c793a07f96bd1e2fd62e1447f731ed733b upstream.

When asn1_encode_sequence() fails, WARN is not the correct solution.

1. asn1_encode_sequence() is not an internal function (located
   in lib/asn1_encode.c).
2. Location is known, which makes the stack trace useless.
3. Results a crash if panic_on_warn is set.

It is also noteworthy that the use of WARN is undocumented, and it
should be avoided unless there is a carefully considered rationale to
use it.

Replace WARN with pr_err, and print the return value instead, which is
only useful piece of information.

Cc: stable@vger.kernel.org # v5.13+
Fixes: f2219745250f ("security: keys: trusted: use ASN.1 TPM2 key format for the blobs")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -84,8 +84,9 @@ static int tpm2_key_encode(struct truste
 	work1 = payload->blob;
 	work1 = asn1_encode_sequence(work1, work1 + sizeof(payload->blob),
 				     scratch, work - scratch);
-	if (WARN(IS_ERR(work1), "BUG: ASN.1 encoder failed")) {
+	if (IS_ERR(work1)) {
 		ret = PTR_ERR(work1);
+		pr_err("BUG: ASN.1 encoder failed with %d\n", ret);
 		goto err;
 	}
 


