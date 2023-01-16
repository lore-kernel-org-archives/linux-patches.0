Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3933046B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA5EC433D2;
	Mon, 16 Jan 2023 16:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885325;
	bh=Xf0YJG6TZjlXGp1BWyASytylEJyAh8Ulj6sycuKFSmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzrAUdChXFMXPFwo1YSOGIw8R7+Ra8RJ9YNY9sOJtvFJy2c5OVzWO8wJUrw0Mm0MC
	 zmW2OiugE9eXUyLvnDOdhm8CRb8zTLzchRgizR9kvrKlH8eOCQjzKZ+7cOt3ilmOI1
	 DSY2WRm1GVooRwDHW2KME0e+KD3uuLfTwA7ZURsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <ptyadav@amazon.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 001/658] tracing/ring-buffer: Only do full wait when cpu != RING_BUFFER_ALL_CPUS
Date: Mon, 16 Jan 2023 16:41:29 +0100
Message-Id: <20230116154909.722935987@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pratyush Yadav <ptyadav@amazon.de>

full_hit() directly uses cpu as an array index. Since
RING_BUFFER_ALL_CPUS == -1, calling full_hit() with cpu ==
RING_BUFFER_ALL_CPUS will cause an invalid memory access.

The upstream commit 42fb0a1e84ff ("tracing/ring-buffer: Have polling
block on watermark") already does this. This was missed when backporting
to v5.4.y.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: e65ac2bdda54 ("tracing/ring-buffer: Have polling block on watermark")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -727,6 +727,7 @@ __poll_t ring_buffer_poll_wait(struct ri
 
 	if (cpu == RING_BUFFER_ALL_CPUS) {
 		work = &buffer->irq_work;
+		full = 0;
 	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
 			return -EINVAL;


