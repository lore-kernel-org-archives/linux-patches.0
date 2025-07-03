Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755254414;
	Thu,  3 Jul 2025 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554999; cv=none; b=TCUWMnKZckyfnd3RmymW+9NgfJorvHpwbQ3kmENjuD1hjys4oAfdKChyg+vqOLB6CL9vi1Rruqgv8XaPChHS1E8X2PdZrV/n09h0zv4WgJjxHR9Lpxuh88KNWNZMUv8yOy8PGp6Z6mBIPtRZDVBhp6GhcKC0lp09AR1Ql0QhSts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554999; c=relaxed/simple;
	bh=hq0qwUrRuaW8C4YC9jaDgZT6QVYCS9Ti6lzpfYxWZJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1jcpyd9CKCrVnduwHY9B0uJC1aGPlePMAXDavNiljhfWrqB5+0MiHZ2IroRsMmtXmzg0k3lpdYJPA0Kysi+6eaYAWWXA58BjmDhpNGVD9g0aFZc7LBsUF1ijkD2jlVt1WaSRXmeWiWucdyxzq3K01Rn/O1UMDnGEliX9Ei9330=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ECtYbgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ECtYbgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E12DC4CEE3;
	Thu,  3 Jul 2025 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554999;
	bh=hq0qwUrRuaW8C4YC9jaDgZT6QVYCS9Ti6lzpfYxWZJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ECtYbgU8o1gxKzG/Udu+KtnDm1Wt+tKwL6eM3LjxgPo//B4ejs+lM+AQqw99TGdT
	 EeOKhUe8lCi7m/LByM8DBqg35nNuDPJPwuIOO0WUHVMkDHMEVPAc8bOKYfcobOKrfN
	 Fd9kEjVOFDq/PLO0LvY2TPShT433yoedpPt6j6dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 144/263] wifi: mac80211: fix beacon interval calculation overflow
Date: Thu,  3 Jul 2025 16:41:04 +0200
Message-ID: <20250703144010.131924885@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index dec6e16b8c7d2..82256eddd16bd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3899,7 +3899,7 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
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



