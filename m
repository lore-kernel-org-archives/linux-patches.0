Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF64026738C;
	Sat, 30 May 2026 18:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166372; cv=none; b=OHVfOtuUDyfzMLxOSR2drMPhdrgSdFYRMPRh5YZ+7k4JeIEuxBovNbzAifbDw8csFcWDDy77w6kE7haOiwY4O8/RgK8MhJgAEo/hh6gQY7YlFYCFB/RCPvtpLKi419g5m/Mbs36IFDqbspMX5yjsNQ5WLIwlDneT0EaYSLF7BDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166372; c=relaxed/simple;
	bh=VG2lvgonPhEpB9oDWGUu9FVH3V5XzCCFQpkBlQE8I6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ShAfzaxlNGtJUGV24tG1wmGDLCT9fjdajJH7QbagGZLjDDqSx1zFdAs1myePjk0nNzYqi23J/B7kbvDzu2HNk0sx6/vvpEaRX6auDq/GngRom7jzOAEqjQZavddodcPgOY+/pq3p0dAQGxWI3fp1tSnwLr9+X584gQzQBtuZ69g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCCE89ez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCCE89ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B931F00893;
	Sat, 30 May 2026 18:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166370;
	bh=9U3CoSY0fjuXZbBBMAYaNSY/fU76HRCmnaThbSRDBl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCCE89ezJQgk8GazbBVw3bAcPTL/q3tceC6CxsUTuzns9viujl0+qAVqsp6m8AdIN
	 7M/VxWHeiD4rOXC6h8fOy8bfX/C1m8StTYx31B6Qmm9w5xkRSaCLjxPaKl5nK2BRDe
	 2V9qkyyK6csrzfDIt8PQIee6zaoRQSl4gmMIJfvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 352/589] selftest: memcg: skip memcg_sock test if address family not supported
Date: Sat, 30 May 2026 18:03:53 +0200
Message-ID: <20260530160234.117141135@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 2d028f3e4bbbfd448928a8d3d2814b0b04c214f4 ]

The test_memcg_sock test in memcontrol.c sets up an IPv6 socket and send
data over it to consume memory and verify that memory.stat.sock and
memory.current values are close.

On systems where IPv6 isn't enabled or not configured to support
SOCK_STREAM, the test_memcg_sock test always fails.  When the socket()
call fails, there is no way we can test the memory consumption and verify
the above claim.  I believe it is better to just skip the test in this
case instead of reporting a test failure hinting that there may be
something wrong with the memcg code.

Link: https://lkml.kernel.org/r/20260311200526.885899-1-longman@redhat.com
Fixes: 5f8f019380b8 ("selftests: cgroup/memcontrol: add basic test for socket accounting")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index c19a97dd02d49..07ce722b2533b 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -833,8 +833,11 @@ static int tcp_server(const char *cgroup, void *arg)
 	saddr.sin6_port = htons(srv_args->port);
 
 	sk = socket(AF_INET6, SOCK_STREAM, 0);
-	if (sk < 0)
+	if (sk < 0) {
+		/* Pass back errno to the ctl_fd */
+		write(ctl_fd, &errno, sizeof(errno));
 		return ret;
+	}
 
 	if (setsockopt(sk, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) < 0)
 		goto cleanup;
@@ -964,6 +967,12 @@ static int test_memcg_sock(const char *root)
 			goto cleanup;
 		close(args.ctl[0]);
 
+		/* Skip if address family not supported by protocol */
+		if (err == EAFNOSUPPORT) {
+			ret = KSFT_SKIP;
+			goto cleanup;
+		}
+
 		if (!err)
 			break;
 		if (err != EADDRINUSE)
-- 
2.53.0



