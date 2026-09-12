Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125F535677C;
	Sat, 12 Sep 2026 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228433; cv=none; b=r7lL8KNHQdgUssQQcPzD5XTognHNIUnWgVNrT9r1/H8oibVFsLsHayzjQGcLceqkzGNxk0cCRLmtSD+Vj6NDIiAwWfiIztW2g+l7fDpxjBgmzCudrDzVvsv8iNn8iHbLzaTfxmslbhzU6DKlTC5UxKYg2V4NrxTKMyvsY0PUOro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228433; c=relaxed/simple;
	bh=66WOMbdCK0XiKeSHNWwKjQhAT1wyN0/cOiDPIjLj4pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjH0WHatSahJ7cEy+7wjlhc7FrSbfOdTdeQnxiRKiS78UrCABys+S7G6XX9bwN7iBmMMLNnv0vI+IWoVxZXJ60pD6lcBtf5HjD/7CutNuBgMTTZeF6d2QYAwJE78rE6MHnpmt4fqdTnuk8u0yqDJoizgduUZ1f1+Mn0UgfZ7p3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfnKzZaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfnKzZaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E151F000FF;
	Sat, 12 Sep 2026 15:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228431;
	bh=d1U/u8KPaAKQ8L6juVobDNhA1fOUREYdcRB6kaSTb98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfnKzZafck3Mw8HPa8QjqtgbJqFq2pQ9rNhu4RV+BqK8+xdL+riZi9o7eaprbQLvJ
	 YLmdd/jmRvVolpzWFScnZk1ZsHa8ZXPuD+unZnVwDdNEdyjSwFJbgHJ6EVPItpQu+m
	 Gw7z2ePTwBMOvCGG0+U6BKgIkWTttmVoGxjMUPvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0385/1191] media: video-i2c: fix kthread error pointer left in kthread_vid_cap on failure
Date: Sat, 12 Sep 2026 08:51:53 +0200
Message-ID: <20260912065556.887348013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -532,8 +532,12 @@ static int start_streaming(struct vb2_qu
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


