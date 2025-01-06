Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B2670812;
	Mon,  6 Jan 2025 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177668; cv=none; b=RpdCR1spz3sUVC2fWW5ApEDBZi4RToR5bTQsEckQloD2vNctN1K6N52xKsfxMqjCtGeCDKijexxLTddB2i+sp/7FgPzuiYBxnfEAJtJZltjX9tiENoXlQSWSs4PYtj1tVbyaYoOWibh9Gp+QNZnCZAs4oGJ679VUNrcEQNGBTHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177668; c=relaxed/simple;
	bh=2KiYHgqErBKlW6K9KPmtPcUvTe1brHPi+kibMUmZBt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZSwuDC/Nz2jS7ifMOmIqwfx7d2TQFT2bUg3dyaO7nyQ6QFqEvJ6qCeM2nXFBB0k5UW2qMD+1VPptN7SO+JIbzzkcLZ0Wsb/eqQgQKV7RYcJDb3E9f/tFVHXsbpPzW2JrgaMg3IOVggoM6U89mly8IQ0dzi2H8RqyxZ4Gu6c37I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YT0MD+Qp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YT0MD+Qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F05EC4CED2;
	Mon,  6 Jan 2025 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177667;
	bh=2KiYHgqErBKlW6K9KPmtPcUvTe1brHPi+kibMUmZBt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YT0MD+QpH3UphbT8Jcg0xSiCLiudy0N0FuyTv/1tvJLfhUVrSHS40ekX0iA3tVX6b
	 sNIlPqBxZmaAmlfdkA01+Nbmi3qWuDpln8lCSlqia1OlDfas7//CVFzD4pixXpcVaL
	 Ui56ka26QdxoGHoCIeYJXt2PQLifYgkMAua0vMb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Eric Biggers <ebiggers@google.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 006/156] mmc: sdhci-msm: fix crypto key eviction
Date: Mon,  6 Jan 2025 16:14:52 +0100
Message-ID: <20250106151141.982555561@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 8d90a86ed053226a297ce062f4d9f4f521e05c4c upstream.

Commit c7eed31e235c ("mmc: sdhci-msm: Switch to the new ICE API")
introduced an incorrect check of the algorithm ID into the key eviction
path, and thus qcom_ice_evict_key() is no longer ever called.  Fix it.

Fixes: c7eed31e235c ("mmc: sdhci-msm: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Cc: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Message-ID: <20241213041958.202565-6-ebiggers@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-msm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1867,20 +1867,20 @@ static int sdhci_msm_program_key(struct
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
 	union cqhci_crypto_cap_entry cap;
 
+	if (!(cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE))
+		return qcom_ice_evict_key(msm_host->ice, slot);
+
 	/* Only AES-256-XTS has been tested so far. */
 	cap = cq_host->crypto_cap_array[cfg->crypto_cap_idx];
 	if (cap.algorithm_id != CQHCI_CRYPTO_ALG_AES_XTS ||
 		cap.key_size != CQHCI_CRYPTO_KEY_SIZE_256)
 		return -EINVAL;
 
-	if (cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE)
-		return qcom_ice_program_key(msm_host->ice,
-					    QCOM_ICE_CRYPTO_ALG_AES_XTS,
-					    QCOM_ICE_CRYPTO_KEY_SIZE_256,
-					    cfg->crypto_key,
-					    cfg->data_unit_size, slot);
-	else
-		return qcom_ice_evict_key(msm_host->ice, slot);
+	return qcom_ice_program_key(msm_host->ice,
+				    QCOM_ICE_CRYPTO_ALG_AES_XTS,
+				    QCOM_ICE_CRYPTO_KEY_SIZE_256,
+				    cfg->crypto_key,
+				    cfg->data_unit_size, slot);
 }
 
 #else /* CONFIG_MMC_CRYPTO */


