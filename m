Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C2D268FD5;
	Tue,  8 Apr 2025 10:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109940; cv=none; b=CSluW5VjpvbSfHnOQB0PsxHg2t/IXFEHMXJ8BkMLHgiG6GTxjiKlduWstINSSU98ChX3k5+U4vf26aIqS11EBoMt/x38LfAZskdp3bAVCjvA4zLnb9oxRU/V+tjX2rp8uirCzxEbXEY0QnNL6VAbInHpMOJwj8VoB3+dcEl8bAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109940; c=relaxed/simple;
	bh=QGKBAfV89xwA5igqBKk68PrF9bh3r8kdlvVMH/kY4xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RO9z1lNBLXAS9e9YSGReerb/sPOvAL+WNlP3Ka4zrzBq+45OZd3MeByjzesq60pu+74c8kO+wmkDyqG8quSwciLUH+r0odFg3s8W/HjppJ2PBoUL1xI0zRZk1ykxXN8BlNti1tvrZx4Y3I9JDREwTuGOgwQyL5rGalhAfqcaVyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSL2GaGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSL2GaGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE94C4CEE5;
	Tue,  8 Apr 2025 10:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109939;
	bh=QGKBAfV89xwA5igqBKk68PrF9bh3r8kdlvVMH/kY4xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSL2GaGQxx2VnItncjzACYyY1YAV5XcQBt8jdmbChNgVPOsDqzZNWD+Wx7vzqxSQN
	 qMJ4KILw8QUjF08oOkatju8fZZgDcfdcceJQFsmZFkv9AIleTO3oz3D5ANIHaYBe4C
	 kQAqDf4dbEwn6OXCYIGChHarJBugqPccYLkme+hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 109/227] media: i2c: et8ek8: Dont strip remove function when driver is builtin
Date: Tue,  8 Apr 2025 12:48:07 +0200
Message-ID: <20250408104823.623061481@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 545b215736c5c4b354e182d99c578a472ac9bfce upstream.

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
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/et8ek8/et8ek8_driver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -1460,7 +1460,7 @@ err_mutex:
 	return ret;
 }
 
-static int __exit et8ek8_remove(struct i2c_client *client)
+static int et8ek8_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
@@ -1504,7 +1504,7 @@ static struct i2c_driver et8ek8_i2c_driv
 		.of_match_table	= et8ek8_of_table,
 	},
 	.probe_new	= et8ek8_probe,
-	.remove		= __exit_p(et8ek8_remove),
+	.remove		= et8ek8_remove,
 	.id_table	= et8ek8_id_table,
 };
 


