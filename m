Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4CF356903;
	Tue, 26 Aug 2025 14:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218736; cv=none; b=Gu3euAe1eEOKzjZAsrPLalVu+sNPqNuWCuksIsR6aoiAPAwFkVaCcdiRed8HHK/biMhLzYkWEG62YB7FSEVbMMUe5qn+pXZODkUeRgJNKCWBl0ZWnWmxgjStL+rBgs4uVezDK6U09HryZzhCTi7xF5M7JXxeRRyETqj870sY6G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218736; c=relaxed/simple;
	bh=sKZrVs4grnqZ8pjMIRhIag673saw3A/Y/BoxoR5oXng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJzie+fFgB2K/kuqWLVH8mBaPybrXZPjaXlWGCwpe4X0AryV6cDJTGW2dknJ1PCa36WwOWgU8EcqMrIYFi9VNi1Sp0CKjku+wjfr8oREbnfr0XEUWyB6c+1McrrXsxA+px8NB6d4zEJ3Oys5hfz1Mtc9U9SdVFJC3UyGsd6HEec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0h8k0P8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0h8k0P8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E321DC4CEF1;
	Tue, 26 Aug 2025 14:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218736;
	bh=sKZrVs4grnqZ8pjMIRhIag673saw3A/Y/BoxoR5oXng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0h8k0P8tKje9YHUoyfeHZ1JJaCj9ULSwQdTGXtpym3BXv/0p9CsoWySAlETVOp8pP
	 meLA3aXftfHhwdcJ825oFUcv4OB67ko3akO47poOnazTzVzVeoY+GmdlCoF2NJHtZa
	 kwvj67N47QhNwrdtk2K9RmxFjo3eir1PeAR5bbTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aishwarya TCV <aishwarya.tcv@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/403] perf tests bp_account: Fix leaked file descriptor
Date: Tue, 26 Aug 2025 13:07:18 +0200
Message-ID: <20250826110909.813273170@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 55a9de311d7b..e1ff0faa0149 100644
--- a/tools/perf/tests/bp_account.c
+++ b/tools/perf/tests/bp_account.c
@@ -93,6 +93,7 @@ static int bp_accounting(int wp_cnt, int share)
 		fd_wp = wp_event((void *)&the_var, &attr_new);
 		TEST_ASSERT_VAL("failed to create max wp\n", fd_wp != -1);
 		pr_debug("wp max created\n");
+		close(fd_wp);
 	}
 
 	for (i = 0; i < wp_cnt; i++)
-- 
2.39.5



