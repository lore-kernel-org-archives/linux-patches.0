Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E3115CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C958BC433D6;
	Tue,  8 Nov 2022 13:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915675;
	bh=Vje9gAoWu//vjHCQV2WQYJ3jC/VDrOWpj/Foi4eVcco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQ6tpCL6FAesOHEeBq5hg91icmNGyPIKNrP2mM4ucxBxMf6fG7F9c0PMIjskTxcW/
	 XSb4bCbQGdCbP/4/6DK69HguKY+yWXPpKsPwRsBLS6riVJyUPLJ0oN3tz/w5dkcfJ1
	 SpQo6JuOZ5VKysQ6LJ4bKX2GEnYuL45CfWn12t1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Paul Elder <paul.elder@ideasonboard.com>,
	Dafna Hirschfeld <dafna@fastmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/118] media: rkisp1: Zero v4l2_subdev_format fields in when validating links
Date: Tue,  8 Nov 2022 14:38:57 +0100
Message-Id: <20221108133343.276949855@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit c53e3a049f35978a150526671587fd46b1ae7ca1 ]

The local sd_fmt variable in rkisp1_capture_link_validate() has
uninitialized fields, which causes random failures when calling the
subdev .get_fmt() operation. Fix it by initializing the variable when
declaring it, which zeros all other fields.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkisp1/rkisp1-capture.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/rkisp1/rkisp1-capture.c b/drivers/staging/media/rkisp1/rkisp1-capture.c
index 0c934ca5adaa..8936f5a81680 100644
--- a/drivers/staging/media/rkisp1/rkisp1-capture.c
+++ b/drivers/staging/media/rkisp1/rkisp1-capture.c
@@ -1258,11 +1258,12 @@ static int rkisp1_capture_link_validate(struct media_link *link)
 	struct rkisp1_capture *cap = video_get_drvdata(vdev);
 	const struct rkisp1_capture_fmt_cfg *fmt =
 		rkisp1_find_fmt_cfg(cap, cap->pix.fmt.pixelformat);
-	struct v4l2_subdev_format sd_fmt;
+	struct v4l2_subdev_format sd_fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.pad = link->source->index,
+	};
 	int ret;
 
-	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	sd_fmt.pad = link->source->index;
 	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &sd_fmt);
 	if (ret)
 		return ret;
-- 
2.35.1



