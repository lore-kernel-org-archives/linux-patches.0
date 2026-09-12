Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE96342882B;
	Sat, 12 Sep 2026 11:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213799; cv=none; b=LrHSaTVR/w6ppHnsw8IX/tlys2J3mktucfXIHzbQ3PRoLF3/Jn9Pk7bzOhEwK5u8PLws8DpkX847FTnaiF85thDl6N4unyiU4m74t32nKHpCqBMB/MDko1rm3AgU3O4SfML0DshDb8FI63su7Gl4LXNuYseA+UpGljPVG3BX5HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213799; c=relaxed/simple;
	bh=/c+4oa4IBs8VCCj7LEmWwNGFLo0rK8x3wOPTZH5e5Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMfbcb79nGlO3nvRU4gX0gy2KUnv2czgXnJoSVnWLqB8M7/+3HAm0CzUnbGdIdblUuFwsOnFktn7fKVPR59evO6tnUl0lvipX3dsgDSwLj7DXzXnivjVIgYnNiz45IPSCDcV9384Z7TWMu2zusqIe3hgDpipmX0/VLHJZnbmIkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDhNyfZf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDhNyfZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F241F000FF;
	Sat, 12 Sep 2026 11:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213797;
	bh=2NIp24rzUdTanxXhw9kEU5uLbGTY41Iada1q2Ztp2i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDhNyfZfOsVIg+LaNOuCGuJR4UCweJBJ6Hzqbb1eU+qSNpyyq+MnSTvlMS4k7bljL
	 ifdAmuiRJu9y0SCozbbcJz57R+pFbRmOWPkMaDxjcjI+QGI95t1jyalRAXNZIB2MB+
	 oWohVZBTk5f40hsqedqcboAWHBif79wAkRaQSibY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.12 0196/1376] media: i2c: ov7740: fix use-after-destroy in remove
Date: Sat, 12 Sep 2026 08:43:42 +0200
Message-ID: <20260912065611.918192131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

commit 5d1b3dea5a44124bab6c14a2d71b977dabed54e7 upstream.

The ov7740_remove() function had a severe teardown order bug where it
destroyed the driver's mutex before freeing the V4L2 control handler
which relies on that mutex, leading to a use-after-destroy kernel panic.
Furthermore, the driver explicitly called v4l2_ctrl_handler_free() and
mutex_destroy() sequentially, but then called ov7740_free_controls()
which invokes both of them a second time, resulting in a double-free.

This patch fixes the issue by unregistering the subdevice first, and
relying exclusively on ov7740_free_controls() to safely tear down the
mutex and control handler in the correct order.

Fixes: 39c5c4471b8d ("media: i2c: Add the ov7740 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov7740.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -1119,10 +1119,8 @@ static void ov7740_remove(struct i2c_cli
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct ov7740 *ov7740 = container_of(sd, struct ov7740, subdev);
 
-	mutex_destroy(&ov7740->mutex);
-	v4l2_ctrl_handler_free(ov7740->subdev.ctrl_handler);
-	media_entity_cleanup(&ov7740->subdev.entity);
 	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&ov7740->subdev.entity);
 	ov7740_free_controls(ov7740);
 
 	pm_runtime_get_sync(&client->dev);


