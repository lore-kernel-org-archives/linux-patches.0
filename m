Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9C4412BF7;
	Fri,  4 Sep 2026 05:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500404; cv=none; b=Qx6johLkfwEJWTWwjV8IYfGin/DY5eYqF0MNPYGd/suVyzyzmJ5kLWeN6WIebnLWPfLhCPXLIOxoz3EoQmCPCfkS4z40VQfVjApeXBc2/Zszjy0tjtAkhDilEDW7zQ8Oo/h0UgET1ibtpU2x8+MdWbMnbZD08sw3wLMeDry6mxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500404; c=relaxed/simple;
	bh=zuHR5sp7jF38YIVM27fiWFJkXHmI0KIKLwVFY6yK8s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDlgPMZ7zsW5MkUEUfbtqf0oEjnXZzAtwI+qKh0J2KknmDOG1v5P9KbSh8LdbmhyqSy/tduZdtb/O8feQiST4NCkMdIkKHN9sfiPn36nm9/EJH3bAu2ytsBToBvwJ1UA6uVL7iBtAsVt+6Aq32jvwNpjQYzNXXBpgpibCz4Ipy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHH1I6/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHH1I6/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A9B1F00A3D;
	Fri,  4 Sep 2026 05:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500402;
	bh=XFwsSixzK8YkTVaoPMO4SyV3OGg0xkY1aFwk7WG4bnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHH1I6/d9KfI96lT4uQaL6NdYuyxf1uRIZazkP/l6cdkKnNFyXrAYcvBR1UnwjygE
	 tHBm3Nx65E9c4314IiV3GiVK3FT79ef9FpwCuQhBNO+nJgkdLNTiRNqydxNXdgnbUK
	 dkfNugSDftOGr09HIhA12uMOXtuGk5lRsA+WFLck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 044/552] mm: memcg-v1: fix memsw and TCP failcnt accounting
Date: Fri,  4 Sep 2026 06:53:21 +0200
Message-ID: <20260904045748.831580306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

commit 92192e9c5ee07efc657d3654bc264081fb0aa01b upstream.

Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
cgroups") made failcnt accounting conditional on track_failcnt.  It
enabled the flag for memcg->memory, but not for memcg->memsw or
memcg->tcpmem.

Consequently, memory.memsw.failcnt remains zero when the memory+swap limit
is hit.  memory.kmem.tcp.limit_in_bytes still sets memcg->tcpmem.max, but
TCP charge failures are not reflected in memory.kmem.tcp.failcnt.

Enable failcnt accounting for both v1 counters.

To reproduce memory.memsw.failcnt:

    CG=/sys/fs/cgroup/memory/memsw-test
    LIMIT=33554432
    mkdir "$CG"
    echo "$LIMIT" > "$CG/memory.limit_in_bytes"
    echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"

Start a child process in the cgroup and make it allocate and touch 96 MiB
of memory, causing a memcg OOM.

    cat "$CG/memory.memsw.failcnt"

Without the patch, memory.memsw.failcnt is 0. With the patch,
memory.memsw.failcnt is greater than 0.

To reproduce memory.kmem.tcp.failcnt:

    CG=/sys/fs/cgroup/memory/tcpmem-test
    LIMIT=65536
    mkdir "$CG"
    echo "$LIMIT" > "$CG/memory.kmem.tcp.limit_in_bytes"

Start a child process in the cgroup, create a TCP socket, and reserve
1 MiB of socket memory with SO_RESERVE_MEM. The reservation fails with
ENOMEM.

    cat "$CG/memory.kmem.tcp.failcnt"

Without the patch, memory.kmem.tcp.failcnt is 0.  With the patch,
memory.kmem.tcp.failcnt is greater than 0.

Link: https://lore.kernel.org/20260811030843.109104-1-guopeng.zhang@linux.dev
Closes: https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev?part=1
Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3809,9 +3809,11 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		memcg->memory.track_failcnt = !memcg_on_dfl;
+		memcg->memsw.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
+		memcg->tcpmem.track_failcnt = !memcg_on_dfl;
 #endif
 	} else {
 		init_memcg_stats();


