Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91F5219300;
	Tue, 26 Aug 2025 13:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215014; cv=none; b=DbVReEC0kkCosH+ztXSqX/ciCZW1+OjyI1QBCqDFZfAP8KNGQ6lTNcmV1LVq1Y6qD++wj7DZp8dWhwJb/BuEjtQNXJ1T7DBduFwoY3cgkseO8xlQae+TQki8hpuF+j4essw4jjaTwvyYxWgQc1KhxKC7No/ZHE8DCDpnjLBr7RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215014; c=relaxed/simple;
	bh=gVdMEv9x56O2xWyM7ZXFwzq73G8bO7VECjkTfxNBUvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHFSz9ijDv6oyd4baboqfR3ghk0m9GtcRuL1xGzlzn4IYtc9NTWHmZeUYBH2xHKQ5Je047UET9940FEU1LFmwTLIXVzR3jzrSlKdFz1nuOl82bhDfXSD0w0CQedfsyCOOjwW6I+8YtyNzfDfhshPbufC1sxpS7BOpYZJJbagC9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KivGwKOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KivGwKOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF1CC4CEF1;
	Tue, 26 Aug 2025 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215014;
	bh=gVdMEv9x56O2xWyM7ZXFwzq73G8bO7VECjkTfxNBUvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KivGwKODXFHGMRfHwxdAOg5MsrPcDi7Qy8LU1qAtGPkQvfRq/tmrAiq4KSzwwAlaA
	 qfOryr9ZFRC5A2eD2j5Wozf2OCXLRuQTS2nvSbn+bdI4nLFzw0p3C9/ZMyNIDGwE+s
	 uWNTh0Pb37rIcMJ7ZEQtaq9L6WUkbbUG8Oesn4Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6.1 323/482] media: v4l2-ctrls: Dont reset handlers error in v4l2_ctrl_handler_free()
Date: Tue, 26 Aug 2025 13:09:36 +0200
Message-ID: <20250826110938.789701779@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 5a0400aca5fa7c6b8ba456c311a460e733571c88 upstream.

It's a common pattern in drivers to free the control handler's resources
and then return the handler's error code on drivers' error handling paths.
Alas, the v4l2_ctrl_handler_free() function also zeroes the error field,
effectively indicating successful return to the caller.

There's no apparent need to touch the error field while releasing the
control handler's resources and cleaning up stale pointers. Not touching
the handler's error field is a more certain way to address this problem
than changing all the users, in which case the pattern would be likely to
re-emerge in new drivers.

Do just that, don't touch the control handler's error field in
v4l2_ctrl_handler_free().

Fixes: 0996517cf8ea ("V4L/DVB: v4l2: Add new control handling framework")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -1327,7 +1327,6 @@ void v4l2_ctrl_handler_free(struct v4l2_
 	kvfree(hdl->buckets);
 	hdl->buckets = NULL;
 	hdl->cached = NULL;
-	hdl->error = 0;
 	mutex_unlock(hdl->lock);
 	mutex_destroy(&hdl->_lock);
 }


