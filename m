Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF121078F;
	Tue, 30 Jul 2024 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356881; cv=none; b=FoGIIoUVRE83IWzgv5ukozREvs6EQ37ifpQK83z5XxvS+RK+YivvXNs6CUhYs4SXHqebxDGaLUSHlr3TlsrT4E3gIguPuCp9ltwUEOAuo1EAeN/DgYl8ALbY770Ohxxq74TBhG9wSEO71puODAUNb8l7U0vObbNlxEzGcoGoUgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356881; c=relaxed/simple;
	bh=fSze8S6ji/qYggCjs/V+g9+B9FjlDFPvuvedDw+F01I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6AoFRw7DhzacsGwM12iJCerDUW3voDKODqx43HkI+ora1bPIjEffE7L7VsN2X5UIqQ5eXFiQ1VH8h62Q1d5G9KTMMHhvK0u8/WWJECJo4cxXDYeo3R0PXDPAjZQruptWm90zkTdqnJkxDcf+Ylcmw/T1dtLXTy3ETCZ+GqO0RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3e7hVIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3e7hVIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D455BC32782;
	Tue, 30 Jul 2024 16:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356881;
	bh=fSze8S6ji/qYggCjs/V+g9+B9FjlDFPvuvedDw+F01I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3e7hVIwydblLpa9dTGT6mMfvvxkvRd1h5aGJzr6ayD99J7INnoCVQGh/k2XnwQJQ
	 cUEyj909pp8kQFli/dS0OWwZe9Brjnbz33TsYMTt8RndYV8AT2yde5eCGIsEnMnil7
	 A8YAH41hSUHK0IgiNUmtUPtle5ecn97z5rDvjrU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiYuan Huang <cy_huang@richtek.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/568] media: v4l: async: Fix NULL pointer dereference in adding ancillary links
Date: Tue, 30 Jul 2024 17:45:00 +0200
Message-ID: <20240730151647.423293838@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 9b4667ea67854f0b116fe22ad11ef5628c5b5b5f ]

In v4l2_async_create_ancillary_links(), ancillary links are created for
lens and flash sub-devices. These are sub-device to sub-device links and
if the async notifier is related to a V4L2 device, the source sub-device
of the ancillary link is NULL, leading to a NULL pointer dereference.
Check the notifier's sd field is non-NULL in
v4l2_async_create_ancillary_links().

Fixes: aa4faf6eb271 ("media: v4l2-async: Create links during v4l2_async_match_notify()")
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
[Sakari Ailus: Reword the subject and commit messages slightly.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-async.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index eaa15b8df76df..ac4d987bba255 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -324,6 +324,9 @@ static int v4l2_async_create_ancillary_links(struct v4l2_async_notifier *n,
 	    sd->entity.function != MEDIA_ENT_F_FLASH)
 		return 0;
 
+	if (!n->sd)
+		return 0;
+
 	link = media_create_ancillary_link(&n->sd->entity, &sd->entity);
 
 #endif
-- 
2.43.0



