Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C05F359A9B;
	Sat, 17 Oct 2026 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254898; cv=none; b=qumwFVxPz9Pr6B+qOOphdMYHx0YVWL9NdtKm9DCkPxAA2oXwUSs+4OXSCEF/4t18cHfyLHQPX95GCpJ8ZrAmHFmx/kt+xZtUaBH5iemm6glSZ1/FTnXV/Xj1EvDTcjW/IV6tNC1raXMnwDYgs8oCE1Iu2yc9oNF0TyeOB4aMxuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254898; c=relaxed/simple;
	bh=VyZ+r0KZwPkDpEGu6O4c0Zdue1CxgyX/HywPtDQoweU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMV6w9i4JSMdErWFTIL1OhYcySUTiz4oML3zOQ2E1ycPlMKF8iKgAjvD5Y5eaqWtIt9nO0URQjULZWNoDA+z3Gq2BUXL4rHWc4oRTt2Ejck2TKrta3HxbwNiGkpvzHchebxgy5IWiHYXiJDVHzhGEpamtuPZkvWG/Ys0zHBGC/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgWlcfA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgWlcfA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90A61F000C4;
	Sat, 17 Oct 2026 16:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254897;
	bh=2KqpEoWe3geNWhFb/78tmjRs9uE8koiw+orbC2D5r5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgWlcfA3ZGMK7wu+TGvndwMjoluMRFqeLQ/IjDrRClp/UaSZS6YycuQEuakuF1QCd
	 08nvFjQD85nXx1LyRWJqaRlh+VMH2a1Sj5dFAg4VVkzx+0GJ7w8DPC91J7C2lBzlEz
	 uiuxmaP8bj5Ibzvm0pDl8ZIIviA1WboYc2jE7q9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 561/869] wifi: iwlwifi: dvm: pair transport op-mode enter/leave
Date: Sat, 17 Oct 2026 17:56:42 +0200
Message-ID: <20261017160051.460266737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index a4f6e5a8f3a9d..ee8f588465e61 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1386,14 +1386,14 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 
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
@@ -1516,6 +1516,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
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



