Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAD61F16B;
	Sat, 17 Oct 2026 17:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258641; cv=none; b=dtB34SXiunjwOPVWm/MnOflcefsUegNhmxHWPMFMgysVGaLx/CB6TAgjEWnHPVITdOsttHsnkkGY4grK6dxvfrGf6NbcubkTS6hW9FXV+mqDgskSYzCa94s59zHM/t1s8/dFuKx+o4iq6LmY4G9FK2nJgu7ptSUDcQW16od6OgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258641; c=relaxed/simple;
	bh=BtvO4TriIX5aD5n9EC1jefJfjrSIS2vYozD0BmEL3jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRhXIBOW0ecmCVOUvz4wExFGbfBoBNjjMHKBqDTIgXM9kZURFKXKbOoz1oBbXNOpuWcdFf+g1OnyiS9Nsu2ov6S51vCNdK1D3jDXsZoqNwDhqcnEITiOhKUnJdnXvDtVXrUJJ/UpkTQf9svRhmUPlaj5PrK6iA7/UKU64WIzQlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OphVT4dN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OphVT4dN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087DC1F000C4;
	Sat, 17 Oct 2026 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258640;
	bh=YJGCh7Y84doyYmwEeXbvdwv4QlC86kLqtVRuHjGmcic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OphVT4dN7wH0fxgper0AE4QFuWm0bhBrQRqMYqSHtAayQVbZH0axvLcfbO+ON1M5s
	 eJVBRl0R7Yhhhc3b/ajhpuEvMQMgVP/P8Hko3OJNXDuP73wHQ4Yymx92b9U6qkWOV/
	 CYPJfaSEm8F877oiOqKRZM/xdKP7IC+fyTJVi6PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Gonnet <ggonnet.linux@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0951/1674] bpf: Fix tcx/netkit detach permissions when prog fd isnt given
Date: Sat, 17 Oct 2026 17:53:43 +0200
Message-ID: <20261017160455.540453508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 kernel/bpf/syscall.c      |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b1bc7b2ddfae..12a2d3efdad1f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2798,6 +2798,11 @@ static inline void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
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
index cd31c926f5da3..c5c84dc2159db 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4018,6 +4018,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 			prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
 			if (IS_ERR(prog))
 				return PTR_ERR(prog);
+		} else if (!bpf_mprog_detach_empty(ptype)) {
+			return -EPERM;
 		}
 	} else if (attr->attach_flags ||
 		   attr->relative_fd ||
-- 
2.53.0



