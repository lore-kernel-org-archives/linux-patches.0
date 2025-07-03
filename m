Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853652DE6F8;
	Thu,  3 Jul 2025 15:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556119; cv=none; b=G5p0ICbx0LzcUIKNvNTLJKYYn4ntZDqGljdEe4M8WXws7EyCVjVBktn2gGzdkUIHUe4hcLTu2YFbuhfkatpng9ZA1WZd7VT9Fpy5DkFMM+FgymYRO2Yh+TM1DMhSUNO/1vp1McDZiHNbCsiV+fyVDfucUQO/hVVq7x9Ine1K54o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556119; c=relaxed/simple;
	bh=WYY5JNWiRKVLqTjhZqxfvOlECWuLWFYvUf5VIBOL/24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1U9rPNMnPZ1XhzdKb3+iDJpiomxOF+0A7x2dey/CxnBM7KThbuLKBEFqSqC12HpUGcL2JU5i+Rzo1HVirbM/L94uewSLeRUVd+mcZtz9clZ1KEWTxBHGKeWtrWJosw85pRsv2BvXy4dBI2QjWRGnPpA2QsUOHzmGTDMspAjXmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q740dLVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q740dLVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3155C4CEED;
	Thu,  3 Jul 2025 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556119;
	bh=WYY5JNWiRKVLqTjhZqxfvOlECWuLWFYvUf5VIBOL/24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q740dLVRNrRgRmh4yfMA5eZS3avyOMmjH5PnywBnaZE7oGEanh7PwBufuzoMARob7
	 yHCvnvG2fjWl9VGIsoyoMKOwGSMiI/ekT4dYlJMRhM1vWlMH1Buz1AI1FdKin/lJHJ
	 /M//adwEAsTeM8HseTAWJEtFJM+RgUOrtCITbww4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/132] wifi: mac80211: fix beacon interval calculation overflow
Date: Thu,  3 Jul 2025 16:42:49 +0200
Message-ID: <20250703143942.551158217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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
index e8326e09d1b37..e60c8607e4b64 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4452,7 +4452,7 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
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



