Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB223481B3;
	Mon, 14 Oct 2024 14:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917931; cv=none; b=g8lNhvtpEfSy8fzH7+WG1iPgAC1p1S0kuMwqTv+EzNLVFLe8imZYhxrwr4d/Yn1hH+r42rmQqzM2x0rOBfjKuNmRw1HOzpvDxgKQEmDB7BKdj3IFU9aJ2bb1TjBeediSGPJqlBXk84Cd1M8tOqq490SRTNLYHuP3QhwbTfIXJx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917931; c=relaxed/simple;
	bh=DQyg8Fr5SuxqDR33HBNsRQbxr1zeHZmBKREXPNpAzgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hwv5bFCt2mZh6pwMFNkH9Nh40tnMBYL/TYt86QYZh9G2DBYgBeZsolRRYH/bVzKlHUiAkaYx5r+l79YDMrs/QdDwqdPul8CLPWqYOsfkS1U9ZiKLjgrZAibuoAB+FmJ8JqRBYuWZQSbi7eGtYvXX5kx5ZXaRbRgElrzr+NMVTp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpGgJupt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpGgJupt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D1AC4CEC3;
	Mon, 14 Oct 2024 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917931;
	bh=DQyg8Fr5SuxqDR33HBNsRQbxr1zeHZmBKREXPNpAzgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpGgJuptLNLTBYu3IY4QXpDIFtDj9y9I+PcUu7X3dTsLLJ+lKhtzbhYJEUZN/bNCl
	 O4ZYgWHgbl7hT+L7sjCJ6D2foCyo9IkLTsoOXZejR2PwlsVlU31XLDwFhNY8ganQ37
	 /44RENW7ZQJX0XH6E8lAz84nYNVZpb4MfPqLctH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/798] selftests/bpf: Fix C++ compile error from missing _Bool type
Date: Mon, 14 Oct 2024 16:11:51 +0200
Message-ID: <20241014141224.082705503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 19ad172036daa..2d2ffd772228d 100644
--- a/tools/testing/selftests/bpf/test_cpp.cpp
+++ b/tools/testing/selftests/bpf/test_cpp.cpp
@@ -6,6 +6,10 @@
 #pragma GCC diagnostic pop
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
+
+#ifndef _Bool
+#define _Bool bool
+#endif
 #include "test_core_extern.skel.h"
 
 template <typename T>
-- 
2.43.0



