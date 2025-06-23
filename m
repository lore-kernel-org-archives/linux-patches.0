Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A551DF98B;
	Mon, 23 Jun 2025 21:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713250; cv=none; b=WDs06n71kKNyP8w2yjfbL1L57Ff2Fb6NdPeUGDXUvT9ZHj3QsxlR4xwDugZmgNdpzQg0RgNEjlpMD03uGPoza3WhJe/YXfr4jf5AVFdzBG6eA3rKJ7hdj3GPTKo7PzyIWBc0JgCQ5UKWRNip8d13owPx16O8gHbCjzz6EBejYek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713250; c=relaxed/simple;
	bh=8B2QTdBMOgsW4xhSg5hYIZUh+/vy5yD1dks8JPIZ3C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dIm+uVKb3cmObp+hFzgPofrq8BYb0k0GkJOvCKSj1d1Lfw5c5Cxlo1VysNXK+jxPV5UyEDcURG+As2RElBoY1dDk0d9t6faw32tz5hGcfwYMs0m6CkvF5LppNkRVvKXISLHZz62vSVYFyoEwlerqf87dBk/ZkWqJUgzwVLqYxRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QG2w4aoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QG2w4aoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A60CC4CEEA;
	Mon, 23 Jun 2025 21:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713250;
	bh=8B2QTdBMOgsW4xhSg5hYIZUh+/vy5yD1dks8JPIZ3C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QG2w4aoTczealr3gWMbqxinpHAI1xP2BQPHmEvXUrj92gyPtxv4HWnY7QJVeIgHgv
	 k3ZYLX7nr3bsouqCXhhfRM93sMJS4A70Mx7FvFdVhweaWR6PwmyNlMmrFHxyCsHNhb
	 N6CWWXDY309rHt5V+ZL18q6dzwqJ+rSHANXQJfdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jiawei <zhongjiawei1@huawei.com>,
	Chen Ridong <chenridong@huawei.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.6 056/290] cgroup,freezer: fix incomplete freezing when attaching tasks
Date: Mon, 23 Jun 2025 15:05:17 +0200
Message-ID: <20250623130628.694357605@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

commit 37fb58a7273726e59f9429c89ade5116083a213d upstream.

An issue was found:

	# cd /sys/fs/cgroup/freezer/
	# mkdir test
	# echo FROZEN > test/freezer.state
	# cat test/freezer.state
	FROZEN
	# sleep 1000 &
	[1] 863
	# echo 863 > test/cgroup.procs
	# cat test/freezer.state
	FREEZING

When tasks are migrated to a frozen cgroup, the freezer fails to
immediately freeze the tasks, causing the cgroup to remain in the
"FREEZING".

The freeze_task() function is called before clearing the CGROUP_FROZEN
flag. This causes the freezing() check to incorrectly return false,
preventing __freeze_task() from being invoked for the migrated task.

To fix this issue, clear the CGROUP_FROZEN state before calling
freeze_task().

Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
Cc: stable@vger.kernel.org # v6.1+
Reported-by: Zhong Jiawei <zhongjiawei1@huawei.com>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/legacy_freezer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -189,13 +189,12 @@ static void freezer_attach(struct cgroup
 		if (!(freezer->state & CGROUP_FREEZING)) {
 			__thaw_task(task);
 		} else {
-			freeze_task(task);
-
 			/* clear FROZEN and propagate upwards */
 			while (freezer && (freezer->state & CGROUP_FROZEN)) {
 				freezer->state &= ~CGROUP_FROZEN;
 				freezer = parent_freezer(freezer);
 			}
+			freeze_task(task);
 		}
 	}
 


