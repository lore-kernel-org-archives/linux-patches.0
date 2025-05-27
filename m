Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8529D13A244;
	Tue, 27 May 2025 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365652; cv=none; b=irGfv5SfJv+XJI6Ses82SwGROawV9WaZw4fQyHG2z7xIFYcFFGdtHxsNz+1skKLvyPDZXjSQVr6NqEcPJDX/d89h3Ou5Ncvlda6BY52gxvI+5RLLl6LAacXka+O1Sa6uWVvkaiFzdQ9miJ9atBMtikMggV/LhbmU2GcotN1oTeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365652; c=relaxed/simple;
	bh=wf45OkiiORwCYKMPYmQI39IFxIaUFNwao8bRaFDb1JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWcSIO9FbODRo9+urGJ7I8tMe5zuoC9vj0qUGHI1dDQDBWVkBVCtCddv3cWdE38gddHd5OLsXKidS57GLy9EFoDjNFA7UvFrTM/bLjK2XcfTf0duycVufNjjIX6zCoKD4f/cI1SJLCfDr2E/UgeCpi8NW3v9Iqk1bHlZfhPyc2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwNgXlQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwNgXlQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACC9C4CEE9;
	Tue, 27 May 2025 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365652;
	bh=wf45OkiiORwCYKMPYmQI39IFxIaUFNwao8bRaFDb1JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwNgXlQwf2uOvu27G8gFa2v9x2EQ7NOcovkFF/utQTXzfDT1PGyTEukTogedXR5Po
	 WgukuHGzZDP39X49ZlMFuFHn5Es5y2uS4sF047QFrroLjdH/iuoE8AuQwcjbETH7/D
	 hF9B+NxxUBWtRxOD97qGiMe9HS3hsde3XrhGFbnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 415/626] wifi: iwlwifi: dont warn during reprobe
Date: Tue, 27 May 2025 18:25:08 +0200
Message-ID: <20250527162501.868179379@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 311b167ea09ed..510e04b721da6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -454,6 +454,9 @@ IWL_EXPORT_SYMBOL(iwl_trans_txq_enable_cfg);
 
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



