Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF8CBA3F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139C3C433EF;
	Tue,  7 Mar 2023 17:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210693;
	bh=3mt4/Si+069yYsRqzcPvpa62Jure4uj9TPDeL57XWKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uedJPxe12omZgtxhg2OtwXyiWCF5v/BV4KeTNCxFL5uSLKI5WVkIrmj/KKv/mJdut
	 V88PjvSC6C3LmWKX4vxXAs4Ffr2bh5UPQURilWsRL8PyoYBxEdZyxeRRIwE9O+1SA+
	 3mBT6Bs9R7+IMMgKjMjQ0+lvf5BOa2yVKhiqvQ58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	coverity-bot <keescook+coverity-bot@chromium.org>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0593/1001] media: i2c: tc358746: fix ignoring read error in g_register callback
Date: Tue,  7 Mar 2023 17:56:05 +0100
Message-Id: <20230307170047.243782925@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 9d33802c8bcf96c4099ffea4f392afa52897e556 ]

Currently we ignore the return value of tc358746_read() and return
alawys return 0 which is wrong. Fix this by returning the actual return
value of the read operation which is either 0 on success or an error
value.

Addresses-Coverity-ID: 1527254 ("Error handling issues")

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Fixes: 80a21da36051 ("media: tc358746: add Toshiba TC358746 Parallel to CSI-2 bridge driver")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358746.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358746.c b/drivers/media/i2c/tc358746.c
index e7f27cbb57907..c5a0df300a06d 100644
--- a/drivers/media/i2c/tc358746.c
+++ b/drivers/media/i2c/tc358746.c
@@ -988,6 +988,7 @@ static int __maybe_unused
 tc358746_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
 	struct tc358746 *tc358746 = to_tc358746(sd);
+	int err;
 
 	/* 32-bit registers starting from CLW_DPHYCONTTX */
 	reg->size = reg->reg < CLW_DPHYCONTTX_REG ? 2 : 4;
@@ -995,12 +996,12 @@ tc358746_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 	if (!pm_runtime_get_if_in_use(sd->dev))
 		return 0;
 
-	tc358746_read(tc358746, reg->reg, (u32 *)&reg->val);
+	err = tc358746_read(tc358746, reg->reg, (u32 *)&reg->val);
 
 	pm_runtime_mark_last_busy(sd->dev);
 	pm_runtime_put_sync_autosuspend(sd->dev);
 
-	return 0;
+	return err;
 }
 
 static int __maybe_unused
-- 
2.39.2



