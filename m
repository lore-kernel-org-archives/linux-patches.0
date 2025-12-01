Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEF42550DD;
	Mon,  1 Dec 2025 11:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588698; cv=none; b=Pe6Qe7fbKtWJFyLqIaG8G/z3PxQfckjpI4VT/0pfW7O1NAkjSDOfeC9a/b8HbwiCm4ohHffG+/iIxNOrQBqvTdznHvQ6eBlpn/lbYx/WBRppKBmXC5kl29pcb6DRBngkuMMtn7n1+AIhDa5P2feP6bayOSe1pqydgOT1TCOXkn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588698; c=relaxed/simple;
	bh=+WFptOIa5EplUhY7WMffhl+RdQU4wOQHPMbtNIeSKpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrJivwBVeX+fEo/c9q2qMm+QWMhS2c+vUuMFfZmPnySgOsstssietYr2G2+RiHrGNbb4ILxQTLDethW4vstZvznc+7bT6Gkuvb8H4s2y7on+cYkMF5luqGh1rZUzS4rv775IluvOVguJgw6suGNvelxSg8qRRRt/9UdOpVqnL4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l59cvJe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l59cvJe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FF2C4CEF1;
	Mon,  1 Dec 2025 11:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588698;
	bh=+WFptOIa5EplUhY7WMffhl+RdQU4wOQHPMbtNIeSKpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l59cvJe6WMjFUCLTOoLSQ2/GveW1QnljGGiRHBd7zuMA/X749D3Ef1UGZabXrKlUY
	 waxGrL3xdTTWSYah1aI+n3KloIoxqrz7Kk8Zd/i5syNvTGAc9Nf8OaYi53avGX2O7V
	 /cPCS0IbfffwiYnvynZBonTPxHWPPE0h51TCObjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/187] wifi: mac80211: skip rate verification for not captured PSDUs
Date: Mon,  1 Dec 2025 12:24:07 +0100
Message-ID: <20251201112246.244447688@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4c805530edfb6..e8e72271fbb8f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4669,10 +4669,14 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
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



