Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621123;
	b=ALNOUZgpvGlQ4TzELhNLJHnDXPYUcT5QP8xhrTFe3lpY4fBuD5uLB97lpPkiehRx9H1q
	 cAl2/veFwsikJuomGSeswRnva2S0S63ubc3yGCMbwa3AlUDUrIMxuqRUg9mB4P2IVg9b3
	 XQa2OZ9pdqwxKXGQTCEvLpj7XPtXzk0osOLaWL9+GDAx3sG8+uzQpzJPQXNegwoHDQtAX
	 1Wo2fH3fXU/9SvvIn06kdaqe6NrbFthww3x+cCUh3DdxQHCHrBHjcM2NHg+Pjlicg1QK1
	 kKvMWUxJMwv1s2Jp8uISnHBcM9jJ9CIlrWas9/OH1tcnLVhjDFr8KPWavwNuCRcBaKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lqtGtaIIbOTQvm1ZlXKb1ZwkrIf82mC7dFrWnLh37pg=;
	b=X/rgTzujdCoDIo7Moc5e/SrHu75/DURUXCWS5R0FzVF+v59tBiXgAHi0yTefFFrjpOFN
	 +Z/vv9yuzrZaiPnXlzQ48HpX3NICSsK08r9ObjTr76TSHTQ+0mqtLNBzsASP5QBqDFJFp
	 zP/wC6khu3ySq6+fIHaiuYbwsouc2Ye0RvTJdI9pJYF1erz7UzjC9oY6pFWRNgsTF2fhy
	 sUSqIRBV+0rH03jZJYnObNhtd9BNB/AhmNht2X1g961TqSofVxSUkwBjaK8JZ2/CmKn0Y
	 qDUXpuyvp/T0NPw1l7sXF9zWpUhzSQGzxPj+44YTqJ3j+8AQ3NQbGYh99C4So2rlwIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOxaOMrJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8270C606A323;
	Wed, 25 Nov 2026 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOxaOMrJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A981F000C6;
	Wed, 25 Nov 2026 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621123;
	bh=lqtGtaIIbOTQvm1ZlXKb1ZwkrIf82mC7dFrWnLh37pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOxaOMrJ4FeQrA9SqH6WQ0F5eHaFHq/cLZEvJrFUXsBt656cLB38Ex3IVtUGSPPYI
	 fwbuvtNV4V8m+7CPTg4i3puujqMpIt8o2JFWykopoEwDzId6fcvqqKnopTWa6tEIiz
	 9BsVTpLL4yw/MOLzxwOcJTT8du1zxIVVdpsm6Bgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/990] bpf: Clamp the trace length before the skip test in stackid_init()
Date: Wed, 25 Nov 2026 15:24:39 +0100
Message-ID: <20261125143824.712258509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit a08ba2ab79dffd92c32d3f2dadfc7eba03625a2b ]

stackid_init() gives a bucket of the stack map
min(trace_nr - skip, max_depth - skip) trace entries. Here max_depth is the
size of a bucket plus skip, but at most perf_event_max_stack. Context
markers can make trace_nr larger than that, so the skip test can pass when
max_depth < skip. Then 'max_depth - skip' wraps, and the kernel can write
after the bucket.

Clamp trace_nr to max_depth before the skip test, as __bpf_get_stack_pe()
does. The result changes only when skip >= max_depth. Then it is -EFAULT.
Until now skip == max_depth could give the id of an empty trace.

get_perf_callchain() releases the trace, so an NMI can change trace->nr.
Use READ_ONCE() in bpf_get_stackid(), so the compiler reads it one time.

Fixes: 23f852daa4ba ("bpf: Fix stackmap overflow check in __bpf_get_stackid()")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-3-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 128c8d61070e4..aa87e8d2d7d2e 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -401,12 +401,14 @@ static int stackid_init(struct stackid *stackid, struct bpf_map *map,
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	u32 max_depth;
 
+	max_depth = stack_map_calculate_max_depth(map->value_size, stack_map_data_size(map), flags);
+	/* trace_nr can be above max_depth and max_depth below skip: clamp first */
+	trace_nr = min_t(u32, trace_nr, max_depth);
 	if (trace_nr <= skip)
 		/* skipping more than usable stack trace */
 		return -EFAULT;
 
-	max_depth = stack_map_calculate_max_depth(map->value_size, stack_map_data_size(map), flags);
-	stackid->nr = min_t(u32, trace_nr - skip, max_depth - skip);
+	stackid->nr = trace_nr - skip;
 	stackid->len = stackid->nr * sizeof(u64);
 	stackid->ips = trace->ip + skip;
 	stackid->hash = jhash2((const u32 *)stackid->ips, stackid->len / sizeof(u32), 0);
@@ -521,7 +523,8 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 			/* couldn't fetch the stack trace */
 			return -EFAULT;
 
-		err = stackid_fastpath(&stackid, map, trace, trace->nr, flags);
+		/* the entry is released already, an NMI can change trace->nr */
+		err = stackid_fastpath(&stackid, map, trace, READ_ONCE(trace->nr), flags);
 		if (err != -ENOENT)
 			return err;
 
-- 
2.53.0



