Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCC5746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303AEC433C7;
	Sun, 17 Sep 2023 20:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982564;
	bh=n0UGtTvmpjWGKxpbvDMfno2ASHZ27UE1SiL2O5NEjKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaJND0zbAL5nVwl1dKFpiSaTBsZ4Vm2p/S7AZ2wTKFTnyy2HCx6cN4nXb7y/7Ndc1
	 Zlnp+1/1gJrNxo/f/CzHzg0iWKsAV7Gbe1sAJuGtphVjqSA4eovJQQP5fJkk03IvM8
	 ZsTqPbOA2lI89w9IfYoJ0ZYlfinPJrkl+7wwVUP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/511] media: ov2680: Fix regulators being left enabled on ov2680_power_on() errors
Date: Sun, 17 Sep 2023 21:11:55 +0200
Message-ID: <20230917191120.798266665@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 84b4bd7e0d98166aa32fd470e672721190492eae ]

When the ov2680_power_on() "sensor soft reset failed" path is hit during
probe() the WARN() about putting an enabled regulator at
drivers/regulator/core.c:2398 triggers 3 times (once for each regulator),
filling dmesg with backtraces.

Fix this by properly disabling the regulators on ov2680_power_on() errors.

Fixes: 3ee47cad3e69 ("media: ov2680: Add Omnivision OV2680 sensor driver")
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 0b9bc4a461c05..3059d1157bac3 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -475,7 +475,7 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 		ret = ov2680_write_reg(sensor, OV2680_REG_SOFT_RESET, 0x01);
 		if (ret != 0) {
 			dev_err(dev, "sensor soft reset failed\n");
-			return ret;
+			goto err_disable_regulators;
 		}
 		usleep_range(1000, 2000);
 	} else {
@@ -485,7 +485,7 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 
 	ret = clk_prepare_enable(sensor->xvclk);
 	if (ret < 0)
-		return ret;
+		goto err_disable_regulators;
 
 	sensor->is_enabled = true;
 
@@ -495,6 +495,10 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 	ov2680_stream_disable(sensor);
 
 	return 0;
+
+err_disable_regulators:
+	regulator_bulk_disable(OV2680_NUM_SUPPLIES, sensor->supplies);
+	return ret;
 }
 
 static int ov2680_s_power(struct v4l2_subdev *sd, int on)
-- 
2.40.1



