Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3472222B7;
	Mon, 23 Jun 2025 21:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715428; cv=none; b=dkUYGis80fTQ2LbnMPVBuB4Se50wwamcbj2big0JNQv64vqZhT+lObrQsBT6JsRsYj9A73+qYJKldcyvAi943x8UFWOIC26oy+yaJ3U4AqmDQ2CgjJ10yoc4GII1ImMeTX1gp4WDmHEaHEnthfn/suvss9UcrqD5XrO/ABFEvac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715428; c=relaxed/simple;
	bh=ZLg94wKt0DUOoMhXqtrrw1SrxzDnvCTvIwFCKL/TkIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyzA8zZqm+XHuCCZ8N2mphcD2O7OKND+4K7ZFJts/f3wTcfpxF87qRN99pubaT81g053GT970anf7XOVxLMIPkId50utNzQLBbWbJXXBY7anklqtDeYnrBOaMMuDIBJmQj2txDjMeV6aMF/duaB+xOdm/trV3GnTNRwrSlYRKrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBRwjtwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBRwjtwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27629C4CEEA;
	Mon, 23 Jun 2025 21:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715428;
	bh=ZLg94wKt0DUOoMhXqtrrw1SrxzDnvCTvIwFCKL/TkIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBRwjtwVnPPfijY8dtaI1boKDzAlUyzlAFFoD9a6yqAsmCYcWWlUPokXfDxI9WjAO
	 vCnGXKX2WphoFen9yQTVjVC4MJf4rJ4Otg679+JWzOHLJGO+N+hnAOKrnL84djphro
	 9F+d8V7fc7y829pOmTis/uWw1Foc6Gs95hl0uLW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/508] wifi: ath11k: validate ath11k_crypto_mode on top of ath11k_core_qmi_firmware_ready
Date: Mon, 23 Jun 2025 15:04:39 +0200
Message-ID: <20250623130651.015407759@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>

[ Upstream commit b0d226a60856a1b765bb9a3848c7b2322fd08c47 ]

if ath11k_crypto_mode is invalid (not ATH11K_CRYPT_MODE_SW/ATH11K_CRYPT_MODE_HW),
ath11k_core_qmi_firmware_ready() will not undo some actions that was previously
started/configured. Do the validation as soon as possible in order to avoid
undoing actions in that case and also to fix the following smatch warning:

drivers/net/wireless/ath/ath11k/core.c:2166 ath11k_core_qmi_firmware_ready()
warn: missing unwind goto?

Signed-off-by: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202304151955.oqAetVFd-lkp@intel.com/
Fixes: aa2092a9bab3 ("ath11k: add raw mode and software crypto support")
Reviewed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250522200519.16858-1-rodrigo.gobbi.7@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 28 +++++++++++++-------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index a8bdddccca4cb..0910d06ed296f 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1517,6 +1517,20 @@ int ath11k_core_qmi_firmware_ready(struct ath11k_base *ab)
 {
 	int ret;
 
+	switch (ath11k_crypto_mode) {
+	case ATH11K_CRYPT_MODE_SW:
+		set_bit(ATH11K_FLAG_HW_CRYPTO_DISABLED, &ab->dev_flags);
+		set_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
+		break;
+	case ATH11K_CRYPT_MODE_HW:
+		clear_bit(ATH11K_FLAG_HW_CRYPTO_DISABLED, &ab->dev_flags);
+		clear_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
+		break;
+	default:
+		ath11k_info(ab, "invalid crypto_mode: %d\n", ath11k_crypto_mode);
+		return -EINVAL;
+	}
+
 	ret = ath11k_core_start_firmware(ab, ATH11K_FIRMWARE_MODE_NORMAL);
 	if (ret) {
 		ath11k_err(ab, "failed to start firmware: %d\n", ret);
@@ -1535,20 +1549,6 @@ int ath11k_core_qmi_firmware_ready(struct ath11k_base *ab)
 		goto err_firmware_stop;
 	}
 
-	switch (ath11k_crypto_mode) {
-	case ATH11K_CRYPT_MODE_SW:
-		set_bit(ATH11K_FLAG_HW_CRYPTO_DISABLED, &ab->dev_flags);
-		set_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
-		break;
-	case ATH11K_CRYPT_MODE_HW:
-		clear_bit(ATH11K_FLAG_HW_CRYPTO_DISABLED, &ab->dev_flags);
-		clear_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
-		break;
-	default:
-		ath11k_info(ab, "invalid crypto_mode: %d\n", ath11k_crypto_mode);
-		return -EINVAL;
-	}
-
 	if (ath11k_frame_mode == ATH11K_HW_TXRX_RAW)
 		set_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
 
-- 
2.39.5



