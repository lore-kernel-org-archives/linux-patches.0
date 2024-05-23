Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A21414BF85;
	Thu, 23 May 2024 13:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470269; cv=none; b=UsXPN0t4WPrqZ/sL01KtocrAB9OgOK7TvDC6fDLpSyS3zDN5UOkoa5/bfBn1BtpO4XOZvR1xhyO9ZB9CDCq7Hk+QV650W9yc0pdYfBcLybCnC76AHUzPRVisgAfQwD7jZViDFA1owh/ZBbYfvDmfynXJFrhx9XHGWK8tO8C4XO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470269; c=relaxed/simple;
	bh=kvqRI6G69uxY9OVl7JI6M9jrb4NvUA2DUXcVZXGJzaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahtpIEhk76Cd1Tw4+Gpj1dEqS/wFciVGFQ/sjBEv8/rDdgmZ8KyaHiUQfO94tyLxOvW1+mYHt5oq292QzukMZuyjXtuPdFvYwQwn51Jy5LAjPa7li84l1OiLuEf4ZX5aRy6fmNRyCq6sDO+sp+Fcb2QDQZDtA5V5Y/anfjNIMh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsTfiJqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsTfiJqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57419C4AF09;
	Thu, 23 May 2024 13:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470268;
	bh=kvqRI6G69uxY9OVl7JI6M9jrb4NvUA2DUXcVZXGJzaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsTfiJqjXeL3muOS5wMlRr7cbcaoO4Wl4XmB7w90Udli75Rjblo1X7+ApVCAr0KvR
	 sJDPaQiua9O7fWC1FuQiYelHvjLoF6+4dMlFQnKYBLphQqfNDFfuFQG8/QY8/eaw9Q
	 KZ2zbR7he1T4l4WhZ7FmzD9YxhiGWNt/GKz9Y5qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6.9 18/25] Revert "media: v4l2-ctrls: show all owned controls in log_status"
Date: Thu, 23 May 2024 15:13:03 +0200
Message-ID: <20240523130331.071611751@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit eba63df7eb1f95df6bfb67722a35372b6994928d upstream.

This reverts commit 9801b5b28c6929139d6fceeee8d739cc67bb2739.

This patch introduced a potential deadlock scenario:

[Wed May  8 10:02:06 2024]  Possible unsafe locking scenario:

[Wed May  8 10:02:06 2024]        CPU0                    CPU1
[Wed May  8 10:02:06 2024]        ----                    ----
[Wed May  8 10:02:06 2024]   lock(vivid_ctrls:1620:(hdl_vid_cap)->_lock);
[Wed May  8 10:02:06 2024]                                lock(vivid_ctrls:1608:(hdl_user_vid)->_lock);
[Wed May  8 10:02:06 2024]                                lock(vivid_ctrls:1620:(hdl_vid_cap)->_lock);
[Wed May  8 10:02:06 2024]   lock(vivid_ctrls:1608:(hdl_user_vid)->_lock);

For now just revert.

Fixes: 9801b5b28c69 ("media: v4l2-ctrls: show all owned controls in log_status")
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -2504,8 +2504,7 @@ int v4l2_ctrl_handler_setup(struct v4l2_
 EXPORT_SYMBOL(v4l2_ctrl_handler_setup);
 
 /* Log the control name and value */
-static void log_ctrl(const struct v4l2_ctrl_handler *hdl,
-		     struct v4l2_ctrl *ctrl,
+static void log_ctrl(const struct v4l2_ctrl *ctrl,
 		     const char *prefix, const char *colon)
 {
 	if (ctrl->flags & (V4L2_CTRL_FLAG_DISABLED | V4L2_CTRL_FLAG_WRITE_ONLY))
@@ -2515,11 +2514,7 @@ static void log_ctrl(const struct v4l2_c
 
 	pr_info("%s%s%s: ", prefix, colon, ctrl->name);
 
-	if (ctrl->handler != hdl)
-		v4l2_ctrl_lock(ctrl);
 	ctrl->type_ops->log(ctrl);
-	if (ctrl->handler != hdl)
-		v4l2_ctrl_unlock(ctrl);
 
 	if (ctrl->flags & (V4L2_CTRL_FLAG_INACTIVE |
 			   V4L2_CTRL_FLAG_GRABBED |
@@ -2538,7 +2533,7 @@ static void log_ctrl(const struct v4l2_c
 void v4l2_ctrl_handler_log_status(struct v4l2_ctrl_handler *hdl,
 				  const char *prefix)
 {
-	struct v4l2_ctrl_ref *ref;
+	struct v4l2_ctrl *ctrl;
 	const char *colon = "";
 	int len;
 
@@ -2550,12 +2545,9 @@ void v4l2_ctrl_handler_log_status(struct
 	if (len && prefix[len - 1] != ' ')
 		colon = ": ";
 	mutex_lock(hdl->lock);
-	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
-		if (ref->from_other_dev ||
-		    (ref->ctrl->flags & V4L2_CTRL_FLAG_DISABLED))
-			continue;
-		log_ctrl(hdl, ref->ctrl, prefix, colon);
-	}
+	list_for_each_entry(ctrl, &hdl->ctrls, node)
+		if (!(ctrl->flags & V4L2_CTRL_FLAG_DISABLED))
+			log_ctrl(ctrl, prefix, colon);
 	mutex_unlock(hdl->lock);
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_log_status);


