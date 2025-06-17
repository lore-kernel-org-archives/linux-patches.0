Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F352E9738;
	Tue, 17 Jun 2025 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176502; cv=none; b=Sy2yGgwct+QCh8hiNYWjVYtoFNvpFqTW4wL9X5sWncsjwPaaAYRiunVYeCI+9WfbtLqzRM45njN9H9WPxaFYjVpS6EDltuT7IF8V4tqSdZDe6HnLq1kc8dPd2TXma2GurjbwbirZLAdWB/j3fhWPQ19XNsvK1Dh59e5aX9Al314=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176502; c=relaxed/simple;
	bh=ss/cr8GhKgjUesKJ5GdLWmj/xoBq+Dqvc7kbLXr/giM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWGirVDJ05weFEudr/h7mMu/4slWtY0G8rpy5BAdHS/i0xIIHPAT0bB1amabdMXa8TefqF8VWUPexyeL1e/Sw6EsOzaJAfXptBeLxa9tEusWblgWtjkCOKJtv5QqxKjJPKzbD9WJp03WTTJbrUh017Q5D+rqNzBIJCfKyh/2lLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRJO1Dvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRJO1Dvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A43C4CEE3;
	Tue, 17 Jun 2025 16:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176502;
	bh=ss/cr8GhKgjUesKJ5GdLWmj/xoBq+Dqvc7kbLXr/giM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRJO1DvffTSCp6EgBX83bomYp8KYHZoOR2FW7bpX54Jpzn3PelL1wGukibZh4BRTR
	 XuzI8aKBQhq50avjd7z1Ceg4KEwStJ//faOymugxw8tTntqTnXRwdLtZYK+MiAyHvI
	 LpTDi/8symIRw8ELbsary/vcxjt6fn6LRXsRV1/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 177/780] wifi: ath12k: Resolve multicast packet drop by populating key_cipher in ath12k_install_key()
Date: Tue, 17 Jun 2025 17:18:05 +0200
Message-ID: <20250617152458.683893436@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit d61c0b3c63462d17e63e5a2b4815e0f1ad17f57e ]

Currently, the key_cipher in the ath12k_vif structure, which represents the
group cipher of the MLD AP, is populated when the link address matches the
ieee80211_vif address within ath12k_install_key().

However, in MLD AP, the link address and ieee80211_vif address can differ.
Due to this key_cipher is not populated and multicast packets don't get the
correct cipher information and resulting multicast packets drop.

To fix this, compare the link address with the arvif->bssid instead of the
ieee80211_vif address.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00209-QCAHKSWPL_SILICONZ-1

Fixes: 3dd2c68f206ef ("wifi: ath12k: prepare vif data structure for MLO handling")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250403082207.3323938-2-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index a1fad297ca357..3883dab6771b8 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4605,7 +4605,6 @@ static int ath12k_install_key(struct ath12k_link_vif *arvif,
 		.macaddr = macaddr,
 	};
 	struct ath12k_vif *ahvif = arvif->ahvif;
-	struct ieee80211_vif *vif = ath12k_ahvif_to_vif(ahvif);
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
@@ -4658,7 +4657,7 @@ static int ath12k_install_key(struct ath12k_link_vif *arvif,
 	if (!wait_for_completion_timeout(&ar->install_key_done, 1 * HZ))
 		return -ETIMEDOUT;
 
-	if (ether_addr_equal(macaddr, vif->addr))
+	if (ether_addr_equal(macaddr, arvif->bssid))
 		ahvif->key_cipher = key->cipher;
 
 	return ar->install_key_status ? -EINVAL : 0;
-- 
2.39.5



