Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84847BA3F;
	Mon,  1 Apr 2024 16:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990732; cv=none; b=TiV1p03PBM2QTsnaGj0Q7/o76AS3miw9sz1cRX/QSvLLKlNbEOdEJzbBO754fjHZJk2q5+cCA5hurTLAl6xp6mTD3DGPbmXWe3A+Csd96KF1WDOPmZmDzQCKAfA7ufaBpSNzSG6VFJj//2ILonTiWCbiZ5bqChF7l6cLUvg8Nkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990732; c=relaxed/simple;
	bh=pHrHZ+s8m5DnyM6Vy2KzLfNQo7q/xCX63pjKi2Sbl6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOKLJWnxOK0XcGGKuDOMxe05UTvY69XqmdJIKXkOk1fpYwXIKH++8hzEKBFMI5kbv9hKgRoYCu2OZyaK4sU5T8EBqaj/TQCpEMi20xaWWgwgtS+9/S9nNxnoV3iTq0tU8amzVSuWHdPb+iSteVLKHxKuePDYuOa2QU1L15lKTIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYUGuWJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYUGuWJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103B8C433C7;
	Mon,  1 Apr 2024 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990732;
	bh=pHrHZ+s8m5DnyM6Vy2KzLfNQo7q/xCX63pjKi2Sbl6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYUGuWJganJwOdC8wA1IlEfmq1L+O+e5VBDcSxQUvwuf7Dbkq0R+WZS8S3yVVk8cK
	 eWril5xBRHmirpRi3uvJhk9EnluBI50uQW0+gswGfD+FJHI80yX83IH0x4QgxOGQ8o
	 cfGTNpWhYjpOyUDRXW/Wxd1TeU0Kis+Gz2RHqcFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/272] media: mc: Fix flags handling when creating pad links
Date: Mon,  1 Apr 2024 17:43:32 +0200
Message-ID: <20240401152531.036179888@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index 20a2630455f2c..688780c8734d4 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -1017,6 +1017,11 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
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
@@ -1032,7 +1037,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 
 	link->source = &source->pads[source_pad];
 	link->sink = &sink->pads[sink_pad];
-	link->flags = flags & ~MEDIA_LNK_FL_INTERFACE_LINK;
+	link->flags = flags;
 
 	/* Initialize graph object embedded at the new link */
 	media_gobj_create(source->graph_obj.mdev, MEDIA_GRAPH_LINK,
-- 
2.43.0



