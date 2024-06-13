Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E1113C805;
	Thu, 13 Jun 2024 11:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279316; cv=none; b=NVQUxZJxhe1/iI/VaLnCtkie6w5ldXep1hN6e8gvbCSIJ8aZEIi7G576stV0rLqP7JsEuJVlqbdMDXoHRFSYPy/dodRQ8wlctjLXNVoAxbUlqr4Qdswk1cJ9/3hUCotSCxCLhS8v2V2DDbdZIh/QvgNyCBUYaEfEazUGGlJ/7lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279316; c=relaxed/simple;
	bh=a6VXqwB4ucFf30GQQzd9lom+CQ8mHCMamdiZy9lGOdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrC/RfL1SP01yNVJuGtkPkjf6/5U2WSA6E5f8utQoRuUaZW6OARUfjoLUqbg5MPd9ZAVvRgHXb5AoZ8mEMu3Ycm9jlW1Cu1unLqaMOiwV/H0CU/pXcKNka39lc1eU9d/i5i9eftHcxDhJ0Mm6ARFmo9n59KS6sOsqrh26Cz97hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtMeIsoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtMeIsoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCA2C2BBFC;
	Thu, 13 Jun 2024 11:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279316;
	bh=a6VXqwB4ucFf30GQQzd9lom+CQ8mHCMamdiZy9lGOdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtMeIsoPKupbRlu2RLwNISR+0NXUJFg3BjYZw5wE3AKnmghmrpLSEJ1tPZAWajto4
	 qOQiC86l4lujzhK6KtFwLGoWi9+0UWngZnU9++nuv8gIid95IywuyhxRK+9mugnTkP
	 oNCuxSjYx0Iqw1OZICIr2xKEwG4lBD/hmM9d90mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.9 035/157] media: mc: Fix graph walk in media_pipeline_start
Date: Thu, 13 Jun 2024 13:32:40 +0200
Message-ID: <20240613113228.776079704@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -619,6 +619,12 @@ static int media_pipeline_explore_next_l
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


