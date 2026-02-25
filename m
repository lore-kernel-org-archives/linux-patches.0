Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CEA256C84;
	Wed, 25 Feb 2026 01:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983861; cv=none; b=bo/vK0U2Ux4qDw5sBmYBysQN/SS4xMpsI/hUNAJrQSkf01LZ3HNwH0hGtWUG30PeI0xk7g5WHv+yoQAfw190X9oa6LuWoBo4eAebbIFXSnRf9QME89Lxck3/3wn9ONd5vAK+1iUX83ugu3QxMoFrJIzvza5OrYUnMd/rAcHx4mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983861; c=relaxed/simple;
	bh=WFsYtMSohbn0/iEhgp3ybl2HqXqS7Ml2usLFPmR7Vi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfZ9kIcOvG2dKvIxRvdyR2nHE3Vbtjb0vlv97J+UHlVAI6XpoeTjUH0EcHeAgoXuoIQiivkN6m7Yila5kC83VOStgAvjYnDtzELNLH8dxfBVIUJnSE4ttp11WH96rKHowl8MGGxCUURfo1Yb+DTCe6SWIdS72yX3fJBc9QH/zlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e92z8KhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e92z8KhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3074FC116D0;
	Wed, 25 Feb 2026 01:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983861;
	bh=WFsYtMSohbn0/iEhgp3ybl2HqXqS7Ml2usLFPmR7Vi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e92z8KhDIWV7xHbb5Qo0T8HXU2uF482XW0RtFtIyyvzGU/YPjXQ0Cv7aDptGKu0vs
	 vJDnbJbH5hcxN38RJxNY7fu5/+43cxdJ/ljnzc/aAPHm6j7trp0ZO6PE0RphPCKqu0
	 e2wLhUBgt/RZ+UFmQMsFe1TsyJKIj6aQJiibdmlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Gonnet <ggonnet.linux@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/641] bpf: Fix tcx/netkit detach permissions when prog fd isnt given
Date: Tue, 24 Feb 2026 17:17:01 -0800
Message-ID: <20260225012351.405863188@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d808253f2e945..e2dd3a6d495af 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -3200,6 +3200,11 @@ static inline void bpf_prog_report_arena_violation(bool write, unsigned long add
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
index e9cf69594824c..f39367765f0c4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1365,11 +1365,6 @@ static int map_check_btf(struct bpf_map *map, struct bpf_token *token,
 	return ret;
 }
 
-static bool bpf_net_capable(void)
-{
-	return capable(CAP_NET_ADMIN) || capable(CAP_SYS_ADMIN);
-}
-
 #define BPF_MAP_CREATE_LAST_FIELD excl_prog_hash_size
 /* called via syscall */
 static int map_create(union bpf_attr *attr, bpfptr_t uattr)
@@ -4554,6 +4549,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 			prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
 			if (IS_ERR(prog))
 				return PTR_ERR(prog);
+		} else if (!bpf_mprog_detach_empty(ptype)) {
+			return -EPERM;
 		}
 	} else if (is_cgroup_prog_type(ptype, 0, false)) {
 		if (attr->attach_flags || attr->relative_fd)
-- 
2.51.0



