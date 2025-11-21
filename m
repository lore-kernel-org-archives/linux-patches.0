Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8713358BE;
	Fri, 21 Nov 2025 13:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733261; cv=none; b=MWFHlf5suFweK4vXWDOIFwX6W8bnYVJuImVXvYxF1WN5qBUV/Hgbc0Bk1WarCL6jBldatGVC9MofSO+dDG9f8ZJZ1HEq1fwVX1zeGeouOQL0N3XKEn6twhm0+3MntRKvULLyZSlxT9hoFYzj2qJJOI5iVpwcNIN7DMT8aoqiOl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733261; c=relaxed/simple;
	bh=Ya9n2AB/dnE5ybo9BvlWr6S6Ft67fUdFK0eM832tg88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aO2AGuS3hOMuUn0tgULbzrOU6YJPJ906YCiRBLbg8TcCG4rYJXkA5unqD3oGQ+F8X8rfHH245eiqXTQNDPTHGwkcywpCIft6Ot2FI6UI4DRpRHdPnyfDdX41UmyJ1C2xKTBWQmZ8RDufM8bpoHgCUPw1blzHY4XayrryPxsItYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G70QCAow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G70QCAow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25B7C4CEF1;
	Fri, 21 Nov 2025 13:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733261;
	bh=Ya9n2AB/dnE5ybo9BvlWr6S6Ft67fUdFK0eM832tg88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G70QCAow6vXNgGcXXy2pN1qj/bbDCbYk+y43Q0upj/AAtiGWVK8xWExzRwQUy1JFj
	 asNKLa5j/ht9umLaeoXQtSNYmZQoC6JXG64FTdZertvuXXBskUKg8pBhoXHRwo76Gn
	 5s0M+qu8xKEY9XIIxvkfDSLQGyb6w4NVTrnQB++c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 407/529] wifi: mac80211: skip rate verification for not captured PSDUs
Date: Fri, 21 Nov 2025 14:11:46 +0100
Message-ID: <20251121130245.501066850@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 164c6e8049826..e6a0a65d4d43a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5341,10 +5341,14 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
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



