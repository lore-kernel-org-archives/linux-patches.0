Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0866D1D0E0A;
	Wed,  2 Oct 2024 14:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879694; cv=none; b=WvBE0fMLUS0K1rwrRUza3OMueagw/6wqhVShH2frYpY3EYEEZalYXVKKlg8L6rjLGsTk3GMNsOIQ/Xxhv+h/QxedvG2ljQrWq+kdtzbEgOEg13cB6cSeqXDcVjaSkZHMF4RhEvb6IWalpTnL6ADyEhaUi3CmHobmOGsaojqY/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879694; c=relaxed/simple;
	bh=RwCIiJmBV2DKzOY0GcMgkTu0AZIq1+xzr0B6IEwdhpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaCL6upiaQs9JrFciYk3K8sMz6E/2cIUcD+cZXiWhz7hxDZTmUzlfS9pipOpTpV9/A/FDsu5AqqDUYjkt1vrfUUKro9r++LKO5M73Lj+1ptvt6av1789zPqdU20kRMMuF2toppR3t+Gz+Az4EgJVpDWqbm1IBOYuWA5Gaw48Yw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWcJwQfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWcJwQfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8258CC4CEC2;
	Wed,  2 Oct 2024 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879693;
	bh=RwCIiJmBV2DKzOY0GcMgkTu0AZIq1+xzr0B6IEwdhpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWcJwQfsWiiEcAGlrgI/RkazclCIpLm39dPNrhogCdwsLsdoFPEqESdNsARoHHZs3
	 GmjMKjVjQeSdGMYnGu1k6C1Yx/GThRp4bXNYW9VOH7E368MHzqvnYFWb3DzxKRSE2e
	 GccT8PytCc/ycaEglN0VcxvDYQzxZCxjwdHqRlbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/538] selftests/bpf: Fix errors compiling cg_storage_multi.h with musl libc
Date: Wed,  2 Oct 2024 14:57:26 +0200
Message-ID: <20241002125800.425494335@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 730561d3c08d4a327cceaabf11365958a1c00cec ]

Remove a redundant include of '<asm/types.h>', whose needed definitions are
already included (via '<linux/types.h>') in cg_storage_multi_egress_only.c,
cg_storage_multi_isolated.c, and cg_storage_multi_shared.c. This avoids
redefinition errors seen compiling for mips64el/musl-libc like:

  In file included from progs/cg_storage_multi_egress_only.c:13:
  In file included from progs/cg_storage_multi.h:6:
  In file included from /usr/mips64el-linux-gnuabi64/include/asm/types.h:23:
  /usr/include/asm-generic/int-l64.h:29:25: error: typedef redefinition with different types ('long' vs 'long long')
     29 | typedef __signed__ long __s64;
        |                         ^
  /usr/include/asm-generic/int-ll64.h:30:44: note: previous definition is here
     30 | __extension__ typedef __signed__ long long __s64;
        |                                            ^

Fixes: 9e5bd1f7633b ("selftests/bpf: Test CGROUP_STORAGE map can't be used by multiple progs")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/4f4702e9f6115b7f84fea01b2326ca24c6df7ba8.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/cg_storage_multi.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/cg_storage_multi.h b/tools/testing/selftests/bpf/progs/cg_storage_multi.h
index a0778fe7857a1..41d59f0ee606c 100644
--- a/tools/testing/selftests/bpf/progs/cg_storage_multi.h
+++ b/tools/testing/selftests/bpf/progs/cg_storage_multi.h
@@ -3,8 +3,6 @@
 #ifndef __PROGS_CG_STORAGE_MULTI_H
 #define __PROGS_CG_STORAGE_MULTI_H
 
-#include <asm/types.h>
-
 struct cgroup_value {
 	__u32 egress_pkts;
 	__u32 ingress_pkts;
-- 
2.43.0



