Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6172E540B;
	Tue,  8 Jul 2025 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993926; cv=none; b=pAZKWSI9C8ZF31hq0dUiMDILJ6PHwu9Fnt0LLfd/DY2BmRYZwFNcVY8Aa0Tdr3CmRdDFPwspsK5GXRS6uxhQkeM3jvfaDsBJu8h+HQHqDJc4vgJAUkkWtdZRD8teKhKMF321DHB1tDziYlTK7Gne1gQ1hOr3NOSSEo/WDNO2I8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993926; c=relaxed/simple;
	bh=4YrchkTvKUmtK8joCK2Nda53W+vW7KtduYc5rTxgOcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaBUTVX3m03KyZiLuVNfleeUIcKpKeaUxbnsjuVgSUPcfKRkTnO7Oh/mRFGGFnua29KVpj/c7HdvVbgLxezgkQwI5X1ltQ5mSyDkFwHwCLv98yw3iaKdCovv8tXo4t9eWL60sGJ3swxEBLNaWwCtZ0FjkDo5tEs83C6aE7258fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxfR1kd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxfR1kd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37945C4CEED;
	Tue,  8 Jul 2025 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993926;
	bh=4YrchkTvKUmtK8joCK2Nda53W+vW7KtduYc5rTxgOcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxfR1kd5Q+O1eSPLjDn5F7v1AE+/n+ZWctFXhQ6u0Mj46jkfQX20aoCvKP1hcnCTX
	 emhQjKlToAnLnyQKt0Mi6OM/fpmjIYjoJtzPIo2czILVjtXdPg94FW75Bk9KkQc9a4
	 18109I4xGKhdSw5NYv6IJ1yuSpAnMGeSVK6YCDXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/160] wifi: mac80211: fix beacon interval calculation overflow
Date: Tue,  8 Jul 2025 18:21:42 +0200
Message-ID: <20250708162233.356126353@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc78d3cba45e4..07512f0d5576e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4350,7 +4350,7 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
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



