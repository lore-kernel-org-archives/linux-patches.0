Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C356B268C61;
	Tue,  8 Apr 2025 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112702; cv=none; b=MDgLwo97/nm7TgnD5dRqS694+KQ9yCsBgmtVcPR29mNBH+FgN5ZYkyEXwFT1Xu4+DFy+oz0n7aCS1HOSXrHs14pq8pkliJ7MzO/DhcLaZvBF/SrdOW3soLLhnRj9LVilLIoXqCYNvVKoeEjJ/eM2cyxjiIkqQlyy114awipungo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112702; c=relaxed/simple;
	bh=CyEA2eyzVaRvPIN/U59P4/SvwMb+LR+ql5UH+3fPLFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3rYpdEuwXOwmBf6gDeBV8Hqv+QjdHrjLlzDKQGrnY1N3oz6bb2TWF83gLqVpwOd4Ipt/yyBwKmO8vRkrR8V3hhtDN+GML8XggpzdbAjPQwivLGDbrmkQhfBuOxv40o+vID/0mMo2J6CoKvGnNQzAE36o8tuN+IQv7jvB/N3jAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss8Va528; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss8Va528"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F89C4CEE5;
	Tue,  8 Apr 2025 11:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112702;
	bh=CyEA2eyzVaRvPIN/U59P4/SvwMb+LR+ql5UH+3fPLFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss8Va528D+qmBCCtBF3LzRx0h4uQ9oxQL3WWKhtNNDt4y0/TvuJzEUNImbIflkJ73
	 1wkaCygp6zBg4zjuMvbzZAAoImpBOTVsimMFC5CyUwR50f0E9SSkPCIdK3H975+i4N
	 QlXUepGwu5stRzc/s7D6yuuVm3oRnD2+GXT2OZeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 127/279] media: i2c: et8ek8: Dont strip remove function when driver is builtin
Date: Tue,  8 Apr 2025 12:48:30 +0200
Message-ID: <20250408104829.771083281@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


