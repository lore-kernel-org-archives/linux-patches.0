Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F205B350A21;
	Tue, 16 Dec 2025 12:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887225; cv=none; b=DJLmzhQpzE18ZtLPvAlAm6NhG9iuqjvnXT9sA96zZwEXVsxdFZ9qFis9kRgjY2IZOCCPZkdsHZKFRMydBWTOxddilboDBksyq7oM3WPRNbhleVfgRiyzIkDaIEtN7hkweQH4JkZPQyD8yF7c74JPD7ytjl5K804ctSSyDd7NJ7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887225; c=relaxed/simple;
	bh=KR7qA7VSeZttsCy/fXJumAi9dx9t6vLcDJk7OIsCDmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5TjJbTIECQUp41Aot1lMwtPRRjSAe6vAp7yc1Ley5HzPhnhbK2maKC2R6jmMYlUyLfYdFmu1H14y+ehxrcMSe697nTnNf20rERLmx6ZwovvBwi5N9YulfOwBVy/dXDVYpaZRTCKFegq/4r9uq6rgnVI82T9cnaO2U2GqQYrQmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYRdCWwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYRdCWwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FB3C16AAE;
	Tue, 16 Dec 2025 12:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887224;
	bh=KR7qA7VSeZttsCy/fXJumAi9dx9t6vLcDJk7OIsCDmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYRdCWwgpptHQ5vqcfe65C/3jPUCRb3+d/4r805jd6LdyrZo7R4qyfYDl//gt1IFw
	 Ege2YTc16NneVMGnMNaHgge6bRWOQVxPBcSYbGT3rLK/3CHCYP78TwMi4Co3x901Ft
	 0NlSTmd647geegQmozcHUW/YqhyHJSigwpebaavs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 164/614] wifi: ath12k: unassign arvif on scan vdev create failure
Date: Tue, 16 Dec 2025 12:08:51 +0100
Message-ID: <20251216111407.277906429@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8f139505019c4..095b49a39683c 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -5059,7 +5059,8 @@ static int ath12k_mac_initiate_hw_scan(struct ieee80211_hw *hw,
 		ret = ath12k_mac_vdev_create(ar, arvif);
 		if (ret) {
 			ath12k_warn(ar->ab, "unable to create scan vdev %d\n", ret);
-			return -EINVAL;
+			ath12k_mac_unassign_link_vif(arvif);
+			return ret;
 		}
 	}
 
@@ -12895,6 +12896,7 @@ static int ath12k_mac_op_remain_on_channel(struct ieee80211_hw *hw,
 		if (ret) {
 			ath12k_warn(ar->ab, "unable to create scan vdev for roc: %d\n",
 				    ret);
+			ath12k_mac_unassign_link_vif(arvif);
 			return ret;
 		}
 	}
-- 
2.51.0



