Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D4B3081C8;
	Mon, 13 Oct 2025 14:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367442; cv=none; b=swrjcpnV5Q+F7zw/fVHFiUaAZFKRKVi1cyS9rv0spLapeK81oop7GE6RslgzqzkDz7ODeOiu7Hzk7Wzgu5Q+3QQOkEVtAEPgqkUaBmywJtaQTwy5wEqVz9kW29EeOsaYSHKO3icvy4Hh169R2GQGPcXm9w15PkUc2nPj0ca3z+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367442; c=relaxed/simple;
	bh=2gV+NKftCI2/i9KnmnZ5/vGrT8lT2gCvPF7G7B/N/DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORYm7YLxZA+0UbL89qlBIOR9QcH2l2ma3ClzO5T8lGmBRPIKn0I5JC65+zmqky0Zfk1eYb4qvv9h+g6tO7qL5LpfEhMu3DX7Pr56lG4/MxWGZMCZwLoqXv8rR/0YUwIkmzLKyZWxwU/cF+gJKbtoez5ChSHrwRDVLkH7lHZq1I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNkr/8bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNkr/8bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4B8C4CEE7;
	Mon, 13 Oct 2025 14:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367442;
	bh=2gV+NKftCI2/i9KnmnZ5/vGrT8lT2gCvPF7G7B/N/DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNkr/8bjNW/qO1nFfqZX9BO95AVdt3bB3eEx9BqUceNeY26tayHzysR+HXS0VnOpu
	 5omh+YevabM/BV+NowzlHRMYv5lfZT5ndnslUtI+37BTgT61g6K1Wa+7zdNfYxBeIf
	 iM/ySXmbswi/6ZJD4sdGKWiYujxxHlWygGDXwxtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/196] bpf: Remove migrate_disable in kprobe_multi_link_prog_run
Date: Mon, 13 Oct 2025 16:43:25 +0200
Message-ID: <20251013144315.712533820@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8903db0b59602..a896b80252ae1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2726,18 +2726,23 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
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
 		err = 0;
 		goto out;
 	}
 
-	migrate_disable();
 	rcu_read_lock();
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	err = bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
 	rcu_read_unlock();
-	migrate_enable();
 
  out:
 	__this_cpu_dec(bpf_prog_active);
-- 
2.51.0



