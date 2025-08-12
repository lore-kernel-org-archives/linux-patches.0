Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD692F8BE7;
	Tue, 12 Aug 2025 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021474; cv=none; b=o55R0NZ3ihJj0yNijAn7mztYrzPmm36gXramgdmjdK+Y8sBHeYYKsedvdp0JnB/4eGcCs4eI0fn7IS5FWHc8qxZgl788OYgqT+RpX5Sbb27vFjU5HgZOLT1WYV6/XABi+UQ+oZQ34t/QhMmFBxp4FCXpxxeiLuqrOnzS6MBXoCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021474; c=relaxed/simple;
	bh=J12lc51rrIj9xua2FqQUGOn5sKght/WtcEXN8R1XgK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWvcLQVASQk67mYGJRwLVGv3xJRAPmL9UXmjf8IRh2N5NwuTyG85CoUX8TuR/HyCI7QTJnh0yTcpehmv39+aChMQP/bspx6CjuESs7mZCK6zSNses59mkKu+ShQcVWNhGcQre42hpyaY84dGOiPCmmDAF+FAPCDq03qHA0RAcos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlM9boHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlM9boHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6FBC4CEF1;
	Tue, 12 Aug 2025 17:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021474;
	bh=J12lc51rrIj9xua2FqQUGOn5sKght/WtcEXN8R1XgK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlM9boHgxdbVKTnTSJeLB8/l3C7BU4BGOq0QIcPPuiwkuqEbsX2RvRzd7BBRYVuo3
	 cIO2ut1bf4xZ7+2EcZ4H7v5+kBwRkDz64oHmz4TjROndpRo4abqFoM/ID1fIZzNzlE
	 4GiOsE2LAARrW9TplfLaVpAA4ZnB91l07YTSmH9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aishwarya TCV <aishwarya.tcv@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/262] perf tests bp_account: Fix leaked file descriptor
Date: Tue, 12 Aug 2025 19:28:42 +0200
Message-ID: <20250812172958.807330147@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 4a6cdecaa1497f1fbbd1d5307a225b6ca5a62a90 ]

Since the commit e9846f5ead26 ("perf test: In forked mode add check that
fds aren't leaked"), the test "Breakpoint accounting" reports the error:

  # perf test -vvv "Breakpoint accounting"
  20: Breakpoint accounting:
  --- start ---
  test child forked, pid 373
  failed opening event 0
  failed opening event 0
  watchpoints count 4, breakpoints count 6, has_ioctl 1, share 0
  wp 0 created
  wp 1 created
  wp 2 created
  wp 3 created
  wp 0 modified to bp
  wp max created
  ---- end(0) ----
  Leak of file descriptor 7 that opened: 'anon_inode:[perf_event]'

A watchpoint's file descriptor was not properly released. This patch
fixes the leak.

Fixes: 032db28e5fa3 ("perf tests: Add breakpoint accounting/modify test")
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250711-perf_fix_breakpoint_accounting-v1-1-b314393023f9@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/bp_account.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/tests/bp_account.c b/tools/perf/tests/bp_account.c
index 6f921db33cf9..855b81c3326c 100644
--- a/tools/perf/tests/bp_account.c
+++ b/tools/perf/tests/bp_account.c
@@ -102,6 +102,7 @@ static int bp_accounting(int wp_cnt, int share)
 		fd_wp = wp_event((void *)&the_var, &attr_new);
 		TEST_ASSERT_VAL("failed to create max wp\n", fd_wp != -1);
 		pr_debug("wp max created\n");
+		close(fd_wp);
 	}
 
 	for (i = 0; i < wp_cnt; i++)
-- 
2.39.5



