Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543021C0DE7;
	Mon,  1 Apr 2024 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989336; cv=none; b=laYAxA5hQBWg+goU4IvUM6byBzbivaC5WW++1yqzKfBNiJNiIGmYNrbjfw2Zjs7uUacEIdU/ra59UG9ffg0i4XvJtYZNKmZliUxFAr08cWNqiWOCwyIbC1aCKOalysyByWMT7HxW1rQmPY5qvPsdh064YSA/JszjZyJLF63cpjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989336; c=relaxed/simple;
	bh=CG3cfBVEmp/pUouHclVtKKQYayS1E2mUHstl88XVfHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGAlBnLSccxiCJ0ncInkek8OhhQSIlfgMPV/XR1YRcVYURESUbiPYNfphqMVkdsxiPBUR5bD+vk7DDUolgKlLjGIHuxfckpyBV5QADFZUGQHsWjE3ovNhiMmbvBr5fZqOOEi4SUrtNu5MO9Ewf3uVwS8qZe9frj1tDhBfsVwvbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHCU7/Js; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHCU7/Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BF0C433C7;
	Mon,  1 Apr 2024 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989336;
	bh=CG3cfBVEmp/pUouHclVtKKQYayS1E2mUHstl88XVfHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHCU7/JsGc/f8m8yatHqrzHBtMX6yQff9JzubcLcgdfCbWMQgJVKqFop8Oj+pE4gR
	 AxbD1yijEkNBZDlSr0rHWVY+J4r1JHPOZwBfiHNN75UgARwxT4bYBGIgDNJESpueQ6
	 f2awBIsnJBliggSQx5AaGP+yYmRYFd9bnmeHyP9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/396] media: mc: Fix flags handling when creating pad links
Date: Mon,  1 Apr 2024 17:41:08 +0200
Message-ID: <20240401152548.468848053@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 422f7af75d03d50895938d38bc9cb8be759c440f ]

The media_create_pad_link() function doesn't correctly clear reject link
type flags, nor does it set the DATA_LINK flag. It only works because
the MEDIA_LNK_FL_DATA_LINK flag's value is 0.

Fix it by returning an error if any link type flag is set. This doesn't
introduce any regression, as nobody calls the media_create_pad_link()
function with link type flags (easily checked by grepping for the flag
in the source code, there are very few hits).

Set the MEDIA_LNK_FL_DATA_LINK explicitly, which is a no-op that the
compiler will optimize out, but is still useful to make the code more
explicit and easier to understand.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/mc/mc-entity.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/mc/mc-entity.c b/drivers/media/mc/mc-entity.c
index 737fc14e92dd3..330d876f41945 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -1079,6 +1079,11 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	struct media_link *link;
 	struct media_link *backlink;
 
+	if (flags & MEDIA_LNK_FL_LINK_TYPE)
+		return -EINVAL;
+
+	flags |= MEDIA_LNK_FL_DATA_LINK;
+
 	if (WARN_ON(!source || !sink) ||
 	    WARN_ON(source_pad >= source->num_pads) ||
 	    WARN_ON(sink_pad >= sink->num_pads))
@@ -1094,7 +1099,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 
 	link->source = &source->pads[source_pad];
 	link->sink = &sink->pads[sink_pad];
-	link->flags = flags & ~MEDIA_LNK_FL_INTERFACE_LINK;
+	link->flags = flags;
 
 	/* Initialize graph object embedded at the new link */
 	media_gobj_create(source->graph_obj.mdev, MEDIA_GRAPH_LINK,
-- 
2.43.0



