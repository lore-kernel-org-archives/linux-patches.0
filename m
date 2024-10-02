Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326E31D0B82;
	Wed,  2 Oct 2024 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879720; cv=none; b=ZTq4OufLNisj/tIFk7CpWXxlRxV0kwB0FbgxvpqkodJfj3XQwGX+jBUuXRHTj7smAyTisZOyY3fuKDD9Lq4c8dlx916jEZiZi/iRJWtatbW7XW1ztQYqYJZHM/CvtpVJGVxhLCOKSo2UvCDk0G8foxRkAwIUXwVPYra/mVEW9V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879720; c=relaxed/simple;
	bh=JrwwpoVl+Vtlj0HBxSI26CEktES2Yi5WsFk5pZGznA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtPyn9lwnwYelngHTmpZQNjPCHqiKvnsf/1dsll1chIphO2ILTXjKJeOwSzQ8T/74M9OKXLh2H2k347w4WXmq+bs4O4KdDvpdclOB2MIH7syDyk7jk5mCP2CyKQi/0v0XLtW1GOQvfsFUQhYVVVsyjTbOX0ZhxJj7Zl0/WcQEIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/HoYUZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/HoYUZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2403C4CEC2;
	Wed,  2 Oct 2024 14:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879720;
	bh=JrwwpoVl+Vtlj0HBxSI26CEktES2Yi5WsFk5pZGznA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/HoYUZMl1Q9efwt0O83iHALy3BzDlhjX30xSdSlco1KxxHpj5yvqcvM7m/hqcgmN
	 dNuaMMMMMGL1AyJ76X6On7MYxezKcssPCCQ8mzV/htoTvvpTNQCYiazwXBdszqTHL+
	 WeAQmAUbbdJVNBjTg1rutKyrbNqDShEXBssWVhUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/538] selftests/bpf: Fix C++ compile error from missing _Bool type
Date: Wed,  2 Oct 2024 14:57:34 +0200
Message-ID: <20241002125800.744120841@linuxfoundation.org>
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
index f4936834f76f4..435341c254208 100644
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
 
 template <typename T>
-- 
2.43.0



