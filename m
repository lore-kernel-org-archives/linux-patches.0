Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EE13538B3;
	Fri, 21 Nov 2025 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732828; cv=none; b=WKFeYWoxJtc4BKEzlk6rcYiLykWUjJ5wvKUPrjg9KK8MqW64ledEakBoEhijxd1mJ7R2gButy56D0mIEjDGtzAqSq2j9PqGuFIEh6bW0cxIvXqFY1mvUhXSAP7X1+j2yRTaXYBYOCh+tslrvBZ+yIDG+CQV/giBHW5qWcrjkIFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732828; c=relaxed/simple;
	bh=ZXf5q6CzCsO+WtN8zXtEQALJj9RnTlJkwtuf2IcRw7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4/E7dK4vc/7EPgwN+rHxFmlDMxlG2g+l3aq94mSwZ3MyXAutVsw1nrZoGZUqJAT+mMhN7CUBRolU4fc+TH9+vtkAYlKijsjuUiTlL9ey+GcH+FENVj3CgK40+jhFBbswoc1HvzJ64Fo9wUm41GEad8NqckJ1hjv3cyBdCs5niQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeBcd7/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeBcd7/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8152C16AAE;
	Fri, 21 Nov 2025 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732828;
	bh=ZXf5q6CzCsO+WtN8zXtEQALJj9RnTlJkwtuf2IcRw7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeBcd7/goCK9mr5ly3rlHakznnZ3Frw9MXpn90ADCLnEMEWNY2mT7V0/BpuZgTkjN
	 thbZqMzh+GLy5KH+SHRwGrrU+a9lQVH4f9MTzcWryY4FPK1YwWQDwPaPB2SUn0njTC
	 jlkhJL7fNJDtDWpFcW6lsvslLOs2sOrMHgtwfxS0=
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
Subject: [PATCH 6.6 258/529] wifi: ath10k: Fix connection after GTK rekeying
Date: Fri, 21 Nov 2025 14:09:17 +0100
Message-ID: <20251121130240.200689935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 655fb5cdf01f8..233e5c619fa4e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -14,6 +14,7 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <linux/bitfield.h>
+#include <linux/random.h>
 
 #include "hif.h"
 #include "core.h"
@@ -287,8 +288,15 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
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



