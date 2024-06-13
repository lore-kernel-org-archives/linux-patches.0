Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A33144D36;
	Thu, 13 Jun 2024 12:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282908; cv=none; b=jlHeX1Gggj0hwJLOvlE4QOT51VXZcO7sGZG5LBKFpd74wadoHi3RM88HXymtkk8PB94ZGMtPHbr7VMB6AT55C8vSEF5Fpl3y3p9EedK2K+CSgtQB4UkQd9qgDXfZD6vaJe23x5LfA3Ipcxb4+05g5r05WNecUCsZaTsSYSBdS0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282908; c=relaxed/simple;
	bh=WCu0uCE1zbmbG962tRnlDoDOxyiz90uLovaGAI+w9qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYUuLx+4hwmymvD3PvtiptPJW1cPqPUlypV4liySE0vHJMl/8/XX5MQoaWqZt9irOs/PmyLksZoC+pAe/Z+TLDeGXb/efOd9EaHxK1jbHjywXnO0a8y/T+gmYXEVlIoGb4ENS662swFl0WNmlXZPMZhTyZ/KFFVuXc9pzKQJvNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfMeQ5xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfMeQ5xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E57C2BBFC;
	Thu, 13 Jun 2024 12:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282907;
	bh=WCu0uCE1zbmbG962tRnlDoDOxyiz90uLovaGAI+w9qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfMeQ5xr26GyPm8+Z1+Tu1+C5eCJp/wHSHe5hm8hKzHluThrvhBhjNyA76vc26x5V
	 TAzImjdKnEl7ZWB0TayCH5ZLoReT2zAqsCw/Fn0sgivvOnsPd0TMdLZpUYOBZm0uvG
	 +sBy+bjgk5QxLPtdiSuXc57ID6wxtkikd+Yhi6ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 34/85] media: mc: Fix graph walk in media_pipeline_start
Date: Thu, 13 Jun 2024 13:35:32 +0200
Message-ID: <20240613113215.461789794@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 8a9d420149c477e7c97fbd6453704e4612bdd3fa upstream.

The graph walk tries to follow all links, even if they are not between
pads. This causes a crash with, e.g. a MEDIA_LNK_FL_ANCILLARY_LINK link.

Fix this by allowing the walk to proceed only for MEDIA_LNK_FL_DATA_LINK
links.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc: stable@vger.kernel.org # for 6.1 and later
Fixes: ae219872834a ("media: mc: entity: Rewrite media_pipeline_start()")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/mc/mc-entity.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -593,6 +593,12 @@ static int media_pipeline_explore_next_l
 	link = list_entry(entry->links, typeof(*link), list);
 	last_link = media_pipeline_walk_pop(walk);
 
+	if ((link->flags & MEDIA_LNK_FL_LINK_TYPE) != MEDIA_LNK_FL_DATA_LINK) {
+		dev_dbg(walk->mdev->dev,
+			"media pipeline: skipping link (not data-link)\n");
+		return 0;
+	}
+
 	dev_dbg(walk->mdev->dev,
 		"media pipeline: exploring link '%s':%u -> '%s':%u\n",
 		link->source->entity->name, link->source->index,


