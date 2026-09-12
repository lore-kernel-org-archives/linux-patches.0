Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2151C33993;
	Sat, 12 Sep 2026 09:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203695; cv=none; b=Sy79inJHPgEKm+f08n4DPPBAJTpLcDDRhOdkihKFqL4cW95omnnb8L4qXM3lBOsWAw4sYTcEaBD9/CnL5RSZGz/R5ZbudtPS8epMms4QNXO/mIsWY4vLimFKf/scRgDrZp3vMi69JqjXWk0RwP+7+dsX7JLTVEZFHZzLJCsSv9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203695; c=relaxed/simple;
	bh=4rp3RbEy6ECq4XRXut/KoQyx/h4hbe7zUkxUqnsIfuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPgxMt7n88S3P5aKta9WqQcjsWRQVqlo/M2eRBN/OMtez/HCOBZ+iB1H6LRaK6h+9a9RVZ9skLAL9DK0KjMNLtKIAjUlI5z2W7vvy8vqElauF+gX2mI99CAMJtBCKxWYmoKDhDKVi2PpQtSTAIGZsmnf6d6BGtd0oRL7lcPbXO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xApcGfP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xApcGfP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA681F000FF;
	Sat, 12 Sep 2026 09:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203694;
	bh=N9MbVVVlSF0oAs5wSkDUrK37/eib34KsEBbO7q42fAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xApcGfP2pU9Vk7zW+TwrHlhlHDZoyqBCtwpvlzHfEcZumf6bLX2wtCla43bKWAZEx
	 APu4b74Fla4Jbf0ij8lLolraVyrGzwVnk81xBE4d5fFSreuDAmDroYTCm1buBXIA/i
	 a4agyUGhbhno3vu12vH2BwBCGPqbUofVTEG2kn50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1458/1815] ring-buffer: Remove trace_buffer::cpus
Date: Sat, 12 Sep 2026 08:53:28 +0200
Message-ID: <20260912065723.240866141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index eb01f1d650666..1925ee9cc36da 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -572,7 +572,6 @@ struct ring_buffer_per_cpu {
 
 struct trace_buffer {
 	unsigned			flags;
-	int				cpus;
 	atomic_t			record_disabled;
 	atomic_t			resizing;
 	cpumask_var_t			cpumask;
@@ -2783,7 +2782,6 @@ static struct trace_buffer *alloc_buffer(unsigned long size, unsigned flags,
 	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
 	init_waitqueue_head(&buffer->irq_work.waiters);
 
-	buffer->cpus = nr_cpu_ids;
 
 	bsize = sizeof(void *) * nr_cpu_ids;
 	buffer->buffers = kzalloc(ALIGN(bsize, cache_line_size()),
-- 
2.53.0



