Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026FB1C07DD;
	Tue, 15 Oct 2024 13:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997298; cv=none; b=uH/GibSSWWcAwWf+5SlgetlFIzlHnu0W7XPWHGftzynjrJywy2kuYfm73Wgr1YeWOxLP5KlP1p4htB/6qjPIVHGvYP43Sp2QXz/JuezZ/vco3WiSNquSELcxXkWGlhS3Rvu1IAsDZuKkj/2bXyTALzapxkie2Y10pwkn7dEqVas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997298; c=relaxed/simple;
	bh=A0u1CKxA2On20zciSKEuVUov2iszfKTIXgpnD+Jx8gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfThUYzxCdhwnYxDC5xCcCAggVtnxo6GLRZmitr2sCMp0+jo+VYhmYqh895zdaptbURUBzjH53zzD/yS3EHjapzN/o8cGcJzPEitAPA4AKWuylhTblZijGSky7Bgb7hUQ3jJqZIRJRp1GJa/nZUKIhL1G1QLvmCoH9zFMWbg7rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wT9qnIiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wT9qnIiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2403EC4CEC6;
	Tue, 15 Oct 2024 13:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997297;
	bh=A0u1CKxA2On20zciSKEuVUov2iszfKTIXgpnD+Jx8gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wT9qnIiGOiatjcfHEUDV+vZ00KrX2LWM51wXzVONz9PP5oazC/ktdPovZORAkIIqj
	 9GVqeUTAULZUhiVByP/djTBruV/H6+ARw21J/9VtJ5SW0NfFnoIabPWK35eIdiCLV+
	 qWHOnpdVEeDAr7nuBiCyGoQFWoCdW/qsAblaMaQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/518] selftests/bpf: Fix C++ compile error from missing _Bool type
Date: Tue, 15 Oct 2024 14:40:47 +0200
Message-ID: <20241015123922.517073322@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



