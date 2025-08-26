Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBECA345747;
	Tue, 26 Aug 2025 13:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214556; cv=none; b=Bb2Ew4aH/+DI/Jp2K+u1RtxinjH+3QC38FHcuo03u0DdgoGQRoNL48GXDJT1qNI5kWCJT6RWtsKVFZ4AUKygFiJ+tEHJcysQg9WdaoMiNZVEYgcretC+UVGTSL7LuZhCrawlyLQ8trbWaoEHRbIofLJjQ8WX0SrHqvwSSNiwQXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214556; c=relaxed/simple;
	bh=kKKssaRU1oX+7061Zumosg3lIO3JPpjTqtK+B7MsMW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niDtlY5H0RRyGsuxD6na7jyQpgOzL1tOYJAOyAbEJaMzMQ8pemjWaVRPN97uFApCnSvEq6WvLvyevA8RLYnt1bs43agGliKdEitNMq5Bpyrz1Z/qUWBi1PGwyn6rxpFQOFsf7j+5IJLmjkcmmIPYzt4JlWjch+jQw1xwyivDZHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5G/hpbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5G/hpbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E22BC113D0;
	Tue, 26 Aug 2025 13:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214556;
	bh=kKKssaRU1oX+7061Zumosg3lIO3JPpjTqtK+B7MsMW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5G/hpbB7fJ4gZeYi52ZBCgaz2wG5H97eLZtLDnGPOzZ1KR99HRXikctW74v1dgaC
	 aUAjzkmJ3XESbeA5yFqZcfgqpOjpg53k12BMWgVUf3z8M1DDCZZpbicBB+p3J4a+Rj
	 7rj3HSUPlPAAJyc9TuQVuqn7HGg5/kGjCGy8J8Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexei Safin <a.safin@rosa.ru>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/482] wifi: iwlegacy: Check rate_idx range after addition
Date: Tue, 26 Aug 2025 13:06:45 +0200
Message-ID: <20250826110934.571409597@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 78dee8ccfebf..1c22a29d20d6 100644
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



