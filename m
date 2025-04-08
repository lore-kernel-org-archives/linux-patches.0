Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EBF206F18;
	Tue,  8 Apr 2025 12:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115528; cv=none; b=Q/wi9CWUe5upUHZWyqR5oKeNqiCa6VjjG1ui4wEcNyCjlBCdqFf4DSbaCwr+8KGP5Y5QdLBvLlWwcFJuilbasQ9xkKYC6nSzkeUA/q85r2O0A02Tx1OjrQlpazCe8/E6dSD43WnSV6jfVOlEH3K1L6rArCQsZrJb9T/pSQ8z2+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115528; c=relaxed/simple;
	bh=zazv+dU2dB1iLQuLb1FjBrl89eWqzDkkOO39AamGbuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vC4/4m3vBK20kEjLuuql+62np6iB3guSMIDQV6LKUweyr5abrRW+gnhIZWO/5MdpxGYNkwchr5zqF294/wvASjY3mJJoDNgAf6bGxsDUln5a7da3f5aVHW4+ME+HEdrU5VvA9pOVjwHdQColUvqnD+mU2pZfr0Tj5RhZ0BrNdiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yod1SiC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yod1SiC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3432C4CEE5;
	Tue,  8 Apr 2025 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115528;
	bh=zazv+dU2dB1iLQuLb1FjBrl89eWqzDkkOO39AamGbuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yod1SiC4q19rdHNXFXuznf8/kzQBUkcntKAEctds++GUlBFoABf74XK6f0q2Sko+R
	 LGspQT/hCVywPk6ltAZE7ZKRc7UWGF+bYPuegtsdZmSMJl7o1h+n+AkFNLUNd5y4vt
	 BoIfzBVdjUhFi5e3XlQovDCv4zCJVC47D5Vm8644=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/204] watch_queue: fix pipe accounting mismatch
Date: Tue,  8 Apr 2025 12:48:51 +0200
Message-ID: <20250408104820.319109869@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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
index 442bb92212f2a..a72ea1c2f59fe 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -270,6 +270,15 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
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



