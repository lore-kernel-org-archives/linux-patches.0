Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6799A35C1BC;
	Sat, 17 Oct 2026 16:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253907; cv=none; b=WTHZwgZDhwXCCokyHJEM4jBvqwPAYFfgyAWqfQtJ2Nl6UxcLlmNrrTNmcrb56yqzlCxpMsRoBifuNlUF+KAEQUj+nT9coU+VtS0qP9KPnj0xRj5xD+x1LpD2FGuyXejUpxrOuc/oUNKoSp+QZNJw+upa3V4ZF0Gi7tGtdJqi34k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253907; c=relaxed/simple;
	bh=rZ2jCnQj8zQ1CAhOC9XWeDSy7yQEGeJguhrfaa6cjkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYplKYClBWSH+J1PU6hD8qXlrzHZteMjurF1ryeuFUaXIR2GWtJN+hdmn/irTuIpiE0+VJFVPE3uYRh3DJhwLH4elyXqRHq9m7csY3HT2T1gwTr7rJrMU7y7yA8kKOmAlpsSeMyIyQ1F1QQm1GypBYIKdEmDC6XQF94ENx2p+PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrHbtjhL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrHbtjhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35F31F000C4;
	Sat, 17 Oct 2026 16:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253906;
	bh=upB3XXscFaJ/05d/rSIFJFnPjwumWuFRpJb3mTq1x2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrHbtjhLHlQ3RL69TXanjTFTFEso3AAXsxmCaiSJmJ3plls/BopW66ZaePCKhp0MV
	 BvK9k4qOI20kHgCO6OwjTQuDsJnM02qoKJg1/HQhmqyq+2SlTxaafJJAR0lbuTu9ro
	 klCT+PJfEZYdFWLiG2XO1Ietd5d3fmkPAxgWNTtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Gonnet <ggonnet.linux@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/869] bpf: Fix tcx/netkit detach permissions when prog fd isnt given
Date: Sat, 17 Oct 2026 17:51:53 +0200
Message-ID: <20261017160044.042880565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Guillaume Gonnet <ggonnet.linux@gmail.com>

[ Upstream commit ae23bc81ddf7c17b663c4ed1b21e35527b0a7131 ]

This commit fixes a security issue where BPF_PROG_DETACH on tcx or
netkit devices could be executed by any user when no program fd was
provided, bypassing permission checks. The fix adds a capability
check for CAP_NET_ADMIN or CAP_SYS_ADMIN in this case.

Fixes: e420bed02507 ("bpf: Add fd-based tcx multi-prog infra with link support")
Signed-off-by: Guillaume Gonnet <ggonnet.linux@gmail.com>
Link: https://lore.kernel.org/r/20260127160200.10395-1-ggonnet.linux@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h       |  5 +++++
 include/linux/bpf_mprog.h | 10 ++++++++++
 kernel/bpf/syscall.c      |  7 ++-----
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a63fd54ac6b4f..8bdb4ba4df7ee 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2999,6 +2999,11 @@ static inline void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
 }
 #endif /* CONFIG_BPF_SYSCALL */
 
+static inline bool bpf_net_capable(void)
+{
+	return capable(CAP_NET_ADMIN) || capable(CAP_SYS_ADMIN);
+}
+
 static __always_inline int
 bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr)
 {
diff --git a/include/linux/bpf_mprog.h b/include/linux/bpf_mprog.h
index 929225f7b0959..0b9f4caeeb0a3 100644
--- a/include/linux/bpf_mprog.h
+++ b/include/linux/bpf_mprog.h
@@ -340,4 +340,14 @@ static inline bool bpf_mprog_supported(enum bpf_prog_type type)
 		return false;
 	}
 }
+
+static inline bool bpf_mprog_detach_empty(enum bpf_prog_type type)
+{
+	switch (type) {
+	case BPF_PROG_TYPE_SCHED_CLS:
+		return bpf_net_capable();
+	default:
+		return false;
+	}
+}
 #endif /* __BPF_MPROG_H */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 857285a48d433..43081a7fb283a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1206,11 +1206,6 @@ static int map_check_btf(struct bpf_map *map, struct bpf_token *token,
 	return ret;
 }
 
-static bool bpf_net_capable(void)
-{
-	return capable(CAP_NET_ADMIN) || capable(CAP_SYS_ADMIN);
-}
-
 #define BPF_MAP_CREATE_LAST_FIELD map_token_fd
 /* called via syscall */
 static int map_create(union bpf_attr *attr)
@@ -4177,6 +4172,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 			prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
 			if (IS_ERR(prog))
 				return PTR_ERR(prog);
+		} else if (!bpf_mprog_detach_empty(ptype)) {
+			return -EPERM;
 		}
 	} else if (is_cgroup_prog_type(ptype, 0, false)) {
 		if (attr->attach_flags || attr->relative_fd)
-- 
2.53.0



