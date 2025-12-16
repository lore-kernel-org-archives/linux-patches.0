Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECBC34C14C;
	Tue, 16 Dec 2025 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887631; cv=none; b=jnze5UVBKLQ8SKOE93frKvpDkLZ00qeWFS8beIDzr8NUcYrG+170E96DTAFd3ZT8/YV/3KV6l/+jurdgpUUD/eZJLLTcxgX80iSgvBDcDyXpAI3NT00eJ53Egwo54HpoR9a1qnAY6RRNTEEdCiAP3lb7up/MyDsMLokBBDoJgPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887631; c=relaxed/simple;
	bh=boAQcO+JropKPwhiRk9ebMDNspOOhPiltJU8jsIt0+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLHiG2pnzRuFdP5DrIBhXWKSXrOTdfOwYKtmG9C1PoODer0/81QWQezdJqHy2MQSEHSaYVPkNuiQANhdz/A9+QOXQ8a5lyvpCBR0FUCQAzBTAV5JdsPDUqnbpfKTnruzqMNa+LYn/5CFxV168TcdVxA3UdUVTajas3TC1jXy7vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSHgPin7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSHgPin7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E5AC4CEF1;
	Tue, 16 Dec 2025 12:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887631;
	bh=boAQcO+JropKPwhiRk9ebMDNspOOhPiltJU8jsIt0+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSHgPin7/BFPFf6oV+pzQGXBxcRi+7ZEPcvZz963WT+49BRvzUbC7Zj2JlDkL8Gem
	 fQN4tL+jFGfjiv1Nw2qXsKsFhxrDgp0smGC08zhwUizHAqdcx8zkdpVz2DPid+x/mP
	 0Y8Y6fGp2YGnG7ZTzWv5ip7+Xah5nOm9k8NLkICc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b0cff308140f79a9c4cb@syzkaller.appspotmail.com,
	Yonghong Song <yonghong.song@linux.dev>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sahil Chandna <chandna.sahil@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 291/614] bpf: Prevent nesting overflow in bpf_try_get_buffers
Date: Tue, 16 Dec 2025 12:10:58 +0100
Message-ID: <20251216111411.915453348@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sahil Chandna <chandna.sahil@gmail.com>

[ Upstream commit c1da3df7191f1b4df9256bcd30d78f78201e1d17 ]

bpf_try_get_buffers() returns one of multiple per-CPU buffers based on a
per-CPU nesting counter. This mechanism expects that buffers are not
endlessly acquired before being returned. migrate_disable() ensures that a
task remains on the same CPU, but it does not prevent the task from being
preempted by another task on that CPU.

Without disabled preemption, a task may be preempted while holding a
buffer, allowing another task to run on same CPU and acquire an
additional buffer. Several such preemptions can cause the per-CPU
nest counter to exceed MAX_BPRINTF_NEST_LEVEL and trigger the warning in
bpf_try_get_buffers(). Adding preempt_disable()/preempt_enable() around
buffer acquisition and release prevents this task preemption and
preserves the intended bounded nesting behavior.

Reported-by: syzbot+b0cff308140f79a9c4cb@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68f6a4c8.050a0220.1be48.0011.GAE@google.com/
Fixes: 4223bf833c849 ("bpf: Remove preempt_disable in bpf_try_get_buffers")
Suggested-by: Yonghong Song <yonghong.song@linux.dev>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
Link: https://lore.kernel.org/r/20251114064922.11650-1-chandna.sahil@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index e4007fea49091..81ef159ef89bd 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -777,9 +777,11 @@ int bpf_try_get_buffers(struct bpf_bprintf_buffers **bufs)
 {
 	int nest_level;
 
+	preempt_disable();
 	nest_level = this_cpu_inc_return(bpf_bprintf_nest_level);
 	if (WARN_ON_ONCE(nest_level > MAX_BPRINTF_NEST_LEVEL)) {
 		this_cpu_dec(bpf_bprintf_nest_level);
+		preempt_enable();
 		return -EBUSY;
 	}
 	*bufs = this_cpu_ptr(&bpf_bprintf_bufs[nest_level - 1]);
@@ -792,6 +794,7 @@ void bpf_put_buffers(void)
 	if (WARN_ON_ONCE(this_cpu_read(bpf_bprintf_nest_level) == 0))
 		return;
 	this_cpu_dec(bpf_bprintf_nest_level);
+	preempt_enable();
 }
 
 void bpf_bprintf_cleanup(struct bpf_bprintf_data *data)
-- 
2.51.0



