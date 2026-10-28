Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209845;
	b=i0fF1YoP0np2hWu4ZK0yoartXn7HA2qxgGKCcsO5H/7r/4Wsfxu3hkDjlk5fORnzmeEL
	 IFwlg0KLzQTwYupd8veGZWXEdMPrTejSc9HG+6UlXYRsAUnD7wxBEj+3kN0jznPP37Pc4
	 ERmU8PBDcc58p9D3Wo7rWYEZYj/SXKWgUP7d0eO9RgFxO1dWwivuw5O0lobHFZZg3vOMi
	 F5Z/W/R4eb/Ciehe1kXrW7mGGqaZ2d8fOecYmhKkPpQSV6u+Ev0AAz5iUmLI2KESTh7nD
	 ICMGsQCzbhDdh9slvUIBWwOUHcoa2fFMJ0/O8JcqJOBcVQDfSF0a7KB5K0I2n4tTrgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k9j0BpPNTXJp0hTjeHrw8vpcJFTN1R28G5n5Ud3dzc8=;
	b=XOreUsXxZmRIWJFwccx1k5sn2uSfswu7zR7+Io4KK3eCLCuvtsl8E/EFxypAOHr7642E
	 AjMrgieJgnnmDr8JPDZ5UV3qFL0UhsCRH8hNtN1J7R5G3iD+3WQvulIwnavZtv/zhnax1
	 Me6855ps/kVoblxd7kkinvm4QwltA/ydNGXd4y91rZXN++yFyTxe5V7tWVOkueFzzXT4T
	 +BuW1oKuJdXkevaG27j7pg/dkwSBxxjp2nKbUl28ZIjYZGZI0/1N3vnBt3EyT7cxHhM9M
	 yMEl2/mPEPsvOI2udUrDFGO80jsukBvOnYB4vQb78VaNkzRFRw1DkRgyH46uBy+sgYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cpRpFLqB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7180E606A31C;
	Wed, 28 Oct 2026 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cpRpFLqB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AD71F01825;
	Wed, 28 Oct 2026 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209845;
	bh=k9j0BpPNTXJp0hTjeHrw8vpcJFTN1R28G5n5Ud3dzc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpRpFLqBADqwJh9W4BH0Ge7uikHVKfdHlRphM5iPMEOQFcwpOeICVAbI4NcDWsWoj
	 aDCCZIcYJNLgv2eivtswoG1tFAziya7jd+J3Flo9oORxQkCTBdr3rjzgwu2fSMX5pu
	 jpJt+FZROn5I61oM9pnKKTnm0V8iuADe0tHnxI70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 098/109] keys/trusted_keys: return immediately after TPM unseal failure
Date: Wed, 28 Oct 2026 18:01:22 +0100
Message-ID: <20261028165944.661615135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srish Srinivasan <ssrish@linux.ibm.com>

commit f92d0ccb05bf9089072cb067dda0dffd5394c4ef upstream.

trusted_tpm_unseal() proceeds to pcrlock() when the TPM unseal operation
fails. If pcrlock() succeeds, its return value overwrites the unseal error,
causing key instantiation to succeed.

Return immediately when unseal fails to preserve the original error.

Cc: stable@vger.kernel.org # v5.15+
Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260912062950.279104-2-ssrish@linux.ibm.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -921,8 +921,10 @@ static int trusted_tpm_unseal(struct tru
 		ret = tpm2_unseal_trusted(chip, p, options);
 	else
 		ret = key_unseal(p, options);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_info("key_unseal failed (%d)\n", ret);
+		goto out;
+	}
 
 	if (options->pcrlock) {
 		ret = pcrlock(options->pcrlock);


