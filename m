Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250511A2630;
	Mon, 13 Oct 2025 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367187; cv=none; b=XGbz5yMnjlcLYqdb9A2Al5uKqcobDNXKdSf+cl5BFHENVvhcmp0pTjjFa+beAHYTlQgKot2F0SP7hnsF2ebbMksbi3a0mqQxWVIXZzAfD0dRn1OS0gFtAeqUQ/Ti/HHKN8Fs1ftiK7fhheQDcaDx+rDVffVwQCBa1dchRFwoX+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367187; c=relaxed/simple;
	bh=RQYZdPXP/ghDoMgMkRA0OaJdR09OnY3q1T0Ow9KxeiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEMbir8Fmgcz2UjGStpo/ToIfCs2qCk/Ia7o7OASKr7+4iux7wPcQDYD9+uRMu+iqfRjgaxE7fKcSMIsGIEmZYmn7GKUrkftEJzTXIf+pWqDyRYf/AYGTagizffo7fFNHYvgfpni67I1L6g0AEoiRxOtvkz8KZe9FGaAf2rl/6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuB1wnT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuB1wnT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518D7C4CEE7;
	Mon, 13 Oct 2025 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367186;
	bh=RQYZdPXP/ghDoMgMkRA0OaJdR09OnY3q1T0Ow9KxeiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuB1wnT5HqAcPnJkiej/Kc9n/wZFRQzXRj9HFGQLuEJUeGnC0g2lmOIwpEUZFsZEx
	 zHD45om8o506hLRmufcpoj+xrX7jkHU6bDl/0Ka9029bXB4Dk1mXDqNt7NojclbTkz
	 SmUiMvIRkKUU9RgKGVPEPmFf6xPcP8i/4VMaGNF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/196] bpf: Enforce expected_attach_type for tailcall compatibility
Date: Mon, 13 Oct 2025 16:44:22 +0200
Message-ID: <20251013144317.791347596@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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

Fixes: 5e43f899b03a ("bpf: Check attach type at prog load time")
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250926171201.188490-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 1 +
 kernel/bpf/core.c   | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5f01845627d49..142a21f019ff8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -228,6 +228,7 @@ struct bpf_map_owner {
 	bool xdp_has_frags;
 	u64 storage_cookie[MAX_BPF_CGROUP_STORAGE_TYPE];
 	const struct btf_type *attach_func_proto;
+	enum bpf_attach_type expected_attach_type;
 };
 
 struct bpf_map {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3136af6559a82..6924f86a8a3ff 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2137,6 +2137,7 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 		map->owner->type  = prog_type;
 		map->owner->jited = fp->jited;
 		map->owner->xdp_has_frags = aux->xdp_has_frags;
+		map->owner->expected_attach_type = fp->expected_attach_type;
 		map->owner->attach_func_proto = aux->attach_func_proto;
 		for_each_cgroup_storage_type(i) {
 			map->owner->storage_cookie[i] =
@@ -2148,6 +2149,10 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 		ret = map->owner->type  == prog_type &&
 		      map->owner->jited == fp->jited &&
 		      map->owner->xdp_has_frags == aux->xdp_has_frags;
+		if (ret &&
+		    map->map_type == BPF_MAP_TYPE_PROG_ARRAY &&
+		    map->owner->expected_attach_type != fp->expected_attach_type)
+			ret = false;
 		for_each_cgroup_storage_type(i) {
 			if (!ret)
 				break;
-- 
2.51.0



