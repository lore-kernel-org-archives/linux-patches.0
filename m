Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92A72E92A8;
	Tue, 15 Jul 2025 13:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587542; cv=none; b=a9lEP1x7Lgj1xlmgYRsVT70zj7Hv6z8XDTdPsbxaWjcfnCa/o4QAMraB3O2GStcXdasRbkgjBpMK4r28mhcJhTA01JD+urxyy/YhVJe1FLHEh3nSS/jibURitLF94x4B6/VNRjY9boLjFeSA7+CHqSTXbf3adxNNE2D3G2dPNKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587542; c=relaxed/simple;
	bh=E3oKN7K38yx3kecR5rhaUY1HnQdD+tEKj+LAJJnVxIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9YFeabeIW3LpFhbYrcElKG/ZypSUlc8mTwyjBxGT7/LOY/XMtAnYDGt6bZtswWSdZzB6JL4gbFTAwuDkJtN4iFZx+q+KQ5ErpS9BFWpUz4YJwaBgjggXucL+pHABCrcybNtgDiKifp0JoRQImUi/Lw2IiBCofpK55VaqlptEnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCRDbPOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCRDbPOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB19C4CEE3;
	Tue, 15 Jul 2025 13:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587542;
	bh=E3oKN7K38yx3kecR5rhaUY1HnQdD+tEKj+LAJJnVxIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCRDbPOhKfzqW/eEaGiclGfQMBJDVegmW3sQw2kXZT2sP9JaVeeApBZ5zc16StGSp
	 5nr+W4cGm3NR/22igTq1PyzS90jsBqxd1Z43T76YnrTMqf2WayE/I4IiqxLZ5QvcrH
	 jVQUNq6viusdzzEY4Sdal0PMPd56OkNxL0Tzx+6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/208] wifi: mac80211: fix beacon interval calculation overflow
Date: Tue, 15 Jul 2025 15:12:40 +0200
Message-ID: <20250715130812.997762893@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 7a3750ff0f2e8fee338a9c168f429f6c37f0e820 ]

As we are converting from TU to usecs, a beacon interval of
100*1024 usecs will lead to integer wrapping. To fix change
to use a u32.

Fixes: 057d5f4ba1e4 ("mac80211: sync dtim_count to TSF")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20250621123209.511796-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0da845d9d4863..7cb32340108e3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4242,7 +4242,7 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
 {
 	u64 tsf = drv_get_tsf(local, sdata);
 	u64 dtim_count = 0;
-	u16 beacon_int = sdata->vif.bss_conf.beacon_int * 1024;
+	u32 beacon_int = sdata->vif.bss_conf.beacon_int * 1024;
 	u8 dtim_period = sdata->vif.bss_conf.dtim_period;
 	struct ps_data *ps;
 	u8 bcns_from_dtim;
-- 
2.39.5



