Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F72FBEF;
	Tue, 25 Jun 2024 09:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308206; cv=none; b=XIzmGHX8nptHwOBZUaNMaCLx4zL25i+YWQg56jqsMnhd//ZA4TnlMl2JYCB+kcAdjafe9rcxfbIba0pZUCD8KSXY+ZMYJfpN74A05XmvclLOIQ//vUcfHNoMakPU4d5rokojanWjKYc9zlZr6UoN2WwZk3OsPVy2WUtnJVs2ROc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308206; c=relaxed/simple;
	bh=bVJ+cXu36CBofQqGk/8KvNw+V1mVH/z7Mu3tFHHIDLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3vChp94FxIzZ1RCraRJr8UQ2nTeYSjQhtOmR4pWRbZlY6zz/pyBaC2CPmdPvcOUzYtwU8Xk2ldY/9cA7yBv/OqzO7lVzb1bRqp88+dAq5RJA14RFjXajQw4BX7v6qGOzC64h+MccgtlwlZl0XRUWW4ksOOIfMPEqkD4TZH3QBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BN4jc+FI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BN4jc+FI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F8AC32781;
	Tue, 25 Jun 2024 09:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308206;
	bh=bVJ+cXu36CBofQqGk/8KvNw+V1mVH/z7Mu3tFHHIDLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BN4jc+FIXtcivUVqM6LuwXZe3NZNM9HpvQCEbSBuggxc0zmkx8fcHeF7xHw5cU9ER
	 0pf2LnL9a+k61LJs1Hcn0sKEpnSYh4W/5bqSJ2tBu+CGIclaGrCguIZ/ljdagtSCOh
	 b1YlbVXgV5qrakNU9WOR5Em97IkCe9lqvXQN/lwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>,
	david.faust@oracle.com,
	cupertino.miranda@oracle.com,
	Yonghong Song <yonghong.song@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 043/250] bpf: avoid uninitialized warnings in verifier_global_subprogs.c
Date: Tue, 25 Jun 2024 11:30:01 +0200
Message-ID: <20240625085549.714247196@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose E. Marchesi <jose.marchesi@oracle.com>

[ Upstream commit cd3fc3b9782130a5bc1dc3dfccffbc1657637a93 ]

[Changes from V1:
- The warning to disable is -Wmaybe-uninitialized, not -Wuninitialized.
- This warning is only supported in GCC.]

The BPF selftest verifier_global_subprogs.c contains code that
purposedly performs out of bounds access to memory, to check whether
the kernel verifier is able to catch them.  For example:

  __noinline int global_unsupp(const int *mem)
  {
	if (!mem)
		return 0;
	return mem[100]; /* BOOM */
  }

With -O1 and higher and no inlining, GCC notices this fact and emits a
"maybe uninitialized" warning.  This is by design.  Note that the
emission of these warnings is highly dependent on the precise
optimizations that are performed.

This patch adds a compiler pragma to verifier_global_subprogs.c to
ignore these warnings.

Tested in bpf-next master.
No regressions.

Signed-off-by: Jose E. Marchesi <jose.marchesi@oracle.com>
Cc: david.faust@oracle.com
Cc: cupertino.miranda@oracle.com
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20240507184756.1772-1-jose.marchesi@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/progs/verifier_global_subprogs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_global_subprogs.c b/tools/testing/selftests/bpf/progs/verifier_global_subprogs.c
index baff5ffe94051..a9fc30ed4d732 100644
--- a/tools/testing/selftests/bpf/progs/verifier_global_subprogs.c
+++ b/tools/testing/selftests/bpf/progs/verifier_global_subprogs.c
@@ -8,6 +8,13 @@
 #include "xdp_metadata.h"
 #include "bpf_kfuncs.h"
 
+/* The compiler may be able to detect the access to uninitialized
+   memory in the routines performing out of bound memory accesses and
+   emit warnings about it.  This is the case of GCC. */
+#if !defined(__clang__)
+#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
+#endif
+
 int arr[1];
 int unkn_idx;
 const volatile bool call_dead_subprog = false;
-- 
2.43.0



