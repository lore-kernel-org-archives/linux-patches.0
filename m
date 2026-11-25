Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624120;
	b=nokO8ttCUbGcIyn/ft13FM8xmsRI3vUCY/9K+zEQ9b0KmgOMlavVkPBOhuqLc30V+SGZ
	 pfRmyCVjCXZ2kUU2xlWhAdI6drSNFP1MqNbOmXmpXXoAJMOxQWYOV8pSuLg36qYCm15Cz
	 kcFDVuFsZoAaRmnct8k9rdr1olk/Z3Yaf/sBa7aQCB9i1c66ml4vFrXeO/dw1iYdhOV2F
	 85euufet6SLiuFBKv/DpJsjH366ptVoGsMumwwH8xZ0O/sjaXSWS7XA69FBY0364m2zBA
	 y6+RysXUAhVRsBqmQQn4kGA+jozIEfMDXBWfvYDn3ItEcPU02GK0XynZJATx2LY0qvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V0/zDpJ0gTuwTKAb5KXaDe6raYo4EGlYhzIJ/fS3Gys=;
	b=mDYaFr06cdHu9K5pdnzcmMCi7Nvsqfutmsf0miLlC/ea8O6hz6NEV4FRxcPTXTwawEnE
	 N9h/nBUqgtcIbE23vPL4NUFYSKf14HfAmCQnblV7HGPSrEngcbI3R3kyN8sswyg6c5qDg
	 0H7O4TZJftViaOMz5rATttGkjKHKO0lPzrzFr4laSW4ZUGempySqxIVqEDWMkuaExSzZZ
	 nR5cLZDAyYSP+4oNwOEVxQ7OCL7elVez7Yx++nGLc5YADIlsyigfl4uJw/fx1Y2ehoINe
	 K7rCmmeLR4JU5JCkst/AhfVGUk4rHuYY5jFBUzl/ojRBmik85+0t2aHGj74p8FU80FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUBo2Szn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55148606A323;
	Wed, 25 Nov 2026 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUBo2Szn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F841F000EB;
	Wed, 25 Nov 2026 16:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624120;
	bh=V0/zDpJ0gTuwTKAb5KXaDe6raYo4EGlYhzIJ/fS3Gys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUBo2SznTMIrpON3+CdSonn7p7fyWQLsHlytaeswolp0kpK1xSpb0k5EsTPj2G4Yh
	 hO8zQg1jVLLwL3BYluytmeYlDo8demwYMV+Cry8QhsJUADngCVJs5HCzuhCwKi4B6f
	 Fn01TJy1ggFVV4v4aKQEA0QfPdYi2KMKXVVg+RC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/816] bpf: Clamp the trace length in __bpf_get_stack() again
Date: Wed, 25 Nov 2026 15:27:21 +0100
Message-ID: <20261125143851.374651548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 007fd460798be9af7d4874734f934afa47742f29 ]

get_perf_callchain() and get_callchain_entry_for_task() store a trace in a
per-CPU entry, one per context. They release the entry before they return
it. Thus a second user in the same context can write to the entry while the
first user reads it. preempt_disable() stops only other tasks.

__bpf_get_stack() requests at most max_depth frames. This is skip plus the
frames that fit in the buffer, but not more than perf_event_max_stack.
Since the commit below, it copies 'trace->nr - skip' frames with no limit.
But a second user can store a longer trace. The unwinders of PowerPC add
context markers that max_depth does not limit. In both cases the copy
writes after the end of the buffer.

Read trace->nr one time. Clamp the value to max_depth before the skip test,
as __bpf_get_stack_pe() does. Thus when max_depth is less than skip, the
helper returns -EFAULT, and 'trace_nr - skip' does not underflow. The
copied frames can still be those of the second user.

Fixes: e17d62fedd10 ("bpf: Refactor stack map trace depth calculation into helper function")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index e57f092437800..d38d8e49a789d 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -573,14 +573,20 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 					   crosstask, false);
 	}
 
-	if (unlikely(!trace) || trace->nr < skip) {
-		if (may_fault)
-			rcu_read_unlock();
-		preempt_enable();
-		goto err_fault;
-	}
+	if (unlikely(!trace))
+		goto err_unlock;
 
-	trace_nr = callchain_store(trace, trace->nr, buf, elem_size, flags);
+	/*
+	 * trace->nr can be above max_depth. The per-CPU entry is released
+	 * already: a tracing program or an NMI which takes a callchain in the
+	 * same context before the copy below reuses it. And the unwinders of
+	 * PowerPC store context markers on top of max_depth.
+	 */
+	trace_nr = min_t(u32, READ_ONCE(trace->nr), max_depth);
+	if (trace_nr < skip)
+		goto err_unlock;
+
+	trace_nr = callchain_store(trace, trace_nr, buf, elem_size, flags);
 
 	/* trace should not be dereferenced after this point */
 	if (may_fault)
@@ -589,6 +595,10 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 
 	return callchain_finalize(buf, size, trace_nr, elem_size, flags, may_fault);
 
+err_unlock:
+	if (may_fault)
+		rcu_read_unlock();
+	preempt_enable();
 err_fault:
 	err = -EFAULT;
 clear:
-- 
2.53.0



