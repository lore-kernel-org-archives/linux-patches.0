Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325C426B09F;
	Tue,  8 Apr 2025 12:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114202; cv=none; b=o/7jKY/B3v4TnOBB2l257DJ1axEE9H4rNQQ7tnp5u7wa3HlQx6OA63nt8xJB1uH8JGNsib12Vw+HG1GVYVDBGzbRX4HAYqpi3S8MStTwldwIr+BCRAYdLQ39fHEKWVC7FlT3JCTfXrhDYvgv2LLDkESUpwDRLCodztZNSgxSJTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114202; c=relaxed/simple;
	bh=miTpQxUGFMZ1wqmVpFHy22Lt0M93iUszNG3euVMUKyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDd4sBijwGX3XO/tqp9CP4vbp+YEsjolmGJSIw6FCoYTtC9VqZM5xkgHtnAuNedqBkaxDyvDXEe/BmxCIOVjvjaLK4xjGFu9V9OcVgwqapi6c6ArdR8EOWew7FDhl3xFbsZjHNclw9nC/RIKwom5A/3FuHtXGZDKXfs5Lwe3mvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yqmLn7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yqmLn7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B454FC4CEE5;
	Tue,  8 Apr 2025 12:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114202;
	bh=miTpQxUGFMZ1wqmVpFHy22Lt0M93iUszNG3euVMUKyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yqmLn7L307l+MM8pKgEkETnGGXkuvoFcWi2xAmIpHs0S1Pz5EgZjzmod6P0vl6om
	 bzLCMOKucAf0AKjsEHd5fOLK9lSmudaU9YW72/8SAwEMmzKfgpu5WmtAbPIfMaIE57
	 Eso2olHenalEIrUR/DfKujW3rlr0PhBgagquKhks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 002/499] watch_queue: fix pipe accounting mismatch
Date: Tue,  8 Apr 2025 12:43:34 +0200
Message-ID: <20250408104851.318592464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 1895fbc32bcb9..6d1936fb8ff02 100644
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



