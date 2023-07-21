Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3402200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48216C433C7;
	Fri, 21 Jul 2023 19:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966244;
	bh=XrBunZsUmWLliryqiX80EASe8LCgoBdLE9X7NU4WnZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MCgdifBPBrnN5t7U8naiRR1t3mYAptEwQyIXLC5RcRTq9n16yyqqNlsgUyg9rY7N
	 9s9hA7wqwyKavnwyQta8gaCPOkHCVhrfTJV+t3ilcIUijXRTS/CmTTL4mDjUgi4GSe
	 tZAzX0MwJBMlWbj+2LvFdhCahEqQkjkfwEY/CWe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/532] media: i2c: Correct format propagation for st-mipid02
Date: Fri, 21 Jul 2023 18:02:59 +0200
Message-ID: <20230721160629.299692610@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index f630b88cbfaa9..cf55c57a79707 100644
--- a/drivers/media/i2c/st-mipid02.c
+++ b/drivers/media/i2c/st-mipid02.c
@@ -710,8 +710,13 @@ static void mipid02_set_fmt_source(struct v4l2_subdev *sd,
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



