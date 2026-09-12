Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D6C32B125;
	Sat, 12 Sep 2026 19:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242284; cv=none; b=oD/sxbZRe9ru1dGUnUbRQQota1LJ8HeY1aZmaymla/+i0IeVFxObs4DxUFBuXVpsCFfHO59B0/+et9Wb9fx88wXPCr4qWAwmnibGCmYMkXXXWM6dE7aBR8N6KdAbrXpAaUkjTLN5XMDFN6zJF04MmVsqWu6U3vvsAh4onNKYsXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242284; c=relaxed/simple;
	bh=ksftsR3/VXi6/A7n4+6rDWF1kXyMnIu6txsxviQmwQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzX20l4wqHh4Lrm34sCuac0YKGWcxiEMfePz/IuGAu8LV+52xhj2S2Z3UlefgwqPERvRMiiUGI/7SIoDxqYvXupLrZzmI/l/gq2gTuS9mrkgCIyerknzrfg4cF47EdmPs1Fx3JsPCYC911gwUWCQAN9N1zVialLpi9Nn/j+Eie4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVWh47wc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVWh47wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306A41F000FF;
	Sat, 12 Sep 2026 19:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242282;
	bh=fW2nYKrSO4SjZeEcuHVHMcnBc/u72u0kMrH5ZfTrz4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVWh47wcNPP9d4w3FYrmPdmIaHKVSdmPvmeyKeksKFwMaplpGw0h2f+yjVL/jNKi/
	 tjvjs1rQPUW13AezAh+LVr/hZevKA4LcwHsSI/FQd5KSwvKBL0gPoJfKM73x0JjFwy
	 pZEppaeEobisfwIBvwjNFDcug+Esp1YeXlYMzX/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.10 333/798] bpf: Enforce expected_attach_type for tailcall compatibility
Date: Sat, 12 Sep 2026 08:59:21 +0200
Message-ID: <20260912065524.794497268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 4540aed51b12bc13364149bf95f6ecef013197c0 ]

Yinhao et al. recently reported:

  Our fuzzer tool discovered an uninitialized pointer issue in the
  bpf_prog_test_run_xdp() function within the Linux kernel's BPF subsystem.
  This leads to a NULL pointer dereference when a BPF program attempts to
  deference the txq member of struct xdp_buff object.

The test initializes two programs of BPF_PROG_TYPE_XDP: progA acts as the
entry point for bpf_prog_test_run_xdp() and its expected_attach_type can
neither be of be BPF_XDP_DEVMAP nor BPF_XDP_CPUMAP. progA calls into a slot
of a tailcall map it owns. progB's expected_attach_type must be BPF_XDP_DEVMAP
to pass xdp_is_valid_access() validation. The program returns struct xdp_md's
egress_ifindex, and the latter is only allowed to be accessed under mentioned
expected_attach_type. progB is then inserted into the tailcall which progA
calls.

The underlying issue goes beyond XDP though. Another example are programs
of type BPF_PROG_TYPE_CGROUP_SOCK_ADDR. sock_addr_is_valid_access() as well
as sock_addr_func_proto() have different logic depending on the programs'
expected_attach_type. Similarly, a program attached to BPF_CGROUP_INET4_GETPEERNAME
should not be allowed doing a tailcall into a program which calls bpf_bind()
out of BPF which is only enabled for BPF_CGROUP_INET4_CONNECT.

In short, specifying expected_attach_type allows to open up additional
functionality or restrictions beyond what the basic bpf_prog_type enables.
The use of tailcalls must not violate these constraints. Fix it by enforcing
expected_attach_type in __bpf_prog_map_compatible().

Note that we only enforce this for tailcall maps, but not for BPF devmaps or
cpumaps: There, the programs are invoked through dev_map_bpf_prog_run*() and
cpu_map_bpf_prog_run*() which set up a new environment / context and therefore
these situations are not prone to this issue.

[ Fixed conflict, applied the changes to bpf_prog_array_compatible
instead of __bpf_prog_map_compatible. Dropped the guard testing for
BPF_MAP_TYPE_PROG_ARRAY as bpf_prog_array_compatible is only called on maps whose
map_type is already BPF_MAP_TYPE_PROG_ARRAY, so the check was always true ]

Fixes: 5e43f899b03a ("bpf: Check attach type at prog load time")
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250926171201.188490-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 1 +
 kernel/bpf/core.c   | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5d5d0bc7ca50b..fb213524ccac1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -876,6 +876,7 @@ struct bpf_array_aux {
 		spinlock_t lock;
 		enum bpf_prog_type type;
 		bool jited;
+		enum bpf_attach_type expected_attach_type;
 	} owner;
 	/* Programs with direct jumps into programs part of this array. */
 	struct list_head poke_progs;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index db613a97ee5f9..c9b3fe8b250ae 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1795,10 +1795,14 @@ bool bpf_prog_array_compatible(struct bpf_array *array,
 		 */
 		array->aux->owner.type  = fp->type;
 		array->aux->owner.jited = fp->jited;
+		array->aux->owner.expected_attach_type = fp->expected_attach_type;
 		ret = true;
 	} else {
 		ret = array->aux->owner.type  == fp->type &&
 		      array->aux->owner.jited == fp->jited;
+		if (ret &&
+		    array->aux->owner.expected_attach_type != fp->expected_attach_type)
+			ret = false;
 	}
 	spin_unlock(&array->aux->owner.lock);
 	return ret;
-- 
2.53.0



