Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9293E95A4;
	Wed, 20 May 2026 18:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300165; cv=none; b=LRkS7juU7Etb04C2UmmH0C/2s/Ae6QnNvQ+FiIv5afmeRi9Dlcnx8LBdB31cIjbOzNctUf8wwXJqoD2R1DP5BflGg91p9SU2bKg/vSOey0t8PoKd+nwyFDoAEGm6unPp86uey7WO1XXv+KrWpCIFZ/pb8hB7WFlh91djeGVmc90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300165; c=relaxed/simple;
	bh=+1JcpVOCHXMQMtPSjAaZF1JopU+KR/vU9iWfKtBWuuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gySG7URItGE52eObdWt/W6YRU5vTmYV1pqAPOe5pYGYKsYeCvuQC0OM6IXabyOqk2M/nc2WALf4vuBPGDtYuaHQXjnP37YmqWl4hEQsSqUzzKVYPECEwwK4Q3GscSKvsO13yHtYcaIY+bkbrWRhRh+PsrcSPpVW7frID7P3kgs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZMigbus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZMigbus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A121F00898;
	Wed, 20 May 2026 18:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300163;
	bh=BeWGe/6HJJwi9Yq2KJX+9Y+vWZu7i/DcUV74G4Typag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZMigbusIxpFD6BlnWHHdHP2KPoRzzSFPJ+aGVj/zb5giTp7e1hYxFwm8uMQ+r2/b
	 CefiIAoqyZEv6Ug6lDuizKT+1gVlXQps5R76l05aGPKmtUgo5QhHOk2NNXyX43EhAH
	 H6FXNrAzxHrtneBBjc3yCbANTTsNOTygU92N90IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/666] bpf: reject negative CO-RE accessor indices in bpf_core_parse_spec()
Date: Wed, 20 May 2026 18:14:40 +0200
Message-ID: <20260520162112.726835876@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 1c22483a2c4bbf747787f328392ca3e68619c4dc ]

CO-RE accessor strings are colon-separated indices that describe a path
from a root BTF type to a target field, e.g. "0:1:2" walks through
nested struct members. bpf_core_parse_spec() parses each component with
sscanf("%d"), so negative values like -1 are silently accepted.  The
subsequent bounds checks (access_idx >= btf_vlen(t)) only guard the
upper bound and always pass for negative values because C integer
promotion converts the __u16 btf_vlen result to int, making the
comparison (int)(-1) >= (int)(N) false for any positive N.

When -1 reaches btf_member_bit_offset() it gets cast to u32 0xffffffff,
producing an out-of-bounds read far past the members array.  A crafted
BPF program with a negative CO-RE accessor on any struct that exists in
vmlinux BTF (e.g. task_struct) crashes the kernel deterministically
during BPF_PROG_LOAD on any system with CONFIG_DEBUG_INFO_BTF=y
(default on major distributions).  The bug is reachable with CAP_BPF:

 BUG: unable to handle page fault for address: ffffed11818b6626
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 Oops: Oops: 0000 [#1] SMP KASAN NOPTI
 CPU: 0 UID: 0 PID: 85 Comm: poc Not tainted 7.0.0-rc6 #18 PREEMPT(full)
 RIP: 0010:bpf_core_parse_spec (tools/lib/bpf/relo_core.c:354)
 RAX: 00000000ffffffff
 Call Trace:
  <TASK>
  bpf_core_calc_relo_insn (tools/lib/bpf/relo_core.c:1321)
  bpf_core_apply (kernel/bpf/btf.c:9507)
  check_core_relo (kernel/bpf/verifier.c:19475)
  bpf_check (kernel/bpf/verifier.c:26031)
  bpf_prog_load (kernel/bpf/syscall.c:3089)
  __sys_bpf (kernel/bpf/syscall.c:6228)
  </TASK>

CO-RE accessor indices are inherently non-negative (struct member index,
array element index, or enumerator index), so reject them immediately
after parsing.

Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algorithm")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/20260404161221.961828-2-bestswngs@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/relo_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index 63a4d5ad12d1a..04c8febfc0aa7 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -293,6 +293,8 @@ int bpf_core_parse_spec(const char *prog_name, const struct btf *btf,
 			++spec_str;
 		if (sscanf(spec_str, "%d%n", &access_idx, &parsed_len) != 1)
 			return -EINVAL;
+		if (access_idx < 0)
+			return -EINVAL;
 		if (spec->raw_len == BPF_CORE_SPEC_MAX_LEN)
 			return -E2BIG;
 		spec_str += parsed_len;
-- 
2.53.0



