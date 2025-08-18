Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F1932A3EC;
	Mon, 18 Aug 2025 14:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525628; cv=none; b=buvJOlAt0lHmV5O7tNqcawesWQtIqWSi8EUy7IdJFocbDLkojYFsHlV9t5Zqgdiqt2nCcVqMzQFgu5VVIWlPoZCINGf9z0kpKHFrTaO+u63aJLpCsCp/SjYCdF42sB4pB/aumw7sQvI21N3r//JoBnqZCLfTAj1z7bKJq/sUQAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525628; c=relaxed/simple;
	bh=74aO6F4zPGDKg189gv8qcNC4v95tnwMun0f+q0bVUUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OM3/6xct0vA0DOnlMf3tg2b3sZpQceafVi2Ag2o7t30OSxM2FR+dgQfpg+7kCnje7/RveJzH8pr9uzz5h0AEOaarhWC8gPfMH7mNiJNgZWRcCG5O4/S+CKwzxfisfU6/AVje8XVmH15CtNdGRUo6ugfHdEGMXTUU1rmj2rCqyr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ob7GPyVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ob7GPyVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E773C4CEEB;
	Mon, 18 Aug 2025 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525628;
	bh=74aO6F4zPGDKg189gv8qcNC4v95tnwMun0f+q0bVUUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ob7GPyVYj9wqQzlV2sacyy5020c7B5DSBjDQfBlfeKql4jbm9IIhQTv1F6c4MSgo4
	 /M72TTYx6j6bpYPULX7CQkx2fpqQCsh5ir4VLGChh2KmIhWsKzbLVsdxWylkjyoyXO
	 qKMWe+rOR8LSGpiVdsyzfd03lkqiLZZuK+9CgE4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexei Safin <a.safin@rosa.ru>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 320/570] wifi: iwlegacy: Check rate_idx range after addition
Date: Mon, 18 Aug 2025 14:45:07 +0200
Message-ID: <20250818124518.186726938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

[ Upstream commit 0de19d5ae0b2c5b18b88c5c7f0442f707a207409 ]

Limit rate_idx to IL_LAST_OFDM_RATE for 5GHz band for thinkable case
the index is incorrect.

Reported-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reported-by: Alexei Safin <a.safin@rosa.ru>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Reviewed-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20250525144524.GA172583@wp.pl
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 8e58e97a148f..e9e007b48645 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -1575,8 +1575,11 @@ il4965_tx_cmd_build_rate(struct il_priv *il,
 	    || rate_idx > RATE_COUNT_LEGACY)
 		rate_idx = rate_lowest_index(&il->bands[info->band], sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
-	if (info->band == NL80211_BAND_5GHZ)
+	if (info->band == NL80211_BAND_5GHZ) {
 		rate_idx += IL_FIRST_OFDM_RATE;
+		if (rate_idx > IL_LAST_OFDM_RATE)
+			rate_idx = IL_LAST_OFDM_RATE;
+	}
 	/* Get PLCP rate for tx_cmd->rate_n_flags */
 	rate_plcp = il_rates[rate_idx].plcp;
 	/* Zero out flags for this packet */
-- 
2.39.5



