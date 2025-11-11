Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A4D24BBEB;
	Tue, 11 Nov 2025 00:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822311; cv=none; b=aGMfnU8pDGFnBs/5Xak/9+RDLj+dMCWTuCEMaw9B2IjQ65gDxvJjSUQYDtWgffbPHpD7BsktHFXK29VfNtVmdrUKdctG6MA3MKApwV3/k7onwCXiLiZ7ThUmgZ4zBJBJPMxQQ/t8BjwB6LzvdI9Ft7QOvlBuy5IrFh9JkWtjxDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822311; c=relaxed/simple;
	bh=fV5qYgE0E6osD/vOd//SOWUE/CjUc0FGrcS0GEwVARI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niIRM4qTNu4+GPEFLrtBEq+5qHf9Lh6Aonnn+CrRt19J6RNcUfCeYIumGHrqMNP1UUvpI/15C7iHgt74O/GkhY/hpt6QcrnP1CcDK+WD15CeLBdZedGRwu0ygUbbj31djR0jC7tnecuUNldi1fxIAwJ1c3jyzHa+nKDdiXUcn/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FK7wSi3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FK7wSi3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F3CC116B1;
	Tue, 11 Nov 2025 00:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822311;
	bh=fV5qYgE0E6osD/vOd//SOWUE/CjUc0FGrcS0GEwVARI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FK7wSi3ifZmkWsHUUHTGjioyf2O46CfWzPpW01Ahl72bizn7gfJTPdQWIxiBJ71vH
	 p2ypdDnbNGCGXLXVTarVmharOHvQtxVgXSY8phya+v1Cl6bga2ie6aYayXL/I3fbFJ
	 ecL9iOAToTT3lxqi+IFaObXjuTI4Qv00xdGrZKjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 037/849] wifi: iwlwifi: fix potential use after free in iwl_mld_remove_link()
Date: Tue, 11 Nov 2025 09:33:27 +0900
Message-ID: <20251111004537.339126584@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 77e67d5daaf155f7d0f99f4e797c4842169ec19e ]

This code frees "link" by calling kfree_rcu(link, rcu_head) and then it
dereferences "link" to get the "link->fw_id".  Save the "link->fw_id"
first to avoid a potential use after free.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aNKCcKlbSkkS4_gO@stanley.mountain
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/link.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index 782fc41aa1c31..960dcd208f005 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -501,6 +501,7 @@ void iwl_mld_remove_link(struct iwl_mld *mld,
 	struct iwl_mld_vif *mld_vif = iwl_mld_vif_from_mac80211(bss_conf->vif);
 	struct iwl_mld_link *link = iwl_mld_link_from_mac80211(bss_conf);
 	bool is_deflink = link == &mld_vif->deflink;
+	u8 fw_id = link->fw_id;
 
 	if (WARN_ON(!link || link->active))
 		return;
@@ -513,10 +514,10 @@ void iwl_mld_remove_link(struct iwl_mld *mld,
 
 	RCU_INIT_POINTER(mld_vif->link[bss_conf->link_id], NULL);
 
-	if (WARN_ON(link->fw_id >= mld->fw->ucode_capa.num_links))
+	if (WARN_ON(fw_id >= mld->fw->ucode_capa.num_links))
 		return;
 
-	RCU_INIT_POINTER(mld->fw_id_to_bss_conf[link->fw_id], NULL);
+	RCU_INIT_POINTER(mld->fw_id_to_bss_conf[fw_id], NULL);
 }
 
 void iwl_mld_handle_missed_beacon_notif(struct iwl_mld *mld,
-- 
2.51.0



