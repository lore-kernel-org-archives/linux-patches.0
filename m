Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5389986347;
	Tue, 27 May 2025 17:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367849; cv=none; b=TlX2gpgFHca7nfQsB1dEQCa/FJnm8AOyYyIUiKdDarbL1l9awlRvXOh9Edmvs+lksDMdOBsibbqU4h+F0Dj/Y15Mon7b29M+IPk3WOGloANBxFQwH3RP5PnsyQWXX6T5OfI3vlygd3qoGZTaKXcprxXyvrfm9Ss1sKHpiL6/dbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367849; c=relaxed/simple;
	bh=n4pAU8lZ+Jnk21HcxsEqNDD/gahz3SnAWnHkwnD/0rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwKxLDOpPj8PxNFv0NuxBz+tNOAojaPcNChwkAqhuyYv0krWkapk05iv7aEanI5+4xCSTsd04A4T4JOdlgLbJ+Ym8e9m2pHTH5Is3fKTGk5PjyfEFPf7oYVuJBVF5fGu2uHXf8FSQjuttkd1BOHKk2ksD0f+LpEQ84y18xboV3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aY7TqnLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aY7TqnLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CE4C4CEE9;
	Tue, 27 May 2025 17:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367849;
	bh=n4pAU8lZ+Jnk21HcxsEqNDD/gahz3SnAWnHkwnD/0rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aY7TqnLUbkCLorn7RG5kIboOzE0qT+KhsepB7Y00zANHytQfBJXSP59lF9GynHdtT
	 AuiXdP2PyJVkDi82B2Uo35p5eqsx5IMM7E5TfvO/Gb5JthtoiyFy2OdJPHC5VAyxaL
	 BbaOdGwDHq5dNGCsaieaG9aQxUUce9SlwOCr3SMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 519/783] wifi: iwlwifi: dont warn during reprobe
Date: Tue, 27 May 2025 18:25:16 +0200
Message-ID: <20250527162534.280684402@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 696cca64308dc641d0bbe4aa2c09dd9752aa288d ]

During reprobe, the sw state is being destroyd, and so is the
connection. When the peer STA is being removed, the opmode sends a
command to flush the TXQs of the STA and uses iwl_trans_wait_txq_empty.

This one warns if the FW is not alive, but it really shouldn't if
there is a FW error - and return silently instead, just like we do when
sending a hcmd.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20250205145347.76425b10e5a0.I3bf0de2eb090a8b94c4e36d93dd91df61fadb808@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index eb631080c4563..75571f8693ee3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -690,6 +690,9 @@ IWL_EXPORT_SYMBOL(iwl_trans_txq_enable_cfg);
 
 int iwl_trans_wait_txq_empty(struct iwl_trans *trans, int queue)
 {
+	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
+		return -EIO;
+
 	if (WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
 		      "bad state = %d\n", trans->state))
 		return -EIO;
-- 
2.39.5



