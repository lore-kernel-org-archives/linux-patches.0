Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B19B255E20;
	Thu, 17 Apr 2025 18:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914511; cv=none; b=SY/F3+sDowCfFD0uM/mhfofoQ93InFUeSiVNnpFsO0UDw04z+uGfGy+zffbjFmTAGKa+t3LIWxk1XVCQCjs00NF+Cojf6/GDq23CJQMclrIZ2/sxWMpaQynNRUO6QnnO/hd17FcwxwkN/sf8n0r1+3+xJtz8GTQloUEKQeP0hMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914511; c=relaxed/simple;
	bh=/1xj3wqTKZg9oJNLJJq5gHeCZHqamVV59ftOBQJ1tvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9yMayeUun81k1JIpcASSeLVE5FT4hSPC7XZvCuW8xZYNMhVwCqiDsSW//SfJ2SwzLku2fRKcb6FolKTYR7n4fG9s3/bfsTOw7rVHrQhWCgX1vYcBdhOK4LZUNhC1TZcodbZZ96fA+QReA2GvgFRPzS21PYJVdF/Frnf8FmNBUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obCvP6gb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obCvP6gb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80947C4CEE4;
	Thu, 17 Apr 2025 18:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914510;
	bh=/1xj3wqTKZg9oJNLJJq5gHeCZHqamVV59ftOBQJ1tvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obCvP6gbPxfbyStf/rXBgkCQny/2IRNXzTwgA4gvz7TNG1a3ALId3nQHOW6/6bh4C
	 hO972oTueOU85AdYZ0fObxub2sX2+RiBFtygG9Ft6IuuedgE6T/pNgqEnGH+e9g9XP
	 mBnuTFXl4whKLIyVWAvT3eS1AhG7/kNWvWu70pjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 238/414] media: i2c: imx319: Rectify runtime PM handling probe and remove
Date: Thu, 17 Apr 2025 19:49:56 +0200
Message-ID: <20250417175120.998298332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


