Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFE32512EB;
	Thu,  3 Apr 2025 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693777; cv=none; b=H3M/a5ljeHjSmT+XFDi68va7ue5IVC2tO7889zO9n/E+2X+3VL6KSkJPC0II1ZxmG7weS8sHEexkxn++rVC1832pr+Y9IALKU4qfrHgcj80Rw7egV5SJemorE4aZjBWIX2xxzaoc9EoKerYbYh/6ehTjqq25dUhtW96RuVA+VI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693777; c=relaxed/simple;
	bh=cYmscPfGjl4WNWzynbyM7ygS8pIhhYBnuNAhbzvDLr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GDFXy8FT49dg9PEixHAch9uBrRxgTxyR5A9bKlmPGA3/kiuSlF6osA2BR4FVXukpqY2HiVuy8Qh7M3AIIX5DwGoUQ8ZvwNPz/4ITyBPtP7l1t4bQjPhSKzcv/Y6EWdbM71s0ChYOGXKWoXd2OFH1mR9IZFRSGnhO7beXhApa9Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFy0zXDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFy0zXDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A487BC4CEE7;
	Thu,  3 Apr 2025 15:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693777;
	bh=cYmscPfGjl4WNWzynbyM7ygS8pIhhYBnuNAhbzvDLr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFy0zXDxlLZDXZ1i5AVdFGTtpFsL0lT4v0FV0cO85gIbm47AmxEhlAYt7b8w/glVS
	 oUlDytphRxQgP+rPjgOwIdAf6+WfqoMCW+OuKCGzVbrJrALzAqaRkWaFE3ZI+CBRVj
	 lxLP/+6xFPdzRfyOGKHNDy529TCVGIfQLNp2WhCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 21/22] media: i2c: et8ek8: Dont strip remove function when driver is builtin
Date: Thu,  3 Apr 2025 16:20:16 +0100
Message-ID: <20250403151621.533638623@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
 drivers/media/i2c/et8ek8/et8ek8_driver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -1460,7 +1460,7 @@ err_mutex:
 	return ret;
 }
 
-static void __exit et8ek8_remove(struct i2c_client *client)
+static void et8ek8_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
@@ -1502,7 +1502,7 @@ static struct i2c_driver et8ek8_i2c_driv
 		.of_match_table	= et8ek8_of_table,
 	},
 	.probe_new	= et8ek8_probe,
-	.remove		= __exit_p(et8ek8_remove),
+	.remove		= et8ek8_remove,
 	.id_table	= et8ek8_id_table,
 };
 


