Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0864E330B12;
	Tue, 11 Nov 2025 01:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824926; cv=none; b=YsWzMN9WC9ZUlDR7J5cAwKrMuLIBXWP+UtB7b4Jb+qwGfC6X+aCbAWEtQ3Wruxo4m8XunxrBGdDYKT0TQyKP8+80+RgaqYVAU3DcR3rvPL7T23TirexbHH4KfyoKeoqeKHy0Pv1XX6Q97NlXnMXi03++Vs+WICcYUOWjpWzXLyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824926; c=relaxed/simple;
	bh=EPcHGQPvVsIaktgHSKvt09p4BeNjNoBIqVx70cn+sPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHLHk5XtwXiyKJK/oIMpCsAl3wsuzg/VsgxxciDhdQZmlwzMmgZ1BhCyVRyhbGWFQPrWaLK8d0YHZLTtnbPzFAf9FFHdL2FFXOoJNKOnEW8axeftt3KDYFJ/vwo1ylHAkCV6ackdIHOvUaUVTzsSiT83Q0qG7XhpgSklki9G9TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlGwS14I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlGwS14I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA67C116B1;
	Tue, 11 Nov 2025 01:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824925;
	bh=EPcHGQPvVsIaktgHSKvt09p4BeNjNoBIqVx70cn+sPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlGwS14IfaF80/HzNHB7mym9xV3MF/zP5hBvD1l1zdKKNtUoPjc/+3xmHn0I2E+l5
	 f4sutACq26VhWXR3Rdmt8vJPC3+GUAMNB+si/j1ORs2wPkIbcbcY93sifYU9icMqCD
	 QMRe7EmVl69ozJ/Ahp0xWwGhfG39/06EI1oQvEvA=
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
Subject: [PATCH 6.17 599/849] wifi: ath10k: Fix connection after GTK rekeying
Date: Tue, 11 Nov 2025 09:42:49 +0900
Message-ID: <20251111004550.903682634@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 24dd794e31ea2..154ac7a709824 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -16,6 +16,7 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <linux/bitfield.h>
+#include <linux/random.h>
 
 #include "hif.h"
 #include "core.h"
@@ -290,8 +291,15 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
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



