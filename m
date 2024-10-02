Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500071D1F6B;
	Wed,  2 Oct 2024 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879685; cv=none; b=Nln512p/SDQeflRKIXYLZ7RN/QcDMdRHolzIdQMGtcI+cPTTzQJ+ckL20vlgKMirLeDUfjAM0cpTw5NTGV+wp/+vOt2RoJZ1RE+Qj8TgW8Et0gf1u6VYj3REqxiZRDE983m6IJaBR7xgBWebohSrCmiy4NqsFQiXZuCJprBLJdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879685; c=relaxed/simple;
	bh=3Saap2/o9iw+pRmvGspJNMo70ptycNUhxf2Hx6i9htQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgVcndB47PskMiFZJSHKSMB3mTIHGBfFCcUrbis3MHvyvWVTDBLy/+Y2rZYYIQE0tDHurReOeY7pPnOe+P3nY7sqcfbrvF2k5EJiJu/je6Cjy6olcfCBU8tI5N1HOP2iQpgTvmUVFIZDIX3CqTo8RA9smE33qqE8vxTouPbSS30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxUrhxsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxUrhxsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3246C4CEC2;
	Wed,  2 Oct 2024 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879685;
	bh=3Saap2/o9iw+pRmvGspJNMo70ptycNUhxf2Hx6i9htQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxUrhxsvQG8GMeeTaDntxLVCBfjtWRqXvu/FZhac7eciOQXDopBhsHlPjzkT7/1BG
	 aG/o1fPqovchE9dSxb6QzkUrMIJDzDbFAviE6lPLt8xtKj0UvrdsaFjgksFYw5Q+kB
	 Vw8pdQhAMcwGDPTPVXtBcnsBMR4V0aAR9n+lbpyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/538] selftests/bpf: Fix compiling core_reloc.c with musl-libc
Date: Wed,  2 Oct 2024 14:57:23 +0200
Message-ID: <20241002125800.306978504@linuxfoundation.org>
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
index 47f42e6801056..26019313e1fc2 100644
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



