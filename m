Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F9421883E;
	Tue, 29 Apr 2025 17:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948051; cv=none; b=JHC8mnGc7sEkXl5pOcs8MEbuMP8Qz1vBrcScAPmhajJ/+YX9LdWzrnIlaNdhN+hh/u7guigBFAMk96t+Vmj/0qu8j93OD+dnPwEZRr1nFWUayhbCdeOm3SsgaFq++SNgBQvmUZgLfpQmcQKLVVYaErZoCFRDaTM0fKkMCttKu94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948051; c=relaxed/simple;
	bh=/nNF9/YFjnBfKSjnbSIYQmAhN4y+Amra8B4vSo2myB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe2odlC94r0w0GZLVmj+1UOSjQNrpKwi3dgJghsQJNSeWfKAcgEsnB7u3TSuops9J7MLraRMrNiTdBmAE81OW7feT6yLqS1wV5FG/weseh7UAwjU1sBk4LHb1cibDoq4bEWHvVul4Rat9to6owHTH/zDpC1aiRpJdwoPMe5smLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1ue6FeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1ue6FeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACDEC4CEE3;
	Tue, 29 Apr 2025 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948051;
	bh=/nNF9/YFjnBfKSjnbSIYQmAhN4y+Amra8B4vSo2myB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1ue6FeCK05QXLWgsuTa+ucVuN3Bnq2Z4UdtogZvQAJb2vul30pD90r3+z2f53cYF
	 04VFEe1Crp9/qw4Q4Abm2a/++cxo1C1zNgFfiGfYIgFcmtm9x9Agp5KSO5Flo/3LMd
	 btswodbCe41M0mRnTYfd3AXllf4gVLVPC3o4SAlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/280] i3c: master: svc: Add support for Nuvoton npcm845 i3c
Date: Tue, 29 Apr 2025 18:42:00 +0200
Message-ID: <20250429161122.433194622@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit 98d87600a04e42282797631aa6b98dd43999e274 ]

Nuvoton npcm845 SoC uses an older IP version, which has specific
hardware issues that need to be addressed with a different compatible
string.

Add driver data for different compatible strings to define platform
specific quirks.
Add compatible string for npcm845 to define its own driver data.

Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250306075429.2265183-3-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 42102baabcdda..7911814ad82ac 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -158,6 +158,10 @@ struct svc_i3c_regs_save {
 	u32 mdynaddr;
 };
 
+struct svc_i3c_drvdata {
+	u32 quirks;
+};
+
 /**
  * struct svc_i3c_master - Silvaco I3C Master structure
  * @base: I3C master controller
@@ -183,6 +187,7 @@ struct svc_i3c_regs_save {
  * @ibi.tbq_slot: To be queued IBI slot
  * @ibi.lock: IBI lock
  * @lock: Transfer lock, protect between IBI work thread and callbacks from master
+ * @drvdata: Driver data
  * @enabled_events: Bit masks for enable events (IBI, HotJoin).
  * @mctrl_config: Configuration value in SVC_I3C_MCTRL for setting speed back.
  */
@@ -214,6 +219,7 @@ struct svc_i3c_master {
 		spinlock_t lock;
 	} ibi;
 	struct mutex lock;
+	const struct svc_i3c_drvdata *drvdata;
 	u32 enabled_events;
 	u32 mctrl_config;
 };
@@ -1768,6 +1774,10 @@ static int svc_i3c_master_probe(struct platform_device *pdev)
 	if (!master)
 		return -ENOMEM;
 
+	master->drvdata = of_device_get_match_data(dev);
+	if (!master->drvdata)
+		return -EINVAL;
+
 	master->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(master->regs))
 		return PTR_ERR(master->regs);
@@ -1909,8 +1919,13 @@ static const struct dev_pm_ops svc_i3c_pm_ops = {
 			   svc_i3c_runtime_resume, NULL)
 };
 
+static const struct svc_i3c_drvdata npcm845_drvdata = {};
+
+static const struct svc_i3c_drvdata svc_default_drvdata = {};
+
 static const struct of_device_id svc_i3c_master_of_match_tbl[] = {
-	{ .compatible = "silvaco,i3c-master-v1"},
+	{ .compatible = "nuvoton,npcm845-i3c", .data = &npcm845_drvdata },
+	{ .compatible = "silvaco,i3c-master-v1", .data = &svc_default_drvdata },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, svc_i3c_master_of_match_tbl);
-- 
2.39.5



