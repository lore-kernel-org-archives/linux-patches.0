Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDA081749;
	Mon, 14 Oct 2024 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917825; cv=none; b=WWc6uAQX5FMYgq/N/nlRQmJOf0iqpKZ4/Q5NQAijTnAZi0hTUllz1t3PeUgcMgQ5AkcRF5KAnbwiLI5VsJer9YUarqOHAqv/27oCwq0qNnUdKv2zujJ6/gNET239XwN39yXuAbw/pTPUAzx1Frp0RkvdDgKXJCLRmiQLPHpRWts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917825; c=relaxed/simple;
	bh=nOOq6ORhSMmvC76KXxX4m8aU9orrNlKYU2r+V2rZfSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hs47Jd7VDvFbg1BVxZvt/fxOhAlC45Z8w1ABpEyuwo1Mi290zfn8yeqMO8uHre6ZcM0Ja/3YpUC9bfZbBghmICKAauj52NBv3oWDdO5rJdigUZ9cQvLku7PBYN7//ItvIYTSECX495ZBjzwEcHrDMjKdBPSzqzrPgdoHchS3Gvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AH+f655c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AH+f655c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336F1C4CEC3;
	Mon, 14 Oct 2024 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917824;
	bh=nOOq6ORhSMmvC76KXxX4m8aU9orrNlKYU2r+V2rZfSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AH+f655cGcQXO1mIvjS1aqzcRKpJWE6FSU8V1rnM3C27ZlfS76lTIIqDZ8VhiaTot
	 j5iHm7q/IupK//CVFAeUgSdVt2QfyzHafGkPzZnAPeDG8ea381fkLe0VX30cfVtkHX
	 n07bKFcPhk4+MzgqixuL3hev1cGhizGBH9bwg73g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/798] selftests/bpf: Fix missing UINT_MAX definitions in benchmarks
Date: Mon, 14 Oct 2024 16:11:39 +0200
Message-ID: <20241014141223.614651742@linuxfoundation.org>
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

[ Upstream commit a2c155131b710959beb508ca6a54769b6b1bd488 ]

Include <limits.h> in 'bench.h' to provide a UINT_MAX definition and avoid
multiple compile errors against mips64el/musl-libc like:

  benchs/bench_local_storage.c: In function 'parse_arg':
  benchs/bench_local_storage.c:40:38: error: 'UINT_MAX' undeclared (first use in this function)
     40 |                 if (ret < 1 || ret > UINT_MAX) {
        |                                      ^~~~~~~~
  benchs/bench_local_storage.c:11:1: note: 'UINT_MAX' is defined in header '<limits.h>'; did you forget to '#include <limits.h>'?
     10 | #include <test_btf.h>
    +++ |+#include <limits.h>
     11 |

seen with bench_local_storage.c, bench_local_storage_rcu_tasks_trace.c, and
bench_bpf_hashmap_lookup.c.

Fixes: 73087489250d ("selftests/bpf: Add benchmark for local_storage get")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/8f64a9d9fcff40a7fca090a65a68a9b62a468e16.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bench.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/bench.h b/tools/testing/selftests/bpf/bench.h
index d748255877e2d..6695938714837 100644
--- a/tools/testing/selftests/bpf/bench.h
+++ b/tools/testing/selftests/bpf/bench.h
@@ -10,6 +10,7 @@
 #include <math.h>
 #include <time.h>
 #include <sys/syscall.h>
+#include <limits.h>
 
 struct cpu_set {
 	bool *cpus;
-- 
2.43.0



