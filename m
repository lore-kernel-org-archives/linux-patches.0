Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91C93515D2;
	Fri,  4 Sep 2026 05:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498473; cv=none; b=LaOktq9btNuQ+QUlOg2I3bhnN+cqqfu2pKft4L+9eSKlR204tGcFpq+ryPUdCW1MQwEk57V7eyhB+sizycRJ7fF+KX/l2v8mOy7tH1mXJmEH3+4fkhk8iMmWY9FsKfTFyOlH2g9MoTBChH8xh6hjM72QzYX1LyoZtb7mrP4fNEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498473; c=relaxed/simple;
	bh=klk2grP7TaUt/gSRJR9xVNPWWgVeQ96IYDbbbyy0CgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IN9R3PDZhgOv8XC8Ay8CYC2aQIuKYjAZoCToZe3yPHjc5zNrX1G6U5u2MIO0H59lvHfEHNZm+JuHOlLAyMHBuXyo94zQbVD7UxOZloBoRXntmotyncutC1F9YLLNcrJUAosrtpKecoZ8jM6dfcyfdHPL/AeGh4qeVN/w09AdYCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNCc+BJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNCc+BJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184AD1F00A3D;
	Fri,  4 Sep 2026 05:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498472;
	bh=EdsVm+1ExS/6KSmOXs9cCrNzACLTr9SCzxSlFJdLmGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNCc+BJ/EkzIo3qePCR5gFdo7Fh0qD6Egl2DEAbit0zATcLI2m7FgoK5lN/VdMrpM
	 d0m0QaO2xzwQUCSu0DranTAzdCT4Y7+MJUdd2ZN1zkbSpPte8t6mqcPH+liTco/r6x
	 Ig91tHL2n/yqKMYUk3GfpsK3rjX/h94uG5A3B5Mk=
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
Subject: [PATCH 7.2 073/713] mm: memcg-v1: fix memsw and TCP failcnt accounting
Date: Fri,  4 Sep 2026 06:50:41 +0200
Message-ID: <20260904045805.477932696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4180,9 +4180,11 @@ mem_cgroup_css_alloc(struct cgroup_subsy
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


