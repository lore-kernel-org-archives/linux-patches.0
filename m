Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715AD221FAC;
	Tue, 12 Aug 2025 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020729; cv=none; b=nYQ3nbg4LAvodV60kywonin0HIDi5B8KOGCHfcCV8Zvco9QrsPxv/qtw0c/jRNXZV/ILfxn2AqjRfgIA7W0ji2pMCVl6geTCky8ZMc1OTadfdTLukBwcFgnJIEkA+GYXdQzvicN46kC+0kC7Dlr/C7KfxPnpo8q2U4aX6/6iR4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020729; c=relaxed/simple;
	bh=ZdqJdCqJT4LLdk7+ekpkUUf/FkZb5NryXMAEKHOn9UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ih+BRb+zXZPovvHI3Q3g2tOsmJ7xSaiVPjv/2bP4PIO+YZbSTmOTr9TQHwlt2DFmNe0jHKtoFVSlcbHOQ46uyZfRShK/m4CWlZTVeJqln21UeLrpZ3WrMPhZ3/cv8eb0KiJuH2ukY3NZuevaIx6X2PaWsF9+i4eDGXP7FpIkUwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLLp6r7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLLp6r7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C6AC4CEF0;
	Tue, 12 Aug 2025 17:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020729;
	bh=ZdqJdCqJT4LLdk7+ekpkUUf/FkZb5NryXMAEKHOn9UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLLp6r7AyspRJy7I/t5lNlXph1j8hikywIxGVrtDQ+NpNaJrbUpT7StT4zBUUhfgo
	 WmrhtLXkHWicMafMa9oOoWh8VRi4J6TVoQSszQk6beOF2o0AOOolXmqNlaA2/npmCu
	 m+y6gUtcejEsH5r9bFVXj7JW6b5eiLZ8q0EtsFec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aishwarya TCV <aishwarya.tcv@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/253] perf tests bp_account: Fix leaked file descriptor
Date: Tue, 12 Aug 2025 19:29:07 +0200
Message-ID: <20250812172955.485128402@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



