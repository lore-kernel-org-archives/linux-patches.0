Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216208;
	b=2MWxnzpyWHCrCGrHwMp7nmzKRrJ7AKL6yIgpVPFMaxXRIAEaIlog1DBatz14nymm6GSw
	 UxSOLqThx/Fq8LjaKNuUaNPgNQe+AUDKSgcezZ1Um7RQavG54qUNRIf3bwWpjztDAxVXo
	 zkuZfhNlnOVquVseG0Ypb6L6d12Z5eXq9Bl/+umfMmXiL1gAWrTk6rX0BMaJJt5arqq+P
	 PzAZmlGJ9tZ27AAebp1fa6qwqC/4mWXIG+XWauqZ7+AKP+EawpurAPmGSZCyHmlfVF69K
	 TDNqoQKMGZo4pJc8vmIAdSJqqFZoVglDxazuVSvEv+xqtR+p75E3wxNb32ktgSaARMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=khP7lcJ+9zgtTWJDgQZ9J3obcYp3JfnJ3E+S003M+u8=;
	b=Lpd5Xp57tL/MCpyxVS5kFJnh1m3suNEPtjfzqXJHwwndb3QbwxYPrMme3LMKSBS8g3Ui
	 a0ITKZ3IlAIRP1jhSi6UptDDWedA0c5HOyqazPiPmpXCWbKC7gGZhjIs8AjHLi97GgvrL
	 tMVlq4Lv317tThCqKZe3zLs6jXnEwNow6/eZUKqow9ETcH7LFnPCwkwdQOf0Qmb7bmZBI
	 /CiyYiEIHeWq1v6dkGEL+MO7/ubBY4G2/UVN8n1ajk2EQiNsH7FKQhpOJhu7rw2ID8uON
	 Lc1LHBI5G5PtelKTelE2r1Mzw1VxuoSvZTo8jzdvgUK0NnEBbEgLCTKBW5gjLzNvplA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSu3qgYF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05404606A333;
	Wed, 28 Oct 2026 19:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSu3qgYF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508781F01825;
	Wed, 28 Oct 2026 19:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216207;
	bh=khP7lcJ+9zgtTWJDgQZ9J3obcYp3JfnJ3E+S003M+u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSu3qgYFCA3nj1Orf2d6oZk0TD/Fyp1Y514n2Ys4CvLuGizub0tQ5T8RmGH6t3jzd
	 GBEsq8CKqlte7681BliKd4TnCUHB5KjQvjHL9sY8sTsagSABiz4tHO5AWqX2vqY5oX
	 hc329lMwZE0KfS/sdtWyKTZle2Ocezpr38E3i+is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1478/1887] bpf: Disable preemption in bpf_get_stackid
Date: Wed, 28 Oct 2026 17:59:34 +0100
Message-ID: <20261028170533.086892083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 15f1bd8574662f1b7b26aaa2e23ebf4066f0117d ]

The get_perf_callchain call needs disabled preemption plus we need
it disabled as long as we access its returned trace entries buffer.

Note the bpf_get_stackid_pe function is executed already with
preemption disabled.

Fixes: d5a3b1f69186 ("bpf: introduce BPF_MAP_TYPE_STACK_TRACE")
Reported-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260803210149.296496-6-jolsa@kernel.org

Closes: https://lore.kernel.org/bpf/20260206090653.1336687-2-chen.dylane@linux.dev/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 49652d55ba708..a8d54f650ff90 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -294,6 +294,7 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 	bool user = flags & BPF_F_USER_STACK;
 	struct perf_callchain_entry *trace;
 	bool kernel = !user;
+	long ret;
 
 	if (unlikely(flags & ~(BPF_F_SKIP_FIELD_MASK | BPF_F_USER_STACK |
 			       BPF_F_FAST_STACK_CMP | BPF_F_REUSE_STACKID)))
@@ -303,14 +304,17 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 	if (max_depth > sysctl_perf_event_max_stack)
 		max_depth = sysctl_perf_event_max_stack;
 
-	trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
-				   false, false);
+	scoped_guard(preempt) {
+		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
+					   false, false);
+		if (unlikely(!trace))
+			/* couldn't fetch the stack trace */
+			return -EFAULT;
 
-	if (unlikely(!trace))
-		/* couldn't fetch the stack trace */
-		return -EFAULT;
+		ret = __bpf_get_stackid(map, trace, flags);
+	}
 
-	return __bpf_get_stackid(map, trace, flags);
+	return ret;
 }
 
 const struct bpf_func_proto bpf_get_stackid_proto = {
-- 
2.53.0



