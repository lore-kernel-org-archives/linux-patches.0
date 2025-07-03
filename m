Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5746417332C;
	Thu,  3 Jul 2025 15:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555660; cv=none; b=Vu4bAjqITAbXcsDjFzJNMpClMraSAfg85cFqUXrKNoN/sYyY9ZiAhH8IX+BmAiuE5UAsM21mYx2ioO2luu89l0SOAlSx8eTKNmku8LLZOg6Dyj3bg7t11hH8XgSDt58M+uUylCTTn9QqgTJrunOIK+2GQLMl4D1RE61nRE5z6Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555660; c=relaxed/simple;
	bh=FS9uKkLAeLJcB38mo9vg0JgDDR2gbwBxrozYuubxLFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHSTBhhQmoF02Ln0AchzgpXG0DbrE3K16iH1UQAGf9LJXdPHzKtwc7Ijndpq1zp54N9i17oScu5k2kYLOANt3UWgWldMhatSLj1x7WlnhRCi0H6JMvW22RoWLHRueJwTrdhuPSN15CkKZUXdeSvr1NQe1yrTDZQiZMc+/H/v4lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9YhV9FH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9YhV9FH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA83C4CEE3;
	Thu,  3 Jul 2025 15:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555660;
	bh=FS9uKkLAeLJcB38mo9vg0JgDDR2gbwBxrozYuubxLFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9YhV9FHPp9ruygi9TVubtAWZayVPM5Br1Ct9BuRK//MkwS8SrJNw/rtfRaWXTbvs
	 i4weHzP9yX4bl9+b5v43xEY+PndAOqhukFMQUoNzR1PXHXoG5PlGSJdcU8r2c4U3t8
	 /gKvUBVHKkKso72ZcMdxGeHE9batTNmOXxkRcptA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/139] wifi: mac80211: fix beacon interval calculation overflow
Date: Thu,  3 Jul 2025 16:42:25 +0200
Message-ID: <20250703143944.367504813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 154b41af4157d..3a3cd09bdab65 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4753,7 +4753,7 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
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



