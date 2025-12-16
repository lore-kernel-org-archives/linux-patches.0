Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A2F346E51;
	Tue, 16 Dec 2025 11:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885556; cv=none; b=HZJ1wdwrgnlZErNBC5zpdGUZ2LvWbMYKtder/uwdPOwqxbKRgLz0zFwfa+mF7AW7GNEjSeEbVXpBgphHM53Jc+O9cJ009Tif6msnv/3l9dgN5tCOhYCqVDB0EGwiviHlxAz26gQ4z9yooy5Pcp16w8EDsjpO2JcJ4Y4LuyayDpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885556; c=relaxed/simple;
	bh=YViHeWDhDarUnXkPHG+eijCK9yFFeQJV/SFT+Sf84dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVr2wUOLcOr1VaDPsD1m6vsBbW0ySERPUQ6eZKC0ohq0RG9qWDGKIIToGQgw2ceFDf+gCSEva5UYkqNMpYWmexF4SPZd31XbSySkFTUxCTmLMlDsoxh3hB5TiMRSnpBUvfPZ39y4PJPfR75pivUUZSJoUwkChmG70sRujp5X6zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U64MlD4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U64MlD4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B967C4CEF1;
	Tue, 16 Dec 2025 11:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885556;
	bh=YViHeWDhDarUnXkPHG+eijCK9yFFeQJV/SFT+Sf84dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U64MlD4H3SHM811Qldb5qVYVv8HdR3ADwooENCKHKmTrl6E28syDSF0C8UMVhheLV
	 txkRfGlkHGA+zbIztyIYRkfNWfe3UamqLVGFDfWUpGh0tfAjl02X6qgNrK8sjtj+Nf
	 AVxqjg6yeRtb5/ikJFe3+lvtod9IvknSRwwgyfaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 140/507] wifi: ath12k: unassign arvif on scan vdev create failure
Date: Tue, 16 Dec 2025 12:09:41 +0100
Message-ID: <20251216111350.600204053@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

[ Upstream commit e70515039d44be61b6a73aafb401d141b0034d12 ]

During scan and remain-on-channel requests, a scan link vif (arvif) is
assigned and a temporary vdev is created. If vdev creation fails, the
assigned arvif is left attached until the virtual interface is removed,
leaving a stale link in ahvif.

Fix this by freeing the stale arvif and resetting the corresponding link in
ahvif by calling ath12k_mac_unassign_link_vif() when vdev creation fails.

While at it, propagate the actual error code from ath12k_mac_vdev_create()
instead of returning -EINVAL in ath12k_mac_initiate_hw_scan().

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: 477cabfdb776 ("wifi: ath12k: modify link arvif creation and removal for MLO")
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251026182254.1399650-3-rameshkumar.sundaram@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 98b684b27566a..6bdcf5ecb39e5 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -5073,7 +5073,8 @@ static int ath12k_mac_initiate_hw_scan(struct ieee80211_hw *hw,
 		ret = ath12k_mac_vdev_create(ar, arvif);
 		if (ret) {
 			ath12k_warn(ar->ab, "unable to create scan vdev %d\n", ret);
-			return -EINVAL;
+			ath12k_mac_unassign_link_vif(arvif);
+			return ret;
 		}
 	}
 
@@ -12846,6 +12847,7 @@ static int ath12k_mac_op_remain_on_channel(struct ieee80211_hw *hw,
 		if (ret) {
 			ath12k_warn(ar->ab, "unable to create scan vdev for roc: %d\n",
 				    ret);
+			ath12k_mac_unassign_link_vif(arvif);
 			return ret;
 		}
 	}
-- 
2.51.0



