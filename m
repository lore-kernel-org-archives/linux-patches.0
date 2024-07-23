Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02C6158848;
	Tue, 23 Jul 2024 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759163; cv=none; b=RMfIyelo1ZNEXW0Ybom2/L1cy8xorsFYEcW+Hd3MBSyreHKTl//fC/NQok/gtrIo9671vQgRdYxFbIuoH/R/uS9dzuXWKsGwITYYI6DxxixfB8oIgINttj09+MHdOFFswTz+O8jq4BA2XGtHhmsPFoEiSQXu5TaP1jD+iRQxVfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759163; c=relaxed/simple;
	bh=GCg8wvu1BNXFOQbm2vdGPdSoHdkQMHvy293q6dOfIZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxW4LBCe7BXRzwc0fbOloe63vdWzV3E3ea4ZXWXAJA728zAyOzkMghJcbv5soQJxwWM+k42oUp9GMQmduP7YeQQNVFaa2kGviUeqiQigC05r9SiJnz+6BYhIaslithU89PL4D371nDUQt9hJOCrOAmvrClTK8GfQaKQ0MbFJMqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ye5KF8na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ye5KF8na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445F4C4AF0A;
	Tue, 23 Jul 2024 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759163;
	bh=GCg8wvu1BNXFOQbm2vdGPdSoHdkQMHvy293q6dOfIZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ye5KF8naUnz6GxMRU8VC+lwBMbT54lomQqUPd1Hkshc6U0MvBk1Hi0zH5H3pRjOR+
	 elrGEkUYHqk2aM6LXb0AMiQrV8m97sKV7OzIZ4tjlR2tJm9d6i5dkX5WxK5+pGD6qQ
	 10cc1VKIAFE/sN/DUX1/1HwdHCs2yFBJ1JnBRMEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yedidya Benshimol <yedidya.ben.shimol@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/105] wifi: iwlwifi: mvm: Handle BIGTK cipher in kek_kck cmd
Date: Tue, 23 Jul 2024 20:23:00 +0200
Message-ID: <20240723180403.898390303@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yedidya Benshimol <yedidya.ben.shimol@intel.com>

[ Upstream commit 08b16d1b5997dc378533318e2a9cd73c7a898284 ]

The BIGTK cipher field was added to the kek_kck_material_cmd
but wasn't assigned. Fix that by differentiating between the
IGTK/BIGTK keys and assign the ciphers fields accordingly.

Signed-off-by: Yedidya Benshimol <yedidya.ben.shimol@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240513132416.7fd0b22b7267.Ie9b581652b74bd7806980364d59e1b2e78e682c0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 9a36ce98b5bfc..425588605a262 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -594,16 +594,25 @@ static void iwl_mvm_wowlan_gtk_type_iter(struct ieee80211_hw *hw,
 					 void *_data)
 {
 	struct wowlan_key_gtk_type_iter *data = _data;
+	__le32 *cipher = NULL;
+
+	if (key->keyidx == 4 || key->keyidx == 5)
+		cipher = &data->kek_kck_cmd->igtk_cipher;
+	if (key->keyidx == 6 || key->keyidx == 7)
+		cipher = &data->kek_kck_cmd->bigtk_cipher;
 
 	switch (key->cipher) {
 	default:
 		return;
 	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
-		data->kek_kck_cmd->igtk_cipher = cpu_to_le32(STA_KEY_FLG_GCMP);
+		if (cipher)
+			*cipher = cpu_to_le32(STA_KEY_FLG_GCMP);
 		return;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-		data->kek_kck_cmd->igtk_cipher = cpu_to_le32(STA_KEY_FLG_CCM);
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+		if (cipher)
+			*cipher = cpu_to_le32(STA_KEY_FLG_CCM);
 		return;
 	case WLAN_CIPHER_SUITE_CCMP:
 		if (!sta)
-- 
2.43.0



