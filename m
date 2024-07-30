Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED3B1A6161;
	Tue, 30 Jul 2024 16:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357037; cv=none; b=cF+4wWE5e43/TJBMnnbFejTf92pDGDDI245gLN9BUoR8hu/Nb+iEjjx8cGY9cBsDMge0k5p/8VtrPogk80M0/UNrpG78HEoG8gHxKOB42RR9OjLgSAZjcjEXueMI+gcjUNEskfm4LZN4EE35z7wwGiUPy/sIO3eoAXUm2mNivow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357037; c=relaxed/simple;
	bh=iahH78ZChp+DxXPd4pz4MGQdgbkG0Bytq2Dhji1CJ7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deAZoXV6zafkCi4wuFI57Z/0HF1A8/1n49IWPhy/VJ+XrZJm8swrK/wEuOoy+5D3eG58QC8knqj18a0ehjxnTBw23rSgIL9xM4BmtEPjTUaovTM/3HpZ/7lni71jQe879M1JeN5ikDVuukyWn5AApaMmfzsNSX7DUjnh0NglH94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+GIuDJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+GIuDJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13BAC32782;
	Tue, 30 Jul 2024 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357037;
	bh=iahH78ZChp+DxXPd4pz4MGQdgbkG0Bytq2Dhji1CJ7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+GIuDJ5LYY9m3RYkfE9xNLMSTQU1JtUV+lj2C8Ju8RwkTi6uShVCX0GMqSqpGyOn
	 H3GIY3C0hG0RbmN0IBRSW+GERIjxpu6N22rJ0Jc2+fPaiwjJTdUaor6SviAJYffbIi
	 hCc1izuYrTefa/jTyHOe8eXvlUgCjn4nxQxUHaCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 212/809] wifi: iwlwifi: mvm: always unblock EMLSR on ROC end
Date: Tue, 30 Jul 2024 17:41:28 +0200
Message-ID: <20240730151732.978082209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f9068fe4fd49f9e4409c30546d7e16238942ce62 ]

Since we always block EMLSR for ROC, we also need to always
unblock it, even if we don't have a P2P device interface.
Fix this.

Fixes: a1efeb823084 ("wifi: iwlwifi: mvm: Block EMLSR when a p2p/softAP vif is active")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240625194805.96bbf98b716d.Id5a36954f8ebaa95142fd3d3a7a52bab5363b0bd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index c0322349bfcd8..9d681377cbab3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -120,7 +120,7 @@ static void iwl_mvm_cleanup_roc(struct iwl_mvm *mvm)
 			iwl_mvm_rm_aux_sta(mvm);
 	}
 
-	if (vif && !IS_ERR_OR_NULL(bss_vif))
+	if (!IS_ERR_OR_NULL(bss_vif))
 		iwl_mvm_unblock_esr(mvm, bss_vif, IWL_MVM_ESR_BLOCKED_ROC);
 	mutex_unlock(&mvm->mutex);
 }
-- 
2.43.0



