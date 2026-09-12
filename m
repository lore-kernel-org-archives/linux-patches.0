Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBE2486647;
	Sat, 12 Sep 2026 19:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240424; cv=none; b=Ysy5askyUTIatTzNXJQ8htDLAUzjtHq4CqDF/DCjC1triQlcimC1BYE/TdRhj9J2OS+ByT3l4/55lXbgVqNsJtWoi5ffNWDWymsKI8tlPcLWY78BXfsjQjia/wwAEs7XXl3n/YJhlx01jAPz5xXB3QE7vhINCJccUQCZESxNzLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240424; c=relaxed/simple;
	bh=MF8ItjXmWRNx1+4y4A4q6aoTvErlA2qtIkGvSp+kjNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2C1555rFxTVkIKokgZ+gaI1EHG1ktkKJDyy2avLzhep/0bhdVrE8+WG6vMVmQYX9spKCekhlv9N50c0FkFp0fZCGkGa7da5Z6a6t+g0enGHt6/xxdA5j+PYx3WsPNzX54A7w1AtijFrGt5VeMKxPiTkMMeKOCF1MkSoIRY+pTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+wCbdcu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+wCbdcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4D71F000FF;
	Sat, 12 Sep 2026 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240422;
	bh=EBy24brare31EINix9UN65vwSM/sTvpJj155ESgjALs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+wCbdcus8H0Kv/pEVd6/CEf4+vZfU0W/lcWArH7WaoHoUyvO6sP9997/xk7k8+Fn
	 YJNGuNZc/N4HCfbq9oOu77w5GDIVVXkTIBgeL86cRDZ9Wuq6if4KNxVOKcAmrm8IBj
	 wr+pkDoDhJhBOpNt4paOLccPvF9/ezwO3BckXZIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 858/935] i3c: mipi-i3c-hci: Switch PIO data allocation to devm_kzalloc()
Date: Sat, 12 Sep 2026 09:04:48 +0200
Message-ID: <20260912065546.504829327@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 11d17c2855bfc04550557017eae02e92f3eeab1c ]

The driver already uses managed resources, so convert the PIO data
structure allocation to devm_zalloc().  Remove the manual kfree().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 308ecb824db3 ("i3c: mipi-i3c-hci: Fix missing STAT_IBI_STATUS_THLD in PIO mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/pio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/pio.c b/drivers/i3c/master/mipi-i3c-hci/pio.c
index 653cee2d0645a..9f0e12d2b906a 100644
--- a/drivers/i3c/master/mipi-i3c-hci/pio.c
+++ b/drivers/i3c/master/mipi-i3c-hci/pio.c
@@ -141,7 +141,7 @@ static int hci_pio_init(struct i3c_hci *hci)
 	struct hci_pio_data *pio;
 	u32 val, size_val, rx_thresh, tx_thresh, ibi_val;
 
-	pio = kzalloc(sizeof(*pio), GFP_KERNEL);
+	pio = devm_kzalloc(hci->master.dev.parent, sizeof(*pio), GFP_KERNEL);
 	if (!pio)
 		return -ENOMEM;
 
@@ -219,8 +219,6 @@ static void hci_pio_cleanup(struct i3c_hci *hci)
 		BUG_ON(pio->curr_rx);
 		BUG_ON(pio->curr_tx);
 		BUG_ON(pio->curr_resp);
-		kfree(pio);
-		hci->io_data = NULL;
 	}
 }
 
-- 
2.53.0



