Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4061A364059;
	Sat, 12 Sep 2026 08:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201506; cv=none; b=L8agyPxSZsK/hhViGUAUNIUdAWYATyfpIbJL9kGdMQ6DOWTRsc317kiMCRy/sYqSCLTu6l4Sc9YWNs/gO2w5NLONWi57L6dXshU4oApS2xXlKFTbhPtq3xYGhRmDECgcNU60oiquAHMpN0Z2kEbEt4G+TuYSTYwArQpqNnLHsr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201506; c=relaxed/simple;
	bh=JMR7gPg1pirwb/5q3ZXUC9jVLlnLVURxPrQPQImCTxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUtdV0BgXASYCewCG23folWDtzW3TRsxpUjwOsa0+r0FGHwdm3nDd4DJc4LhiYMVahOue62gkWk9JiAHAdkUJVv0O1z593OXzsHkGor7VrApaDc0ekR5cKEoGeqQCTc6JAlFCDiAOB1T1zqbIMIt8V8fn9E92NUd6eUNjzVuG5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp/W9iPQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp/W9iPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E566E1F000FF;
	Sat, 12 Sep 2026 08:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201504;
	bh=Sjre8dGTOaZF7fahRzN7KLl1jHqP/PggpSps/fh0Vis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qp/W9iPQE1Ml9Q6sJJrK/dg0imh4Zn3r1ATdf+iMN6eKGQ4M40pKpv4W+Tl89St84
	 v34mvEDLVofeK3aP3odylC8XlVb6Wh2KRh+rRD7DjxoqaX2tHYj6sXkY8qvi2b+LKf
	 /JYwRkWjIyzhSnhcnklv2mNm9VEwwNkTaAWrI/hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0957/1815] arm_mpam: Apply T241-MPAM-6 to 63-bit counters
Date: Sat, 12 Sep 2026 08:45:07 +0200
Message-ID: <20260912065711.436735301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shanker Donthineni <sdonthineni@nvidia.com>

[ Upstream commit 2c43aced9be353f8428678a75495ca9d631dc927 ]

T241-MPAM-6 causes all MBWU counter formats to count 64-byte
requests instead of bytes. Commit dc48eb1ff27c excluded the 63-bit
MSMON_MBWU_LWD format while scaling the shorter counters. Systems
selecting the preferred 63-bit counter consequently report bandwidth
values that are 64 times too small.

Apply the scale to both the sampled value and overflow correction for
the 63-bit format. Unsigned arithmetic retains modulo-u64 behavior
when the scaled counter range exceeds u64.

Fixes: dc48eb1ff27c ("arm_mpam: Add workaround for T241-MPAM-6")
Link: https://lore.kernel.org/lkml/20240816131432.993859-1-sdonthineni@nvidia.com/
Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Tested-by: Fenghua Yu <fenghuay@nvidia.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 2f09f4b78bd3b..b68f5599e8dbe 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1196,8 +1196,7 @@ static u64 mpam_msmon_overflow_val(enum mpam_device_features type,
 {
 	u64 overflow_val = __mpam_msmon_overflow_val(type);
 
-	if (mpam_has_quirk(T241_MBW_COUNTER_SCALE_64, msc) &&
-	    type != mpam_feat_msmon_mbwu_63counter)
+	if (mpam_has_quirk(T241_MBW_COUNTER_SCALE_64, msc))
 		overflow_val *= 64;
 
 	return overflow_val;
@@ -1293,8 +1292,7 @@ static void __ris_msmon_read(void *arg)
 			now = FIELD_GET(MSMON___VALUE, now);
 		}
 
-		if (mpam_has_quirk(T241_MBW_COUNTER_SCALE_64, msc) &&
-		    m->type != mpam_feat_msmon_mbwu_63counter)
+		if (mpam_has_quirk(T241_MBW_COUNTER_SCALE_64, msc))
 			now *= 64;
 
 		if (nrdy)
-- 
2.53.0



