Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72DF3446CC;
	Tue, 11 Nov 2025 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824155; cv=none; b=QDSj1TGk5rfFfqHZNbGL1A8stS0vWbu1SrRqgqb1Mou9ZHHskiAbVtc6+XqJEcfhZ8P2/FBJgL5VAHMJonqpow+cezepYnoddxsVCnh9E0oGhp5OVCXxf0vhkeXhMbpT4tLJ83TZGf/63JEQ6/fZu/U7wlpJIGVA0wScp/sU7ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824155; c=relaxed/simple;
	bh=AAeT8gGCo7tSSqXRL7LnAt6n+xAOya5vxubWMz6TYLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1vrS5Xa/EWeM1lIRz4ja9oIugmnICuIs98kWWBBDry0HTRNzCc8pkoRx9TkYi4fa8NUQja21tqtBvJgz1pAVxU1DZZ0S9T0eVkeLIiLn6W8d8AuYF97hG7PdTnsFTlfsq4hekLKE/rUW/fpWeEGNIfNwwnNm3U74HGaOSkZ6Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1l6c+geq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1l6c+geq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9B8C19422;
	Tue, 11 Nov 2025 01:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824155;
	bh=AAeT8gGCo7tSSqXRL7LnAt6n+xAOya5vxubWMz6TYLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1l6c+geq2CO4defCgCgT2L9zfOaoojxY1WvXWz50IPSc1xYHAexBbxQa9iB/CqRtz
	 73R9vs8cyAM6qj6IkDs/VCMA44JFbryIgtXHK0zAIP6AQYAi3XD5RaX9CsCQIRjW3B
	 37Wieb3ufyxf8Ije3kDi4Mt8Uv1W096uqo+tYyeQ=
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
Subject: [PATCH 6.12 398/565] wifi: ath10k: Fix connection after GTK rekeying
Date: Tue, 11 Nov 2025 09:44:14 +0900
Message-ID: <20251111004535.825901154@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6493731333abb..74ee3c4f7a6a2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -14,6 +14,7 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <linux/bitfield.h>
+#include <linux/random.h>
 
 #include "hif.h"
 #include "core.h"
@@ -288,8 +289,15 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
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



