Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C05D4C3CC;
	Mon,  8 Jan 2024 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjB2htCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B66C433CC;
	Mon,  8 Jan 2024 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726779;
	bh=GD2N1bXiLQKaJqWL0eyjqAdjGdRAohvDtITXr7nmazY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjB2htCmVRcbtV1CbTQfCV1rAsf2l3iYy1SkOFriNYBIC0of5T1Z1+VAiuOUA4XM2
	 yPZ28tYp2UpwyGB21tQjYQG7SkblQQ2bj/JH+9HUNquNeA4Xalo0MxECEkM4ZcnBoX
	 BiXEBB8xyD1qsQJ8u9vB0Z2iXkGEgWnuvadRiz4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Marek Vasut <marex@denx.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/124] clk: si521xx: Increase stack based print buffer size in probe
Date: Mon,  8 Jan 2024 16:08:21 +0100
Message-ID: <20240108150606.430814041@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 7e52b1164a474dc7b90f68fbb40e35ccd7f7e2e2 ]

Increase the size of temporary print buffer on stack to fix the
following warnings reported by LKP.

Since all the input parameters of snprintf() are under control
of this driver, it is not possible to trigger and overflow here,
but since the print buffer is on stack and discarded once driver
probe() finishes, it is not an issue to increase it by 10 bytes
and fix the warning in the process. Make it so.

"
   drivers/clk/clk-si521xx.c: In function 'si521xx_probe':
>> drivers/clk/clk-si521xx.c:318:26: warning: '%d' directive output may be truncated writing between 1 and 10 bytes into a region of size 2 [-Wformat-truncation=]
      snprintf(name, 6, "DIFF%d", i);
                             ^~
   drivers/clk/clk-si521xx.c:318:21: note: directive argument in the range [0, 2147483647]
      snprintf(name, 6, "DIFF%d", i);
                        ^~~~~~~~
   drivers/clk/clk-si521xx.c:318:3: note: 'snprintf' output between 6 and 15 bytes into a destination of size 6
      snprintf(name, 6, "DIFF%d", i);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"

Fixes: edc12763a3a2 ("clk: si521xx: Clock driver for Skyworks Si521xx I2C PCIe clock generators")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310260412.AGASjFN4-lkp@intel.com/
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20231027085840.30098-1-marex@denx.de
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si521xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-si521xx.c b/drivers/clk/clk-si521xx.c
index ef4ba467e747b..5886bc54aa0e7 100644
--- a/drivers/clk/clk-si521xx.c
+++ b/drivers/clk/clk-si521xx.c
@@ -282,7 +282,7 @@ static int si521xx_probe(struct i2c_client *client)
 	const u16 chip_info = (u16)(uintptr_t)device_get_match_data(&client->dev);
 	const struct clk_parent_data clk_parent_data = { .index = 0 };
 	const u8 data[3] = { SI521XX_REG_BC, 1, 1 };
-	unsigned char name[6] = "DIFF0";
+	unsigned char name[16] = "DIFF0";
 	struct clk_init_data init = {};
 	struct si521xx *si;
 	int i, ret;
@@ -316,7 +316,7 @@ static int si521xx_probe(struct i2c_client *client)
 	/* Register clock */
 	for (i = 0; i < hweight16(chip_info); i++) {
 		memset(&init, 0, sizeof(init));
-		snprintf(name, 6, "DIFF%d", i);
+		snprintf(name, sizeof(name), "DIFF%d", i);
 		init.name = name;
 		init.ops = &si521xx_diff_clk_ops;
 		init.parent_data = &clk_parent_data;
-- 
2.43.0



