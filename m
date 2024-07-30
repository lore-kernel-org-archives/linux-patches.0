Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222AC1A76A9;
	Tue, 30 Jul 2024 17:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360205; cv=none; b=td0vyXBy/Hlkz88WOfsAel+/p+HjgiPYZoEU5QIr2/ZdNP7Asevz34FStLXcCwuJzsQBrJlp3sU6IM7YVOEIpqUjRiycZAbu/M4OpxM7YRSfn+xBpVTscnBbX3DF6pZLSQWqZk0JyArMy0mNUw/FZhi98E1SjZJYGiDfxi6FgA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360205; c=relaxed/simple;
	bh=lzDI+wbmrTmX4yBjyKm6jyJ6kXlAD0fyFy9rEQ0VIdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+fYj180ndqinz8J2XzgvCRj5MWRmEfIPbc5/m+tJe+IqKBt+P7QufqOK4Jx3zG3XTRPsjRWZS5bmFj9nqG5tKzL9kkt2YtcJ3PjdNdfBa3HpiwAiGCD8HQ1jo+AfS7Bgx0mQb/zMxaUsGKMBgaEe8ZAwGO1eAIhAdpooMPAcBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6IhWLeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6IhWLeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A030DC32782;
	Tue, 30 Jul 2024 17:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360205;
	bh=lzDI+wbmrTmX4yBjyKm6jyJ6kXlAD0fyFy9rEQ0VIdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6IhWLeuRvSBZYinFm+tHToi1f/Rk6IDtGk3hY4CRlV0aLWXjTGQkHjcMiU6Dtd7A
	 XgYzvhpbUYbxa84FqAdEj4/+pKXlTei3prpgVMSS3udndBSywvLnJpR3AF9rO+Phxi
	 QwSppoyMzxXIjSox3rSpDKZtGZnRyXXAQC96/RBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@goodmis.org,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"levi.yun" <yeoreum.yun@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 597/809] trace/pid_list: Change gfp flags in pid_list_fill_irq()
Date: Tue, 30 Jul 2024 17:47:53 +0200
Message-ID: <20240730151748.410228602@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: levi.yun <yeoreum.yun@arm.com>

commit 7dc836187f7c6f70a82b4521503e9f9f96194581 upstream.

pid_list_fill_irq() runs via irq_work.
When CONFIG_PREEMPT_RT is disabled, it would run in irq_context.
so it shouldn't sleep while memory allocation.

Change gfp flags from GFP_KERNEL to GFP_NOWAIT to prevent sleep in
irq_work.

This change wouldn't impact functionality in practice because the worst-size
is 2K.

Cc: stable@goodmis.org
Fixes: 8d6e90983ade2 ("tracing: Create a sparse bitmask for pid filtering")
Link: https://lore.kernel.org/20240704150226.1359936-1-yeoreum.yun@arm.com
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: levi.yun <yeoreum.yun@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/pid_list.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/pid_list.c
+++ b/kernel/trace/pid_list.c
@@ -354,7 +354,7 @@ static void pid_list_refill_irq(struct i
 	while (upper_count-- > 0) {
 		union upper_chunk *chunk;
 
-		chunk = kzalloc(sizeof(*chunk), GFP_KERNEL);
+		chunk = kzalloc(sizeof(*chunk), GFP_NOWAIT);
 		if (!chunk)
 			break;
 		*upper_next = chunk;
@@ -365,7 +365,7 @@ static void pid_list_refill_irq(struct i
 	while (lower_count-- > 0) {
 		union lower_chunk *chunk;
 
-		chunk = kzalloc(sizeof(*chunk), GFP_KERNEL);
+		chunk = kzalloc(sizeof(*chunk), GFP_NOWAIT);
 		if (!chunk)
 			break;
 		*lower_next = chunk;


