Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1301D07AD;
	Wed,  2 Oct 2024 14:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877945; cv=none; b=qtmHXIXqK/1j2EymHmcIVjXub8WsTiRdZqMV0VYB76iWovj/ifx6kfaYovcgRohXstvPydZ+TrtyqGUO7v7OsL6pcqamXv5QjnLedqrgwR0wv4sUWMpNXfgUyT7DNa/D1Gtm1sxBDsT1Ktr7Q/FbUDVejPiS71s+XmelYbEquNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877945; c=relaxed/simple;
	bh=0L+lUWGbzSbuoy5sUloEMyt1UR+69W0wPAS+Qr9TluE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIgV74xtJnCYIY9+O8pjQtdJ1ZPn4nxvm7jg2APdqEpFyPZzJtlgxHVQIV/WjE9OAZLJ8xakyfhnR63QnQssj4ZKWSPi5R8MVSFOU4t7EDo/ozpTDKJOvuoGE8FVTfMVHGr4eMyV6W0fWDHwwYFYb1ShpLQ+10ccTXZiRedShMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7iP9RMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7iP9RMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89E9C4CEC2;
	Wed,  2 Oct 2024 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877945;
	bh=0L+lUWGbzSbuoy5sUloEMyt1UR+69W0wPAS+Qr9TluE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7iP9RMoctldIArxygsKAWTQ4BqAVAL7egmO5fP2Zkz+Hczw9yGuct3A4Cur5jCoY
	 r8IwOEE+I0S9fPGeRwLsyBDE4Ql5NG2u4SX60mL26N6/zqnD4cr34ZGgqohHc9r4RS
	 52i+VgS5k2TtgTkcUIKTXSI2ueuCmZfn7hLqQ9mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 249/634] selftests/bpf: Fix compiling core_reloc.c with musl-libc
Date: Wed,  2 Oct 2024 14:55:49 +0200
Message-ID: <20241002125820.926823282@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



