Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C30D264FA0;
	Tue,  8 Apr 2025 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109945; cv=none; b=YID7/d3HH1PFFmFhWticQWYW5U0lx/13oPnYYtl9X1CqOu6CGoIrxZ2gH0IOTbbM2hZ/xcZnmSIe3RkQQZQeueOgX5SspPE5x/Im4dbPaMpVnu7miu7MIFcc7TIQd2t8wauTdKeLiG8Q50mUPY5dwGsG1Bsd6KwMmrKG4fAvEi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109945; c=relaxed/simple;
	bh=vgLnIe7rIoz8cuJT9xuMPdD7FPwzKGKr49BP/d7ls0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cw3nkNWtFED4ROUoydNODlAVt4XaIle34qmyEf0K3KvwPN8XL+M4fUAlzwmUW3M1jVdoOxX+uExyqimNCZ5278VQ7iURMLpshpUb9eRgT6PxlDBn1Z9lKLUjn6hWseMj4YRHBGrCnq7u5jRCv50YbWifjJzbPbxEZWL/S/0iJpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXL02gHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXL02gHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2BCC4CEE5;
	Tue,  8 Apr 2025 10:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109945;
	bh=vgLnIe7rIoz8cuJT9xuMPdD7FPwzKGKr49BP/d7ls0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXL02gHoyMV2LD09zpC1gPbduFCb0X6FrmenBNADIvF+OvkVn3cMKFE88bp4Azclr
	 7kCQK9ZoAc1a5Xkkep17wHFSkuBxZzDWsThLUnHalL9i9AYTL0oFDvF0wVgFGs3NKa
	 9nFCxYlhzwZVDazp+DxX48jc+Z7ZXMhXbfxPWYyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/227] watch_queue: fix pipe accounting mismatch
Date: Tue,  8 Apr 2025 12:48:09 +0200
Message-ID: <20250408104823.679577697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit f13abc1e8e1a3b7455511c4e122750127f6bc9b0 ]

Currently, watch_queue_set_size() modifies the pipe buffers charged to
user->pipe_bufs without updating the pipe->nr_accounted on the pipe
itself, due to the if (!pipe_has_watch_queue()) test in
pipe_resize_ring(). This means that when the pipe is ultimately freed,
we decrement user->pipe_bufs by something other than what than we had
charged to it, potentially leading to an underflow. This in turn can
cause subsequent too_many_pipe_buffers_soft() tests to fail with -EPERM.

To remedy this, explicitly account for the pipe usage in
watch_queue_set_size() to match the number set via account_pipe_buffers()

(It's unclear why watch_queue_set_size() does not update nr_accounted;
it may be due to intentional overprovisioning in watch_queue_set_size()?)

Fixes: e95aada4cb93d ("pipe: wakeup wr_wait after setting max_usage")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Link: https://lore.kernel.org/r/206682a8-0604-49e5-8224-fdbe0c12b460@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watch_queue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 73717917d8164..37da8647b4ecb 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -274,6 +274,15 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
 	if (ret < 0)
 		goto error;
 
+	/*
+	 * pipe_resize_ring() does not update nr_accounted for watch_queue
+	 * pipes, because the above vastly overprovisions. Set nr_accounted on
+	 * and max_usage this pipe to the number that was actually charged to
+	 * the user above via account_pipe_buffers.
+	 */
+	pipe->max_usage = nr_pages;
+	pipe->nr_accounted = nr_pages;
+
 	ret = -ENOMEM;
 	pages = kcalloc(sizeof(struct page *), nr_pages, GFP_KERNEL);
 	if (!pages)
-- 
2.39.5



