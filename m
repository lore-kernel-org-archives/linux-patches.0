Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB42E17E90E;
	Mon, 27 May 2024 19:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837242; cv=none; b=bqTxIaYP5hVAnBgk+igwRsvVz/O8Jf6G99qUPKsbSBAGfjELx5f5n0MQ64Kqh0ZvHfjKjsAZFiGk/v+Cvsf7kpXFwxu0xU1QYsmBGo3MedZ+ISQPbjuXdK0B9IjGE3lDFSV6hZniKQd7Jjoz9HAG8H/E8bEBrU+soI3R7LfLPi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837242; c=relaxed/simple;
	bh=B9AaKuQ0IoUlf8Noaz6Yi60kqBcd9V6WbVEfdDIF3nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j9Wxk8uUZPem5UxNxjvCQEMhJjJF+XbFU+8kwtM1+njfwd+Qs9Z3RejA6BOHh6Q5lEwNAmCL3gEQvWucfqew+AV+hHSSVSlvyoYAkdlWzhxYMMCzNUfQBpI3UK1mqM9HBYawNYs3sjejo8cuYO+ZwFyiHgK5/TZfZnpAgFzUV9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Za2zf8OD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Za2zf8OD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5B2C2BBFC;
	Mon, 27 May 2024 19:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837242;
	bh=B9AaKuQ0IoUlf8Noaz6Yi60kqBcd9V6WbVEfdDIF3nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Za2zf8ODrtayHQ9vJuNlv9N7o44uFHOaVWHgHJv0zsigW4fzNsd0qIVhCJYen1/2l
	 L52cZ4L9Kuhxx4TnL/IGpJX4IQs2UbWh38VFZ33fz3SpBA4bWT4QvlE1w+7Z5kKvpQ
	 zACCj0IApPq7xyXbLEB2NZ2KDwbypYKeBU2xsp6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 323/427] media: i2c: et8ek8: Dont strip remove function when driver is builtin
Date: Mon, 27 May 2024 20:56:10 +0200
Message-ID: <20240527185631.755062606@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index f548b1bb75fb9..e932d25ca7b3a 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -1475,7 +1475,7 @@ static int et8ek8_probe(struct i2c_client *client)
 	return ret;
 }
 
-static void __exit et8ek8_remove(struct i2c_client *client)
+static void et8ek8_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
@@ -1517,7 +1517,7 @@ static struct i2c_driver et8ek8_i2c_driver = {
 		.of_match_table	= et8ek8_of_table,
 	},
 	.probe		= et8ek8_probe,
-	.remove		= __exit_p(et8ek8_remove),
+	.remove		= et8ek8_remove,
 	.id_table	= et8ek8_id_table,
 };
 
-- 
2.43.0



