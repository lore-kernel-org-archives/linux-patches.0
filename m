Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDD5146D40;
	Mon,  6 Jan 2025 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177292; cv=none; b=sZKW7lRw7DprFnOOGrnxDuAPGzJha6lp4KZk+zg6he9GOhd17o2/Xn1qElGs0PS7CbPzSaWd1pqXAb6LQfJy0xvKSo+bMDZeQbiD3nNHN4XJZke9NrplSt6ODm22A+JesiqSlbW9Um/eK1AvLXmO5metgh9M9xS9sEW4JFykFrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177292; c=relaxed/simple;
	bh=e57js/CbqmSbMNgXSq1XnQclkXMIwKBjP/RfDyvimd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtuxAp0ahpFEebmnBqme16h5JCLykQKX4svsc1etLr7STyp8Wi3HQES4QFlMMKyyMDPCOxF5LXFbQCz9p1KUy70MPmYt3xKJ/yC0Z1VT3MZWPHo7coyg29I/UqepDLKt8c6+B5BbgsaLQbxbc8NUEIBV0zk0o7MdtlhuZh9tAcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+VwcfeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+VwcfeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AFFC4CED2;
	Mon,  6 Jan 2025 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177291;
	bh=e57js/CbqmSbMNgXSq1XnQclkXMIwKBjP/RfDyvimd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+VwcfeKr9tb6U7gH0PIAG90ZEKYZlZLbJV2sySE7LCp0oltaLwq0KLXQ5Tq+nRWs
	 2Fi+8AxiVwHLnlkNCNzBz4A1E2E/n/0qkvMNyv4/eKJFxNHzzwFD3U2xx/AlrT6fEN
	 qoAyfIH8ZbXgYmaKVfXGD3r6cmWyWhBlHGk5sM1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Eric Biggers <ebiggers@google.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 115/222] mmc: sdhci-msm: fix crypto key eviction
Date: Mon,  6 Jan 2025 16:15:19 +0100
Message-ID: <20250106151154.950809293@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


