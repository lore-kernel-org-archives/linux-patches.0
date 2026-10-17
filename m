Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2D13A1E92;
	Sat, 17 Oct 2026 17:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259572; cv=none; b=j2YFpHhrl/NYnxCPTCamc1PwdSWHQBRePWkmkTEJn1hOM6Y2VEipvM8BQ0brwpj7om5c7F4Utry31IIqzigbZdoNF30+rsUQBk5hzPl5uG2PwQiDbV3tjsNnlaCALJxwcXiX14LdCyCjMTMaIcKS2i2+DzcW1y5Y89U+IuFMBDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259572; c=relaxed/simple;
	bh=6fLo7H8W7Xp5uSYiCiYqBR6ToQeZHCPh2JxDUQ46+Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZoX7cLKffmPaiD0GFVQvNd8P4l3pDLUwu4AhWAOrfIG2P5S8fxjcco8snJ6UyfNi4XrJhUOcdOP+zDRQ48Os4uVMmlw+na5G+aMUSSmPYgzu15T3Tz7n2QmRf8brSdJYauIRbYdsIz1/RapTMmolyAKxlZhgAxXI50kPI4sAUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSmj/uGJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSmj/uGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9660E1F000C5;
	Sat, 17 Oct 2026 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259571;
	bh=boqA0Y2DC1MfRbv8zZHpIrAgWrxE8Z8dOUfYVSymK2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSmj/uGJEmreh4A5kK7iPpKiR8vOI4nRTgyT1lXE8LwVE8H9VQMqXokxIYA25lDtR
	 +67Y8ggM5zZsOT9k8xQhKyQlRwx8vFEID4iDa+rZhQqEgN3He6oL1JzTkgZlJRwB3W
	 NAX0S+iuqu0bP1bG8BuQMbzCZBFr4PA+2AcXupAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1258/1674] wifi: iwlwifi: dvm: pair transport op-mode enter/leave
Date: Sat, 17 Oct 2026 17:58:50 +0200
Message-ID: <20261017160503.432160718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6b340a694cee9e7a24b2be827c738b5b6cb13c84 ]

If there's a failure and the op-mode didn't actually fully
initialize, it should leave the transport again. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250504132447.714c3517548b.I49557e7ba8c03be2b558cc9fb5efa2a9fbab890e@changeid
Stable-dep-of: 67105abd6195 ("wifi: iwlwifi: dvm: fix memory leak in iwl_op_mode_dvm_start()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 447870f610e9c..c9b2306520d12 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1388,14 +1388,14 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 
 	err = iwl_trans_start_hw(priv->trans);
 	if (err)
-		goto out_free_hw;
+		goto out_leave_trans;
 
 	/* Read the EEPROM */
 	err = iwl_read_eeprom(priv->trans, &priv->eeprom_blob,
 			      &priv->eeprom_blob_size);
 	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
-		goto out_free_hw;
+		goto out_leave_trans;
 	}
 
 	/* Reset chip to save power until we load uCode during "up". */
@@ -1518,6 +1518,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	kfree(priv->eeprom_blob);
 out_free_eeprom:
 	kfree(priv->nvm_data);
+out_leave_trans:
+	iwl_trans_op_mode_leave(priv->trans);
 out_free_hw:
 	ieee80211_free_hw(priv->hw);
 out:
-- 
2.53.0



