Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2AF1D07BD;
	Wed,  2 Oct 2024 14:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879778; cv=none; b=BilO6iqVAt4PAGbeBwAL2+xe2hx3N/o+8fCFJE2NcpJ9o7MroxFWTU88KQdcdrOCh7utbs1zrYEs1Kglnm4OgX64Pr5f+zHTaB6lsXSQ1zH6MTT268mpONTsk+xzMCBwT46Whhp51uMavLbW7IWXe5OmxKb2OnqfB6A4OBBoCDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879778; c=relaxed/simple;
	bh=6avjQpim4wqxN22ash2m1yLrcPezaK09BhWY0KoiGDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=As+7HQxsEaFTPBnQ9JOpEOLfbUVK8kKspHGol6WalDJY9fr51R6OoV+dL5tSWZTOTNetCc/a4T/nlFUohQcc0avYlYHNFpFIzzt8G+gEGL4ZLTnp97Gq+9gx47CUjXGXd+rd0rFggvJ0TekxrXPf6jlzAEfH6uXg0y3Zpb7biEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Opz6JFY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Opz6JFY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000CBC4CEC2;
	Wed,  2 Oct 2024 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879778;
	bh=6avjQpim4wqxN22ash2m1yLrcPezaK09BhWY0KoiGDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Opz6JFY10xr/JkZvHWRHDGfcRD24qAeXoCQQhGVrgQuHt/VUzRfFfJDzIUY3RVbGY
	 rb6TWSM68Zz9tHZPgGCexUw/A07Ee3IK8UUnt+ypIyvtPELlNpPNRVPbcWQ0Jj3iaG
	 yZYk0QTvAbs7EtZEldey+JSuhSqoo8rh5clYr3I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/538] selftests/bpf: Fix missing UINT_MAX definitions in benchmarks
Date: Wed,  2 Oct 2024 14:57:13 +0200
Message-ID: <20241002125759.914204961@linuxfoundation.org>
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



