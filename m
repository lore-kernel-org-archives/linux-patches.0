Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214550;
	b=Axwc1HX8KI75Yhdqckq2sJ3aQPOTXY8q/MAvP+mLjgF6ROjlS56MP0+WvDChNvq0m3Tt
	 adhjdeerikb/fW4VlV/60HEztKEGFcVEwOm2nk9pKQAEzeQBL5mF/0vdw+rAxe6HTjh16
	 UNrWrZsGH0iAwKIfWG3rc+aI5Knm0MlIhr8UmVi72LiRsq2UnOokh/sW/i3PIPr4vrWZ3
	 u/l3R5pO1ICik6PNFwV7L/ZfiLEFV1Sb5c8lldnu2fz4PE/JuXIlWuMc4RTU+J5h9ywOK
	 v6gxlKXJPLi1VUEV38RmLLDVpqpBTMMnFGC0tYYMAZSlkJHlguCPOQex4k1+29s6zEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zj0QRHdlWU7awOdZCWImlzJSaFM+WpW8jKD+tpH40Qg=;
	b=3ayWjJkRFEtpkZQDps7AwwEtO4KHgZMYpv25dZVIEiuuc34ppA5qPD4cohtHm6UQOK1e
	 RaW/RhevQaDkGAHQ3atGN4ZZ/ePlGMHm9hBnuDRsGOoZSpNVDq+CZ+geX0UtXxh4ugngL
	 X7tdBmWJRKJW/934lMW/E+nG7ehaj1h5LWDTIaZp3RHHH8X2GXOwlg5xtTOu+I3mQXBUg
	 1Fw+I0AhS5Ry5afgKbY2U9OCV+7YTNTCoZwXYM3URnEgGRd3tiJwUDbrR9zBXzCDZF6k2
	 IsqDC3BZkfQj8DTPJwjL3Il0tpAF9kcBvQjKaef+GiRhoyA7vjnhBRaWH//joUC0Y1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yG0kW2Gl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038BD60A2607;
	Wed, 28 Oct 2026 19:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yG0kW2Gl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A90A1F01825;
	Wed, 28 Oct 2026 19:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214549;
	bh=Zj0QRHdlWU7awOdZCWImlzJSaFM+WpW8jKD+tpH40Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yG0kW2GlLt8K0M+BAZ2CthRLydDRGcrcZc9RIA+uqbOwrCMrsPcxi8/X577tNOVQi
	 N2EZHJqcfuFecWaPjq0W60jsOWgAvzW4oZwMrHjIriusCFPFxSdwK5Fg+lmO+3zwVd
	 Wkovtj7uRSNMCaHZ5ZQ/aj6VE2ZwWZU03OvSfNvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c9b724fbb41cf2538b7b@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0896/1887] bpf: Fix stackmap overflow check in __bpf_get_stackid()
Date: Wed, 28 Oct 2026 17:49:52 +0100
Message-ID: <20261028170519.808577861@linuxfoundation.org>
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

From: Arnaud Lecomte <contact@arnaud-lcm.com>

[ Upstream commit 23f852daa4bab4d579110e034e4d513f7d490846 ]

Syzkaller reported a KASAN slab-out-of-bounds write in __bpf_get_stackid()
when copying stack trace data. The issue occurs when the perf trace
 contains more stack entries than the stack map bucket can hold,
 leading to an out-of-bounds write in the bucket's data array.

Fixes: ee2a098851bf ("bpf: Adjust BPF stack helper functions to accommodate skip > 0")
Reported-by: syzbot+c9b724fbb41cf2538b7b@syzkaller.appspotmail.com
Signed-off-by: Arnaud Lecomte <contact@arnaud-lcm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/bpf/20251025192941.1500-1-contact@arnaud-lcm.com

Closes: https://syzkaller.appspot.com/bug?extid=c9b724fbb41cf2538b7b
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index f0fd936cef319..dcbc3b314d5c3 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -219,7 +219,7 @@ static long __bpf_get_stackid(struct bpf_map *map,
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
 	struct stack_map_bucket *bucket, *new_bucket, *old_bucket;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
-	u32 hash, id, trace_nr, trace_len;
+	u32 hash, id, trace_nr, trace_len, max_depth;
 	bool user = flags & BPF_F_USER_STACK;
 	u64 *ips;
 	bool hash_matches;
@@ -228,7 +228,10 @@ static long __bpf_get_stackid(struct bpf_map *map,
 		/* skipping more than usable stack trace */
 		return -EFAULT;
 
-	trace_nr = trace->nr - skip;
+	max_depth = map->value_size / stack_map_data_size(map) + skip;
+	if (max_depth > sysctl_perf_event_max_stack)
+		max_depth = sysctl_perf_event_max_stack;
+	trace_nr = min_t(u32, trace->nr - skip, max_depth - skip);
 	trace_len = trace_nr * sizeof(u64);
 	ips = trace->ip + skip;
 	hash = jhash2((u32 *)ips, trace_len / sizeof(u32), 0);
@@ -357,15 +360,11 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
 		return -EFAULT;
 
 	nr_kernel = count_kernel_ip(trace);
+	__u64 nr = trace->nr; /* save original */
 
 	if (kernel) {
-		__u64 nr = trace->nr;
-
 		trace->nr = nr_kernel;
 		ret = __bpf_get_stackid(map, trace, flags);
-
-		/* restore nr */
-		trace->nr = nr;
 	} else { /* user */
 		u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
 
@@ -376,6 +375,10 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
 		flags = (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
 		ret = __bpf_get_stackid(map, trace, flags);
 	}
+
+	/* restore nr */
+	trace->nr = nr;
+
 	return ret;
 }
 
-- 
2.53.0



