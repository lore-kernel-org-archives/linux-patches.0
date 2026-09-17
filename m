Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC8C398911;
	Thu, 17 Sep 2026 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668554; cv=none; b=Cnsf0WqvBsG1fM0IT9uxEtqqDKmDPIOxEmMcLot1jE8WWzpsTuL1TImrP/NC7Rdui5F9JkJoBDTW1dlfSt3TLBpxL1llAHpvp6Lc87NL2yqGusQXhIEmaOLPUhhq77VzKU4njRHy35pPzp0HkUJhPkz3RX5fd4/7U+CfdLAoagc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668554; c=relaxed/simple;
	bh=i9P7k6O6WFv4ZXLazvAmFLh2Jv3Rf/9W/+w/6i/k3xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLsTMttpq2Wb1uDTk/xVxRo6WUAKYt9aenB9II55zMDQf4pE/JHmRZxlw8vtK9irruPoTbcjkZxvdgCS8MK8cK1s649Eyr6kgaZgnBLqRO7+vLkQp69CJ04FyBz6pdv0gdr1hu2CUyW/rHrteA4J10A5xwXA9/pw5Kj9JnvPMow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqLxkT3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqLxkT3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9B71F000FF;
	Thu, 17 Sep 2026 18:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668552;
	bh=Z9FwBDqZcJOUgELxOt0maFJjUj8BJpMQdPLYrJ9u7bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqLxkT3XeYv1/Bm7UI6LSZwFI6RYQnPuab8wUXnTQeQNfhjQ3aMKVyNu2FX0GR4fw
	 Ix1m0Pe/LcArPWHmqv784k6RBcGPI4p3RI9GrgLgC2/o/YUR0ip5jFgsNB0CI1ww97
	 N/nUVhNpGenS5YR53fAMp2QQYtWKo+37FiX1LcFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0413/1102] wifi: iwlwifi: mvm: validate sta_id in BA window status notif
Date: Thu, 17 Sep 2026 16:05:56 +0100
Message-ID: <20260917151550.033705514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 6aa77efaea9efea92e3090c35ad348fd759a3cf3 ]

BA_WINDOW_STATUS_NOTIFICATION_ID extracts a 5-bit sta_id from the
firmware notification and uses it to index fw_id_to_mac_id[] without
bounds checking. Validate sta_id before array access to prevent
out-of-bounds indexing.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.2e97f337f3cb.Ic3f0f404082ccdea13809a3c0b70e0f5417e1037@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 1a0b5f8d43390..a080e24d4b44b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -1335,6 +1335,11 @@ void iwl_mvm_window_status_notif(struct iwl_mvm *mvm,
 		/* get the station */
 		sta_id = (ratid & BA_WINDOW_STATUS_STA_ID_MSK)
 			 >> BA_WINDOW_STATUS_STA_ID_POS;
+		if (IWL_FW_CHECK(mvm,
+				 sta_id >= mvm->fw->ucode_capa.num_stations,
+				 "Invalid sta id (%d) in BA window status notification\n",
+				 sta_id))
+			continue;
 		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
 		if (IS_ERR_OR_NULL(sta))
 			continue;
-- 
2.53.0



