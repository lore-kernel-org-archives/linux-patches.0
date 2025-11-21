Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC57246762;
	Fri, 21 Nov 2025 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731800; cv=none; b=KP5Z8crCRFEE2Dd/SbaZEfjSdDIYIP28H/q4abTo9nfU+vqZLcZ3ZQiXt2RGXp55I0NM1ytQyV2ars8UuVE3WQRgJ9I5IQa+yNTxJlakm1WI2ULomz4MfE/XVy/Bs3soK7Y1KphtIPZsUnRY2KqgYhZZqozcxnA3YVBLZb88lnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731800; c=relaxed/simple;
	bh=ocjaZ+KhRXqaESwGxaPYCDqcO+TgnBZu9sCwiDsjNKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=An8rjPHVuCAa5+S3jbvKmWpXqz3lXqbNr6QgeJnXp1+k81QmzjHd/cbmsqTdLuTU+F64jmALP5Id1cPmx5LIjsvEqGG6LC4CC9MlXugLSnVbMd1CnfWYGisPCZAFNru0M0PQ0m90xNqn4KuJC01/L3EB4HONV0dprAmWNnIOr3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bT20+LLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bT20+LLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3436C4CEF1;
	Fri, 21 Nov 2025 13:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731800;
	bh=ocjaZ+KhRXqaESwGxaPYCDqcO+TgnBZu9sCwiDsjNKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bT20+LLG2nRGcH5T4tKgQj4l5fCPGA9Gh2Y/4OHOuxO1VkgmeuSuXkXAi4sfj9U8+
	 4j5DYWl3LsNzcmGBGWcAV3XepL6uoZNykWnTRLPxpFwR6zA0k2pTy+wUhiItQ2lb/k
	 k3GQft+7tA77t3xewq1NQHX1gGaih80ulAjw7G1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/185] wifi: mac80211: skip rate verification for not captured PSDUs
Date: Fri, 21 Nov 2025 14:11:18 +0100
Message-ID: <20251121130145.719858902@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
index 538c6eea645f2..ea6fe21c96c55 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5402,10 +5402,14 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
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



