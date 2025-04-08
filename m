Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0931FBCB2;
	Tue,  8 Apr 2025 11:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110316; cv=none; b=PSIEtschjg0xxbB3euEus5pSs7XJdsQN8W7udezozNYZyW8SoPIMaZo5c9CehkS6KRw1184PSp7CPEEQ2XP61Pm41v0ciYFHC+Pa2JJiKEgqRhv0rflalb6FYKeypBVF+aePTf3VnMJ8UMzoAcB/hWjZ5UMlqIAEmfIx8P0imEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110316; c=relaxed/simple;
	bh=WDJDbuNbVdw2dUMSWog+TdB4QJMFd76hgPRIOe1lj4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovMfE7dv0gDUX8Wzh9JXmoCOFbQwtR0sFGct8hF29kf0cYbVQOvG036NexIAkZmiUdVGrKV7ZxF2bBrGyGts5dZtcFFQdiyykozaS22EzXTM0fs6QBJrUKzTktye7kwucLkXIJtr/GtoZtjU5eQ4ZNdc8V6UQI9FdkvlA0k+azY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uj/i4ddX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uj/i4ddX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E74C4CEE5;
	Tue,  8 Apr 2025 11:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110316;
	bh=WDJDbuNbVdw2dUMSWog+TdB4QJMFd76hgPRIOe1lj4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uj/i4ddXs/KhgKaBYPvsjmEnR7pCxq1nEMlp3K3guflvV0GGVpgQk2c2H9jAjB6Y6
	 zF8R+dzr7t8i+CLnGJgpOQ+63j6kEloycWcyM6vQYBcAmpHgZnffpgpq6KiHR7RNpo
	 NoDjYysWyCPExWKCGRQ+kDSvl1cwP5nafl7d0ZVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 002/731] watch_queue: fix pipe accounting mismatch
Date: Tue,  8 Apr 2025 12:38:19 +0200
Message-ID: <20250408104914.315087844@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 5267adeaa4034..41e4e8070923a 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -269,6 +269,15 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
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
 	pages = kcalloc(nr_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
-- 
2.39.5



