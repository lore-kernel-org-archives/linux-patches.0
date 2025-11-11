Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C323224113D;
	Tue, 11 Nov 2025 00:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822764; cv=none; b=TVZQ1hoGtCui2rGJOvAle7ygK+mIanqv58YeftivjngHONzxwV1o3GsVCiN/oIUdT9yanc9ZcSTWD9+NjcQEk6xPGJJRw8hs6sr7sJXp6qc2QEE2EaO2xokBPRKgWe/kRtb+YgN4ubXT13bDlu3MjAqEDyXUeWjymQjWZDuY1P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822764; c=relaxed/simple;
	bh=E91sg/zmdvunB3pWEPwItxq4qZU8HVDh5wkXChSmMI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnUEyWPcyopgjtukds3ttNCqbBMMmX3QOiLPbjlv5WosbiEsh4DJPQlRbMgUvSpoBKSaNn7dd7KkOSLDWp4zkyx+hMjebt7JFOTmM/dVRHqtFVDM+VRx3bITO0zvUj9I8nCp42+EwHkfb7yJBPo3gxc/ZfQtgDrWWYrKzA4Eops=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdmjVFl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdmjVFl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E21C19421;
	Tue, 11 Nov 2025 00:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822764;
	bh=E91sg/zmdvunB3pWEPwItxq4qZU8HVDh5wkXChSmMI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdmjVFl0Mm9LhgQ2R7dlwY5oay7PPENW68NIH7ojyqqB7IhTTFwWPBqtrNO1rP3Gy
	 DD3aU+TwhF61bsjgyd0Ky34PrFH5ZVTg2fh5HxjDDlKGyr1vSZ13H71YI3Q0elCKrx
	 /xyIaEH7/YKA6h1ezUAZMiWg/GX+GUFoiUhEuteQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 163/849] selftests/bpf: Fix incorrect array size calculation
Date: Tue, 11 Nov 2025 09:35:33 +0900
Message-ID: <20251111004540.371788912@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit f85981327a90c51e76f60e073cb6648b2f167226 ]

The loop in bench_sockmap_prog_destroy() has two issues:

1. Using 'sizeof(ctx.fds)' as the loop bound results in the number of
   bytes, not the number of file descriptors, causing the loop to iterate
   far more times than intended.

2. The condition 'ctx.fds[0] > 0' incorrectly checks only the first fd for
   all iterations, potentially leaving file descriptors unclosed. Change
   it to 'ctx.fds[i] > 0' to check each fd properly.

These fixes ensure correct cleanup of all file descriptors when the
benchmark exits.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250909124721.191555-1-jiayuan.chen@linux.dev

Closes: https://lore.kernel.org/bpf/aLqfWuRR9R_KTe5e@stanley.mountain/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/benchs/bench_sockmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/benchs/bench_sockmap.c b/tools/testing/selftests/bpf/benchs/bench_sockmap.c
index 8ebf563a67a2b..cfc072aa7fff7 100644
--- a/tools/testing/selftests/bpf/benchs/bench_sockmap.c
+++ b/tools/testing/selftests/bpf/benchs/bench_sockmap.c
@@ -10,6 +10,7 @@
 #include <argp.h>
 #include "bench.h"
 #include "bench_sockmap_prog.skel.h"
+#include "bpf_util.h"
 
 #define FILE_SIZE (128 * 1024)
 #define DATA_REPEAT_SIZE 10
@@ -124,8 +125,8 @@ static void bench_sockmap_prog_destroy(void)
 {
 	int i;
 
-	for (i = 0; i < sizeof(ctx.fds); i++) {
-		if (ctx.fds[0] > 0)
+	for (i = 0; i < ARRAY_SIZE(ctx.fds); i++) {
+		if (ctx.fds[i] > 0)
 			close(ctx.fds[i]);
 	}
 
-- 
2.51.0



