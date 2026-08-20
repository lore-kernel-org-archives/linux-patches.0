Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E8F367B70;
	Thu, 20 Aug 2026 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238509; cv=none; b=iorb3waXWAq+ZNmf6BnvZgUUTTbNyEmzpEHu9XmbutFXXpLrJqEAs1I6/WCjkE0OxOUo7igA7yEmDi7qnxcMMk5tDYgDyKeyPU/u7aLXgPH485jHijAQIdVUh6Qe94XgRUOhPrN6D2nGv+Px//DfmtvYdntwAbm/Pcgbedd7JMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238509; c=relaxed/simple;
	bh=rmnX1HQUTDEBRSNJzF7HREBnHBXX54sSIvOiB+VR5rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkdppgwSPif6xy3L0fBQxm/gbhVIJlYiqR6AV3qDVFSLhuU72QMoJkCDl7KfoVCDgadiy+mT7rrOj5LMHYxkukoJ0YOp83r4znoCjL5W5wrOQWpy2IhG1S1I/VQaaq6I1KJLPjlvmspi65V/4WRS7OacIwe6WHCnAKzi9olPBXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyYCR05l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyYCR05l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675BD1F000E9;
	Thu, 20 Aug 2026 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238507;
	bh=gdDTrAlHlJBUkv0qEIz16cG/1PuQeKaMbzBSxP4IkS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyYCR05lDIYmMciFWmCaoBnF83KtI4RW08ztEZjAx7sBD9LW6Kw8LwZCBFqCaPvge
	 oiyg+Qa2J2CTRuVFX560Q1vJ1Ujr2pfJYrfD9WDEX1ludukjHuKrypPUJKPPO4lHno
	 L9xUm2gaWdTK0W56abacClvBCFB3m82WQDfGHArk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robby Cai <robby.cai@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 171/228] regulator: fp9931: Fix VPOS/VNEG voltage selector table
Date: Thu, 20 Aug 2026 16:55:13 +0200
Message-ID: <20260820145249.887817209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robby Cai <robby.cai@nxp.com>

[ Upstream commit 66694b5f90f3876fccb87bbd02b453cdc33b3ae4 ]

The VPOSNEG_table[] mapping does not match the FP9931 datasheet.

The datasheet defines the VPOS/VNEG voltage mapping as:

  00h-04h ->  7.04V (-7.04V)
  05h     ->  7.26V (-7.26V)
  06h     ->  7.49V (-7.49V)
  ...
  28h-3Fh -> 15.06V (-15.06V)

However, VPOSNEG_table[] has two issues:

1. Selector 0x00~0x04 should all map to 7.04V (5 entries), but the
   table has 6 entries of 7.04V, causing all subsequent entries to be
   shifted by one position.

2. Selectors 0x29~0x3F should all clamp to 15.06V (23 entries), but
   the table has only 41 entries. Any selector value above 0x28
   would result in an out-of-bounds table access.

Fix both issues by removing the duplicate 7.04V entry and appending
the missing 23 clamped 15.06V entries, bringing the table to the
correct size of 64 entries (0x00~0x3F).

Fixes: 12d821bd13d4 ("regulator: Add FP9931/JD9930 driver")
Signed-off-by: Robby Cai <robby.cai@nxp.com>
Link: https://patch.msgid.link/20260724103441.800522-2-robby.cai@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fp9931.c | 54 +++++++++-----------------------------
 1 file changed, 12 insertions(+), 42 deletions(-)

diff --git a/drivers/regulator/fp9931.c b/drivers/regulator/fp9931.c
index 002b41f53eff8..ff743a8b0dfe8 100644
--- a/drivers/regulator/fp9931.c
+++ b/drivers/regulator/fp9931.c
@@ -37,48 +37,18 @@ struct fp9931_data {
 };
 
 static const unsigned int VPOSNEG_table[] = {
-	7040000,
-	7040000,
-	7040000,
-	7040000,
-	7040000,
-	7040000,
-	7260000,
-	7490000,
-	7710000,
-	7930000,
-	8150000,
-	8380000,
-	8600000,
-	8820000,
-	9040000,
-	9270000,
-	9490000,
-	9710000,
-	9940000,
-	10160000,
-	10380000,
-	10600000,
-	10830000,
-	11050000,
-	11270000,
-	11490000,
-	11720000,
-	11940000,
-	12160000,
-	12380000,
-	12610000,
-	12830000,
-	13050000,
-	13280000,
-	13500000,
-	13720000,
-	13940000,
-	14170000,
-	14390000,
-	14610000,
-	14830000,
-	15060000,
+	7040000,  7040000,  7040000,  7040000,  7040000,            /* 00h-04h */
+	7260000,  7490000,  7710000,  7930000,  8150000,  8380000,  /* 05h-0Ah */
+	8600000,  8820000,  9040000,  9270000,  9490000,  9710000,  /* 0Bh-10h */
+	9940000,  10160000, 10380000, 10600000, 10830000, 11050000, /* 11h-16h */
+	11270000, 11490000, 11720000, 11940000, 12160000, 12380000, /* 17h-1Ch */
+	12610000, 12830000, 13050000, 13280000, 13500000, 13720000, /* 1Dh-22h */
+	13940000, 14170000, 14390000, 14610000, 14830000, 15060000, /* 23h-28h */
+	/* 29h-3Fh: clamped to 15.06V per datasheet */
+	15060000, 15060000, 15060000, 15060000, 15060000, 15060000,
+	15060000, 15060000, 15060000, 15060000, 15060000, 15060000,
+	15060000, 15060000, 15060000, 15060000, 15060000, 15060000,
+	15060000, 15060000, 15060000, 15060000, 15060000,
 };
 
 static const struct hwmon_channel_info *fp9931_info[] = {
-- 
2.53.0



