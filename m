Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217168;
	b=Vfbr5fwyd0ISUYbzAHPCEFYaTQBnHvWsraJrDWxnLn6waMGapGe4d/UQwxNLtzzFRPXv
	 7PxyBuh87QH/RjEJDLd93irkxJVqVqJzY1zU72fsDLjDOt93M/eQG5mesG/WlNjfxchLf
	 kyLMdnJ+AU/lAkt0QyAO31EVP/9Y6W+Ke3Od17vqGbwqp8jv0mrGVsOrvD3LWxJXXPxwC
	 JgV9nYyBC1yltEg6abBhHk7puxaDQG99e+8A7mRq0usX/RkjPp/+B2pgLOf+V5153fQGR
	 VbDW/jKsMONI9Piz2Q5NOG1kO6Ii6nwA6WxfdK0r9H83B+mwcqmslaAjU/6vAm2+eKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ha25kevwrvXVTU35zrb6BtHmPUVei2oc63IEOnz+LWQ=;
	b=2tlv6jcTDa7bJT0mXmQaIPGejgMbV8ve68pPGK5+a39HBxhg0TtnqgiwCg0N3vdn40OB
	 QyVz8RnSaliNCQok3q/3ZKoibbXRpKT5ezTrcJtkkHyWg1M2OUHhEdxQwGpbwdrRAm698
	 aOevwIGErtR5ya64//IKIQ9FG6LeTWwwCjCbtDMXb6AvpEkpzDT5ZwIpHtcLw7uapRxst
	 08YXOvuuXS8orv+o4VNX6REaCjjdDqAUjWo0oBXwX2/QqW3BGLQrbdx+AT0zq53Y2sgRV
	 oNr3HY+4PdheSfBX2E35fl1kmOq/6Xdv6DN8cLqlZ92U+vR6kVNgWhYgkQFhO3RL5xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xIGk/er0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80886606A31A;
	Wed, 28 Oct 2026 19:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIGk/er0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7F01F01825;
	Wed, 28 Oct 2026 19:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217168;
	bh=Ha25kevwrvXVTU35zrb6BtHmPUVei2oc63IEOnz+LWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIGk/er06LTiYCiu9IWL+ls+z87rg8kMYWESdPIPfRJBGJWgluSZMcv/StK0uKHZT
	 XORwYkfmAHxXlzotPznBnnVD+GIchB5XNb0Q80DeJkfLZoYvlXlgdPAgXBZGEw01kk
	 oO0GDslRpsshIUSHwKm18LyyEBnnD0BBvnI0kyDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 1812/1887] keys/trusted_keys: return immediately after TPM unseal failure
Date: Wed, 28 Oct 2026 18:05:08 +0100
Message-ID: <20261028170540.680795667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -959,8 +959,10 @@ static int trusted_tpm_unseal(struct tru
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


