Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81069370AE5;
	Wed, 20 May 2026 16:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295069; cv=none; b=DAFFAkukCUKCqs5AloIL3+R9fjAXQNZ/vWm2SKPuvPfJ4J3mBpdIS4Hwl9+GgLg6cTLM1S19pez+BIog9Pq/dTf+gbZpNrZCojY/9RVt7+lFYu++zyI/Tvrr4NRym3XelMBwchpppCWIjBPQRne+ZipOazLCVwP3P2qW5l3YtLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295069; c=relaxed/simple;
	bh=Zlv498hCmdMzxVqIdjk/ZwujCSaOvxPNobCXBJ4wcnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKo8VIqWb1BovC+xM2gc6SNweEdiC0byACdh5Cqsg/GixLKIFgXaxZ2iqGBdZI1tqmj7u6hUPvbk95Kb4deHi4uhdPFM3SieFVNSlP6zNnXkYtxHVgn+0ls7WtU+Tiq5ooxJl2lE6bHwu52RPyWNthxkNLw/adwigndSlLGgb6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqbbMO0u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqbbMO0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBAE1F000E9;
	Wed, 20 May 2026 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295066;
	bh=C9oH5FtdcDJveJf+Oz9bGhJr8/UtrguHU99BV7e79Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AqbbMO0uyM9drzRRzAwujR+uZtuvU54CCsy5DKnqfUMjJOo3kPEkglpQ/Y+8JHK+Z
	 OTu3iSfuaHTAuFqId7ciMWBT8jcWTDbYTG5MKP6KV8O0fLOQ7nYUvCSIDIopmeZ84y
	 7jMdptUJ4HW89KRPKvC8tuUHB/Bc2CT0x/sqfjI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0278/1146] media: i2c: og01a1b: Fix V4L2 subdevice data initialization on probe
Date: Wed, 20 May 2026 18:08:48 +0200
Message-ID: <20260520162154.508504251@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 535b7f106991c7d8f0e5b8e1769bfb8b1ce9d3d6 ]

It's necessary to finalize the camera sensor subdevice initialization on
driver probe and clean V4L2 subdevice data up on error paths and driver
removal.

The change fixes a previously reported by v4l2-compliance issue of
the failed VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT test:

  fail: v4l2-test-controls.cpp(1104): subscribe event for control 'User Controls' failed

Fixes: 472377febf84 ("media: Add a driver for the og01a1b camera sensor")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/og01a1b.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/og01a1b.c b/drivers/media/i2c/og01a1b.c
index c7184de6251ae..7b892b26203c0 100644
--- a/drivers/media/i2c/og01a1b.c
+++ b/drivers/media/i2c/og01a1b.c
@@ -1042,6 +1042,7 @@ static void og01a1b_remove(struct i2c_client *client)
 	struct og01a1b *og01a1b = to_og01a1b(sd);
 
 	v4l2_async_unregister_subdev(sd);
+	v4l2_subdev_cleanup(&og01a1b->sd);
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	pm_runtime_disable(og01a1b->dev);
@@ -1153,11 +1154,18 @@ static int og01a1b_probe(struct i2c_client *client)
 		goto probe_error_v4l2_ctrl_handler_free;
 	}
 
+	ret = v4l2_subdev_init_finalize(&og01a1b->sd);
+	if (ret < 0) {
+		dev_err_probe(og01a1b->dev, ret,
+			      "failed to finalize subdevice init\n");
+		goto probe_error_media_entity_cleanup;
+	}
+
 	ret = v4l2_async_register_subdev_sensor(&og01a1b->sd);
 	if (ret < 0) {
 		dev_err(og01a1b->dev, "failed to register V4L2 subdev: %d",
 			ret);
-		goto probe_error_media_entity_cleanup;
+		goto probe_error_v4l2_subdev_cleanup;
 	}
 
 	/* Enable runtime PM and turn off the device */
@@ -1167,6 +1175,9 @@ static int og01a1b_probe(struct i2c_client *client)
 
 	return 0;
 
+probe_error_v4l2_subdev_cleanup:
+	v4l2_subdev_cleanup(&og01a1b->sd);
+
 probe_error_media_entity_cleanup:
 	media_entity_cleanup(&og01a1b->sd.entity);
 
-- 
2.53.0



