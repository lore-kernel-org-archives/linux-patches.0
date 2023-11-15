Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2833DB95
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKqqQJGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036C8C433C7;
	Wed, 15 Nov 2023 20:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078434;
	bh=4n0Sp3541vOtlikAuTQa5M+BGK6jkOWNY92ohkWBxvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKqqQJGuLg2gOEVq0NDjKsNe+W48Ojgn1nQPKcjgatjZuzkff7hle0QY5IqkunOxK
	 Pju42QmxH0VagufnoWryj1syVCODGOl30myHjjbOj0u2Brh4g0nhPSx3b8FqzCeLoJ
	 FMXiHPSRsEpaJX2rcrM5pT/nNtvZ1qLYn2o1Qv44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 319/379] media: ov5640: Fix a memory leak when ov5640_probe fails
Date: Wed, 15 Nov 2023 14:26:34 -0500
Message-ID: <20231115192704.024816992@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 20290feaaeb76cc719921aad275ccb18662a7c3a ]

sensor->ctrls.handler is initialized in ov5640_init_controls(),
so when the sensor is not connected and ov5640_sensor_resume()
fails, sensor->ctrls.handler should be released, otherwise a
memory leak will be detected:

unreferenced object 0xc674ca80 (size 64):
   comm "swapper/0", pid 1, jiffies 4294938337 (age 204.880s)
   hex dump (first 32 bytes):
     80 55 75 c6 80 54 75 c6 00 55 75 c6 80 52 75 c6 .Uu..Tu..Uu..Ru.
     00 53 75 c6 00 00 00 00 00 00 00 00 00 00 00 00 .Su..........

Fixes: 85644a9b37ec ("media: ov5640: Use runtime PM")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index aa9e5a99fc536..e0019668a8f86 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3909,7 +3909,7 @@ static int ov5640_probe(struct i2c_client *client)
 	ret = ov5640_sensor_resume(dev);
 	if (ret) {
 		dev_err(dev, "failed to power on\n");
-		goto entity_cleanup;
+		goto free_ctrls;
 	}
 
 	pm_runtime_set_active(dev);
@@ -3933,8 +3933,9 @@ static int ov5640_probe(struct i2c_client *client)
 err_pm_runtime:
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
-	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 	ov5640_sensor_suspend(dev);
+free_ctrls:
+	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 entity_cleanup:
 	media_entity_cleanup(&sensor->sd.entity);
 	mutex_destroy(&sensor->lock);
-- 
2.42.0



