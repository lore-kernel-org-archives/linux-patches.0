Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C23D1A619E;
	Tue, 30 Jul 2024 16:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357797; cv=none; b=p9iKMdLg9z72zjpFwl3MCxfR+5YfEZ7oUQnqn5HChCpItfnz5NO1M0YA+hg7pcgZd/WjjvnFQaE+QqiEHJAjUzTM1A06U/54NZ/6aUBHCD/b/sSK1QNC5NTIcfZ5/rNKKgqJI5p4uAcR81qQ+D547mHEfYtJrXyh0qi/ItDDu7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357797; c=relaxed/simple;
	bh=/vt93KaJL+UMPmTSx+ZNwTuw5IXgwl2WWJssgyEd2oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5Pp7D3f2rworfxdCeurTOCO62C4zyEI8mrOrPfCZKrX6gQ7Cgzhl+SiUtYVZIC/Hh9qRJuF7PjvqYXZQ7pED4TgAN4DKHAts9GUXD2ncDLkfYxSKeTwbc6vZxG22UsN4CAe/SeTVsSB+76FxaJlwxYghF4bryxOK35Z9mp1jjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BUWyBZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BUWyBZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6B0C32782;
	Tue, 30 Jul 2024 16:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357797;
	bh=/vt93KaJL+UMPmTSx+ZNwTuw5IXgwl2WWJssgyEd2oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BUWyBZctFYTB5uTUOQm6E2OrHcZYFUmgl6IEchkdJSCu1pbD1PEoD47eGff4aV2D
	 utfsl4cyf13EOaRogzdtQQws+OdnBCj+7jedOkDeiL+hOyttpcE9bdS2gVb01GvYQ9
	 td1tc9ZEGsR9sTekvwkyLXBFNKxEyX3SNsCi9p/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiYuan Huang <cy_huang@richtek.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 293/809] media: v4l: async: Fix NULL pointer dereference in adding ancillary links
Date: Tue, 30 Jul 2024 17:42:49 +0200
Message-ID: <20240730151736.165510835@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 222f01665f7ce..c477723c07bf8 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -323,6 +323,9 @@ static int v4l2_async_create_ancillary_links(struct v4l2_async_notifier *n,
 	    sd->entity.function != MEDIA_ENT_F_FLASH)
 		return 0;
 
+	if (!n->sd)
+		return 0;
+
 	link = media_create_ancillary_link(&n->sd->entity, &sd->entity);
 
 	return IS_ERR(link) ? PTR_ERR(link) : 0;
-- 
2.43.0



