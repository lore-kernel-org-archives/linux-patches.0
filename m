Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFFE268C6B;
	Tue,  8 Apr 2025 12:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116081; cv=none; b=GkfktNFjPJop3WWG5AWKmqVzmMYLcM18H/76hbxXKTu0WMaEclZlHdavZURkedE2SwKUEC8W/IxVHnGbaL9n2ELrdVcX2QxnYZ4k6uQacTKHyxxI9Hg3Gf6SzakGeZWRnxI83Md5lwv9m2FaOXLEaWIz0213IQohwX9fq/T45Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116081; c=relaxed/simple;
	bh=3JL+HVw10jrAYJMZl8ygacgj4c5RdvPcq+PZdGqrFQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWPFrcfZc81UhO62N+QiPaJExgpt5bx4MC+FwcuBhSg/7vRqobti7vyHVEX4ZrxdfxsgWC3m5ZZ5IOk1JaIIR9MygHDv2OiPiS7tDa9w6/lh10Ap2kYxG1ik5EUfISF0L5rIKAzVTpg3zm8CgdFE+pxwgHBQbbJCu1yEFucXTmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdvPV2JQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdvPV2JQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670D7C4CEE5;
	Tue,  8 Apr 2025 12:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116081;
	bh=3JL+HVw10jrAYJMZl8ygacgj4c5RdvPcq+PZdGqrFQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdvPV2JQ5nnDSNM5elb27NI4m1cwAzYY2OhRd8H5u3S+CNQvv3TF53KO1EgJruEyE
	 dKWFW2XOOxVEwk/bNKOOzRM9Z32SaYrG8uLXaiIZogNPfmleUeL9ciUk2epv70FqJQ
	 304//ioUcn/aDziWa0peHgXeciWyyECtHUWZYc3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/423] watch_queue: fix pipe accounting mismatch
Date: Tue,  8 Apr 2025 12:45:27 +0200
Message-ID: <20250408104845.716515740@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d36242fd49364..e55f9810b91ad 100644
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



