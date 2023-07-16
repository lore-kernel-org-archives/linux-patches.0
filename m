Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CE88F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8C4C433C7;
	Sun, 16 Jul 2023 20:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538780;
	bh=5rpOE4GsLknOK2Wrlcnwwt9DRdRQzV7IFxCEADy54xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GA7bkVNc/9L7SBUzxLCXKfR5s9tQwRmI/UyP7yTFgEn4X/oBOAktCuskNEMz2pHX
	 zj7jgsyp6vbD64L+bAhthY0W00za8ADxVjDBwlEyyZ+D+zpGts6BGRPblT2id4hGCO
	 9Hcm2iN8tmg9ylr4LB6eySefmBYWupmfEtUe5rHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 574/800] media: i2c: Correct format propagation for st-mipid02
Date: Sun, 16 Jul 2023 21:47:07 +0200
Message-ID: <20230716195002.418306573@linuxfoundation.org>
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

From: Daniel Scally <dan.scally@ideasonboard.com>

[ Upstream commit 306c3190b30d4d6a098888b9d7d4cefaa0ddcb91 ]

Format propagation in the st-mipid02 driver is incorrect in that when
setting format for V4L2_SUBDEV_FORMAT_TRY on the source pad, the
_active_ rather than _try_ format from the sink pad is propagated.
This causes problems with format negotiation - update the function to
propagate the correct format.

Fixes: 642bb5e88fed ("media: st-mipid02: MIPID02 CSI-2 to PARALLEL bridge driver")
Signed-off-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/st-mipid02.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/st-mipid02.c b/drivers/media/i2c/st-mipid02.c
index 31b89aff0e86a..f20f87562bf11 100644
--- a/drivers/media/i2c/st-mipid02.c
+++ b/drivers/media/i2c/st-mipid02.c
@@ -736,8 +736,13 @@ static void mipid02_set_fmt_source(struct v4l2_subdev *sd,
 {
 	struct mipid02_dev *bridge = to_mipid02_dev(sd);
 
-	/* source pad mirror active sink pad */
-	format->format = bridge->fmt;
+	/* source pad mirror sink pad */
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		format->format = bridge->fmt;
+	else
+		format->format = *v4l2_subdev_get_try_format(sd, sd_state,
+							     MIPID02_SINK_0);
+
 	/* but code may need to be converted */
 	format->format.code = serial_to_parallel_code(format->format.code);
 
-- 
2.39.2



