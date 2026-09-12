Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701272D0C94;
	Sat, 12 Sep 2026 18:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237731; cv=none; b=Bvi7UdjNtbSI9gZu0265CO47cBCg1EcLyRD24hfa4WDACUXnbFtpQu/RjOvtomelgn+pO9O2QVPKy24l1/0BWcKd0PWx0bMqbMliKxMdeEx3Myx5cSAsQZwAlQCdh37xUrTv0oTAaLgmOWglYUq+qa+9oziebiDgCb5JwkVIqPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237731; c=relaxed/simple;
	bh=kb/jDhYzvAk5fc5JScoJKBSsR5eD9CJoU+o2oOv/g94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EI2J6/UnxU897pCYY2XWZY0CoAfZUgCDs6UiX3QgcdMdRNC5KuYb8IIIBOf4IqqxHPXpLEjsqv+ws7ZG9M1MjWfx8Q34LaPZnEX32qR7N/HKUNCawvYlCQuCosHgFXDsIZowG5yu03qtELqjv7f86ZqM1iaXdLccGp3gmqU94RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXXdMMXb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXXdMMXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4B91F000FF;
	Sat, 12 Sep 2026 18:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237730;
	bh=7bAQLpRqXuA7rhTta74LQ5vqFQQ4ifMTpM0Uu8pGQy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXXdMMXbynCPyIpqdcGIyQy4BJYhiuTY9tzXWkeWRI6Ioj/Y7XSLhzyvyRYAQKy7u
	 stn/ykHm30S3GH/MT11+2HwQfcpfV+xvuUeQ7hchwFb7pwZaYcpeHIePxGKOqro12h
	 A4P/hovJv/jZmgTawxW7keYsP8z539Ig81rjGBD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 5.15 319/935] media: i2c: ov7740: fix use-after-destroy in remove
Date: Sat, 12 Sep 2026 08:55:49 +0200
Message-ID: <20260912065534.121683750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1158,10 +1158,8 @@ static int ov7740_remove(struct i2c_clie
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct ov7740 *ov7740 = container_of(sd, struct ov7740, subdev);
 
-	mutex_destroy(&ov7740->mutex);
-	v4l2_ctrl_handler_free(ov7740->subdev.ctrl_handler);
-	media_entity_cleanup(&ov7740->subdev.entity);
 	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&ov7740->subdev.entity);
 	ov7740_free_controls(ov7740);
 
 	pm_runtime_get_sync(&client->dev);


