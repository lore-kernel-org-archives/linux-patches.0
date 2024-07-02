Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F1B1BE251;
	Tue,  2 Jul 2024 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941370; cv=none; b=UWbIPVSnmWE6fN1cMYdvcUTXiDJwaBV8U2r4eQPnDgEL5Oac5sT0oK4TRcS6GQo/7nMpRXRkdVHiH+vwfMtYv5/n2jPFVNIAeJPdRiQT4sEI9jooO6vw1ikmpBAVDj/6+O06xWozEf1BlLljagcVI0Xoz7+dDtFyH0zpSh+fqI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941370; c=relaxed/simple;
	bh=Wgd0Az/OIXSrQBSuqeTJs3gblCgY2nOoybDY24S4hTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/rCRBvcc2aC+LN8bVuFyx8S+kb8qd0wZkLDGZN2ApHj18gj13++OFYGBb1prXBnvhgyUFOwDygPpLXrjNhSCGzAs9OWOhA0qHPIiw/Om8aE4shq10Xemo7VFMMNePqi84ARLwDBdwb464f6J/KVLjXik/k+67v92PyFL/62uJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsHT4EOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsHT4EOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2475FC116B1;
	Tue,  2 Jul 2024 17:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941369;
	bh=Wgd0Az/OIXSrQBSuqeTJs3gblCgY2nOoybDY24S4hTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsHT4EOVKpi+m4dS2QXH5wOasw4/2ndyFqaoB3xsnjyYhnmi/Ei6LyrcRcmaNxfns
	 h9SwvlwaHbkyLf32LayYiBv77OepXdUx0YlS3MvgrVS6yEhIpy4xKrbdHbDg6jH7fX
	 hy8q9GnXfFAEQmpvt5uekxrzrMYQN4Jqkh8q0uE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+603bcd9b0bf1d94dbb9b@syzkaller.appspotmail.com,
	syzbot+eb02dc7f03dce0ef39f3@syzkaller.appspotmail.com,
	syzbot+b4e65ca24fd4d0c734c3@syzkaller.appspotmail.com,
	syzbot+d2b113dc9fea5e1d2848@syzkaller.appspotmail.com,
	syzbot+1a3cf6f08d68868f9db3@syzkaller.appspotmail.com,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/128] bpf: Mark bpf prog stack with kmsan_unposion_memory in interpreter mode
Date: Tue,  2 Jul 2024 19:04:05 +0200
Message-ID: <20240702170227.900753834@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit e8742081db7d01f980c6161ae1e8a1dbc1e30979 ]

syzbot reported uninit memory usages during map_{lookup,delete}_elem.

==========
BUG: KMSAN: uninit-value in __dev_map_lookup_elem kernel/bpf/devmap.c:441 [inline]
BUG: KMSAN: uninit-value in dev_map_lookup_elem+0xf3/0x170 kernel/bpf/devmap.c:796
__dev_map_lookup_elem kernel/bpf/devmap.c:441 [inline]
dev_map_lookup_elem+0xf3/0x170 kernel/bpf/devmap.c:796
____bpf_map_lookup_elem kernel/bpf/helpers.c:42 [inline]
bpf_map_lookup_elem+0x5c/0x80 kernel/bpf/helpers.c:38
___bpf_prog_run+0x13fe/0xe0f0 kernel/bpf/core.c:1997
__bpf_prog_run256+0xb5/0xe0 kernel/bpf/core.c:2237
==========

The reproducer should be in the interpreter mode.

The C reproducer is trying to run the following bpf prog:

    0: (18) r0 = 0x0
    2: (18) r1 = map[id:49]
    4: (b7) r8 = 16777216
    5: (7b) *(u64 *)(r10 -8) = r8
    6: (bf) r2 = r10
    7: (07) r2 += -229
            ^^^^^^^^^^

    8: (b7) r3 = 8
    9: (b7) r4 = 0
   10: (85) call dev_map_lookup_elem#1543472
   11: (95) exit

It is due to the "void *key" (r2) passed to the helper. bpf allows uninit
stack memory access for bpf prog with the right privileges. This patch
uses kmsan_unpoison_memory() to mark the stack as initialized.

This should address different syzbot reports on the uninit "void *key"
argument during map_{lookup,delete}_elem.

Reported-by: syzbot+603bcd9b0bf1d94dbb9b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/000000000000f9ce6d061494e694@google.com/
Reported-by: syzbot+eb02dc7f03dce0ef39f3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/000000000000a5c69c06147c2238@google.com/
Reported-by: syzbot+b4e65ca24fd4d0c734c3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/000000000000ac56fb06143b6cfa@google.com/
Reported-by: syzbot+d2b113dc9fea5e1d2848@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/0000000000000d69b206142d1ff7@google.com/
Reported-by: syzbot+1a3cf6f08d68868f9db3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/0000000000006f876b061478e878@google.com/
Tested-by: syzbot+1a3cf6f08d68868f9db3@syzkaller.appspotmail.com
Suggested-by: Yonghong Song <yonghong.song@linux.dev>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20240328185801.1843078-1-martin.lau@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 16d15d5d1e197..0ea0d50a7c161 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2034,6 +2034,7 @@ static unsigned int PROG_NAME(stack_size)(const void *ctx, const struct bpf_insn
 	u64 stack[stack_size / sizeof(u64)]; \
 	u64 regs[MAX_BPF_EXT_REG] = {}; \
 \
+	kmsan_unpoison_memory(stack, sizeof(stack)); \
 	FP = (u64) (unsigned long) &stack[ARRAY_SIZE(stack)]; \
 	ARG1 = (u64) (unsigned long) ctx; \
 	return ___bpf_prog_run(regs, insn); \
@@ -2047,6 +2048,7 @@ static u64 PROG_NAME_ARGS(stack_size)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5, \
 	u64 stack[stack_size / sizeof(u64)]; \
 	u64 regs[MAX_BPF_EXT_REG]; \
 \
+	kmsan_unpoison_memory(stack, sizeof(stack)); \
 	FP = (u64) (unsigned long) &stack[ARRAY_SIZE(stack)]; \
 	BPF_R1 = r1; \
 	BPF_R2 = r2; \
-- 
2.43.0



