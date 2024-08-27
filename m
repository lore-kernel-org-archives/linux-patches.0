Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12B61C3F19;
	Tue, 27 Aug 2024 15:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770942; cv=none; b=UlYP3IRbniBRcepjqUnpFG4PYcszUl3ih3LRjzKHyhNF2om87oOYpzR6odRFLkhcMplcvSp9GFSZfOXe0v7WFtYjTp9V1qGmfLa5SAmLMJdOrDfF96WFiN1tQkvvBAHH+qcNyD+MIspxZkQNQMafTSprghe6GMImNDZnzbWlQVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770942; c=relaxed/simple;
	bh=jmAmf3ChKWN6k/tcf2i8OXLRRGZnjBmGCNIo3wpy6bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2JNzR9GDdADp6a3MtRvBUZS7k6LeEv5trTkuDeWjBTjrclpu/DB8m9iN0GcMmePZnVdoIc9WKX5G1mfgfp2h+oBjqLhGYd8AdGLFBqe1xqoOtvURS9HNsxUrKxaFdtn6ka7Sl7lq3o6B6iBr9Yv6jIDPFtbb/x94QR+Fq053bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsWZhYVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsWZhYVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28425C61048;
	Tue, 27 Aug 2024 15:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770942;
	bh=jmAmf3ChKWN6k/tcf2i8OXLRRGZnjBmGCNIo3wpy6bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsWZhYVG0OmhmN8UkA2BUr/hE7tXeh0nWW/S77/5r5BupbVxJGFzagaF19k3kSOlI
	 9JGdcoevBJJ0gjdfw6gkslAvUgaolq3H3U20mj49UYs5qdrGkTXJRHICyQrl3jTk3I
	 QZHomo8Wl4qKQUuwDkdOy0HXdCHkG7yfw0kgSTDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Huey <khuey@kylehuey.com>,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.10 040/273] perf/bpf: Dont call bpf_overflow_handler() for tracing events
Date: Tue, 27 Aug 2024 16:36:04 +0200
Message-ID: <20240827143834.922002183@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Huey <me@kylehuey.com>

commit 100bff23818eb61751ed05d64a7df36ce9728a4d upstream.

The regressing commit is new in 6.10. It assumed that anytime event->prog
is set bpf_overflow_handler() should be invoked to execute the attached bpf
program. This assumption is false for tracing events, and as a result the
regressing commit broke bpftrace by invoking the bpf handler with garbage
inputs on overflow.

Prior to the regression the overflow handlers formed a chain (of length 0,
1, or 2) and perf_event_set_bpf_handler() (the !tracing case) added
bpf_overflow_handler() to that chain, while perf_event_attach_bpf_prog()
(the tracing case) did not. Both set event->prog. The chain of overflow
handlers was replaced by a single overflow handler slot and a fixed call to
bpf_overflow_handler() when appropriate. This modifies the condition there
to check event->prog->type == BPF_PROG_TYPE_PERF_EVENT, restoring the
previous behavior and fixing bpftrace.

Signed-off-by: Kyle Huey <khuey@kylehuey.com>
Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Reported-by: Joe Damato <jdamato@fastly.com>
Closes: https://lore.kernel.org/lkml/ZpFfocvyF3KHaSzF@LQ3V64L9R2/
Fixes: f11f10bfa1ca ("perf/bpf: Call BPF handler directly, not through overflow machinery")
Cc: stable@vger.kernel.org
Tested-by: Joe Damato <jdamato@fastly.com> # bpftrace
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20240813151727.28797-1-jdamato@fastly.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9708,7 +9708,8 @@ static int __perf_event_overflow(struct
 
 	ret = __perf_event_account_interrupt(event, throttle);
 
-	if (event->prog && !bpf_overflow_handler(event, data, regs))
+	if (event->prog && event->prog->type == BPF_PROG_TYPE_PERF_EVENT &&
+	    !bpf_overflow_handler(event, data, regs))
 		return ret;
 
 	/*


