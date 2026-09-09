Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D2F568FD3;
	Wed,  9 Sep 2026 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964052; cv=none; b=IdMx6/BMzQ/rpoySsyjb1ZsVHR60NajDaTdwfmlPXx4dugjhofgS9eZ4Me0GY61f1+vuL3weTgIL/6QIxBAdZIC9kRG7EvI9+oR4YBVdTftUW2+Or5JM12BvQLbfystv7JoDshZXB4VWd42dEwlKjuoVr7I8hHo4EcF/oZ5xC9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964052; c=relaxed/simple;
	bh=hKnSBmJt1nweig/rlc13Q+k5q9L3u4vftdvf9QYNa9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqdvxeCyBF4poNb4CopRrqvKEWOdFugaTmjEVRfT7gV01iA9oP0bzShzKyqY834bygVHcniBO15Iqn/0ol4Ysy4pk3JyorfrODrcF7dV4+QqOkfhuBgx5je8tTicXVnnFlRAPm30P+9MitumNiqsfITuMDo5rcug5mkNUXaSu0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epq/ym6q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epq/ym6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C811F00A3E;
	Wed,  9 Sep 2026 14:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964051;
	bh=W9fxWGcyYxjJoXefh84DqYowU1S1y4wlPQCF21AIzHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epq/ym6qjV/lGxMXif0jCx3WaKmBhdfC1qu/6V/yrYyl7/jY3e6BiP/da/PEQohdm
	 23HOAedayDklUQIpuOlOktRqxFrAUcm/BMtdHO0NraoXMqfc314CHR1n0kGEwGnU96
	 JzZSsWeCYwl3AkfVhh4NA991l2bHiQBAq3tabQqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@collabora.com>,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 290/583] media: i2c: imx415: Return test pattern write errors
Date: Wed,  9 Sep 2026 15:39:35 +0200
Message-ID: <20260909134248.083460386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>

commit 8cd5735b88d76dda80b089031747b6f18ee0bca2 upstream.

imx415_set_testpattern() accumulates failures from cci_write(), but drops
the value and always returns success. Return the accumulated error so V4L2
reports failures to userspace.

Fixes: d5df1c7f3f83 ("media: i2c: imx415: Convert to new CCI register access helpers")
Cc: stable@vger.kernel.org
Reviewed-by: Michael Riesch <michael.riesch@collabora.com>
Signed-off-by: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx415.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx415.c
+++ b/drivers/media/i2c/imx415.c
@@ -686,7 +686,7 @@ static int imx415_set_testpattern(struct
 		cci_write(sensor->regmap, IMX415_DIG_CLP_MODE, 0x01, &ret);
 		cci_write(sensor->regmap, IMX415_WRJ_OPEN, 0x01, &ret);
 	}
-	return 0;
+	return ret;
 }
 
 static int imx415_s_ctrl(struct v4l2_ctrl *ctrl)


