Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEB38F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3277C433C8;
	Sun, 16 Jul 2023 20:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538778;
	bh=8M/JMwttDdJna+e2sGSEmjJKf9t9p0CDBzIIaqsNmXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FL/PSY+0y6f18OkCF+WDSVBe4MlyMUZTW+TT1YBLNaidU/06PXF2369gJmjaHUrl9
	 8TG1/xvqWcOe5buL3fd27FfBQsWJAYPtBLEEJ/SzABUksgHeSrYw+0gql8k4gvZNDd
	 +lHlFe618YiRQqre+YR3yni/IENK3iOtEG3gU4Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 573/800] media: i2c: imx296: fix error checking in imx296_read_temperature()
Date: Sun, 16 Jul 2023 21:47:06 +0200
Message-ID: <20230716195002.395194927@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 1b3565dbc6aa124f34674e3dcf6966f663817e05 ]

The "& IMX296_TMDOUT_MASK" means that "tmdout" can't be negative so the
error checking will not work.

Fixes: cb33db2b6ccf ("media: i2c: IMX296 camera sensor driver")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx296.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx296.c b/drivers/media/i2c/imx296.c
index 4f22c0515ef8d..c3d6d52fc7727 100644
--- a/drivers/media/i2c/imx296.c
+++ b/drivers/media/i2c/imx296.c
@@ -922,10 +922,12 @@ static int imx296_read_temperature(struct imx296 *sensor, int *temp)
 	if (ret < 0)
 		return ret;
 
-	tmdout = imx296_read(sensor, IMX296_TMDOUT) & IMX296_TMDOUT_MASK;
+	tmdout = imx296_read(sensor, IMX296_TMDOUT);
 	if (tmdout < 0)
 		return tmdout;
 
+	tmdout &= IMX296_TMDOUT_MASK;
+
 	/* T(°C) = 246.312 - 0.304 * TMDOUT */;
 	*temp = 246312 - 304 * tmdout;
 
-- 
2.39.2



