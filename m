Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F0F34F494;
	Wed,  3 Dec 2025 16:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777910; cv=none; b=EpJ1yahzRwziesQPz5qGT9hZV0zeTZ5TLOZZehFOelbmb0kjIkXfWcaeptxMvKTyBnBZaiWbGifFAsgXTrECFK6dEHy6EqUEQJqH4B9twgQ7uRe8AZOPWpt7MeqkNUzqHpU7lmBP7CHIRT2p+py5boABj5ka1idQI0k15iPlMT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777910; c=relaxed/simple;
	bh=RD1L+1qjiHajI4J2ehKhB8uJmiwTpEcX9Gzdkqayu+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpoSm3Mr7XxEI7mYox6JTTUjwlrY5toTct0IOsvUbC5+b4GnTd33entF3Yt5IEI5Wf4otcMTjCbYg3EMZOGzB21sl92YYfdDTBsIA4svwhT/sn0P6ATFaz7Y3aNN35SGlngVpFEf65gGNw8XD0QC2twAlyCtiB6gB/aGFfAV4CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEvZwKMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEvZwKMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B177C4CEF5;
	Wed,  3 Dec 2025 16:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777910;
	bh=RD1L+1qjiHajI4J2ehKhB8uJmiwTpEcX9Gzdkqayu+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEvZwKMnQulj20zyU0+lCG8KZbzUkGrhqK0F1TgLWK6UGl/nydr/txXLZfYRDXNwN
	 gHy7s2HdcT8rAI3PFDYcyC7DgM5D8xRe6VLnBkhCuzpOWmYngA77npsgynqRiHD2j1
	 lZhkInPaaMTMrOOwUc3SNiBXV6Wx5QCiRgdcSW/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/392] wifi: ath10k: Fix connection after GTK rekeying
Date: Wed,  3 Dec 2025 16:25:18 +0100
Message-ID: <20251203152420.260160044@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 487e8a8c3421df0af3707e54c7e069f1d89cbda7 ]

It appears that not all hardware/firmware implementations support
group key deletion correctly, which can lead to connection hangs
and deauthentication following GTK rekeying (delete and install).

To avoid this issue, instead of attempting to delete the key using
the special WMI_CIPHER_NONE value, we now replace the key with an
invalid (random) value.

This behavior has been observed with WCN39xx chipsets.

Tested-on: WCN3990 hw1.0 WLAN.HL.3.3.7.c2-00931-QCAHLSWMTPLZ-1
Reported-by: Alexey Klimov <alexey.klimov@linaro.org>
Closes: https://lore.kernel.org/all/DAWJQ2NIKY28.1XOG35E4A682G@linaro.org
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Tested-by: Alexey Klimov <alexey.klimov@linaro.org> # QRB2210 RB1
Link: https://patch.msgid.link/20250902143225.837487-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2b4c694b0fbbe..d90909ffa6780 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -13,6 +13,7 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <linux/bitfield.h>
+#include <linux/random.h>
 
 #include "hif.h"
 #include "core.h"
@@ -286,8 +287,15 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 
 	if (cmd == DISABLE_KEY) {
-		arg.key_cipher = ar->wmi_key_cipher[WMI_CIPHER_NONE];
-		arg.key_data = NULL;
+		if (flags & WMI_KEY_GROUP) {
+			/* Not all hardware handles group-key deletion operation
+			 * correctly. Replace the key with a junk value to invalidate it.
+			 */
+			get_random_bytes(key->key, key->keylen);
+		} else {
+			arg.key_cipher = ar->wmi_key_cipher[WMI_CIPHER_NONE];
+			arg.key_data = NULL;
+		}
 	}
 
 	return ath10k_wmi_vdev_install_key(arvif->ar, &arg);
-- 
2.51.0



