Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E0222128B;
	Tue, 26 Aug 2025 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216321; cv=none; b=GbKcsNtT31fKCQ8USNbQoQ28hH1f8+J1xCKjMPy5k9yLa/wdOTCf4fHEFsTgC1sPNuuSc3Y7+nATOI+wgVKUl+z6KAvT9r4upXkfZwPdtVOiI5XYNOAe26kZDrfC7ZBbeY6rheK6cnzLMJ3hdkLE1Y925O+PN01uihYskW7CzS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216321; c=relaxed/simple;
	bh=0+pnD09jUQ1favwv4WB7XWq2MCNj/Lj/qIbrLwGN4bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qs0RGybyBnUvYpEPDcAG6H9+vkw6NFuOX7BzmZ8xOtRt+bU0/Byelw6ARh+obyoa5X/eQKAmF5LKyw4YGjHnDjf4uGlyRLhiOPU3BgKgapyFG8ItHjlSd1Gjt6Of0I5Cs+YhfP9MJD3lXCo1Yhch9RLV9/TZ62FVf1FqE3RZBZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYEOUwGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYEOUwGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88A7C4CEF1;
	Tue, 26 Aug 2025 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216321;
	bh=0+pnD09jUQ1favwv4WB7XWq2MCNj/Lj/qIbrLwGN4bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYEOUwGP4SuE54BcL/M31BJy3yb8WoTqpmrBKJC/A8QB7NgDRURW8KqJttfj49W3m
	 36eiLcFcTFWnAjDUDRn4dgjuQGJwG1KOTIqXCMCsAdSAZag2XICPbKYNpupPRd9TGf
	 BCus22Fv2scf6/2vrWTjupjJHSR7un74Y4aTZbgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexei Safin <a.safin@rosa.ru>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 367/644] wifi: iwlegacy: Check rate_idx range after addition
Date: Tue, 26 Aug 2025 13:07:38 +0200
Message-ID: <20250826110955.509845760@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ceab7704897d..df9d139a008e 100644
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



