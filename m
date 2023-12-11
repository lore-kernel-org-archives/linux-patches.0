Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF05FBE0;
	Mon, 11 Dec 2023 18:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKvIMiRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4629AC433C7;
	Mon, 11 Dec 2023 18:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319676;
	bh=IKwGU2l78zLUo79iKglwBDrX4DAaADDNgt6QjdnHrpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKvIMiRGjaph0BCFGtVdZhtraeHMcfZHzONs0RKGTLz3yuGiUX5oinzOlVMpRMc+O
	 8zVuIjRMBlJeJ3h388VhA4J1aUoGQasO6amrWcGp4fdVE0M8r91+Q5dCxqx3IgNtvz
	 bPSA+Hp+U5jwjdwjezjfgxNNXcFBkR6SBBTiZeHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/244] coresight: ultrasoc-smb: Config SMB buffer before register sink
Date: Mon, 11 Dec 2023 19:21:26 +0100
Message-ID: <20231211182054.599426720@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 830a7f54db102c889a3fe1c0a225f369ac05f07f ]

The SMB dirver register the enable/disable sysfs interface in function
smb_register_sink(), however the buffer depends on the following
configuration to work well. So it'll be possible for user to access an
unreset one.

Move the config buffer operation to before register_sink().
Ignore the return value, if smb_config_inport() fails. That will
cause the hardwares disable trace path to fail, should not affect
SMB driver remove. So we make smb_remove() return success,

Fixes: 06f5c2926aaa ("drivers/coresight: Add UltraSoc System Memory Buffer driver")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20231114133346.30489-3-hejunhao3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/ultrasoc-smb.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/hwtracing/coresight/ultrasoc-smb.c b/drivers/hwtracing/coresight/ultrasoc-smb.c
index 0a0fe9fcc57f9..2f2aba90a5148 100644
--- a/drivers/hwtracing/coresight/ultrasoc-smb.c
+++ b/drivers/hwtracing/coresight/ultrasoc-smb.c
@@ -583,37 +583,32 @@ static int smb_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = smb_config_inport(dev, true);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, drvdata);
 	spin_lock_init(&drvdata->spinlock);
 	drvdata->pid = -1;
 
 	ret = smb_register_sink(pdev, drvdata);
 	if (ret) {
+		smb_config_inport(&pdev->dev, false);
 		dev_err(dev, "Failed to register SMB sink\n");
 		return ret;
 	}
 
-	ret = smb_config_inport(dev, true);
-	if (ret) {
-		smb_unregister_sink(drvdata);
-		return ret;
-	}
-
-	platform_set_drvdata(pdev, drvdata);
-
 	return 0;
 }
 
 static int smb_remove(struct platform_device *pdev)
 {
 	struct smb_drv_data *drvdata = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = smb_config_inport(&pdev->dev, false);
-	if (ret)
-		return ret;
 
 	smb_unregister_sink(drvdata);
 
+	smb_config_inport(&pdev->dev, false);
+
 	return 0;
 }
 
-- 
2.42.0



