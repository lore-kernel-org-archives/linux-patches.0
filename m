Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAD9125DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7650CC43444;
	Mon,  8 May 2023 10:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541889;
	bh=Zl3yB4I7jmLbr4Wjo08xzHw+k2BrZbWVxUBQSp+G6Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiMaYOsaQtVkojJNalwuX2pOfepHBiOeoAWEtOrdCyq2yfxHtqBsUPJqgbu7GMryD
	 KwLfvmarPqdK0JMfag8bxTKKeciEsb7tsc+MEMlkIspyOePwoiRPY/QJHs032QVXrm
	 obuyR28lSrgGLiOzFoLg9mkgmfVVGgAkkD7pyoU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 260/663] media: v4l: async: Return async sub-devices to subnotifier list
Date: Mon,  8 May 2023 11:41:26 +0200
Message-Id: <20230508094436.683528558@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit 5276c9df9c2ab9a43b534bfb56bdb10899cd3a22 ]

When an async notifier is unregistered, the async sub-devices in the
notifier's done list will disappear with the notifier. However this is
currently also done to the sub-notifiers that remain registered. Their
sub-devices only need to be unbound while the async sub-devices themselves
need to be returned to the sub-notifier's waiting list. Do this now.

Fixes: 2cab00bb076b ("media: v4l: async: Allow binding notifiers to sub-devices")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-async.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 2f1b718a91893..008a2a3e312e0 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -414,7 +414,8 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 
 /* Unbind all sub-devices in the notifier tree. */
 static void
-v4l2_async_nf_unbind_all_subdevs(struct v4l2_async_notifier *notifier)
+v4l2_async_nf_unbind_all_subdevs(struct v4l2_async_notifier *notifier,
+				 bool readd)
 {
 	struct v4l2_subdev *sd, *tmp;
 
@@ -423,9 +424,11 @@ v4l2_async_nf_unbind_all_subdevs(struct v4l2_async_notifier *notifier)
 			v4l2_async_find_subdev_notifier(sd);
 
 		if (subdev_notifier)
-			v4l2_async_nf_unbind_all_subdevs(subdev_notifier);
+			v4l2_async_nf_unbind_all_subdevs(subdev_notifier, true);
 
 		v4l2_async_nf_call_unbind(notifier, sd, sd->asd);
+		if (readd)
+			list_add_tail(&sd->asd->list, &notifier->waiting);
 		v4l2_async_cleanup(sd);
 
 		list_move(&sd->async_list, &subdev_list);
@@ -557,7 +560,7 @@ static int __v4l2_async_nf_register(struct v4l2_async_notifier *notifier)
 	/*
 	 * On failure, unbind all sub-devices registered through this notifier.
 	 */
-	v4l2_async_nf_unbind_all_subdevs(notifier);
+	v4l2_async_nf_unbind_all_subdevs(notifier, false);
 
 err_unlock:
 	mutex_unlock(&list_lock);
@@ -607,7 +610,7 @@ __v4l2_async_nf_unregister(struct v4l2_async_notifier *notifier)
 	if (!notifier || (!notifier->v4l2_dev && !notifier->sd))
 		return;
 
-	v4l2_async_nf_unbind_all_subdevs(notifier);
+	v4l2_async_nf_unbind_all_subdevs(notifier, false);
 
 	notifier->sd = NULL;
 	notifier->v4l2_dev = NULL;
@@ -805,7 +808,7 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	 */
 	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
 	if (subdev_notifier)
-		v4l2_async_nf_unbind_all_subdevs(subdev_notifier);
+		v4l2_async_nf_unbind_all_subdevs(subdev_notifier, false);
 
 	if (sd->asd)
 		v4l2_async_nf_call_unbind(notifier, sd, sd->asd);
-- 
2.39.2



