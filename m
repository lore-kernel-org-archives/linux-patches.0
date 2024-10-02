Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248141D0484;
	Wed,  2 Oct 2024 13:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875926; cv=none; b=qfEG30llclacERifrkp/iWDQer6u8Oi/RyD52CC9B57fKDPHsMZRRKviGJ+sC7kofErUYo1VDnc5o+YiIt6/W8X1y1oGz1Ls5IRsoP9GrPw0HJwx14f+2Idlrj6qxw/PSzH/z4Elml53BHvDuPBHFcQro5YmiGR7V+/QY1J/Hls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875926; c=relaxed/simple;
	bh=7SA2K1PdxpJr107I1pypwGsRPytECGbGBn0qU+6YU5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqUqhBzn+WWoB2JaUr2uHK2AWzHdVjkFpNQrXPVkJbCLkU+VNmjnO8sCkTlNIM5HIWTlgj1yZ3maFrQ2EMeKcU7lTl/XPTGN2XfN8uB2+teIYnASIxWUFG/JondXirk+yEb7+zj/14uyZNeg5/9dN9uYZED9o7dKVbEg4qGfJN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8MLz3Jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8MLz3Jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F66C4CEC5;
	Wed,  2 Oct 2024 13:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875926;
	bh=7SA2K1PdxpJr107I1pypwGsRPytECGbGBn0qU+6YU5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8MLz3Jxw58itpsmFk9gBoVyGxvXWPUfAnWsEyzGQKTfb2aQqIQVy55Tmiro4EYUK
	 drJ9FoLseILP/nLuOdDI8jafV4QypjmV8RyQtKtIcvrEAA0oSpGPO1IjLoS+iv3MJP
	 ucAbzFHwJ9+gnafHCszaoQV/y7jn1gUYZzjJx/Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 269/695] selftests/bpf: Fix missing UINT_MAX definitions in benchmarks
Date: Wed,  2 Oct 2024 14:54:27 +0200
Message-ID: <20241002125833.186737417@linuxfoundation.org>
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
index 68180d8f8558e..005c401b3e227 100644
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



