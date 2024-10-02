Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1171D04A0;
	Wed,  2 Oct 2024 13:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875975; cv=none; b=mw1RoJvoIgITWkRKoD0Zpq6Ja0vwK8HRAuCfIQFyCG0uNJzlXOtbP8tnXkVVqJljrOZ2hHNFSZ+L7bu/Ssps6Yz/Syeo5kLye08sDW6Mu76izqi2QSIZq8zb/O3SLXcPRTRCsXxofRCwGIQHFxNMW2FHmI5IJvQQAHZ1NGHNFU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875975; c=relaxed/simple;
	bh=STmIuj3WUvUeRKIEpqCMI3j5Hj10t46Xx/f6XQXsdD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4sIb/ll34o0tCn72l4IJVKum3gumdxt1lm3pXDEwjcEHKBMmQux/hZ84BxgZsOZVuhxUi73YnJ9JjVfZTJvM47sDvDr7ZSyB2JDR/fO1LubKV3eWlGph5JrfUo5+HcVvOKVXkxr3ePEyAqmZw5h3VHPY0u+aqNIod64mL2cbZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2XOQGEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2XOQGEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4459C4CEC5;
	Wed,  2 Oct 2024 13:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875975;
	bh=STmIuj3WUvUeRKIEpqCMI3j5Hj10t46Xx/f6XQXsdD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2XOQGEpIIn4an+Sj3KGOlTqc4exndFJdIDVAmUyersAVLRJqlfS/BE1zpTqDqkYs
	 dIO5U1ykmxTRXH5aHgACeVi48bxvWc2R2rF8LUSODGa5rMNHdBERFQJxquF2qTMLr9
	 pxWUxrsDnvk6vMqODahfTL0m7mYvTEDzdBs7+0Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 284/695] selftests/bpf: Fix C++ compile error from missing _Bool type
Date: Wed,  2 Oct 2024 14:54:42 +0200
Message-ID: <20241002125833.781231396@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index dde0bb16e782e..abc2a56ab2616 100644
--- a/tools/testing/selftests/bpf/test_cpp.cpp
+++ b/tools/testing/selftests/bpf/test_cpp.cpp
@@ -6,6 +6,10 @@
 #include <bpf/libbpf.h>
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
+
+#ifndef _Bool
+#define _Bool bool
+#endif
 #include "test_core_extern.skel.h"
 #include "struct_ops_module.skel.h"
 
-- 
2.43.0



