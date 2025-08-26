Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BA7352071;
	Tue, 26 Aug 2025 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218330; cv=none; b=g+NpzCj4Xc8NgLphd4+7vo5WVPXiTyB75DSJPXc168WVd7vO/4+lREh+s8KJhWoc+ZeLuAfBxUgQQ0iz1czjJE665W21vJk9PNgPB6wp8+8e+1w4/gkfRUhIS3bjtY1EhmsTLSJcek081pyXhDTZ3LvUVjSgGeBNU0geFEvYPic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218330; c=relaxed/simple;
	bh=arHZagiNgOh76IbkJycol58ky1jjJWlQVHWUHDlIuWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yj9T6pvlrKHB+YICZwrDEsU7mP3gitYOtjk6Q0WBs3XxEv/zGBVHN+UaSTQst1hHT3J9hz+yzAxuVAr0dIQKqrvvYy2x8fWvG07He/oUrWLdAB2g0emjcJbR62/RWz1tSmxzdINcEeqeniXDpc62DkuNe3QyuaBVmI9yvUFMM3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqW+N5qQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqW+N5qQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44266C4CEF1;
	Tue, 26 Aug 2025 14:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218330;
	bh=arHZagiNgOh76IbkJycol58ky1jjJWlQVHWUHDlIuWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqW+N5qQ17j09Jv3Ch72hk4c/1QUtMjOH1T9ovtgLHFm762toc8c3WJ1P2PNT+5gD
	 hCslWmwpsBZtzAxo8EBkq4KExuEuQS71OZJmRVwUTZst0e4BGwyrlfUMXro0ffOPyP
	 kaID3QOgyQjYD1kq+kC0wbrxlwfEFfcx9G+2Mdz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 482/523] media: v4l2-ctrls: always copy the controls on completion
Date: Tue, 26 Aug 2025 13:11:32 +0200
Message-ID: <20250826110936.334777577@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit c3bf5129f33923c92bf3bddaf4359b7b25ecb4ba ]

When v4l2_ctrl_request_complete() is called and there is no control
handler object found in the request, then create such an object so
that all controls at completion state can be stored and are available
to userspace.

Otherwise any attempt by userspace to read the completed request data
will fail.

If allocating the control handler object failed, then indicate that
by returning ENOMEM when attempting to get the controls from the
completed request instead of returning ENOENT.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 5a0400aca5fa ("media: v4l2-ctrls: Don't reset handler's error in v4l2_ctrl_handler_free()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |   36 +++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3767,8 +3767,19 @@ v4l2_ctrls_find_req_obj(struct v4l2_ctrl
 	obj = media_request_object_find(req, &req_ops, hdl);
 	if (obj)
 		return obj;
+	/*
+	 * If there are no controls in this completed request,
+	 * then that can only happen if:
+	 *
+	 * 1) no controls were present in the queued request, and
+	 * 2) v4l2_ctrl_request_complete() could not allocate a
+	 *    control handler object to store the completed state in.
+	 *
+	 * So return ENOMEM to indicate that there was an out-of-memory
+	 * error.
+	 */
 	if (!set)
-		return ERR_PTR(-ENOENT);
+		return ERR_PTR(-ENOMEM);
 
 	new_hdl = kzalloc(sizeof(*new_hdl), GFP_KERNEL);
 	if (!new_hdl)
@@ -3779,8 +3790,8 @@ v4l2_ctrls_find_req_obj(struct v4l2_ctrl
 	if (!ret)
 		ret = v4l2_ctrl_request_bind(req, new_hdl, hdl);
 	if (ret) {
+		v4l2_ctrl_handler_free(new_hdl);
 		kfree(new_hdl);
-
 		return ERR_PTR(ret);
 	}
 
@@ -4369,8 +4380,25 @@ void v4l2_ctrl_request_complete(struct m
 	 * wants to leave the controls unchanged.
 	 */
 	obj = media_request_object_find(req, &req_ops, main_hdl);
-	if (!obj)
-		return;
+	if (!obj) {
+		int ret;
+
+		/* Create a new request so the driver can return controls */
+		hdl = kzalloc(sizeof(*hdl), GFP_KERNEL);
+		if (!hdl)
+			return;
+
+		ret = v4l2_ctrl_handler_init(hdl, (main_hdl->nr_of_buckets - 1) * 8);
+		if (!ret)
+			ret = v4l2_ctrl_request_bind(req, hdl, main_hdl);
+		if (ret) {
+			v4l2_ctrl_handler_free(hdl);
+			kfree(hdl);
+			return;
+		}
+		hdl->request_is_queued = true;
+		obj = media_request_object_find(req, &req_ops, main_hdl);
+	}
 	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
 
 	list_for_each_entry(ref, &hdl->ctrl_refs, node) {


