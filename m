Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4B1207E14;
	Tue,  8 Apr 2025 11:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110852; cv=none; b=n7E9AuLF0rkMaon9FVngekS4FSXCM8+t7loB0d82swI+KboIkGppIWHTRm41FbZaRadUkd8OU4f3m18TDBe6DAAggpsadq7GdXzembgBr5SijxMTCiOD4/j96sPz4Hkc33N3x+SwodylbvMYPkpCjwsthogiJaIb8bnuNxduW5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110852; c=relaxed/simple;
	bh=rCAyK+QMNG8bCqliktYZiRPnhGpAFp4xCBZZznJnkIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUvjETtF0PG8ExHob63Arnc47n/sZitDAfRx9O/v2YJ78xtJSTCrfPhkspmq115zdooNMy9WdodfRwvHwok1+NuS8wr91rwFpvMTqoagDlMvqZtt0/vv6YmHgSmh4z0v96NsFbdEHnr4Ht0luTeSfRpzUKjeninJWk4ZOh4FVk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXt86Tjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXt86Tjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A9BC4CEE5;
	Tue,  8 Apr 2025 11:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110852;
	bh=rCAyK+QMNG8bCqliktYZiRPnhGpAFp4xCBZZznJnkIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXt86Tjo7ZXRNtfT2ef1GsczBYgETTbjpY5gFZauWzDj8+48CVeVTHCTnB/oxrw2r
	 QyKUifqtpDMwTMOaLKwiYnMlTMTT0P7tEJwKNL903cV/sx90FjHH9fKDmqXdNuSVIQ
	 L21N+JOdw7kKCpeVjZL//YTzCcr+WxbIN/F8SuOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 219/731] wifi: mt76: mt7915: fix possible integer overflows in mt7915_muru_stats_show()
Date: Tue,  8 Apr 2025 12:41:56 +0200
Message-ID: <20250408104919.376210769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 77b749520cac06d000d9923f79ffa632cdea6113 ]

Assuming sums of values stored in variables such as sub_total_cnt
and total_ppdu_cnt are big enough to warrant their u64 type, it
makes sense to ensure that their calculation takes into account
possible integer overflow issues.

Play it safe and fix the problem by casting right hand expressions
to u64 as well. Also, slightly adjust tabulation.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 1966a5078f2d ("mt76: mt7915: add mu-mimo and ofdma debugfs knobs")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://patch.msgid.link/20250114154441.16920-1-n.zhandarovich@fintech.ru
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7915/debugfs.c   | 45 ++++++++++---------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 578013884e438..4fec7d000a631 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -303,9 +303,9 @@ static int mt7915_muru_stats_show(struct seq_file *file, void *data)
 		   phy->mib.dl_vht_3mu_cnt,
 		   phy->mib.dl_vht_4mu_cnt);
 
-	sub_total_cnt = phy->mib.dl_vht_2mu_cnt +
-			phy->mib.dl_vht_3mu_cnt +
-			phy->mib.dl_vht_4mu_cnt;
+	sub_total_cnt = (u64)phy->mib.dl_vht_2mu_cnt +
+			     phy->mib.dl_vht_3mu_cnt +
+			     phy->mib.dl_vht_4mu_cnt;
 
 	seq_printf(file, "\nTotal non-HE MU-MIMO DL PPDU count: %lld",
 		   sub_total_cnt);
@@ -353,26 +353,27 @@ static int mt7915_muru_stats_show(struct seq_file *file, void *data)
 		   phy->mib.dl_he_9to16ru_cnt,
 		   phy->mib.dl_he_gtr16ru_cnt);
 
-	sub_total_cnt = phy->mib.dl_he_2mu_cnt +
-			phy->mib.dl_he_3mu_cnt +
-			phy->mib.dl_he_4mu_cnt;
+	sub_total_cnt = (u64)phy->mib.dl_he_2mu_cnt +
+			     phy->mib.dl_he_3mu_cnt +
+			     phy->mib.dl_he_4mu_cnt;
 	total_ppdu_cnt = sub_total_cnt;
 
 	seq_printf(file, "\nTotal HE MU-MIMO DL PPDU count: %lld",
 		   sub_total_cnt);
 
-	sub_total_cnt = phy->mib.dl_he_2ru_cnt +
-			phy->mib.dl_he_3ru_cnt +
-			phy->mib.dl_he_4ru_cnt +
-			phy->mib.dl_he_5to8ru_cnt +
-			phy->mib.dl_he_9to16ru_cnt +
-			phy->mib.dl_he_gtr16ru_cnt;
+	sub_total_cnt = (u64)phy->mib.dl_he_2ru_cnt +
+			     phy->mib.dl_he_3ru_cnt +
+			     phy->mib.dl_he_4ru_cnt +
+			     phy->mib.dl_he_5to8ru_cnt +
+			     phy->mib.dl_he_9to16ru_cnt +
+			     phy->mib.dl_he_gtr16ru_cnt;
 	total_ppdu_cnt += sub_total_cnt;
 
 	seq_printf(file, "\nTotal HE OFDMA DL PPDU count: %lld",
 		   sub_total_cnt);
 
-	total_ppdu_cnt += phy->mib.dl_he_su_cnt + phy->mib.dl_he_ext_su_cnt;
+	total_ppdu_cnt += (u64)phy->mib.dl_he_su_cnt +
+			       phy->mib.dl_he_ext_su_cnt;
 
 	seq_printf(file, "\nAll HE DL PPDU count: %lld", total_ppdu_cnt);
 
@@ -404,20 +405,20 @@ static int mt7915_muru_stats_show(struct seq_file *file, void *data)
 		   phy->mib.ul_hetrig_9to16ru_cnt,
 		   phy->mib.ul_hetrig_gtr16ru_cnt);
 
-	sub_total_cnt = phy->mib.ul_hetrig_2mu_cnt +
-			phy->mib.ul_hetrig_3mu_cnt +
-			phy->mib.ul_hetrig_4mu_cnt;
+	sub_total_cnt = (u64)phy->mib.ul_hetrig_2mu_cnt +
+			     phy->mib.ul_hetrig_3mu_cnt +
+			     phy->mib.ul_hetrig_4mu_cnt;
 	total_ppdu_cnt = sub_total_cnt;
 
 	seq_printf(file, "\nTotal HE MU-MIMO UL TB PPDU count: %lld",
 		   sub_total_cnt);
 
-	sub_total_cnt = phy->mib.ul_hetrig_2ru_cnt +
-			phy->mib.ul_hetrig_3ru_cnt +
-			phy->mib.ul_hetrig_4ru_cnt +
-			phy->mib.ul_hetrig_5to8ru_cnt +
-			phy->mib.ul_hetrig_9to16ru_cnt +
-			phy->mib.ul_hetrig_gtr16ru_cnt;
+	sub_total_cnt = (u64)phy->mib.ul_hetrig_2ru_cnt +
+			     phy->mib.ul_hetrig_3ru_cnt +
+			     phy->mib.ul_hetrig_4ru_cnt +
+			     phy->mib.ul_hetrig_5to8ru_cnt +
+			     phy->mib.ul_hetrig_9to16ru_cnt +
+			     phy->mib.ul_hetrig_gtr16ru_cnt;
 	total_ppdu_cnt += sub_total_cnt;
 
 	seq_printf(file, "\nTotal HE OFDMA UL TB PPDU count: %lld",
-- 
2.39.5



