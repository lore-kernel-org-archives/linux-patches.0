Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D5447A893;
	Sat, 12 Sep 2026 11:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213907; cv=none; b=cAHy4uiC1Zp5A4zQrioljl1ydIM/2muHO8+rE7lXUWdt6Li/Et88l/Suxi+UTYYhRGwHINXdq+fHrz201ghqIDSzW+f5nOzItxTJH6A2U2Ak64Y0ncuYcEqD14Lp3NCM/uk6FOCRSO70m/J14hxRfDo1kI30RZQScwBIagpp1+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213907; c=relaxed/simple;
	bh=1nl9xRN9SJgv/Z+EhBxa8jmHt6vK5iN7TOM/OSbwM0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8xvZkwEjDEUFyLEVFxSt4WtjsBbGKbYmFxoBw47m/SsxMbLpx92ypcyLcFXXgErEk+259fnm+6eGCXiCO0jOaF4M9sPTQB4ZQ/JZWxhpnqfA0h0pjyxfJRATkC+hrTUI8wY5cJWWJlPQHFZ6Uy3oTfozk4OOhJESpqazIFxFac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtOGll7E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtOGll7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3610A1F00893;
	Sat, 12 Sep 2026 11:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213904;
	bh=OeklzJGb1DorUokukRxIat4IBEmKYZw8+AvbEI3dD9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XtOGll7EJ3Z4vOoRrZ4qKBw+LSLtY5ZUTlzNaazo5LKlDmY5+TwcJghb4R+WCpvU+
	 fJ+M9p7eIFhF8uy1fT80a1XLOT0F4K4SupxrKCHqn8zGvXggujx3jQJCsk7XisQcvk
	 I1fTQ7u3DcLBXhRiIDUiR318QfSqM3WlqiUyvw8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0216/1376] media: video-i2c: fix kthread error pointer left in kthread_vid_cap on failure
Date: Sat, 12 Sep 2026 08:44:02 +0200
Message-ID: <20260912065612.363477722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -533,8 +533,12 @@ static int start_streaming(struct vb2_qu
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


