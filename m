Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0D125BEE5;
	Wed,  3 Dec 2025 15:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776450; cv=none; b=napW+ReuWdWDuGNPfcSmK0d/s2G7DMPQmgovlw7rl9b1UWsgY5b5rfEvQhx5XiDI113YMCTEJv7srDAcLWwjpk/jnvGNxAOmOL/lAhxUP+cshCrJVwaL70EwZbfmk79h/qHmV/g9OYYYNgpHBQ9NcGUIuEYumpwNJPPw19LU9uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776450; c=relaxed/simple;
	bh=tpI7gBxcDQN2/v31mJ3DLBdR2zsYuLyTB6aTMXTcBoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFIv/IutxTCNhHIf97OXK3IS5gxar0yJU7BQoj86tF2+KFh9LfQrq1k0Ns75Arpt9zu3Ed+o//5VPsvqn4IPC6ws6658KEN7bOe1o+qBzXqKcExRVGAJcajNCDCpi92zunIuam+BvCZVgxu16G3+mTxVRpocSExaFpeTSzaNE2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uG4MX5Va; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uG4MX5Va"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E30C4CEF5;
	Wed,  3 Dec 2025 15:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776450;
	bh=tpI7gBxcDQN2/v31mJ3DLBdR2zsYuLyTB6aTMXTcBoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uG4MX5VadIiRJB52xtgimjOFM1aAoWWaGFrnywKguGeWZK9xGlDD0VgViHMGugd7b
	 OrZqNqr26HDeLqrZH8W3NJL3xVnzG1NB/rrSWABfIh1tbf2WzGNx+SRtT/BgiHsh4w
	 kspbHcLO37peMvLW7X68q5e4q5nDt4tUM0KO+6rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/300] wifi: mac80211: skip rate verification for not captured PSDUs
Date: Wed,  3 Dec 2025 16:26:31 +0100
Message-ID: <20251203152407.555209615@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b46c4c770608c..98f06563d184c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4779,10 +4779,14 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
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



