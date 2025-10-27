Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60AC320CCE;
	Mon, 27 Oct 2025 18:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591118; cv=none; b=MVuBCmMFkgG5OycgKcxQUQ4aXtyl3/ltUjo8tT0GHKBtlL8C32sFElIvGc7CAW/9gHd72NMiWC8m4jj1gdKL1d0j+01UbbwPJPhvssed4g3t1ZV81qx9nRGW6Az61DSqjZPEXOognXF8KQqUoV85yUeMYf0NF5dsXO+/UTI/Q18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591118; c=relaxed/simple;
	bh=GRJXASE2GiY2DIRP3CH0A5Bc+uPnvuhUXMP6QoW5hmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JDuXCwD/qHVMIaZtD2YLZNlD4eOncvhNmnpBqEHWVWHk5IOOv0/1gt1uezOdAJfTBIlCWYABTYCOFUEW/SDmEppTEKgNBYt++H7lvDaO0VZpkdYIJSQZMAS70hyHx1V1OnSsVcy7m+fMR5ynOGFGEP8enEGZNjoKiKAvg8brrQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbTUzwqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbTUzwqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63383C4CEF1;
	Mon, 27 Oct 2025 18:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591117;
	bh=GRJXASE2GiY2DIRP3CH0A5Bc+uPnvuhUXMP6QoW5hmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbTUzwqvM+M7TqjbWUcevHtyhzZ3Z90jaX20Ai+JYBQlXVXhcJOm7LM4zt4POOHH3
	 W0IF2+o/B74p1wIxuMDWvcOfu60pOVqpjPC19rcL/a6Cr8ie8TEAYrheTSgaOEAbZB
	 TD4QkdcWmje6LkWkZqWbnpX9xyZY1Kc8TWgC+mM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Leilk.Liu" <leilk.liu@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/332] i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD
Date: Mon, 27 Oct 2025 19:31:30 +0100
Message-ID: <20251027183525.599932299@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 265635db29aa5..79d0ac12a9930 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1065,6 +1065,7 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 {
 	int ret;
 	int left_num = num;
+	bool write_then_read_en = false;
 	struct mtk_i2c *i2c = i2c_get_adapdata(adap);
 
 	ret = mtk_i2c_clock_enable(i2c);
@@ -1078,6 +1079,7 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 		if (!(msgs[0].flags & I2C_M_RD) && (msgs[1].flags & I2C_M_RD) &&
 		    msgs[0].addr == msgs[1].addr) {
 			i2c->auto_restart = 0;
+			write_then_read_en = true;
 		}
 	}
 
@@ -1102,12 +1104,10 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
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
@@ -1115,7 +1115,10 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
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



