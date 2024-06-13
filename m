Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84378145A12;
	Thu, 13 Jun 2024 12:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281207; cv=none; b=MnMrTx6KkCI5Q1batFHimgl9nzYiK24m/gZqSZbjC+3o7NzYOrPyghUmnv3ttHZp7NX1VTyXGy/gZ7sAjQmZx4kdh2lJeOHGBsNVB9g9Fepxhu0z6aDqTtsARwJLi/mpGIGHNZ+DUeUyAe2q890rmvz4By7s5R/0Al5UVk4CEvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281207; c=relaxed/simple;
	bh=fEElFSrBoNzwDZseO1v27y8vmvrIasJjTPBsAnm1zks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNP+r6B0g/lO7S/QRYQFMPnDMci3GGRjoufgKvox2dbwFjUZWtHXPWIOKRcLxZCOuPhQZG6A7uN3o/3DeTcX4AZS/MIApcKxFBVE4G92rjSIkgwBwCtiq/fSPC9RUoyO50x19udWeg+QWAda+PgUFQTiV1rUeO12pi7/D5BwaCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exBawHht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exBawHht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9264FC2BBFC;
	Thu, 13 Jun 2024 12:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281207;
	bh=fEElFSrBoNzwDZseO1v27y8vmvrIasJjTPBsAnm1zks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exBawHhtmIh9FR6ckl6mbmRgUUEnw2r5fUI7p1InwUBNKm9C6dDiQXYZzzSavoQpj
	 i3R7vk1c4+6XuFcLdv33qISgpN0ImzsJmboqt2F/2vNULHL4ZE3aCArS6duHAxkEAZ
	 VczFkX+bGbyE4c3yYmZ4Lvvo8Jj4rtPojD6naq6s=
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
Subject: [PATCH 5.10 177/317] perf top: Fix TUI exit screen refresh race condition
Date: Thu, 13 Jun 2024 13:33:15 +0200
Message-ID: <20240613113254.405386591@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



