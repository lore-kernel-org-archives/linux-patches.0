Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3392D0C94;
	Sat, 12 Sep 2026 19:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239811; cv=none; b=FJsVCvqM6bIXZG+n2/X+jKWIHY/FHrovjR6P1DYZ45bYCb+ItEHEQp+s5fAYX7HB3ty3nRExLIm3vKYhvMbyEuY0Vzq+8TvPUxmZS7uuRgAde5icpn0/vKzYXFlnUbZlNg0gGmeOkOuwvsspCtUQIOZwNJ/fm9Xa4WHkGj0WD0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239811; c=relaxed/simple;
	bh=GIAAegk81yCY6RSP0QsnwcTOc1U/rddEjrjV2hh/RJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTHmLHr3Pp5Rkzs4b6fUQfR/BJODIF7tMMFxDAq1TKJV7Cuxt5PFNnMHy6424Rtzmkct4xHblMxsdaL/gjJBD4E0dnuUw/pI310n5FvqQNYGaQypcrL8l/FzQFH2gX6nHp3ZqxWl4n/UC2TzApGpOFRVvedl4hkmALEgraN9saA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZ62F2t/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZ62F2t/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846F61F000FF;
	Sat, 12 Sep 2026 19:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239810;
	bh=ihX/x78oJzcbNj+cL/NY15UW5xvtKGF7RnJebSlyc4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZ62F2t/P9+AiR/sz9p4yLhqxCg8W7b9nijF4l1rxYn6uc8WocFrF1UHe+0D72GBA
	 gz2dFsJZIQRHQmaSJA/nvDr2ox1OB/gyMdiXN07yEqxJVFGf1lsZzgNVJHWw6HKjon
	 m/4F9AT4jokP1TBzPet2YXqHbkXA1eq0WAcVoxts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 740/935] coresight: etm4x: fix wrong check of etm4x_sspcicrn_present()
Date: Sat, 12 Sep 2026 09:02:50 +0200
Message-ID: <20260912065543.803906661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 0e1cd4270b42a257c139165622091e1e8c7104a7 ]

According to Embedded Trace Macrocell Architecture Specification
ETMv4.0 to ETM4.6 [0], TRCSSPCICR<n> is present only if all of
the following are true:

  - TRCIDR4.NUMSSCC > n.
  - TRCIDR4.NUMPC > 0b0000.
  - TRCSSCSR<n>.PC == 0b1.

Comment for etm4x_sspcicrn_present() is align with the specification.
However, the check should use drvdata->nr_pe_cmp to check TRCIDR4.NUMPC
not nr_pe.

Link: https://developer.arm.com/documentation/ihi0064/latest/ [0]
Fixes: f6a18f354c58 ("coresight: etm4x: Handle access to TRCSSPCICRn")
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260725113645.57519-2-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 1b91448f546d6..149fbed92a9da 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -82,7 +82,7 @@ struct etm4_init_arg {
 static inline bool etm4x_sspcicrn_present(struct etmv4_drvdata *drvdata, int n)
 {
 	return (n < drvdata->nr_ss_cmp) &&
-	       drvdata->nr_pe &&
+	       drvdata->nr_pe_cmp &&
 	       (drvdata->config.ss_status[n] & TRCSSCSRn_PC);
 }
 
-- 
2.53.0



