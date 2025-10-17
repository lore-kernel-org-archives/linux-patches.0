Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A8D330B00;
	Fri, 17 Oct 2025 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716036; cv=none; b=e4eT2jzWrFIYPObOL+Z2mPcc2Nug2D5L7AALYTTU6UfDyOW511fZ22f+6blaqthJ1dZV5YoBxNIfoXV+EKAnFWCDNXxeySaDsAAcEqxui7qI/zFfjiU1dUO772WcsVYkpVNTN9HOuBbKiv6ZeWe5K1zROdQTJ+5MzdUWd0R2Jjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716036; c=relaxed/simple;
	bh=GiZ7dwXX5mKeEer1tKWGmipym9oWDxAusoCk0uM4DHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhQNslh1DlhuD6D0Y2dFWdsLGsa040CWtWpbVwRvnjUi2oFP0xCpSMiwugB+4oG5Qp68qTM6MfOTxpl4IPwWO9y+aL9Cx3VSM+S04yISuK2n6z3PCgMjQsU6iUY+/4GotI5jU0iiLmtl0yNATB2suDMTtXqAvfAEbCLo0FiVRN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQUTzijt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQUTzijt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179FFC4CEE7;
	Fri, 17 Oct 2025 15:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716034;
	bh=GiZ7dwXX5mKeEer1tKWGmipym9oWDxAusoCk0uM4DHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQUTzijtTBiQVu/JtnvH9T6+5Ch54a7m38wGKllyTHlcNVH74UeUaFEW5O2JvnZRF
	 Kwux3Ub69cFynDkMtTMRjVoUb3438nILtCemALCrS9f/S1/prKaOKLA0ptiQXXED79
	 /k23p7gGbEGY/K9aZUtrB7j52sAkxg4W8iaZ2QXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Leilk.Liu" <leilk.liu@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/276] i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD
Date: Fri, 17 Oct 2025 16:52:24 +0200
Message-ID: <20251017145144.352103453@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leilk.Liu <leilk.liu@mediatek.com>

[ Upstream commit b492183652808e0f389272bf63dc836241b287ff ]

The old IC does not support the I2C_MASTER_WRRD (write-then-read)
function, but the current code’s handling of i2c->auto_restart may
potentially lead to entering the I2C_MASTER_WRRD software flow,
resulting in unexpected bugs.

Instead of repurposing the auto_restart flag, add a separate flag
to signal I2C_MASTER_WRRD operations.

Also fix handling of msgs. If the operation (i2c->op) is
I2C_MASTER_WRRD, then the msgs pointer is incremented by 2.
For all other operations, msgs is simply incremented by 1.

Fixes: b2ed11e224a2 ("I2C: mediatek: Add driver for MediaTek MT8173 I2C controller")
Signed-off-by: Leilk.Liu <leilk.liu@mediatek.com>
Suggested-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 72acda59eb399..03e5d488f874f 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1067,6 +1067,7 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 {
 	int ret;
 	int left_num = num;
+	bool write_then_read_en = false;
 	struct mtk_i2c *i2c = i2c_get_adapdata(adap);
 
 	ret = mtk_i2c_clock_enable(i2c);
@@ -1080,6 +1081,7 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 		if (!(msgs[0].flags & I2C_M_RD) && (msgs[1].flags & I2C_M_RD) &&
 		    msgs[0].addr == msgs[1].addr) {
 			i2c->auto_restart = 0;
+			write_then_read_en = true;
 		}
 	}
 
@@ -1104,12 +1106,10 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 		else
 			i2c->op = I2C_MASTER_WR;
 
-		if (!i2c->auto_restart) {
-			if (num > 1) {
-				/* combined two messages into one transaction */
-				i2c->op = I2C_MASTER_WRRD;
-				left_num--;
-			}
+		if (write_then_read_en) {
+			/* combined two messages into one transaction */
+			i2c->op = I2C_MASTER_WRRD;
+			left_num--;
 		}
 
 		/* always use DMA mode. */
@@ -1117,7 +1117,10 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 		if (ret < 0)
 			goto err_exit;
 
-		msgs++;
+		if (i2c->op == I2C_MASTER_WRRD)
+			msgs += 2;
+		else
+			msgs++;
 	}
 	/* the return value is number of executed messages */
 	ret = num;
-- 
2.51.0



