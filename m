Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8586212C530;
	Thu, 13 Jun 2024 12:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280023; cv=none; b=Jj1+EFpeo1SYwXrATplLNdqrg/+eDMajHv7zd2fkfyeMngkzrgKlGAQGWVZNkJULC1glwQbBOvpH8e9JYo9orEMC4gj+FRvO1WA88tda8blsIYAInvCThhnB0Osk3OEheh782SnVhazCM9/kglhEdKVq2LB9sMlXt+xH0HfFJ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280023; c=relaxed/simple;
	bh=nQeOyCNa1bcSbrEZM6eWf5j5nclTr9/A219eTct2SJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvPBEXbhBmyuhsbxULrCM5N5O3KvCW5dCCV5xUPORFbQyYZiIQszvOcjHu7/5Q+uXqrn2wLSKdNYZjfWHG2WgnvCz6f5sBmqPwPXVclZ2iY/l71S6HBPtLf4iOHglB9jKW9YrURrjRQ28jRYIOFWzuyDGvd03/kkHo/VC/XtI4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=os0R/EIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="os0R/EIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D624BC2BBFC;
	Thu, 13 Jun 2024 12:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280023;
	bh=nQeOyCNa1bcSbrEZM6eWf5j5nclTr9/A219eTct2SJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=os0R/EIJAj/dA7FxnQLTZFXf/JBU5cP0F74DSesSJU+f++1uxScgA8r74Yl01QIhO
	 lY6CQfIF6JmWypYkAkMTe6ZnoytLj3glTGX9xTJcvdIcKpGI5tsL1atS80nC+lmQta
	 YEhey3Iw8j+6Phn8xALATbVd1BFk0spdnlUi5pvk=
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
Subject: [PATCH 5.4 115/202] perf top: Fix TUI exit screen refresh race condition
Date: Thu, 13 Jun 2024 13:33:33 +0200
Message-ID: <20240613113232.199322102@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



