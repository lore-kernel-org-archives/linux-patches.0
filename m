Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20B2231853;
	Thu,  3 Jul 2025 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554246; cv=none; b=WzdfBgWKcYkQGqsIgZWEYvUSwmPgycyAJVX7ySc61bAXqqvDS67Fg9I3WqJL9WHBtiIGq7KJJaFISBQjERAa3FfvYPAjgGkxftC2rC52m4WX1ryGO/ARQR8jzD6xIVXoRADqyULlyVXum8Dyuq48KL60tauWDRQRUtqvraX94hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554246; c=relaxed/simple;
	bh=wweRQkhXbqWGWzx+mKJ4kZaiMRbn7k3of98POqxJrGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbJEkkCdfWq2aZKXx6chcRyxEiMLAZr0NbrLef3nsi0ERQ2jzHEEQrrWlF/P1m7wWDcAYWLYi80qHe6DQZ880ayzlsWNA8uoIUfV1EDpNBW/zRmf4+9/0F2usEVAeN1z9Hzklq9bqJFZ1hHIy8FqRXrnxyMv56lq1bCXTJU6DrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tl70wr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tl70wr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00B3C4CEE3;
	Thu,  3 Jul 2025 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554246;
	bh=wweRQkhXbqWGWzx+mKJ4kZaiMRbn7k3of98POqxJrGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tl70wr/Zs4VTtl5zZyZgkChqF2jGSDj4aVgFL5hN/1TY4zMUJhRkEUOa7NBAb3of
	 /8xpMgCivQITewoaj3VK0XVf9kOY2K+7uJhfCx5C4T/G8zGwu51mM933c0YbdB9J4S
	 U19Eqj5INYfMXmCoadLvxM91ksorr+SsmTPLqvVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/218] wifi: mac80211: fix beacon interval calculation overflow
Date: Thu,  3 Jul 2025 16:40:45 +0200
Message-ID: <20250703143959.813430829@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a98ae563613c0..77638e965726c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3908,7 +3908,7 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
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



