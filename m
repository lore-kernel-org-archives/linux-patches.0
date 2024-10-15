Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9991EBFE6;
	Tue, 15 Oct 2024 11:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992726; cv=none; b=afmAaIyoVMegZB9+OIUJObe+C/5DpfTdB1hgITH/BsbzRtbCqq2W8WkLdiV5EidyncIU03FUneC4kEFPabxbkwYQXHYQkzSwKEgf+/sMgPJP/g4JwX69f9mqJhEOQYsYQ288/VdnV/EVhDI5ukU2AZRsmbgjWO3Glcpgfm2ew9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992726; c=relaxed/simple;
	bh=0S5H2PkSDraWxsw57ezZjexqaDdJ5uUGlzuUQdBZGDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtPA1GKMcTulmWdzTciCwiQmFqehFKU/BaW+tWGaLAz4ryr1JsVlqMac20F19QNfpcBd4diFk2YOD4zoG1obqZTKUKdQOyCxpm1sxaEGVl0ZT+Awt7qt5fwlQNkyximu9VHPzPSt405od5Jyexx56GiNB7A5mmv/ktFeXlpDVac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XO/VaLeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XO/VaLeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4447C4CEC6;
	Tue, 15 Oct 2024 11:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992726;
	bh=0S5H2PkSDraWxsw57ezZjexqaDdJ5uUGlzuUQdBZGDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO/VaLeDPU9Rc+tbwq9X/yQXzqfMNWi2r97TJ1LD48neg/Zwz8bwv+OXOZYmjjAyM
	 oMKnwCzpKs1SAFC1Sh/SeXVFnB6FbY16eIYMouxVwkb62GiPb+VXrh05fBRM8cYh8H
	 FZ39yqh9rG4ud+wfz2Dj7EPZGMv8MOIyyM0h3H54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/691] selftests/bpf: Fix C++ compile error from missing _Bool type
Date: Tue, 15 Oct 2024 13:22:28 +0200
Message-ID: <20241015112448.295773657@linuxfoundation.org>
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

[ Upstream commit aa95073fd290b5b3e45f067fa22bb25e59e1ff7c ]

While building, bpftool makes a skeleton from test_core_extern.c, which
itself includes <stdbool.h> and uses the 'bool' type. However, the skeleton
test_core_extern.skel.h generated *does not* include <stdbool.h> or use the
'bool' type, instead using the C-only '_Bool' type. Compiling test_cpp.cpp
with g++ 12.3 for mips64el/musl-libc then fails with error:

  In file included from test_cpp.cpp:9:
  test_core_extern.skel.h:45:17: error: '_Bool' does not name a type
     45 |                 _Bool CONFIG_BOOL;
        |                 ^~~~~

This was likely missed previously because glibc uses a GNU extension for
<stdbool.h> with C++ (#define _Bool bool), not supported by musl libc.

Normally, a C fragment would include <stdbool.h> and use the 'bool' type,
and thus cleanly work after import by C++. The ideal fix would be for
'bpftool gen skeleton' to output the correct type/include supporting C++,
but in the meantime add a conditional define as above.

Fixes: 7c8dce4b1661 ("bpftool: Make skeleton C code compilable with C++ compiler")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/6fc1dd28b8bda49e51e4f610bdc9d22f4455632d.1722244708.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_cpp.cpp | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_cpp.cpp b/tools/testing/selftests/bpf/test_cpp.cpp
index a8d2e9a87fbfa..6edcb541cc90e 100644
--- a/tools/testing/selftests/bpf/test_cpp.cpp
+++ b/tools/testing/selftests/bpf/test_cpp.cpp
@@ -3,6 +3,10 @@
 #include <bpf/libbpf.h>
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
+
+#ifndef _Bool
+#define _Bool bool
+#endif
 #include "test_core_extern.skel.h"
 
 /* do nothing, just make sure we can link successfully */
-- 
2.43.0



