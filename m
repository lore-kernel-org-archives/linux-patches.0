Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C186333ADB8;
	Fri,  9 Jan 2026 11:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959695; cv=none; b=QhV85gfOkPJ7PIovnD/e2g5LMa8GlzQ0ymj2t6eoDHNoB+7aphk5O+pI9kEMOrU/3QqRkLVJ++M8WRuyqtqnWhNjqcygRW3k5cktIgK9plrjyKZuqVSimnUfwlt4zHoas1Zg2eES2iZdqE1FQhInpBlNvkOJEGO07Wkj1RegmkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959695; c=relaxed/simple;
	bh=z4iiz708vlu06hXY0YN2NFOtxidXNJ253TP/PMFflO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV93gAdfghSF9lGD3vd6V+iA0lX00b5WFg/8Bmlaj+l2tmbe6AoEHg6jGfN8NWHRCmM4wWAoqYd+dOWyC5YJgUL0xyXScykh47+X0oEwtH7huRX8ml+k6dHUjXKIGmtAGC/yrHn+NFR1AVsggDcDP/mzD7P5HuULyVSV40KJYkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tdp914OE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tdp914OE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14308C4CEF1;
	Fri,  9 Jan 2026 11:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959695;
	bh=z4iiz708vlu06hXY0YN2NFOtxidXNJ253TP/PMFflO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tdp914OEAw7DlaOILuiiYdUsrRMiEQfJj9jcheqPEn5gM1zNgFjrTMVOENyrCW8Zo
	 t2pDFQ4W5aOwQ9e/sv4s27R2x5pHkFUYVDID0OuyPJUfFUaM0WU81b99VciDBt28rR
	 QgtYVWzdlD02dZvJI9abmkqlZj5mFXcSTdlLGZ24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/737] perf lock contention: Load kernel map before lookup
Date: Fri,  9 Jan 2026 12:34:09 +0100
Message-ID: <20260109112138.142772814@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 553d18c98a896094b99a01765b9698b204183d49 ]

On some machines, it caused troubles when it tried to find kernel
symbols.  I think it's because kernel modules and kallsyms are messed
up during load and split.

Basically we want to make sure the kernel map is loaded and the code has
it in the lock_contention_read().  But recently we added more lookups in
the lock_contention_prepare() which is called before _read().

Also the kernel map (kallsyms) may not be the first one in the group
like on ARM.  Let's use machine__kernel_map() rather than just loading
the first map.

Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 688d2e8de231c54e ("perf lock contention: Add -l/--lock-addr option")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf_lock_contention.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/bpf_lock_contention.c b/tools/perf/util/bpf_lock_contention.c
index a73f39540a3d4..aa4c7baf20f57 100644
--- a/tools/perf/util/bpf_lock_contention.c
+++ b/tools/perf/util/bpf_lock_contention.c
@@ -24,6 +24,9 @@ int lock_contention_prepare(struct lock_contention *con)
 	struct evlist *evlist = con->evlist;
 	struct target *target = con->target;
 
+	/* make sure it loads the kernel map before lookup */
+	map__load(machine__kernel_map(con->machine));
+
 	skel = lock_contention_bpf__open();
 	if (!skel) {
 		pr_err("Failed to open lock-contention BPF skeleton\n");
@@ -284,9 +287,6 @@ int lock_contention_read(struct lock_contention *con)
 		bpf_prog_test_run_opts(prog_fd, &opts);
 	}
 
-	/* make sure it loads the kernel map */
-	maps__load_first(machine->kmaps);
-
 	prev_key = NULL;
 	while (!bpf_map_get_next_key(fd, prev_key, &key)) {
 		s64 ls_key;
-- 
2.51.0



