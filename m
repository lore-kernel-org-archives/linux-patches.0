Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6571A186B;
	Thu,  6 Jun 2024 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683185; cv=none; b=un6gcprhXMBDmQbvcgZREIiGZGdOjd76zyGQ3/z1wbCVidBzl/w8ahgrEMSMLuUBrON5vUeHs6Sp4Wr1wJhlQreEq6SKlv/ezsB03EehEci192ofu7TptWvR5fyg0MnQX1W0L3RBdU0VYoSVEO2HBcer355rfUoIvlqMb2GTuQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683185; c=relaxed/simple;
	bh=t+iznMYcgUNeppzziZ3qb8KM8E8Idz3UVXqW67V0C1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvYTZLo20inOa92OoPRT91rlK0JGIFtktLN/b2zSSh9NIM085+7W3F+pHWhMos30DldER0Y3coqu87izUIpjyOc134Hkxq5ZoLICI8/zjezLMJ11ro+Ft6Snt5N9aAnvspSndXAPYE77eWAUGoJKOsc5Y5pd6Fa94Bb/OIfUjGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmSkUdOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmSkUdOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76256C2BD10;
	Thu,  6 Jun 2024 14:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683185;
	bh=t+iznMYcgUNeppzziZ3qb8KM8E8Idz3UVXqW67V0C1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmSkUdOu7kcsRAo2pbcoy7NMhPhkk4KRYJQWUd+i1yn/nihcbt+eDCJv7HjS9HsQO
	 +0XTg37g+a00WenEpKKO8UIWK1H+p9m9D3qk7PI6zr17j6SVly9JSpx0tAwlSjRkmU
	 xs34cXRiZnaPXA3JKz9xDmYGAgA/Fp+vwioE/Kjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <quentin@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/744] bpftool: Fix missing pids during link show
Date: Thu,  6 Jun 2024 15:56:41 +0200
Message-ID: <20240606131736.566587440@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit fe879bb42f8a6513ed18e9d22efb99cb35590201 ]

Current 'bpftool link' command does not show pids, e.g.,
  $ tools/build/bpftool/bpftool link
  ...
  4: tracing  prog 23
        prog_type lsm  attach_type lsm_mac
        target_obj_id 1  target_btf_id 31320

Hack the following change to enable normal libbpf debug output,
#  --- a/tools/bpf/bpftool/pids.c
#  +++ b/tools/bpf/bpftool/pids.c
#  @@ -121,9 +121,9 @@ int build_obj_refs_table(struct hashmap **map, enum bpf_obj_type type)
#          /* we don't want output polluted with libbpf errors if bpf_iter is not
#           * supported
#           */
#  -       default_print = libbpf_set_print(libbpf_print_none);
#  +       /* default_print = libbpf_set_print(libbpf_print_none); */
#          err = pid_iter_bpf__load(skel);
#  -       libbpf_set_print(default_print);
#  +       /* libbpf_set_print(default_print); */

Rerun the above bpftool command:
  $ tools/build/bpftool/bpftool link
  libbpf: prog 'iter': BPF program load failed: Permission denied
  libbpf: prog 'iter': -- BEGIN PROG LOAD LOG --
  0: R1=ctx() R10=fp0
  ; struct task_struct *task = ctx->task; @ pid_iter.bpf.c:69
  0: (79) r6 = *(u64 *)(r1 +8)          ; R1=ctx() R6_w=ptr_or_null_task_struct(id=1)
  ; struct file *file = ctx->file; @ pid_iter.bpf.c:68
  ...
  ; struct bpf_link *link = (struct bpf_link *) file->private_data; @ pid_iter.bpf.c:103
  80: (79) r3 = *(u64 *)(r8 +432)       ; R3_w=scalar() R8=ptr_file()
  ; if (link->type == bpf_core_enum_value(enum bpf_link_type___local, @ pid_iter.bpf.c:105
  81: (61) r1 = *(u32 *)(r3 +12)
  R3 invalid mem access 'scalar'
  processed 39 insns (limit 1000000) max_states_per_insn 0 total_states 3 peak_states 3 mark_read 2
  -- END PROG LOAD LOG --
  libbpf: prog 'iter': failed to load: -13
  ...

The 'file->private_data' returns a 'void' type and this caused subsequent 'link->type'
(insn #81) failed in verification.

To fix the issue, restore the previous BPF_CORE_READ so old kernels can also work.
With this patch, the 'bpftool link' runs successfully with 'pids'.
  $ tools/build/bpftool/bpftool link
  ...
  4: tracing  prog 23
        prog_type lsm  attach_type lsm_mac
        target_obj_id 1  target_btf_id 31320
        pids systemd(1)

Fixes: 44ba7b30e84f ("bpftool: Use a local copy of BPF_LINK_TYPE_PERF_EVENT in pid_iter.bpf.c")
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Quentin Monnet <quentin@isovalent.com>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20240312023249.3776718-1-yonghong.song@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
index 26004f0c5a6ae..7bdbcac3cf628 100644
--- a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
+++ b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
@@ -102,8 +102,8 @@ int iter(struct bpf_iter__task_file *ctx)
 				       BPF_LINK_TYPE_PERF_EVENT___local)) {
 		struct bpf_link *link = (struct bpf_link *) file->private_data;
 
-		if (link->type == bpf_core_enum_value(enum bpf_link_type___local,
-						      BPF_LINK_TYPE_PERF_EVENT___local)) {
+		if (BPF_CORE_READ(link, type) == bpf_core_enum_value(enum bpf_link_type___local,
+								     BPF_LINK_TYPE_PERF_EVENT___local)) {
 			e.has_bpf_cookie = true;
 			e.bpf_cookie = get_bpf_cookie(link);
 		}
-- 
2.43.0



