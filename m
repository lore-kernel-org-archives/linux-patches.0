Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52ED341645;
	Tue, 16 Dec 2025 11:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884188; cv=none; b=cSXb31mG4b5V+he2KpAdqtGNVQUpA//n83YnZ4P+KSzP+xC51v9DAC72esJHjK+IVLsqmt5m8obV+7FGXfs93qC4Jzll25CFH1WC73WnLO8iVCwuz5hfs4IrY0zn2Ufr+OlF11cVLMzcOV8EURilgRDeWpWfEBUO87USVm3JKOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884188; c=relaxed/simple;
	bh=OZtmaAWQtsXjBAq0hNNu4aC+eD/Ynv0ot1XbXH2YqiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aq1p10RGl2odPTCoTqSgGet8xV+6xaPkLpkLdYJAjwhVpIl3Mi3ErxIEw4e23p7xUJ+WznLqwp8VKufBu3Aj6LHXQcLa14ZH2t1+Tdq6ADHUI4J/A12NoPIUcYjv37OEPZzFNXUIrumRkB3ZeLURMIcxBmDHvOG5xc92IsdaRP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAQHj16A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAQHj16A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBBAC4CEF1;
	Tue, 16 Dec 2025 11:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884188;
	bh=OZtmaAWQtsXjBAq0hNNu4aC+eD/Ynv0ot1XbXH2YqiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAQHj16ASGtawlkGob47yUKGzDYfdamH/3Shz6prg8Bmxx6lOfReuFxe1scsuFFBW
	 xGwHGljQoUvVHxgVGyUWThKURWutZJ58yPd4aIq+fg17lfuljUr/u4/BKoBnMV/ged
	 f020suLbejI2KfSM09fNAEtMs100yav+XUMDRfms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/354] perf lock contention: Load kernel map before lookup
Date: Tue, 16 Dec 2025 12:11:08 +0100
Message-ID: <20251216111324.579909575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 41a1ad0878951..a286e15b16a4e 100644
--- a/tools/perf/util/bpf_lock_contention.c
+++ b/tools/perf/util/bpf_lock_contention.c
@@ -26,6 +26,9 @@ int lock_contention_prepare(struct lock_contention *con)
 	struct evlist *evlist = con->evlist;
 	struct target *target = con->target;
 
+	/* make sure it loads the kernel map before lookup */
+	map__load(machine__kernel_map(con->machine));
+
 	skel = lock_contention_bpf__open();
 	if (!skel) {
 		pr_err("Failed to open lock-contention BPF skeleton\n");
@@ -443,9 +446,6 @@ int lock_contention_read(struct lock_contention *con)
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



