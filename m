Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C36125DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA19C433EF;
	Mon,  8 May 2023 11:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543797;
	bh=pE5gl9EvL/OdA3Y4k+18LmgyWphQyHz24/bYKXDKciU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UicswMY6fG8fECNSf9o7iw2LSzxKJGKw7HNUFo+ONqIIQpychRnVQ+jbv7vZeD3Ca
	 BS7FMfMzAmWZX42vW4lH8WtfS0VI4PtEaFkPJk/qdr0dS/G8FLF/INSsjbrN3CPeT0
	 UG3IMHQTnvoasP7me5so+ZF4bYRP3ACx40llJWBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 204/694] media: v4l: subdev: Make link validation safer
Date: Mon,  8 May 2023 11:40:39 +0200
Message-Id: <20230508094439.006176890@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 55f1ecb1199000932cf82e357841cc7498ac904f ]

Link validation currently accesses invalid pointers if the link passed to
it is not between two sub-devices. This is of course a driver bug.

Ignore the error but print a warning message, as this is how it used to
work previously.

Fixes: a6b995ed03ff ("media: subdev: use streams in v4l2_subdev_link_validate()")
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index b10045c02f434..9a0c23267626d 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -1236,6 +1236,16 @@ int v4l2_subdev_link_validate(struct media_link *link)
 	struct v4l2_subdev_state *source_state, *sink_state;
 	int ret;
 
+	if (!is_media_entity_v4l2_subdev(link->sink->entity) ||
+	    !is_media_entity_v4l2_subdev(link->source->entity)) {
+		pr_warn_once("%s of link '%s':%u->'%s':%u is not a V4L2 sub-device, driver bug!\n",
+			     !is_media_entity_v4l2_subdev(link->sink->entity) ?
+			     "sink" : "source",
+			     link->source->entity->name, link->source->index,
+			     link->sink->entity->name, link->sink->index);
+		return 0;
+	}
+
 	sink_sd = media_entity_to_v4l2_subdev(link->sink->entity);
 	source_sd = media_entity_to_v4l2_subdev(link->source->entity);
 
-- 
2.39.2



