Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A648C2E0;
	Mon, 23 Jun 2025 21:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714360; cv=none; b=SD4iAffJlPHBFRHd+ZUNcdxtPOOTDIJUPnen+lrL3s43UzLmeyTJIkxTzvohoNApILlZmvLwlwCPrIXDDCtatyzREw+hvlQrPSGk/ee8njHRYSb3YCmY1TqDJ6ifOnHEbI/fxV4M1MJDLB1NKppciwLGHq3rTfAzpk6oe/gxIAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714360; c=relaxed/simple;
	bh=6KQKOnYG1jYYdulgaiccl6QVzM1u0oOjIowYRx40/38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aptOu9FMq8eSFJJ2QVksmrBuxdTDuPT17AmcMiOR5wxOsRTY8QOGSg4fOXTJ1ek5V+D52mpr5Xra5dSuLUmvMhPXt+A8xjAxEcN9k68fuAdFCYbdQZAERhoXw+jk/OYUV35tWjL3FBrWTNb7NSWZG/agsyLE5vw8f/nS04CNYac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjSQKTfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjSQKTfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CA6C4CEEA;
	Mon, 23 Jun 2025 21:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714360;
	bh=6KQKOnYG1jYYdulgaiccl6QVzM1u0oOjIowYRx40/38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjSQKTfXkfKS9gIKITvMH5AN+V/CMhdGCEJUyrLnq+Lr8FXYiD4VfKAeXiZGOvZ4y
	 F0u0WqenqEF/X6GRq+RU7wT0fbDcfsvkV7foGGTbOSikeEEuYC7DtZN8lFX+6VERzI
	 5NdOY5j6GMm+5P7lJQsmTXzdZ2xN5LfKFwRg1d60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 374/592] wifi: iwlwifi: dvm: pair transport op-mode enter/leave
Date: Mon, 23 Jun 2025 15:05:32 +0200
Message-ID: <20250623130709.336838754@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6b340a694cee9e7a24b2be827c738b5b6cb13c84 ]

If there's a failure and the op-mode didn't actually fully
initialize, it should leave the transport again. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250504132447.714c3517548b.I49557e7ba8c03be2b558cc9fb5efa2a9fbab890e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index a27a72cc017a3..a7f9e244c0975 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1382,14 +1382,14 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 
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
@@ -1508,6 +1508,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	kfree(priv->eeprom_blob);
 out_free_eeprom:
 	kfree(priv->nvm_data);
+out_leave_trans:
+	iwl_trans_op_mode_leave(priv->trans);
 out_free_hw:
 	ieee80211_free_hw(priv->hw);
 out:
-- 
2.39.5



