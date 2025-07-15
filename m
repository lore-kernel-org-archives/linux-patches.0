Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1042E49AC;
	Tue, 15 Jul 2025 13:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586452; cv=none; b=hzQUg1AIXvuWalI7ZUEf6PrFx/8xTFXjw/q9GS3htFXcjAA1mA1YgfZweAFCmXGg55d0g2RLrnE6MwlKE8MIKbM5B+f7Bs/dVGXRvSvAMW0vT30zw5aOywHyDt5dufhtDYx3qf+pWAcjZkkCG08+36rhsjdRj7K2gm4jBFLflho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586452; c=relaxed/simple;
	bh=PcwxdcZYuuu8gBaf/LM7AJqaEywm/63OLW+5iF8tBoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ME272THiH0YG7mqu5fr0V6va+1QExbH/gvxEucL9AJGi9AQk738AAUSV6bOCpS9e1AiM4IuzwjmXv3Z6vhO1QAigUqsL+NwwqpnkYeMcwkM4CU7FKjrWVbc2QUL5kVKWK+twU5Osj80XRX6Z/91SHufPDAQh7XHPdkaCXnMuVPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3QaOlK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3QaOlK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FC2C4CEE3;
	Tue, 15 Jul 2025 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586452;
	bh=PcwxdcZYuuu8gBaf/LM7AJqaEywm/63OLW+5iF8tBoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3QaOlK21UBCaCYTSK0aBJVbjowZSdcEgarbNDPU6qN5STf9GWxZtRutH1ScraFMU
	 xzeC0dVEZugCksmjHdUy1baWvNJx64ewkQjnO1RCZ+4ijjDDZMXqUKWiEGgrpx954q
	 h7PIJEE5aTadTj84V0M3udU40RFja37H81DE3+UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/148] wifi: mac80211: fix beacon interval calculation overflow
Date: Tue, 15 Jul 2025 15:12:41 +0200
Message-ID: <20250715130801.880791758@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 515fe1d539b49..415cd7f50815f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3807,7 +3807,7 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
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



