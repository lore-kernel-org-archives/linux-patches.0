Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B535354AEF;
	Tue, 16 Dec 2025 11:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885804; cv=none; b=iTvD795kNCSwq8VlWk5+VKX7hF4pYq8zBawfK3ueT7krMs89Y+8KcZB5NUpHd9U+Cm24QAt2nVIS+9MSeXkzldUv6/joMG8j4+mSJr9izLNjkDKQhJImLNPKIAGBsF3iYDyzu8V+KLRI0erqrlRtiY7QKrzYrTx7TXBgHkNlDEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885804; c=relaxed/simple;
	bh=+Uw0ajCvnhKfBtUidam7iNEJEzO/dt7W3kU/7Ej/1GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOPbR0kqMkssDEhj6CNhEXg2dVZwPNnOeO25rM1UHiekFjpIRLkXYeHQhjkkTKeSZmC6b2F2pjFVcDjEF00LyYaOvFmRydT8vi/9J7sQEnq6o+xl3eR6jYezYgL47EfvlNaaOyU3emk0S2YYYk8v99VspX6AIKMryDNGcqKJ9j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIdN6Dgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIdN6Dgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E82C4CEF1;
	Tue, 16 Dec 2025 11:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885804;
	bh=+Uw0ajCvnhKfBtUidam7iNEJEzO/dt7W3kU/7Ej/1GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIdN6DgshjKUdN9uzvz0vAxjn5QL9U2FyinAdIOmHVoqip9+QPtwIE3ibJ9Cg0m9p
	 ZE/B6vAAYOCMn5Z76q/KbL/ykCllBRBLH9ZnjzzBOSwTP+qofQD0ooE5HOGLt2lfbv
	 xe3Tr0t+AKXxSzpIjJjNQvnkOjnlx7cKSnqvTBVc=
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
Subject: [PATCH 6.17 242/507] bpf: Prevent nesting overflow in bpf_try_get_buffers
Date: Tue, 16 Dec 2025 12:11:23 +0100
Message-ID: <20251216111354.265517663@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 3eb02ce0dba3b..722314912ba8f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -774,9 +774,11 @@ int bpf_try_get_buffers(struct bpf_bprintf_buffers **bufs)
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
@@ -789,6 +791,7 @@ void bpf_put_buffers(void)
 	if (WARN_ON_ONCE(this_cpu_read(bpf_bprintf_nest_level) == 0))
 		return;
 	this_cpu_dec(bpf_bprintf_nest_level);
+	preempt_enable();
 }
 
 void bpf_bprintf_cleanup(struct bpf_bprintf_data *data)
-- 
2.51.0



