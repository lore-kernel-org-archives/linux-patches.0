Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B77846A60E;
	Tue, 21 Jul 2026 19:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661774; cv=none; b=jJC+amsNat6/76WoHsxit2RFUKWP40gIkz8jwJKBWrs1xjmekqd4EiDO2I6sujPVDAbeILzQRKUPFbdEVVQOwi00ojo6Sq371bYO3BO8tJZGI3mnJ0XehJfKI7OIEv6uoa+BbsvgJf7M2V3YOQlolPB0ZH8YkahbMOTzJtWJXzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661774; c=relaxed/simple;
	bh=FeodNrVQQPOXkhq+sLX0I/VyrNdnwgvZPkcoStRp2NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cG8wtzZQrLRS6i2lJn8dKEwgFjCj4YtKpKVqyxIw27ezAhb6EHd5JRWr7uDAh3vFX9yUtcJnZmIlZevYT0fBVIZsRuPKdVqqXoPsYEz2EYhZS3SWARnxZtC+rU3Cq5otOoHA3x23kVnuCAXqq/UZJt1eHwfgElkL+5fWBw7Ltmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nv/yYiJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nv/yYiJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130191F000E9;
	Tue, 21 Jul 2026 19:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661773;
	bh=fBH0qC/FLiTKK2Gmd6xXQGCPgbb/BVvYZC60IaEymos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nv/yYiJv1kpkqM7AkCHQwp1a9Fe/zvV5IdsHmv/r8xUdEqK2oN+WBzumvv64RK7+t
	 Q3YmFDpKF6ABk4+N+PNtWyTneOTNnP2Sv4IF1gEl7EgpU3wwVKCeH2EtMb0sDz9b+e
	 wgvkXW890kTPa3iulFMLfhrSYtHm6G37vIbg/xEM=
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
Subject: [PATCH 6.12 0194/1276] sched/deadline: Reject debugfs dl_server writes for offline CPUs
Date: Tue, 21 Jul 2026 17:10:37 +0200
Message-ID: <20260721152450.426927445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 564ea17ae405e3..27dcb5a9be4f85 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -378,6 +378,9 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 			return  -EINVAL;
 		}
 
+		if (!cpu_online(cpu_of(rq)))
+			return -EBUSY;
+
 		update_rq_clock(rq);
 		dl_server_stop(&rq->fair_server);
 
-- 
2.53.0



