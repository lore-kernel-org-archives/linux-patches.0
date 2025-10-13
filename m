Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50412DA75A;
	Mon, 13 Oct 2025 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367583; cv=none; b=ktZWtrFcsuHYA2ZK6FdS0kxaGfOgPenGg/fI4CBn6OwZGq4wx8k+66tzeMG+r+SuG71sXo1jGEnF7/+T3k4ajP80furMlSDKcIOHVYBBpvWFgojYCAmiRSZjmbrKZ/4nK+qStnNC7H95OmJHQcYIfcTKgNhHzR0UIXat4I5o5+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367583; c=relaxed/simple;
	bh=5HpMWz7xs6aN+DD5juA/0lSVV/KSUiG27EkoSWwJD80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iyr9VlsGM9eQ9asM47yu+3lirirrF2MSI19jzknXfvJrXOq3UBoIC+GVOagn20r2vrLwAvydbEGciBFqPA+qVSLvxIqI1N3vP7z4F6FZ68mn1sMPR3jNNJfWm9++KKp7+rCj2qIn3CBGFmJn9yTPqcvT6yEqQ/hmNl7dJEv9f+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhuITACd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhuITACd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DEEC4CEFE;
	Mon, 13 Oct 2025 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367583;
	bh=5HpMWz7xs6aN+DD5juA/0lSVV/KSUiG27EkoSWwJD80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhuITACdud+n9PiC8Jt0IeGquDBX3+km73Tqzjf/Cj1tWsYsFIX1M3zxXdbQuhwWU
	 HNMQLcDRaxM2hws6GPNqNlSZm76t8gECO1HvHqa1t/FbIhDfCPm09YCgObk83QuMDF
	 oUSqTrBSTS4p+s2KSCIkKiofjW4lMUNIyX+Ka6G0=
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
Subject: [PATCH 6.6 061/196] bpf: Enforce expected_attach_type for tailcall compatibility
Date: Mon, 13 Oct 2025 16:44:12 +0200
Message-ID: <20251013144317.403860146@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 83da9c81fa86a..0af6b2a5273ad 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -269,6 +269,7 @@ struct bpf_map_owner {
 	bool xdp_has_frags;
 	u64 storage_cookie[MAX_BPF_CGROUP_STORAGE_TYPE];
 	const struct btf_type *attach_func_proto;
+	enum bpf_attach_type expected_attach_type;
 };
 
 struct bpf_map {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3618be05fc352..a343248c35ded 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2279,6 +2279,7 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
 		map->owner->type  = prog_type;
 		map->owner->jited = fp->jited;
 		map->owner->xdp_has_frags = aux->xdp_has_frags;
+		map->owner->expected_attach_type = fp->expected_attach_type;
 		map->owner->attach_func_proto = aux->attach_func_proto;
 		for_each_cgroup_storage_type(i) {
 			map->owner->storage_cookie[i] =
@@ -2290,6 +2291,10 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
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



