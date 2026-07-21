Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7BC47125C;
	Tue, 21 Jul 2026 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657403; cv=none; b=ekr4cwyMsyELceUuq0ufL7s5UHDYeCBDfLaQq6ADB18Sa1koTUHZt//esGY0siOnY2lhFzWYng8d+CsX+YQxiLnm9FXEG527RvGn4xbkR2XMUF7TSuXCaX5LiUJu0f7EeUgMGhWHrERRhLQhdiY6c5UaTYws6UGpPTfX89WCi10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657403; c=relaxed/simple;
	bh=hVyttKQR6zkGqVeZZPGtmmPL0XEQU+cmEML0070Ob4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jF4P1gBBtB3FjtScJ6BjzsI8TJmcBe+JnwgGBK1HLB6VWGyj9ZLBTsw+cuz5/L1ngMIS2DtAakFV89nQzTOQe612iGyZPBidrO/BKkjO+cC5v6K7ZsPK+hY0bCJyKaAAuwzVmQ2Lh8qJjGZxKkIgftmplBgpmc5fwoIzeQcEiyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBH1tUgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBH1tUgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DD31F000E9;
	Tue, 21 Jul 2026 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657401;
	bh=gvrGWwSmXNL3zKh+QwAQVM4ufoukVf/hAyP/VeKkxC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBH1tUgIPzsT2U5gH26iCrp/8/lvzGxTDkq2x37c5F8FoqMk+B6W7880jVZGjRUfI
	 +UuTPOJ60wKAx6fHenkyotctPfJXlwpaOC2Qor5N2WO5cEtzArA1GQ7yrdrn0BCTM9
	 csZ0PaZfeV7UHv63kyptSkRHz/5ygNfo6golFvYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0752/1611] i3c: mipi-i3c-hci: Switch PIO data allocation to devm_kzalloc()
Date: Tue, 21 Jul 2026 17:14:28 +0200
Message-ID: <20260721152532.288207757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 11d17c2855bfc04550557017eae02e92f3eeab1c ]

The driver already uses managed resources, so convert the PIO data
structure allocation to devm_zalloc().  Remove the manual kfree().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 093eb8e73c90 ("i3c: mipi-i3c-hci: Preserve RUN bit when aborting DMA ring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/pio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/pio.c b/drivers/i3c/master/mipi-i3c-hci/pio.c
index bc8a011ef16823..35e6acc958a8e9 100644
--- a/drivers/i3c/master/mipi-i3c-hci/pio.c
+++ b/drivers/i3c/master/mipi-i3c-hci/pio.c
@@ -140,7 +140,7 @@ static int hci_pio_init(struct i3c_hci *hci)
 	struct hci_pio_data *pio;
 	u32 val, size_val, rx_thresh, tx_thresh, ibi_val;
 
-	pio = kzalloc(sizeof(*pio), GFP_KERNEL);
+	pio = devm_kzalloc(hci->master.dev.parent, sizeof(*pio), GFP_KERNEL);
 	if (!pio)
 		return -ENOMEM;
 
@@ -217,8 +217,6 @@ static void hci_pio_cleanup(struct i3c_hci *hci)
 		BUG_ON(pio->curr_rx);
 		BUG_ON(pio->curr_tx);
 		BUG_ON(pio->curr_resp);
-		kfree(pio);
-		hci->io_data = NULL;
 	}
 }
 
-- 
2.53.0



