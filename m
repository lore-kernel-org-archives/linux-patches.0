Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460F530C37A;
	Mon, 13 Oct 2025 15:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368033; cv=none; b=aCzBocwUvu94KUyiLNZt48s3eiRBDnJ8z6+EBKSdLck+5i6a4SFobONOUZig0Zy6J+RcjXsN//Uoobu68Uo64EEiN04ZpdBnWQ+IyBIRr1q+ouW1t1dCSgbECyWd3Ie2iGSrhZqzLkci4GMAg6XF/vKyaOuMaz27qrJ9t+5WeOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368033; c=relaxed/simple;
	bh=aVNusDdpjQFpZIFBqBWO/hIf4hb/JmCuGTnR/UHXTPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YawTWdBQMIT0C5unO3cpCgYLAZs7lc8YWDVfYigICNp9peMYg9ZfTb6bncggCDiAkYgSIwKLjA2k/JE63nJHjhd1cCW274aapW9Srk7o1owCss3o/94+Xham4vLxI/dL9lmhF+RwQGUfzLprOwu6YqCVxRU/9jdd2N6l8GWv71E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYnKu/qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYnKu/qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C22C4CEE7;
	Mon, 13 Oct 2025 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368032;
	bh=aVNusDdpjQFpZIFBqBWO/hIf4hb/JmCuGTnR/UHXTPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYnKu/quaFypZKX1Z47Hn7tTxsIUz3rmfPHdW4haNRHBlG7AAgtcx+5FgRu7kxIOF
	 IB8DOsBFIzRLY3/qsGg2uS+4xBnJELtM34SOM4nQUzzQeHYYhjWe4O3KmGkn+KqyjA
	 8gyPYXKEkidaJiMqsX/smK6Az9aAXYYvy2eWR9iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/262] bpf: Remove migrate_disable in kprobe_multi_link_prog_run
Date: Mon, 13 Oct 2025 16:42:42 +0200
Message-ID: <20251013144326.858339146@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit abdaf49be5424db74e19d167c10d7dad79a0efc2 ]

Graph tracer framework ensures we won't migrate, kprobe_multi_link_prog_run
called all the way from graph tracer, which disables preemption in
function_graph_enter_regs, as Jiri and Yonghong suggested, there is no
need to use migrate_disable. As a result, some overhead may will be reduced.
And add cant_sleep check for __this_cpu_inc_return.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250814121430.2347454-1-chen.dylane@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3ec7df7dbeec4..4a44451efbcc6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2759,19 +2759,24 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 	struct bpf_run_ctx *old_run_ctx;
 	int err;
 
+	/*
+	 * graph tracer framework ensures we won't migrate, so there is no need
+	 * to use migrate_disable for bpf_prog_run again. The check here just for
+	 * __this_cpu_inc_return.
+	 */
+	cant_sleep();
+
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
 		bpf_prog_inc_misses_counter(link->link.prog);
 		err = 0;
 		goto out;
 	}
 
-	migrate_disable();
 	rcu_read_lock();
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.session_ctx.run_ctx);
 	err = bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
 	rcu_read_unlock();
-	migrate_enable();
 
  out:
 	__this_cpu_dec(bpf_prog_active);
-- 
2.51.0



