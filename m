Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31ED522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C74C433C8;
	Sun,  9 Jul 2023 11:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901695;
	bh=XTBEET2PloCM0pbAweaiGlWgqTPBbOqqrVvszYh2AFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZNrTnjW8aTl3LvvdfohEHiT1SLwXDJjd9ZStWaboNW5Yslnpn6NUCVLC+BWKl81R
	 xE4gshKNZ0sA2k7cJsfiXswJtKU8jzAOu91GtmlKgnXYpj61dk3QDgYkfeos6GIIC0
	 0RTyeIi8SV0+meHshTyFUaKDfDS2l7SrmB/MENis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haifeng Xu <haifeng.xu@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeelb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 111/431] selftests: cgroup: fix unexpected failure on test_memcg_low
Date: Sun,  9 Jul 2023 13:10:59 +0200
Message-ID: <20230709111453.757070650@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haifeng Xu <haifeng.xu@shopee.com>

[ Upstream commit 19ab365762c6cc39dfdee9e13ab0d12fe4b5540d ]

Since commit f079a020ba95 ("selftests: memcg: factor out common parts of
memory.{low,min} tests"), the value used in second alloc_anon has changed
from 148M to 170M.  Because memory.low allows reclaiming page cache in
child cgroups, so the memory.current is close to 30M instead of 50M.
Therefore, adjust the expected value of parent cgroup.

Link: https://lkml.kernel.org/r/20230522095233.4246-2-haifeng.xu@shopee.com
Fixes: f079a020ba95 ("selftests: memcg: factor out common parts of memory.{low,min} tests")
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index f4f7c0aef702b..a2a90f4bfe9fe 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -292,6 +292,7 @@ static int test_memcg_protection(const char *root, bool min)
 	char *children[4] = {NULL};
 	const char *attribute = min ? "memory.min" : "memory.low";
 	long c[4];
+	long current;
 	int i, attempts;
 	int fd;
 
@@ -400,7 +401,8 @@ static int test_memcg_protection(const char *root, bool min)
 		goto cleanup;
 	}
 
-	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
+	current = min ? MB(50) : MB(30);
+	if (!values_close(cg_read_long(parent[1], "memory.current"), current, 3))
 		goto cleanup;
 
 	if (!reclaim_until(children[0], MB(10)))
-- 
2.39.2



