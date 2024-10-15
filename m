Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8AB1E7C02;
	Tue, 15 Oct 2024 11:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992716; cv=none; b=ct+7aJ9qBPo9vrzUmvpIUk4rDsXgMOQSiRWf23DU4e2pe3IjcKoZWJZ8exe80H5YueNt1HvK5MC85SM/gpXr3SNCqULxNaleyQ/WwD7LRNNqcXtLdbl0Wbn7V25G6C5embg2/OgZEzeUSHE61tQyyuxNNva7inVygAPJHK3XDDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992716; c=relaxed/simple;
	bh=mRmaQZwqTMec33Q+Pb87XivbgF892mM0zIDE6CTdX7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2nPX0qJY+NmLOkYX0+LlRNvQwH8Q6q743S7FqS4zlpvCl5/lp2TtVqy0wj27QXVQWNSVY6Q22F6eE+XoVDMAmXxREOyUnoiCN6pZvSqyLi4PP6CuYdwtxsWyg55atEpcMzBkiUCaCsCzvaeDOErieFDh/i2ulJ/jAtPZU7LcaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XwZpGPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XwZpGPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801C3C4CECE;
	Tue, 15 Oct 2024 11:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992716;
	bh=mRmaQZwqTMec33Q+Pb87XivbgF892mM0zIDE6CTdX7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XwZpGPUqwLH3MMgocyIai/iRAtZkFFnyrPHHNCF2zIe5tk6bykPfzd82KHrOu+sF
	 5hm5TFkdq0gC9ECZi63Bruip+meyL+Xzkoydegj+6nmwPpLLN5NF+eD/+nUp0lwI8z
	 aCb2fbx5u0dXMyF34s5afBM3jejnNTjfrmemseRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/691] selftests/bpf: Fix compiling core_reloc.c with musl-libc
Date: Tue, 15 Oct 2024 13:22:25 +0200
Message-ID: <20241015112448.175725346@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit debfa4f628f271f72933bf38d581cc53cfe1def5 ]

The type 'loff_t' is a GNU extension and not exposed by the musl 'fcntl.h'
header unless _GNU_SOURCE is defined. Add this definition to fix errors
seen compiling for mips64el/musl-libc:

  In file included from tools/testing/selftests/bpf/prog_tests/core_reloc.c:4:
  ./bpf_testmod/bpf_testmod.h:10:9: error: unknown type name 'loff_t'
     10 |         loff_t off;
        |         ^~~~~~
  ./bpf_testmod/bpf_testmod.h:16:9: error: unknown type name 'loff_t'
     16 |         loff_t off;
        |         ^~~~~~

Fixes: 6bcd39d366b6 ("selftests/bpf: Add CO-RE relocs selftest relying on kernel module BTF")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/11c3af75a7eb6bcb7ad9acfae6a6f470c572eb82.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 4739b15b2a979..ae2c7e8fb6600 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include "progs/core_reloc_types.h"
 #include "bpf_testmod/bpf_testmod.h"
-- 
2.43.0



