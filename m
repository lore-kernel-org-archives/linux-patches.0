Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128BA13D53C;
	Sat, 12 Sep 2026 19:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242216; cv=none; b=D99Ys7NtpEXa7zh3ppUgTdloiRMwTTyr54zQA24wuPwzS3mGmyrwRGvlP5qyR6YAzsQqVe8fILs6OXB2nRx+YBWeJCzBfaDxOCQ8uj4TTxCdOeljt/qvYggVkOYO8mK+xR3Iw805sJJXoQ2h5OrBGup8T2i1vt3Qa2p3VS0TzJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242216; c=relaxed/simple;
	bh=eneKrRzCTj2DT1lixU2W3RYhYHc5zSe8wAfMA7kip6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuSFRNKhX/5o8yQor/J0h1/cyLkudolroeNjCiaY+hj1HlVyVGHYSBuvkNH8fWodNQut2EjJyqixAcDlCN2eEciDLpy6tgzHZOY0i1jIxOcxIDsO6JfPZ4NZRjwLe2ocV+k088iz8p/MSi+gefxRasizoSPwUensWB6zb1qVGYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPhy12Xq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPhy12Xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB041F000FF;
	Sat, 12 Sep 2026 19:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242215;
	bh=4XNPsalvpUigIC+hEBD7kiSY03TzmGCVXwCb5Jz0FC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPhy12XqrJUHrfpZHR50eJ4X6iEUfOMlno6J4ojzzpQ2m8erVvho2Ru/EgB/7Hu4y
	 pa7VO2A+T4xWS35+wPhfvgp3j5bOuJxLDS3m24h0PoUsM4Ntax7ocJAERPIddQOLlL
	 0ghGbSxEOfip1m+WP1SO5WnlA//oOIiNf0h4xDR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 289/798] media: video-i2c: fix kthread error pointer left in kthread_vid_cap on failure
Date: Sat, 12 Sep 2026 08:58:37 +0200
Message-ID: <20260912065523.786940894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -526,8 +526,12 @@ static int start_streaming(struct vb2_qu
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


