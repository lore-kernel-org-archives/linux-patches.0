Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B626222599;
	Mon, 23 Jun 2025 22:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717375; cv=none; b=o/lw+MdJKYmiW6wmIaHuvRH1GgoU0f9nyb00aApKQ5TgeGy//eaqiVfdlWbfLv5Nd+kacdxUfQ0FqqOKT0rsHfgFwWxQEqBPolPaqSdRmkJ5tjgbBy9QX20YkLBzzJGewOFPT1bV/S+wXeJ2CxTGd6lGKjCpaCofDBz4zyOzD6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717375; c=relaxed/simple;
	bh=I2j/ARwoiM6FFK3DGmnkhGLvbAs3RRic1+zX3OIM39w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avPPRCRx1T0gQ7KgdkqmeMee1QDm0lpzVm+eefTS2AlpiF3fsBxTwZpusw8RGHCGN6AK+bpSGdPjHaz5BTDdzmV9IExYrVGOTsXCHUq6QCfzkjgIdTkXp9lbUHGw9Ct8MyEzfLuDZ5wNdblG8PMHTzD2vD+SgV/Y3sw8WcoA6wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWe0+vyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWe0+vyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B825AC4CEEA;
	Mon, 23 Jun 2025 22:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717375;
	bh=I2j/ARwoiM6FFK3DGmnkhGLvbAs3RRic1+zX3OIM39w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWe0+vyRgNHrGKFR78mjwiu9SKOfU48DDuGC1MaaBLMPYzxG0NieGH8oP/PcpDby6
	 60BghHcrNes9LscV86jHoRVJObzAlii68ukFXNCANCi168zwVmw29pCkFQeJZBIprW
	 UV7MzPOLXA4T/IoakdIUmE9QM6kyyTKHSlne6RIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <qmo@kernel.org>,
	Takshak Chahande <ctakshak@meta.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 414/508] bpftool: Fix cgroup command to only show cgroup bpf programs
Date: Mon, 23 Jun 2025 15:07:39 +0200
Message-ID: <20250623130655.399703474@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit b69d4413aa1961930fbf9ffad8376d577378daf9 ]

The netkit program is not a cgroup bpf program and should not be shown
in the output of the "bpftool cgroup show" command.

However, if the netkit device happens to have ifindex 3,
the "bpftool cgroup show" command will output the netkit
bpf program as well:

> ip -d link show dev nk1
3: nk1@if2: ...
    link/ether ...
    netkit mode ...

> bpftool net show
tc:
nk1(3) netkit/peer tw_ns_nk2phy prog_id 469447

> bpftool cgroup show /sys/fs/cgroup/...
ID       AttachType      AttachFlags     Name
...      ...                             ...
469447   netkit_peer                     tw_ns_nk2phy

The reason is that the target_fd (which is the cgroup_fd here) and
the target_ifindex are in a union in the uapi/linux/bpf.h. The bpftool
iterates all values in "enum bpf_attach_type" which includes
non cgroup attach types like netkit. The cgroup_fd is usually 3 here,
so the bug is triggered when the netkit ifindex just happens
to be 3 as well.

The bpftool's cgroup.c already has a list of cgroup-only attach type
defined in "cgroup_attach_types[]". This patch fixes it by iterating
over "cgroup_attach_types[]" instead of "__MAX_BPF_ATTACH_TYPE".

Cc: Quentin Monnet <qmo@kernel.org>
Reported-by: Takshak Chahande <ctakshak@meta.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/r/20250507203232.1420762-1-martin.lau@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/cgroup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index b46a998d8f8df..d157f58ec7d5a 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -284,11 +284,11 @@ static int show_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 
 static int do_show(int argc, char **argv)
 {
-	enum bpf_attach_type type;
 	int has_attached_progs;
 	const char *path;
 	int cgroup_fd;
 	int ret = -1;
+	unsigned int i;
 
 	query_flags = 0;
 
@@ -336,14 +336,14 @@ static int do_show(int argc, char **argv)
 		       "AttachFlags", "Name");
 
 	btf_vmlinux = libbpf_find_kernel_btf();
-	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
+	for (i = 0; i < ARRAY_SIZE(cgroup_attach_types); i++) {
 		/*
 		 * Not all attach types may be supported, so it's expected,
 		 * that some requests will fail.
 		 * If we were able to get the show for at least one
 		 * attach type, let's return 0.
 		 */
-		if (show_bpf_progs(cgroup_fd, type, 0) == 0)
+		if (show_bpf_progs(cgroup_fd, cgroup_attach_types[i], 0) == 0)
 			ret = 0;
 	}
 
@@ -366,9 +366,9 @@ static int do_show(int argc, char **argv)
 static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 			   int typeflag, struct FTW *ftw)
 {
-	enum bpf_attach_type type;
 	int has_attached_progs;
 	int cgroup_fd;
+	unsigned int i;
 
 	if (typeflag != FTW_D)
 		return 0;
@@ -400,8 +400,8 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 	}
 
 	btf_vmlinux = libbpf_find_kernel_btf();
-	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++)
-		show_bpf_progs(cgroup_fd, type, ftw->level);
+	for (i = 0; i < ARRAY_SIZE(cgroup_attach_types); i++)
+		show_bpf_progs(cgroup_fd, cgroup_attach_types[i], ftw->level);
 
 	if (errno == EINVAL)
 		/* Last attach type does not support query.
-- 
2.39.5



