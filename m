Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A8B22DFA7;
	Tue, 26 Aug 2025 14:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218333; cv=none; b=EcA+nOJdY1PdiAB/AXgLrfwzLCKMnyRjfIwhW0CKSmf20xWitrwxbHozgiBWV5wgYbe38UjJftVnQ5D0YnzVQ3BfXqs9WUlTK0yrwlO7qnmaTGS6gUumj736eS3LJ7cwYoTeBPjE1jFGNmocPjT7tNAyp1zEsVqCM6js91MUOiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218333; c=relaxed/simple;
	bh=jjkwXAqkMleyuGGgoeM/YYzUAu3uW/g3p3AisnWNNz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euEIOkLxLzoVKvTpy3v5llPBjNyuBDHepG5xXCDvQc+rLTiXUGJP0ewhNePCFp+ToXUbfdNdOrMGhIsJFjAy0PltRPN2EK462J4xAyNHHg1iaSWbyVrclTaCSILZTYCGqDPcL5X9bvNuJvtCiy9qCgoiIooQJY42N04QOkjBXWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwc/U+lO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwc/U+lO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E151FC4CEF1;
	Tue, 26 Aug 2025 14:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218333;
	bh=jjkwXAqkMleyuGGgoeM/YYzUAu3uW/g3p3AisnWNNz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwc/U+lOoM7TDtP0u/fu0B5vbGk+GFUsFQ8yKgMVqp58HB5ZWAp2l/wHXkYKDMNI7
	 sI+hF/jZkCZrwMu0k9BntM/cfWxLUYBjUcW4+S3RfMsEzlznD3m4LAytIYAvBvhhD/
	 M/BJwtB6NIHLcRCZfsepI9Fp1gdyLIR7M5AgHbsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 483/523] media: v4l2-ctrls: Dont reset handlers error in v4l2_ctrl_handler_free()
Date: Tue, 26 Aug 2025 13:11:33 +0200
Message-ID: <20250826110936.361745695@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 5a0400aca5fa7c6b8ba456c311a460e733571c88 ]

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
[ v4l2-ctrls.c => v4l2-ctrls-core.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2388,7 +2388,6 @@ void v4l2_ctrl_handler_free(struct v4l2_
 	kvfree(hdl->buckets);
 	hdl->buckets = NULL;
 	hdl->cached = NULL;
-	hdl->error = 0;
 	mutex_unlock(hdl->lock);
 	mutex_destroy(&hdl->_lock);
 }


