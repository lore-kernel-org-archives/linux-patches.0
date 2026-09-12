Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5BA3264D4;
	Sat, 12 Sep 2026 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221872; cv=none; b=e0EOjJmMbhoLravgyxyLt8L+6Do8MoI3JPfEG7UltMqaAihFj//9FnlcNjXU/W+1GNqGvDvpxNRBeNXE8beT+Cgft7RQ9EPCxIX+jWQs4r5Qza7NEN+vlBqwH6CNhTXnBKDEI/+DvcUKlMAtDftBZalkXSWFrLcYuFT07W87e2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221872; c=relaxed/simple;
	bh=FWNlfyEk/kdfjLsDo1PcYGX9S5cL2vd6ZQ3cK2MhQuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UV2aie9NjWX6SLLqAaSpCrk2ixd/r2N0DUHLnJ8lWXQ6iPk7GuZmEbsL83o2JXcuEJS4QWoBWY6z/Bky2pJTxW5bs57No/U1fApB5h+VRcCwSl3qOOqXrdz58zkR9jEN30D7haMObHcWzsGClKexs0DepCU3pFNu2amdv9+Vu1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0o2Jf6b4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0o2Jf6b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C034A1F000FF;
	Sat, 12 Sep 2026 14:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221870;
	bh=nfbaIC1mOyOUmy1sKgczVvlex5TbN96u1NB1HuRWbik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0o2Jf6b4Y0RH02CqvuQo4IKZB2kszcBWrHpdizbWNaKSxdx0Tnop/HpW5LatKpKc6
	 fqCwAdPrWhcLUY1x+hlikEiKl6wET6PXNdx5j8CQpLqQcYGlp9GxpZIOl/2H2lDJwG
	 75j/TOsE6A5IoDbRPdid1R3hHFP9PiGzryPIqkoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0470/1424] media: video-i2c: fix kthread error pointer left in kthread_vid_cap on failure
Date: Sat, 12 Sep 2026 08:48:22 +0200
Message-ID: <20260912065617.813258183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


