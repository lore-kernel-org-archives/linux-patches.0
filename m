Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E172E144306;
	Thu, 13 Jun 2024 12:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282372; cv=none; b=r5Mt7fHP1s82N+73iYPa/9yK5aH+96jN1nEPArOp/0l1HRAlQTph25a+vICs5Uz9+YawsPUjYvQEU9nBHZ6f0RnJqGxr+LiwtDX+y0lHkGBub+1oYxvZma+TByl94ktVMp/A9f+lFUuLRRylAtrZEcB8PY//nwkYb6IgqbegjKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282372; c=relaxed/simple;
	bh=qzr9MRxEq5Gnyy3tAbgeR5fKLjZ8b+Ocb1rWZhJJluE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSmqQ3xxuLrEtODBh38KkRW9txOYKvP8Q5tbW46T+tJyiujvG8NHLkdmM5z1UCz8KKoAwV59VjE73s4SfA7Q+lGGMvGx4WXfkqRDV/DmxL4ztvBtRVKUCW+qerkAKnBYjq/V1GawWALNuIrii0KKUiJetUrltg4VBS5HjBS2Bi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9XB/gG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9XB/gG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C195C2BBFC;
	Thu, 13 Jun 2024 12:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282371;
	bh=qzr9MRxEq5Gnyy3tAbgeR5fKLjZ8b+Ocb1rWZhJJluE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9XB/gG2UYuS+dJuNiFWvITDPfyfK8ew3vac31FdTQGRyDmIVHtwkCxWw/cfw5n2E
	 hmuoshq2h5ZTWPJrUKyhfeX/gav7mU+cWNt5Eq2GKYMG9lWUG1+F6zyoxMF8zhI/M+
	 GLulUBpb8h2zVcD5q1i8SqxaaTHuzTBptEZm+BzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyu Liu <liuwenyu7@huawei.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	wuxu.wu@huawei.com,
	Hewenliang <hewenliang4@huawei.com>,
	yaowenbin <yaowenbin1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 224/402] perf top: Fix TUI exit screen refresh race condition
Date: Thu, 13 Jun 2024 13:33:01 +0200
Message-ID: <20240613113310.879886624@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yaowenbin <yaowenbin1@huawei.com>

[ Upstream commit 64f18d2d043015b3f835ce4c9f3beb97cfd19b6e ]

When the following command is executed several times, a coredump file is
generated.

	$ timeout -k 9 5 perf top -e task-clock
	*******
	*******
	*******
	0.01%  [kernel]                  [k] __do_softirq
	0.01%  libpthread-2.28.so        [.] __pthread_mutex_lock
	0.01%  [kernel]                  [k] __ll_sc_atomic64_sub_return
	double free or corruption (!prev) perf top --sort comm,dso
	timeout: the monitored command dumped core

When we terminate "perf top" using sending signal method,
SLsmg_reset_smg() called. SLsmg_reset_smg() resets the SLsmg screen
management routines by freeing all memory allocated while it was active.

However SLsmg_reinit_smg() maybe be called by another thread.

SLsmg_reinit_smg() will free the same memory accessed by
SLsmg_reset_smg(), thus it results in a double free.

SLsmg_reinit_smg() is called already protected by ui__lock, so we fix
the problem by adding pthread_mutex_trylock of ui__lock when calling
SLsmg_reset_smg().

Signed-off-by: Wenyu Liu <liuwenyu7@huawei.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: wuxu.wu@huawei.com
Link: http://lore.kernel.org/lkml/a91e3943-7ddc-f5c0-a7f5-360f073c20e6@huawei.com
Signed-off-by: Hewenliang <hewenliang4@huawei.com>
Signed-off-by: yaowenbin <yaowenbin1@huawei.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 769e6a1e15bd ("perf ui browser: Don't save pointer to stack memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/tui/setup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index e9bfe856a5dee..b1be59b4e2a4f 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -170,9 +170,11 @@ void ui__exit(bool wait_for_ok)
 				    "Press any key...", 0);
 
 	SLtt_set_cursor_visibility(1);
-	SLsmg_refresh();
-	SLsmg_reset_smg();
+	if (!pthread_mutex_trylock(&ui__lock)) {
+		SLsmg_refresh();
+		SLsmg_reset_smg();
+		pthread_mutex_unlock(&ui__lock);
+	}
 	SLang_reset_tty();
-
 	perf_error__unregister(&perf_tui_eops);
 }
-- 
2.43.0



