Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4D34369A;
	Wed, 25 Feb 2026 01:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982926; cv=none; b=g7LnBeXt+ZQuf4Kiu5+hTu/qtJ4bNFZgVrjaiUlo2WKAe99IO+d67dnd5SrwriHsXMRnUJ0GX39aviYY+E5RIhwrnBgVBVhPXpu9sn+HbEL48Ol2pDNttNjuPlNgHA8McZYSdPtvXkFNOLOdkGUxtO2EIcYiLqg2uzk9uTG92xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982926; c=relaxed/simple;
	bh=xfU27sktbIjesrTQl1FAweryaQ7sthpswf+C2MlWiPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7FQVBLry0ctW9MGSY8XXKmJ4lD8AJyUjnvsIqtmML14FCI/bruFAen63ZbpNDrTsdN0lpKyGYhuYz2mvaA4zr6gL36bpCREhyvVkYWH3fPAZ0LzAQ/5ccJZfs105JZcsWpKJasK6jD/FN4IKfI1p/9k6DcsHp8MohMOJ+IIcuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJ552OPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJ552OPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C66C19423;
	Wed, 25 Feb 2026 01:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982926;
	bh=xfU27sktbIjesrTQl1FAweryaQ7sthpswf+C2MlWiPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ552OPSFGGzyECnK2nMX/azyQX8lp4trM2JBEWZRGW+pFJ4rFKDHcfwNXktdOYIv
	 ZoxdlwEjBRCcpnLk/9mGfPBhOCkpsDWCqULH49lL/A3RFbqU42tydMLB5wAY8/omd/
	 wJHfaW3l4hIpU4/YkGtVltUjuy6S7WcnB09xDmfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Gonnet <ggonnet.linux@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 104/781] bpf: Fix tcx/netkit detach permissions when prog fd isnt given
Date: Tue, 24 Feb 2026 17:13:33 -0800
Message-ID: <20260225012402.236913800@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index e5be698256d15..7b2e51216e736 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -3243,6 +3243,11 @@ static inline void bpf_prog_report_arena_violation(bool write, unsigned long add
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
index ee116a3b7baf7..763868d327b4a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1366,11 +1366,6 @@ static int map_check_btf(struct bpf_map *map, struct bpf_token *token,
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
@@ -4565,6 +4560,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
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



