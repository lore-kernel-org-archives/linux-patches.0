Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA3D218EB1;
	Mon, 27 Oct 2025 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590396; cv=none; b=LtXQ/Rpn7tpQyVvZBjix3BEZ56CpL/ky49Eqs9MCqEGjCSBxrzjbuXovzx8HCBNvuEyqmR+u9M78ShUapWu7oIXK5gdpPQwb3iKpwdSjpw4d5jSVh9mCMmFR+Is7BZyWPM6ns03mrYHE524iJ2RpSBuJVkuc3aaY32oOYb7/KjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590396; c=relaxed/simple;
	bh=cSkJ8ddCQZVc02kK4DTBkAeMUxPSaYCqEtuuoCbAIQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WWTRz0j8hbT/fzVrWN7HTr4RDSddq4zIJwVij+W5YAVjsgkTHtn6yBqsfwOiVcrBkTa7SzNcwevsW/JXXkpCcOyDNO0sNQPEcsZF7djM5XAbU0oqHq8pIsDEx7kNJy8EK1VvE77aja3t46iuEsWpj72ZMyIbggVq5eHsOejrYuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RK8JX9kN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RK8JX9kN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B29C113D0;
	Mon, 27 Oct 2025 18:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590396;
	bh=cSkJ8ddCQZVc02kK4DTBkAeMUxPSaYCqEtuuoCbAIQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RK8JX9kNtxbDb7ZoyxmUmoDkXsyKXtuKdWoHOVNO+yfPH+kJUPvbloRLaJ0FKp1gH
	 HsNsJ/c47w6uX+cIqbwIUke1dsWAQ1xBmEg8GIvzyFTpWk5NrWkvh+OSx1B7BulziO
	 Nd8wAKgZhqM0HbrOKTDtOU8Jr1+eF4P0KXEJ1XPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Leilk.Liu" <leilk.liu@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/224] i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD
Date: Mon, 27 Oct 2025 19:32:55 +0100
Message-ID: <20251027183509.786297134@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5587e7c549c4f..2b56ad08efed1 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -782,6 +782,7 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 {
 	int ret;
 	int left_num = num;
+	bool write_then_read_en = false;
 	struct mtk_i2c *i2c = i2c_get_adapdata(adap);
 
 	ret = mtk_i2c_clock_enable(i2c);
@@ -795,6 +796,7 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 		if (!(msgs[0].flags & I2C_M_RD) && (msgs[1].flags & I2C_M_RD) &&
 		    msgs[0].addr == msgs[1].addr) {
 			i2c->auto_restart = 0;
+			write_then_read_en = true;
 		}
 	}
 
@@ -818,12 +820,10 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
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
@@ -831,7 +831,10 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
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



