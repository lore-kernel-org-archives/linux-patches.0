Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91F947A62;
	Mon,  1 Apr 2024 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987882; cv=none; b=ii9FtjNScLF/mIPdDqkSmAHs+KSDsBsqfSMMNST3vaNVPrtheB0wK0OzUypGvDg0Cx3eCHGc+Cefk0Zx4g+gokDNysklYX51tgWfHhfZMIM9Pki1c1+d4z2Fp7skoXoKv/jtY6nuj7n+mHOo+/RkBdZKD/6mmcbL3jOLcjMIb50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987882; c=relaxed/simple;
	bh=8IlfY676se3SZMxGQIIUmGSXXBEfIIECAJMqgYjlKFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N63Q2BMjiew5+bf2osoCnXcK3bAFae0N2rd5l+MxIyQRcTT7JhMICtuu7w034Hwod7NzLU2i7K8gSHmpslOtss5AlR6a6uOAbQb1CVE5tgvFwti8lqRvQHaG+ACd1VMbO0oCBm9Q1M0ozEsknm4Hf9XL6iF21VxLm89jz9mASyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzWmxErB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzWmxErB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088D3C43390;
	Mon,  1 Apr 2024 16:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987882;
	bh=8IlfY676se3SZMxGQIIUmGSXXBEfIIECAJMqgYjlKFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzWmxErBYjmVl2yTurQz7eM7QgXKBnlOtEO2+/p7VGZghM5tzwtsN5FO4nTAGxPoc
	 sK06/BIKOq8+VZSQo8afjzidtc8FUkghIlmH9dH2A4/KnUftb3SASTm9LRTfo8qDgS
	 a6iXLKeVrLGE6HSQiMpYp8YFYOG0JEuXn6kZGm+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 020/432] media: mc: Fix flags handling when creating pad links
Date: Mon,  1 Apr 2024 17:40:07 +0200
Message-ID: <20240401152553.732236858@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index a6f28366106fb..7839e3f68efa4 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -1092,6 +1092,11 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
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
@@ -1107,7 +1112,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 
 	link->source = &source->pads[source_pad];
 	link->sink = &sink->pads[sink_pad];
-	link->flags = flags & ~MEDIA_LNK_FL_INTERFACE_LINK;
+	link->flags = flags;
 
 	/* Initialize graph object embedded at the new link */
 	media_gobj_create(source->graph_obj.mdev, MEDIA_GRAPH_LINK,
-- 
2.43.0



