Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B76947D94A;
	Sat, 12 Sep 2026 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218386; cv=none; b=p69on8ki1xZOPGc4ZhY4iAzP8r7loXOJ/khiowpWaPmuhwzLg8kuqssstHFgzjgYYdS+pJRX9CV19WgGSNHfBiJUHL2vrW8UG7Hjq8YkQkbT3XxgnwyhP96PBp5Pnpihin+bWRvJYvcd6y5ksKP043BafFopbBq7IdNlVRyBtoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218386; c=relaxed/simple;
	bh=sKAuWGc1yH55b4wNMe26Es+Vya/zrcaDZvoSyD0A1Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsmMc6OhoUdXZ0KfaO5hWuHRlRuVNA3zmQhMmQwU0APWCBphrSFnyEeGD6zOoM/efeLi9bGwDLFgLmfeti26x66Mo1g8+TdbNNm4wvWo7W4CSME76plOJix79KVdlyPLSWhF8MO2WlyGPCEksm1RYdQltvzKm07REQz50fzjo+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxxbxLzr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxxbxLzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A081F000FF;
	Sat, 12 Sep 2026 13:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218384;
	bh=p/QZA2m5j0tL61Bw4f1qM5jYWwV4DghTr4KMmcy3bKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxxbxLzr3crkm6y3xM6zbdEe6i7v8aL8+VspQGxBWwYZf/qzoh+M+rHqvybh46f5B
	 NsWcDEu+bbocQtYn1iflB1fI1oATVBVt7f0/5V+7wSQmaZW1vN2avqog6Hm4zanoXn
	 qX0NMaD7z49lEv55R5MARor/zv3i8Vv77X9SMkE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1134/1376] ring-buffer: Remove trace_buffer::cpus
Date: Sat, 12 Sep 2026 08:59:20 +0200
Message-ID: <20260912065632.835819061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit d9b5e22bf24d5c82522475306cd332b287ac43bc ]

The 'cpus' field in struct trace_buffer became useless in commit
8e7b58c27b3c ("ring-buffer: Just update the subbuffers when changing their
allocation order"). Remove it

Link: https://patch.msgid.link/20260813131152.3589632-9-vdonnefort@google.com
Fixes: 8e7b58c27b3c ("ring-buffer: Just update the subbuffers when changing their allocation order")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 47e6e1088e428..cfa08e9e64983 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -544,7 +544,6 @@ struct ring_buffer_per_cpu {
 
 struct trace_buffer {
 	unsigned			flags;
-	int				cpus;
 	atomic_t			record_disabled;
 	atomic_t			resizing;
 	cpumask_var_t			cpumask;
@@ -2407,7 +2406,6 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
 	init_waitqueue_head(&buffer->irq_work.waiters);
 
-	buffer->cpus = nr_cpu_ids;
 
 	bsize = sizeof(void *) * nr_cpu_ids;
 	buffer->buffers = kzalloc(ALIGN(bsize, cache_line_size()),
-- 
2.53.0



