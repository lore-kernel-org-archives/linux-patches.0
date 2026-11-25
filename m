Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624127;
	b=gnC4agwLrpX/R0h++gPM69HAi+9oO/0Bs9zZLTclOxG9P0VcVbOo4+hJrSkqE4cH/Cvh
	 ahDF/yjcnntN6GMjc+1YgWi1tjdFgUvQMZejLr/0+lIxZ/v/G6Qbk4yWfMwencF7Ukgur
	 hsYjW0lrBtdDaYpmFsvx86NZeBf2CxehrhOE+SK1OKT6SkK3Rc2gOTWPf03JOKsQKJexH
	 BTIAc19nGE7pSiwEFFf4BukRFIFhwoi33L9bIk6dcHovYyJScI9os0YLAY4nVDpArs/et
	 Ds7Gi2hWYV/nl1zGcd3pYMLP9gZkgIuVhb0H/Kc4SmSx586extOlvGvRSC4frBploDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ImKP4v9OL5IlaANIOiV3Sqg70j6nYQC9WTnI7gHtn9A=;
	b=4Bv/6eKn1gsh6pqg0zhi8p5aUpBgVwh6i6+1t0G+g5/38g2pBNEzE8qtP4phWQjXWGo4
	 4+2stHLm+vPUGXF4yEs/Z/Q4tMBCmJIbW1bV+nw4F2oP5bWUO3ZaIP/xfouuaGRY5iQHJ
	 6mFLyiwS+bCkxEBW7LIXDO2C9cTqBD++iXfVcNHzXNKlxNhPj6EXEN5tN8OVwuLGyGzVq
	 2S8BLyaYFF3PN6dWEw/LjMo7WdmpIM8cTc801JbyJydmGSEAjjXNy2GBRLwQN7hOmgxdW
	 CqOGvMxSzyLMVHGRZ3RnkKJWOloM45yTjOQdVNF1zugUnB+KSZ3WbtxQc9nmzXp5IWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j/VAE+62";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEC4606A32E;
	Wed, 25 Nov 2026 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j/VAE+62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6BA1F01561;
	Wed, 25 Nov 2026 16:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624126;
	bh=ImKP4v9OL5IlaANIOiV3Sqg70j6nYQC9WTnI7gHtn9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/VAE+62MiWqzZpYMbBrkKZBBjb+bqTabnpqNf/k2YKk8tjFWHYpxioqbclP1wEIB
	 OyxfPaZ3ztWqKDFebXmfEBD2pwXwIKVbbHnAZ7ghkGXQTImRor2gvNlxG+R/Slfmfq
	 CsZJ6PNZks2MFafjb/oJOZ1fb37sY8EFpFQLB2B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/816] bpf: Clamp the trace length before the skip test in stackid_init()
Date: Wed, 25 Nov 2026 15:27:23 +0100
Message-ID: <20261125143851.419489363@linuxfoundation.org>
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
index 43e27cd278c4a..5baf657ccb785 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -268,12 +268,14 @@ static int stackid_init(struct stackid *stackid, struct bpf_map *map,
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
@@ -388,7 +390,8 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 			/* couldn't fetch the stack trace */
 			return -EFAULT;
 
-		err = stackid_fastpath(&stackid, map, trace, trace->nr, flags);
+		/* the entry is released already, an NMI can change trace->nr */
+		err = stackid_fastpath(&stackid, map, trace, READ_ONCE(trace->nr), flags);
 		if (err != -ENOENT)
 			return err;
 
-- 
2.53.0



