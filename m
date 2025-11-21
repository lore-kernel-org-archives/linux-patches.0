Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B2F3491D5;
	Fri, 21 Nov 2025 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731040; cv=none; b=AAerWS62pmLff3KbUOCdbrnHHVdWm7ggZ/mCuvEiSN8n0DFWtM/tzFrYKkI4b21vrrnOPs4MagZn1ppJJiXRunVkqUHGIO8Oq0tBRu9G7QWZzV5Rbk733qnu9VXwmciCmuO7iuTkvOaCc8ZAN5T2seSq9hZ+E63BX473oxMDtMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731040; c=relaxed/simple;
	bh=k+R6S6pFPgQA7fldejKXK3geSc6RqDAhRVx1QQdtXlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeyx17Mtko9cx4PHGFMdb1/8gtvxEUCkeU95hcBUymLJWYOy3q2zcdZe58RITNDNVM682/s7UtHvxjMWE1I6qHXfpRBbAFh0YJ3mieOfZW6Bp/3BgL21Q6H6mbRMkCu3UiLWuBRjGN2BqLsLIuCwji3lqAd5Mhe6j5P5Vdetafo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6/s6wAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6/s6wAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10B7C4CEF1;
	Fri, 21 Nov 2025 13:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731040;
	bh=k+R6S6pFPgQA7fldejKXK3geSc6RqDAhRVx1QQdtXlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6/s6wAPOdqHwD6NKF6wd6UKfgNvqo8rdJwO1JKttUr2808qIA0NEI0tr62kJ6aJi
	 3B3Kx1feMAflqwL/+nVmR9+nq9K72uXKGY/MOl7h6WIdNFK8YQCFmep/h1htGp4VlZ
	 GD+QtxoZSIrbptQhsgPLo7ajCaVyWn+tk/IYRvC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 069/247] wifi: mac80211: skip rate verification for not captured PSDUs
Date: Fri, 21 Nov 2025 14:10:16 +0100
Message-ID: <20251121130157.077275356@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 7fe0d21f5633af8c3fab9f0ef0706c6156623484 ]

If for example the sniffer did not follow any AIDs in an MU frame, then
some of the information may not be filled in or is even expected to be
invalid. As an example, in that case it is expected that Nss is zero.

Fixes: 2ff5e52e7836 ("radiotap: add 0-length PSDU "not captured" type")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251110142554.83a2858ee15b.I9f78ce7984872f474722f9278691ae16378f0a3e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 59baca24aa6b9..dcf4b24cc39cf 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5352,10 +5352,14 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	if (WARN_ON(!local->started))
 		goto drop;
 
-	if (likely(!(status->flag & RX_FLAG_FAILED_PLCP_CRC))) {
+	if (likely(!(status->flag & RX_FLAG_FAILED_PLCP_CRC) &&
+		   !(status->flag & RX_FLAG_NO_PSDU &&
+		     status->zero_length_psdu_type ==
+		     IEEE80211_RADIOTAP_ZERO_LEN_PSDU_NOT_CAPTURED))) {
 		/*
-		 * Validate the rate, unless a PLCP error means that
-		 * we probably can't have a valid rate here anyway.
+		 * Validate the rate, unless there was a PLCP error which may
+		 * have an invalid rate or the PSDU was not capture and may be
+		 * missing rate information.
 		 */
 
 		switch (status->encoding) {
-- 
2.51.0



