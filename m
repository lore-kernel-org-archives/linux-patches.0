Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5416719D8A3;
	Wed,  2 Oct 2024 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875946; cv=none; b=MFZIqTc05Ynv/XirO62nudjzB4KIysKUiUExuRBnHnDsBDoGh66dKwnje/MeXreJeoROXixutlZDlfRwEOlvm1MzwWfwdyH0rafnwaULJl52V4JV8PbLwUnClgBgsaCR6vrM9BH5KcfxGK7E7d7ZbVWlm/e9xd/MepLdyw4RcOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875946; c=relaxed/simple;
	bh=59B4+2oKGe1DgBCLsUPyEHgRz49VbrgiztbtjrhsBto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0bbFaS2GMItyhtDFMwgHrygs/fkFr1nKVnJQ7nxZJl+cTrjnKn2oGX87JE3C1svar6LR10QyzZILwvR8eBpVDr+FeQYV5o+Ow4OGUNJ13qSGk08VuEKXoFld+KIqFL9N8O/7HsmTu5EOw3PgbG3aMg7xjkmqoyS9S+XvsYvlX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKJ4EKpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKJ4EKpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBB2C4CEC5;
	Wed,  2 Oct 2024 13:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875946;
	bh=59B4+2oKGe1DgBCLsUPyEHgRz49VbrgiztbtjrhsBto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKJ4EKpKK8HrMbDgOJg40LawoQqUwNmuX6gopJpBpWanOtYmcSK1GaA+tb/fu3/NW
	 Vw24cXNUOg4huZT823UmueUkV64L5IEwzCaH5DBWv4wt6sQ2D9bIjXKuwhrdgvhV+a
	 9pKYjgLMRDXgJo+kv+M37reTgKkAAkw+zyoNZGik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 275/695] selftests/bpf: Fix compiling tcp_rtt.c with musl-libc
Date: Wed,  2 Oct 2024 14:54:33 +0200
Message-ID: <20241002125833.422041190@linuxfoundation.org>
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

[ Upstream commit 18826fb0b79c3c3cd1fe765d85f9c6f1a902c722 ]

The GNU version of 'struct tcp_info' in 'netinet/tcp.h' is not exposed by
musl headers unless _GNU_SOURCE is defined.

Add this definition to fix errors seen compiling for mips64el/musl-libc:

  tcp_rtt.c: In function 'wait_for_ack':
  tcp_rtt.c:24:25: error: storage size of 'info' isn't known
     24 |         struct tcp_info info;
        |                         ^~~~
  tcp_rtt.c:24:25: error: unused variable 'info' [-Werror=unused-variable]
  cc1: all warnings being treated as errors

Fixes: 1f4f80fed217 ("selftests/bpf: test_progs: convert test_tcp_rtt")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/f2329767b15df206f08a5776d35a47c37da855ae.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
index f2b99d95d9160..c38784c1c066e 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include "cgroup_helpers.h"
 #include "network_helpers.h"
-- 
2.43.0



