Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9C72ED843;
	Tue, 25 Aug 2026 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666471; cv=none; b=ACKemumSleluAsn8LEj6EhzP1Dg4r+lKtVu89ERRu4Hf3gQcRG4/eTIE+ovBWaGuGSVDCDDxjUeMjVrgLCPsZifHFHKs2Zv8uSxgpwm4e6RV3l5J5YM+2lCLhvdWPOnP1FhFjTofxWKqvtAHdyRBnCyLHw6sGfDgQXo7raBtrAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666471; c=relaxed/simple;
	bh=cIhaELCkW8cfVRnh4uvQ4oBWDPA31Z/vgU8z2GBGoIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDa8Nfk3IAPKDIQV39cC9gRU1yuYMhiemSjHq4biU5Yk+QhdBAxz1KLyNnSJt6aXK00s6HMJ3/s2N/kCerE5oEfbPDaVeL0Xh9i+fh9Xf84fyeBqJwz6jqxDejX6/HXEdRfqYkbo/FYzieRV+iZNaEk1z5i81Fagq8iuQxbyG+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=je+xljRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="je+xljRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6BF1F000E9;
	Tue, 25 Aug 2026 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666470;
	bh=ldUPWWzOaci0axnN7L2QLpmUmzGtlXrL9RUc/AIU0M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=je+xljRlWxpsHtKAHR2kCwNbVf2YHe16ppt+DNsSAJ4sc5FyX5DBuYkiXBdx/Ekoo
	 Iy4EAMjahpFg1x2+yUEWpY5UNRyuvIWNm6+6bvJahsOE4EugxKURGNHm6+KF7S7Fwg
	 F0EQtr5wx4MvTHP+2vp2a9YTFw+qNzPFuaZ+lJUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrey Troshin <drtrosh@yandex-team.ru>
Subject: [PATCH 5.10 52/57] bpf: reject negative CO-RE accessor indices in bpf_core_parse_spec()
Date: Tue, 25 Aug 2026 15:27:14 +0200
Message-ID: <20260825132543.378695177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 1c22483a2c4bbf747787f328392ca3e68619c4dc upstream.

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
[Andrey Troshin: backport fixs from tools/lib/bpf/relo_core.c to
  tools/lib/bpf/libbpf.c]
Signed-off-by: Andrey Troshin <drtrosh@yandex-team.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/libbpf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4554,6 +4554,8 @@ static int bpf_core_parse_spec(const str
 			++spec_str;
 		if (sscanf(spec_str, "%d%n", &access_idx, &parsed_len) != 1)
 			return -EINVAL;
+		if (access_idx < 0)
+			return -EINVAL;
 		if (spec->raw_len == BPF_CORE_SPEC_MAX_LEN)
 			return -E2BIG;
 		spec_str += parsed_len;


