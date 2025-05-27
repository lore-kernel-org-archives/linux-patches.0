Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD5F280008;
	Tue, 27 May 2025 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364923; cv=none; b=klaKFwZSIy2Mq53IYFMDuY7X+cgLPbEjYSqDMAFOGcJHx/Wu9RYpjVUmG7/H0WhlLxjMqi+V146+NnbWOna+bxCIOPAi5zPVA2EsqnaB1sTuyAkM5D31QI8ZIqhppHySIBMS0HM8dbBLKwHSjXkKzUAZQWCDgknd+GfYzn8Ruqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364923; c=relaxed/simple;
	bh=QdV0MkwRkpnaoYeFrp3oo/Ca+6Wbg0jURzQUysy77zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TR2U3G6Bw1gk/EvzThI1eSMAH+lNDDhLqrk5WvvPkl6m83zqJmLN+LrM3tjBMN8TjCL0Hsnfk6O+IJDckXTHy2fBZlWWsEKP32C4hl8slEvigXY3p4KsWO+v6tOHGiEPBnkZY4TM5iYFDlc9LvVdKWIC2nsv6+pPFVNZR7GNiKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnCbEJWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnCbEJWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D933BC4CEE9;
	Tue, 27 May 2025 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364923;
	bh=QdV0MkwRkpnaoYeFrp3oo/Ca+6Wbg0jURzQUysy77zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnCbEJWOwK39qcLajSoi9+2PaixRubKOILKOC8YtHvQhK3u92rWldzjc6GLzLHZef
	 h+vGOGDEwv6zmvWc8Kut0pywAzpUpKj5kcdK2Q7vj0eIXPXyBYYNI4giq/3MAWfyjV
	 kUAh4UJ5GOXi+2cN56XaKq5JkgE5eUekFxxWlsag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schwermer <sven@svenschwermer.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/626] crypto: mxs-dcp - Only set OTP_KEY bit for OTP key
Date: Tue, 27 May 2025 18:21:41 +0200
Message-ID: <20250527162453.470740368@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Sven Schwermer <sven@svenschwermer.de>

[ Upstream commit caa9dbb76ff52ec848a57245062aaeaa07740adc ]

While MXS_DCP_CONTROL0_OTP_KEY is set, the CRYPTO_KEY (DCP_PAES_KEY_OTP)
is used even if the UNIQUE_KEY (DCP_PAES_KEY_UNIQUE) is selected. This
is not clearly documented, but this implementation is consistent with
NXP's downstream kernel fork and optee_os.

Signed-off-by: Sven Schwermer <sven@svenschwermer.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxs-dcp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 77a6301f37f0a..29c0c69d5905d 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -265,12 +265,12 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 		    MXS_DCP_CONTROL0_INTERRUPT |
 		    MXS_DCP_CONTROL0_ENABLE_CIPHER;
 
-	if (key_referenced)
-		/* Set OTP key bit to select the key via KEY_SELECT. */
-		desc->control0 |= MXS_DCP_CONTROL0_OTP_KEY;
-	else
+	if (!key_referenced)
 		/* Payload contains the key. */
 		desc->control0 |= MXS_DCP_CONTROL0_PAYLOAD_KEY;
+	else if (actx->key[0] == DCP_PAES_KEY_OTP)
+		/* Set OTP key bit to select the key via KEY_SELECT. */
+		desc->control0 |= MXS_DCP_CONTROL0_OTP_KEY;
 
 	if (rctx->enc)
 		desc->control0 |= MXS_DCP_CONTROL0_CIPHER_ENCRYPT;
-- 
2.39.5



