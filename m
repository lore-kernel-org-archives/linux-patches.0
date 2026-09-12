Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA25340A6F;
	Sat, 12 Sep 2026 18:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237797; cv=none; b=mQV4Rt/0DV1To9Eigu6i/eWU9PrbCoDTk0PMd81LYI3Bl3r6WC+Bvz9UNgvBcmHt6y7vzWgYy/qklk1nB6SA+1WL+RYJ3q2WkAxcjHThaB66wWU6MWpk4OmR7zk67E15CuG9SO2ltea3NeYacJhpZMNlk4NjKDGlnOa8dwPLW94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237797; c=relaxed/simple;
	bh=S9tF5hGgMj8aWfeD0JulH8JeqwnsI3ea2kJma63utG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azuIdQQQu2OkCWZ/euWXlq6I0nius+VABfWs3pKVvcrxg3VdGmsA5+tj/v4S2lSrN4ntPVINgDNIkHsU1GGtLS7BsML1PyNQrUKbx+2hu2q3YSvws9Oz9imueSnCqR51076/IdHCeWhIfjfTx5M2fYqoQA3DHUlclZfC+usnURQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13T1rPIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13T1rPIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC3F1F000FF;
	Sat, 12 Sep 2026 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237796;
	bh=HZJxh5nvdtgG6WZoLHR4Yr1UoAGQBJhneuEz6rDaApQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13T1rPIgziNeXxjyTYA2VkU3e65smbbfiUPVemZPLrpe1fqv9dHKckotExztgl1pl
	 lBrkmNG+a46CQecaSLfh2gquwHyhlef6cGvUr4VaSw4QU6c4Ir4oRtGqmIYIb1FY5Y
	 zTNDUUsj4EU92+NoLfiSScrOAYvDqAQ/VpeQ0uhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 331/935] media: video-i2c: fix kthread error pointer left in kthread_vid_cap on failure
Date: Sat, 12 Sep 2026 08:56:01 +0200
Message-ID: <20260912065534.393822317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday Khare <udaykhare77@gmail.com>

commit 76e379754ba618989f6215be608d5c04774a611d upstream.

kthread_run() returns an ERR_PTR on failure, not NULL.
When start_streaming() fails, data->kthread_vid_cap is left holding
this error pointer instead of being cleared.

This causes two subsequent bugs:
1. A future call to start_streaming() sees a non-NULL kthread_vid_cap
   and returns 0 (success) immediately, without actually starting the
   capture thread.
2. A call to stop_streaming() checks 'kthread_vid_cap == NULL' which
   is false for an error pointer, and proceeds to call kthread_stop()
   on the error pointer, leading to a kernel crash.

Fix this by resetting kthread_vid_cap to NULL on failure before
jumping to the error path.

Fixes: 5cebaac60974 ("media: video-i2c: add video-i2c driver")
Cc: stable@vger.kernel.org
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/video-i2c.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -522,8 +522,12 @@ static int start_streaming(struct vb2_qu
 	data->kthread_vid_cap = kthread_run(video_i2c_thread_vid_cap, data,
 					    "%s-vid-cap", data->v4l2_dev.name);
 	ret = PTR_ERR_OR_ZERO(data->kthread_vid_cap);
-	if (!ret)
-		return 0;
+	if (ret) {
+		data->kthread_vid_cap = NULL;
+		goto error_rpm_put;
+	}
+
+	return 0;
 
 error_rpm_put:
 	pm_runtime_mark_last_busy(dev);


