Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33DA19B3C6;
	Thu,  6 Jun 2024 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683370; cv=none; b=L8Ll2cBHPf8k55o1QTq9X3mKDOuasg6ATfzGHv+4HSoY+ggdy8L12+J620+4XG1KRcCQFKOpZ5L7wce7QzE5/I/8q7oOHusSmXPJiWsZ6BkEWpkdnW9g4yLsftvfgtFBQBqQIYSKHy5LtQMyiz7Lnbn4L6QFa7hxIvGigtdgkUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683370; c=relaxed/simple;
	bh=huy62X8ZSEMy8IJbxSKpesklIn4e/aSvlQVhgRI/wng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aRWOs2PkUSP53jV6yeI/4SIiN2MhBHwrnD0PzkYZ9fb3vXAF9LZcNPgB19R49cG54gPszvoVWawxebLf4Bj/RfD3053yeuMwsvDMTGBFzziwj4NgRg09M5ipHXoPe98EhTpU3w+p1rwc5xFtRWK7DC4H3RSdjBU0XFTSkrUTyXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUWhITVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUWhITVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82037C2BD10;
	Thu,  6 Jun 2024 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683370;
	bh=huy62X8ZSEMy8IJbxSKpesklIn4e/aSvlQVhgRI/wng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUWhITVDunZWFmkohUIcEUmgzRyLNSs1fb4vFRIgE25tgtqzJwFtsRoTiDteyrCOl
	 /f4AmxE0B58+ubEg5TsTJmW/f5L8CrJ/oXv6JfU+zCRjnXmKx1Fnn6MDVZSdJqsSeH
	 6hvNlhcFgxjcW7Bw8mBUDsFsYcHHtjUrnFR8W7Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 312/744] media: i2c: et8ek8: Dont strip remove function when driver is builtin
Date: Thu,  6 Jun 2024 15:59:44 +0200
Message-ID: <20240606131742.416699399@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 545b215736c5c4b354e182d99c578a472ac9bfce ]

Using __exit for the remove function results in the remove callback
being discarded with CONFIG_VIDEO_ET8EK8=y. When such a device gets
unbound (e.g. using sysfs or hotplug), the driver is just removed
without the cleanup being performed. This results in resource leaks. Fix
it by compiling in the remove callback unconditionally.

This also fixes a W=1 modpost warning:

	WARNING: modpost: drivers/media/i2c/et8ek8/et8ek8: section mismatch in reference: et8ek8_i2c_driver+0x10 (section: .data) -> et8ek8_remove (section: .exit.text)

Fixes: c5254e72b8ed ("[media] media: Driver for Toshiba et8ek8 5MP sensor")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/et8ek8/et8ek8_driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
index d6fc843f9368e..0d6f0f8506f76 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -1460,7 +1460,7 @@ static int et8ek8_probe(struct i2c_client *client)
 	return ret;
 }
 
-static void __exit et8ek8_remove(struct i2c_client *client)
+static void et8ek8_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
@@ -1502,7 +1502,7 @@ static struct i2c_driver et8ek8_i2c_driver = {
 		.of_match_table	= et8ek8_of_table,
 	},
 	.probe		= et8ek8_probe,
-	.remove		= __exit_p(et8ek8_remove),
+	.remove		= et8ek8_remove,
 	.id_table	= et8ek8_id_table,
 };
 
-- 
2.43.0



