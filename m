Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE866224AEB;
	Tue,  8 Apr 2025 12:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115556; cv=none; b=GCbSFhbfxM3IDBplrlHVC5ngv1xAK+p2qhWFjoF88Wl0SMqx/fg4lKYTpYrrlRB34Ggu4EUQGilYxzo4wHhCfqgD1obyTau9LZtXsruYsRvlJHKRh7tl/ycB6i1nr8I5lG9fKHrv7ewzO5sQsbCNvYTcH57GyJCL9Vu4agTSI6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115556; c=relaxed/simple;
	bh=3GYEGYNGr7Tev0ODFRWYir19WvzMSwxLicQvON3CyFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWHGGxJhx4VjaEVkK0KDf+IBqVndnJrhILs5GvEiV9kcIOKoB0VmoXDvKv5MPVT1guhwKrzBfr8dvhl0chZKELgPzyez2hqBP/uAxU2FGsFtJrunMZko3738qGhNgB86VwOlRywna1kVMVq5DVk+rFo1eqz9olyMotj5eFeiQes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBoWiZcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBoWiZcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49171C4CEE5;
	Tue,  8 Apr 2025 12:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115555;
	bh=3GYEGYNGr7Tev0ODFRWYir19WvzMSwxLicQvON3CyFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBoWiZcjz/rlQ+x94oXl1L9yV1/t+JJ6FSZX3rfivl9CGPLLVFQEQFVImTKcGbDHo
	 ZYhRUQ3cSk3RF+PV50aOffUXH2fAHuUzNo8GqEVdQ4T6+73vUrlAnFPLY6jXFB6q2h
	 feGeLmlQO7H5iWnAI1itlr0etFa7FjoyrTn228No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/204] perf/ring_buffer: Allow the EPOLLRDNORM flag for poll
Date: Tue,  8 Apr 2025 12:49:09 +0200
Message-ID: <20250408104820.884288765@linuxfoundation.org>
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

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit c96fff391c095c11dc87dab35be72dee7d217cde ]

The poll man page says POLLRDNORM is equivalent to POLLIN. For poll(),
it seems that if user sets pollfd with POLLRDNORM in userspace, perf_poll
will not return until timeout even if perf_output_wakeup called,
whereas POLLIN returns.

Fixes: 76369139ceb9 ("perf: Split up buffer handling from core code")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250314030036.2543180-1-chen.dylane@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 98588e96b5919..3e1655374c2ed 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -19,7 +19,7 @@
 
 static void perf_output_wakeup(struct perf_output_handle *handle)
 {
-	atomic_set(&handle->rb->poll, EPOLLIN);
+	atomic_set(&handle->rb->poll, EPOLLIN | EPOLLRDNORM);
 
 	handle->event->pending_wakeup = 1;
 	irq_work_queue(&handle->event->pending_irq);
-- 
2.39.5



