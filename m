Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979D8256C61;
	Thu, 17 Apr 2025 18:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913322; cv=none; b=EbWVzws1g3UMe659fk4suon0W4Ak190GsFQg/jI+JaNZMi1t3zhA619CYUM1cUEB0bwXhG6UYmiI2jmZhdx5jb/qmG+w5z/MS+ci32OzkyO7FeL/PeK925BbB/LTEfaNTBHl08ubMgqvZXZH5eFciT37zjaQsB6VOsVsZrKGPpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913322; c=relaxed/simple;
	bh=0To7sJ91rBwZp7lpdSuBFMhypy8JeXsUcvcY3DoqXLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/0mq95UL5rOxEzDu4fuoqJmZkAfNZNYCFvttFZkIGyvnnRFZlAFge1e5PBm2TVCHdLlZ+ZP6EnEUzfs2e4KcANJsBNKR510AROyUfPtQZZbNlhicnx9mmD2ZvhLGH8jSOWBJo0n97zqG63NvxgxsxNEcPqxBJDEOVCBgugKvQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSo9zIoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSo9zIoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E91C4CEE4;
	Thu, 17 Apr 2025 18:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913322;
	bh=0To7sJ91rBwZp7lpdSuBFMhypy8JeXsUcvcY3DoqXLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSo9zIoEgsbw822XwWE5esZ04CL+FFJjhnKUdhTp60ZbooB546kPFQir21OQglvtd
	 su/bjdnsI6ScGf9BM2cYEIvIZxGsWmsDeTQlkioRB4QNy5SJTH/qOlHjGqQX1ezoKK
	 hvIB2bBuqKmOTes4K8nHTd3QiJQaOS77eNdTuSms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 260/449] media: i2c: imx319: Rectify runtime PM handling probe and remove
Date: Thu, 17 Apr 2025 19:49:08 +0200
Message-ID: <20250417175128.474572810@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 5f5ffd3bc62b2e6c478061918b10473d8b90ac2d upstream.

Idle the device only after the async sub-device has been successfully
registered. In error handling, set the device's runtime PM status to
suspended only if it has been set to active previously in probe.

Also set the device's runtime PM status to suspended in remove only if it
wasn't so already.

Fixes: 8a89dc62f28c ("media: add imx319 camera sensor driver")
Cc: stable@vger.kernel.org # for >= v6.12
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx319.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/media/i2c/imx319.c
+++ b/drivers/media/i2c/imx319.c
@@ -2442,17 +2442,19 @@ static int imx319_probe(struct i2c_clien
 	if (full_power)
 		pm_runtime_set_active(&client->dev);
 	pm_runtime_enable(&client->dev);
-	pm_runtime_idle(&client->dev);
 
 	ret = v4l2_async_register_subdev_sensor(&imx319->sd);
 	if (ret < 0)
 		goto error_media_entity_pm;
 
+	pm_runtime_idle(&client->dev);
+
 	return 0;
 
 error_media_entity_pm:
 	pm_runtime_disable(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
+	if (full_power)
+		pm_runtime_set_suspended(&client->dev);
 	media_entity_cleanup(&imx319->sd.entity);
 
 error_handler_free:
@@ -2474,7 +2476,8 @@ static void imx319_remove(struct i2c_cli
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 
 	pm_runtime_disable(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
+	if (!pm_runtime_status_suspended(&client->dev))
+		pm_runtime_set_suspended(&client->dev);
 
 	mutex_destroy(&imx319->mutex);
 }


