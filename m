Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADE7309EE2;
	Sat, 12 Sep 2026 19:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242088; cv=none; b=BaeNY3yfgAI0p3a8KlU3vXTVpdHhR6wCUML+HSkkOYqzO4oX5KId73blbPurILYWpbLPau0UrVyKamE+Gi0n04Y6+hKBo75mn22q90ZBejwC/o3uIYYASiThPvlwyOIkebbdCfBlt0p/e80agbFEJAsgtulXXRzDYprRT34hyKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242088; c=relaxed/simple;
	bh=W7qxdwfbUFfGNRvOGrKZenCAql+4G8taa72M3WYwtGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjeFc6o2v5HUp71dRZki+XonQ+qcFRyLpgbbvKLnbOa7xbC7ZTim0mLKlqdwGREFRZjzzDdUvNCWrFxqpI2yC3zb7lQHrLcgygLvGJt8RcuGxr9Vd/QxK/fmih9GdLc+s+1Kh1ixLRsTOQWII0lT8USgMGxHCg2F39wDy1YPvZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWcGMRq9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWcGMRq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869251F000FF;
	Sat, 12 Sep 2026 19:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242087;
	bh=2aakpRDq3Eh7nWFlTD9D9TMu8rQZy5ydx8/gjQC79Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWcGMRq9uuljQP3KSt6ZURj3MyGH1wbF1jJPt1WVrPIN283/mDbhvzp9KKxTHnl5t
	 azausOq8bEa3ENxshb+e/sruPHy35Suf0yC+3Oj7hb2b4bcYPb+0YhzYk8HRIpWPaU
	 fOtjDp+tpGXPvN7tlEVO7IlYkl6CckSGc2quFZCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 5.10 279/798] media: i2c: ov7740: fix use-after-destroy in remove
Date: Sat, 12 Sep 2026 08:58:27 +0200
Message-ID: <20260912065523.553219675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1159,10 +1159,8 @@ static int ov7740_remove(struct i2c_clie
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct ov7740 *ov7740 = container_of(sd, struct ov7740, subdev);
 
-	mutex_destroy(&ov7740->mutex);
-	v4l2_ctrl_handler_free(ov7740->subdev.ctrl_handler);
-	media_entity_cleanup(&ov7740->subdev.entity);
 	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&ov7740->subdev.entity);
 	ov7740_free_controls(ov7740);
 
 	pm_runtime_get_sync(&client->dev);


