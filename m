Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3F32236FC;
	Tue,  8 Apr 2025 12:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116135; cv=none; b=ryY91vLtvN620vSdJJr1VvTLkzjBipzA+VC8G8DF40ARWfRmUdDy1yVceTunlO1niPmQaSFMPTkLGkYyLYMJLo2w/KXSNKjyD4TmkSpSRN8Q/m6WqTSUvsTeZL/mztA19bl6NmuoCHIK0Oup3R02I0Obie61Og6Xuzs/WFjL37s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116135; c=relaxed/simple;
	bh=04ElTJrxENLrbJO1zWJMlsxjHyQfWftvtAi86Q+rlAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9wCKuCOUX+r6pZc6QdmtVhBMrUxYrTbFPxVDRyNKiRr8JZMN/hZkO0tE9qc+yginH1PSmA53rmEFIAZ/+cyp37LE9FiCWM1DuuwRkK5a3w0z793McH/fKGcpuioS8g2FBxooRBhy07IWTc1MfGkMKycOwj61p9W5x1GWrmjUMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbhHDxos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbhHDxos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F64C4CEE7;
	Tue,  8 Apr 2025 12:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116134;
	bh=04ElTJrxENLrbJO1zWJMlsxjHyQfWftvtAi86Q+rlAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbhHDxosbVxblNNmkZ3cnCHW3V00dNp+gEIESOphtoNxicjTP4ldVGkPVx4yYur/I
	 q2Uh4oEOtbS4EyLjpBjauBij7KVWUmmWDPZ5EiaG+VEcSgSCYLYxXmmAPgt02lAKgz
	 AGQ1Yu7+QyOQhrMe/abpeNM8pW+ogtCqCClKpR34=
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
Subject: [PATCH 6.12 028/423] perf/ring_buffer: Allow the EPOLLRDNORM flag for poll
Date: Tue,  8 Apr 2025 12:45:54 +0200
Message-ID: <20250408104846.404668411@linuxfoundation.org>
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
index 4f46f688d0d49..bbfa22c0a1597 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -19,7 +19,7 @@
 
 static void perf_output_wakeup(struct perf_output_handle *handle)
 {
-	atomic_set(&handle->rb->poll, EPOLLIN);
+	atomic_set(&handle->rb->poll, EPOLLIN | EPOLLRDNORM);
 
 	handle->event->pending_wakeup = 1;
 
-- 
2.39.5



