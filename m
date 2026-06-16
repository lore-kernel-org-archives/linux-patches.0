Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036EC42EEBB;
	Tue, 16 Jun 2026 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622724; cv=none; b=TVOlNPAWzQ0eunN0C3boARmJSB53xgCAvyujztZQgt5SCw0lJc3PH4IkbIkkd+NdQjQg8+fnDTW1QE8/92AeHAOwyOezEgrll3aRnCWKbKS2cyNs6BBxnAkTHSu5k2w7nonkmUqGDJ021WVQuGGhkzw4t9yB6Ti9Z3DPJZU+0hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622724; c=relaxed/simple;
	bh=d5zTGuBMHaYrxOSPQxQwg3bBbmoVBj2jzD7KwrbYvcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtvMbkSh2IH88f5SjiqNHs2nmyRCyBP7S7jbXp3VrGU3EWJ1Ls1il+1bKlpdrZ2zZkuP697mfHk0+/4giZn/Q4V01CM7rS/dutZUua0tYPRVdcLNzAXWGxPPkwTqsaXvgNdVxvWE/jLvbN6t0K16rmVW7LEzAd+7Va+bGljK/QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMR0SiHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMR0SiHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4891F000E9;
	Tue, 16 Jun 2026 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622722;
	bh=I/gTRkHd4YSLLhJk+oARa4GuEhqIVusbrLAdm980a8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMR0SiHcBMcDdn+HytroiDWdAFrx4cT/pf37OkkQEDzFkEDNmfKVG1vz5EIAJUfnZ
	 b+wYD7sFvDFIfQezxdge83Ii1gcy7ffW0HXq4ncNerk2rhaHtPDcoYbgwcSM56WK68
	 eZ90RCWfbBrbiiQK175Y4roqPoGeAEgLohQIIHfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 017/378] wifi: iwlwifi: mvm: dont support the reset handshake for old firmwares
Date: Tue, 16 Jun 2026 20:24:08 +0530
Message-ID: <20260616145110.722933068@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 0eaa1f245ac03ed0c6394159360532726f666811 ]

-77.ucode doesn't contain the fixes for this flow it seems.
Don't use the firmware reset handshake even if the firmware claims
support for it.

Fixes: 906d4eb84408 ("iwlwifi: support firmware reset handshake")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220600
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260529085453.9307b81d9b02.I21bba9e649f4cd0e35d3ea6cd97a03258be5832f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ae177477b20127..384bed95835d74 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1416,6 +1416,12 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 		fw_has_capa(&mvm->fw->ucode_capa,
 			    IWL_UCODE_TLV_CAPA_FW_RESET_HANDSHAKE);
 
+	/* Those firmware versions claim to support the fw_reset_handshake
+	 * but they are buggy.
+	 */
+	if (IWL_UCODE_MAJOR(mvm->fw->ucode_ver) <= 77)
+		trans->conf.fw_reset_handshake = false;
+
 	trans->conf.queue_alloc_cmd_ver =
 		iwl_fw_lookup_cmd_ver(mvm->fw,
 				      WIDE_ID(DATA_PATH_GROUP,
-- 
2.53.0



