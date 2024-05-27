Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDBC17727;
	Mon, 27 May 2024 19:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838552; cv=none; b=UsxBMoAFbYtdprOw+PP7dr0Y6iCXrbk8wKCeGVrof1q7ElO9hyOjtQQvi9u/gbeuqKpqYJsc06724UlVUv+DciIrbZs4TqMmeYiP1kpJWmfRhfYQ3qA2U49RNpr9+2p5jRpyvJs2Mj7gI1mMxTiJ3c6MyeLyd48QG+TJoB0qoTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838552; c=relaxed/simple;
	bh=8AGymlFH+ZLlrFEzJ5P1SnSDrzJyd01WElJ+4A6JsYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YTadcJ3DvWxgAPiZ9x2oI7+TeOz70BOkGJ23XSE4stM5C9DcBQB4trrc7vG+s+nFlvHolrfHmcpXFDObCqqaV57lI/u85314cOQU1CpVP+X96/+1bdXrefC/HmB0bZzNi649y956DSvbFwqbx5beoySVnMtWpD74/0G0YwFxVCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ol04nIP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ol04nIP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B893C2BBFC;
	Mon, 27 May 2024 19:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838552;
	bh=8AGymlFH+ZLlrFEzJ5P1SnSDrzJyd01WElJ+4A6JsYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ol04nIP/yk90aMCviUVdMNQVirs4nFe/6I8mg4hnIcmysg41iS4rIULkVS3AY0K0N
	 5Niiz8f3iFcNEUyAkBGSoC6VrB6oGZ+pnJElElw+hQFvp0eGMqpYFx3NVQqiia4i5z
	 PqyXLV+DS+j04YUlxRbzzi/d+2SDSuyRX/0Zfg7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 397/493] media: i2c: et8ek8: Dont strip remove function when driver is builtin
Date: Mon, 27 May 2024 20:56:39 +0200
Message-ID: <20240527185643.259267649@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



