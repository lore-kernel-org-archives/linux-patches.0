Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897DB46D543;
	Tue, 21 Jul 2026 15:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649003; cv=none; b=JDMHGXwuw/9kgDitrkzLkuY/6KG9s6klTcBA+GXwitsoT8i8eh2fc+aFNm42WpAMreX13lSEclRdDvrSubGlW7xgMiB/DdlJOJRocqYMgtaa734Qpl/ZZNEikHbQfuxaymjCnH/K7sFnMRdX/klXBf5A6hOoGm8qUpi35NZKWFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649003; c=relaxed/simple;
	bh=nKbOAso7edzxbg3BbACmTNLxfN0vt0tfzKszGn60C9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0hDol6cvC9Whj5LnVhQ+xSzJDdqzhYFrvEt3v0Zax2Pf3KHLcVfngiPMMwdua49joUbvvJr6lgeDfAvpNurTWqHJwDYk50xnpUhdX/FQUcYkw03IXJ/NihcHFm3Sjh8oXK7iFumpCBWPdSvRY5SD+LFRx/FCttNUeV2i37J7rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYG72/bi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYG72/bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B4E1F00A3A;
	Tue, 21 Jul 2026 15:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649002;
	bh=XiWUd67dD3EuyVaaMBya+jXqtuS01pFdGIea0EXkwPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYG72/bieWx7kB8NT6VT5WiCm5tZeUoWXIX9qosbZgTnjDgiR62v0NyUVN6cl3dZ0
	 BW70ZolyM/6+UXRrvwCz0B44p0iQJckczDegZbbdbYzo4ik3Okz/XE5wIycEJbUjHL
	 O42acfWaaFBc+FLofwgNB+M+T/VGqsRPPMVOuxeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	abaci-kreproducer <abaci@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0370/2077] sched/deadline: Reject debugfs dl_server writes for offline CPUs
Date: Tue, 21 Jul 2026 17:00:43 +0200
Message-ID: <20260721152601.416051469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit 4043f549841619a01999bf5d4e0b7931ef87f6cc ]

Writing runtime or period via the per-CPU dl_server debugfs files
(/sys/kernel/debug/sched/{fair,ext}_server/cpu*/{runtime,period}) on an
offline CPU can trigger two distinct kernel issues:

1) Divide-by-zero in dl_server_apply_params():

  Oops: divide error: 0000 [#1] SMP NOPTI
  RIP: 0010:dl_server_apply_params+0x239/0x3a0
  Call Trace:
   sched_server_write_common.isra.0+0x21a/0x3c0
   full_proxy_write+0x78/0xd0
   vfs_write+0xe7/0x6e0

  Both __dl_sub() and __dl_add() divide by cpus internally, which can be
  0 once the CPU has been removed from any active root-domain span (this
  has been latent since the debugfs interface was introduced).

2) WARN_ON_ONCE in dl_server_start():

  WARNING: kernel/sched/deadline.c:1805 at dl_server_start+0x232/0x270

  Commit ee6e44dfe6e5 ("sched/deadline: Stop dl_server before CPU goes
  offline") added this check to catch enqueueing the server on an
  offline rq.

There's no meaningful semantics for re-configuring the per-CPU dl_server
bandwidth while the CPU is offline, so simply reject the write with
-EBUSY so userspace gets a clear error.

Closes: https://lore.kernel.org/all/20260526092228.3B6891F00A3A@smtp.kernel.org/
Fixes: d741f297bcea ("sched/fair: Fair server interface")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Tested-by: abaci-kreproducer <abaci@linux.alibaba.com>
Link: https://patch.msgid.link/20260526100502.575774-1-arighi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 74c1617cf65234..6f74bde684376e 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -373,6 +373,9 @@ static ssize_t sched_server_write_common(struct file *filp, const char __user *u
 			return  -EINVAL;
 		}
 
+		if (!cpu_online(cpu_of(rq)))
+			return -EBUSY;
+
 		update_rq_clock(rq);
 		dl_server_stop(dl_se);
 		retval = dl_server_apply_params(dl_se, runtime, period, 0);
-- 
2.53.0



