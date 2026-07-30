Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C12411A07;
	Thu, 30 Jul 2026 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423499; cv=none; b=iqaJnfQ5eb7e2EoD8HfEHghCn9a6GccGYEyZy83YNpa226q5vDBeT5wCnwnne+CD/WWWIXdYCjROkwPIRHJsfuTQb3qRgz4/1GyXzfAa99qRFqI8FaBs3Jqm89fMDZ8BXKNOGrFaPBzaud105nl4qLe/lCeL4/JVXeWOoDOI5Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423499; c=relaxed/simple;
	bh=IMo1m/JH814isJrPSXEYJD5NQ//t+lwjSNkG7FSt47M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqfPLsxcBuTuO6sE4WoAeR4hJpYm+yU6ngYJB0s8JLA6u5VuCjA7eq7zS3Vdz9GeJZiLQUtCBa+N76Zig/a6/BDDQY3EYP8d2+FMuSoGQQyPevUCT5JJQK9LotYIb85Rkblqpr3H32CACijL4/bCbp/NnkfCj4/TwcZfDaiOpjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcxI1W0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcxI1W0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9B01F000E9;
	Thu, 30 Jul 2026 14:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423498;
	bh=dwF/alWfozIipzsBFKjQ+Ls/txpb4SIAziziH1AUQlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcxI1W0aayU7lzXn6e30SIZD/joWCFiJQwkVgq2/cFw9kiippGVWZDbfbOKoHUVqm
	 68SkDf+0fSGF0TfwFMr5r/oTSTsBybvxMzBnJ0H7M13rFjSph4/arQKluV2wWMNw6u
	 dyzD95IjgpU5mMT9jfMBv0iFutx+j0yorHFq2p7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/675] xfrm: policy: preallocate inexact bins before xfrm_hash_rebuild reinsert
Date: Thu, 30 Jul 2026 16:06:34 +0200
Message-ID: <20260730141446.486323938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit f38f8cce2f7e79775b3db7e8a5eacda04ac908e4 ]

xfrm_hash_rebuild()'s first loop preallocates the bins/chains the reinsert
loop needs, so the reinsert (after hlist_del_rcu()) cannot allocate or
fail. But its guard is inverted: it skips policies with prefixlen <
threshold and preallocates for the rest.

prefixlen < threshold is exactly when policy_hash_bysel() returns NULL and
the reinsert takes the allocating xfrm_policy_inexact_insert() path. So the
loop preallocates for the exact policies (which never allocate) and skips
the inexact ones, whose bin/node is then allocated GFP_ATOMIC during
reinsert. On failure the error path only WARN_ONCE()s and continues,
leaving a poisoned bydst node; the next rebuild's hlist_del_rcu()
dereferences LIST_POISON2 and takes a GPF. Reachable under memory pressure,
deterministic via failslab.

Invert the guard so preallocation covers exactly the reinserted policies;
the reinsert then allocates nothing and cannot fail.

Crash:
  Oops: general protection fault, probably for non-canonical address
  0xfbd59c0000000024: 0000 [#1] SMP KASAN NOPTI
  KASAN: maybe wild-memory-access in range [0xdead...]
  ...
  Workqueue: events xfrm_hash_rebuild
  RIP: 0010:xfrm_hash_rebuild+0x5b3/0x1190
  RAX: dead000000000122   (LIST_POISON2 + offset)
  ...
  Call Trace:
   hlist_del_rcu (include/linux/rculist.h:599)
   xfrm_hash_rebuild (net/xfrm/xfrm_policy.c:1365)
   process_one_work (kernel/workqueue.c:3322)
   worker_thread (kernel/workqueue.c:3486)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
   ...
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 24969facd704 ("xfrm: policy: store inexact policies in an rhashtable")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 4dad1f8172286a..25f9cbd3ce6a4f 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1329,8 +1329,8 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 			}
 		}
 
-		if (policy->selector.prefixlen_d < dbits ||
-		    policy->selector.prefixlen_s < sbits)
+		if (policy->selector.prefixlen_d >= dbits &&
+		    policy->selector.prefixlen_s >= sbits)
 			continue;
 
 		bin = xfrm_policy_inexact_alloc_bin(policy, dir);
-- 
2.53.0



