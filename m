Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD371C68C;
	Sun,  1 Sep 2024 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208589; cv=none; b=ZhqL+9pu9Wf5ZbUOz6DCqJfCn2vaL9+r5S/Kb45suQ8MKL4sBdAWm7XASIKzBBqgyHODmBzrsGV7fx9Cc4E3HtZCJzybB7SrV8kwAV699NCAuozBiHSgIM1wteCba0+ZT8FWzdqrz4jY+k3SQrluU4+mNwKjCk4zznmtxL0fzYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208589; c=relaxed/simple;
	bh=v34xAQ/Cv/b/PhbvCVT5ehdMX0wzOTn7AQFB1ZdAxJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clv11GiRNzEwL2claFfcYNLAQlFXPBha/lu5j0yjCcNttDGmayZFLlsNDaGKmgRWq68O6Q/hXeHaIHJFYccC620hb/ExTb35hNdEIDNIqk4iw8v3wOzmhp8h5nImqKHc7EFUBTogDjTEMct2AWJERFT7rpCFhyDtOGNyeO5OBJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aURnOl6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aURnOl6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A087DC4CEC3;
	Sun,  1 Sep 2024 16:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208589;
	bh=v34xAQ/Cv/b/PhbvCVT5ehdMX0wzOTn7AQFB1ZdAxJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aURnOl6Lc1x1JS6OjBCNhMssWoSMMiwNpdZFZeovf0AY3aZKWNM/Adi5RBjCUWpJE
	 QFKB3FXC5XMoAvyHijXGowJVCph2XR2xqvRGNbqtwWA254za5kd5asneQeuepPU7DD
	 D3O3IAVbYSB68NkbVObhhCbaTlSuw1Qnv/xSh3Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 097/149] wifi: iwlwifi: mvm: allow 6 GHz channels in MLO scan
Date: Sun,  1 Sep 2024 18:16:48 +0200
Message-ID: <20240901160821.109246119@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 454f6306a31248cf972f5f16d4c145ad5b33bfdc ]

MLO internal scan may include 6 GHz channels. Since the 6 GHz scan
indication is not set, the channel flags are set incorrectly, which
leads to a firmware assert.
Since the MLO scan may include 6 GHz and non 6 GHz channels in one
request, add support for non-PSC 6 GHz channels (PSC channels are
already supported) when the 6 GHz indication is not set.

Fixes: 38b3998dfba3 ("wifi: iwlwifi: mvm: Introduce internal MLO passive scan")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.04807f8213b2.Idd09d4366df92a74853649c1a520b7f0f752d1ac@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index e975f5ff17b5d..7615c91a55c62 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1659,6 +1659,17 @@ iwl_mvm_umac_scan_cfg_channels_v7(struct iwl_mvm *mvm,
 		cfg->v2.channel_num = channels[i]->hw_value;
 		if (cfg80211_channel_is_psc(channels[i]))
 			cfg->flags = 0;
+
+		if (band == NL80211_BAND_6GHZ) {
+			/* 6 GHz channels should only appear in a scan request
+			 * that has scan_6ghz set. The only exception is MLO
+			 * scan, which has to be passive.
+			 */
+			WARN_ON_ONCE(cfg->flags != 0);
+			cfg->flags =
+				cpu_to_le32(IWL_UHB_CHAN_CFG_FLAG_FORCE_PASSIVE);
+		}
+
 		cfg->v2.iter_count = 1;
 		cfg->v2.iter_interval = 0;
 		if (version < 17)
-- 
2.43.0



