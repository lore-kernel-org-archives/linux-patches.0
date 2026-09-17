Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0754D4890;
	Thu, 17 Sep 2026 16:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661031; cv=none; b=kZ5RyrGXOUPjaeJaaof+cHTtTJLoo6cLOdPiGDJ9QjkxMgqzPPj5F8oArlIUzTUsA/sI1FOZ67KV+9bg5+hT8p9vMvvofGAlCK+meQaIY2ObvSOVuz6Q+uiaK2syCC5igIZ8a1D9nDzVMTABb7iAkIZCuXexyhO+qWr3ceR4lWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661031; c=relaxed/simple;
	bh=4kiI8PAa/CIQTdkmPTjyFt5JkwjA1YrXYSzgE8m4Eo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiMBVSmFOWqarwSK+MGET1slS2ZRa5eaQz82SXQk043p5rgS3iAmHwoNlE8b9wJ28Ea445BwjbtmpFtO4Z1+o49ePIa1yxg/71GTUiGpbgZHk8dk1U/tVNRz5mVPhEfY7bUV6ULA0RE+hrfgQbYgTvrg5GARK7DYID7x5eABh9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4EEmHsQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4EEmHsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5501F00899;
	Thu, 17 Sep 2026 16:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661030;
	bh=GFcIpv45tpRm5PZjilM9uWZmiROOKsDrprKjfYTMHVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4EEmHsQd62kx3UC7B3n4zIDGAjx3QpYK8kdRdBzELxEJk8lmQQ45L2oJbOx2lyck
	 9KMeOXjEqQZS8QYvr7An+/N+gXoMfCIyzxwvelqdmPwkcYMbQfW2AMEhZzDfiyc7R4
	 Ls8hypjGVWes5l6saWcXtvcLHAQyOZWU3kU/mb5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0059/1250] thunderbolt: Keep the domain reference while processing hotplug
Date: Thu, 17 Sep 2026 15:57:34 +0100
Message-ID: <20260917151553.543170335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 138ec65b2c761f065b19d115aed2b8246fc272f5 ]

We process hotplug events in a workqueue that may run after the domain
has been removed by tb_domain_remove(). For example if user unloads the
driver while at the same time plugging  a device router we may have
scheduled tb_handle_hotplug() to run. Avoid possible UAF in this case by
taking the domain reference before scheduling the hotplug handler in
tb_queue_hotplug().

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index a0fc2c80c66e3..59a503946c5ef 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -98,7 +98,7 @@ static void tb_queue_hotplug(struct tb *tb, u64 route, u8 port, bool unplug)
 	if (!ev)
 		return;
 
-	ev->tb = tb;
+	ev->tb = tb_domain_get(tb);
 	ev->route = route;
 	ev->port = port;
 	ev->unplug = unplug;
@@ -2527,6 +2527,9 @@ static void tb_handle_hotplug(struct work_struct *work)
 	pm_runtime_mark_last_busy(&tb->dev);
 	pm_runtime_put_autosuspend(&tb->dev);
 
+	/* Undo the refcount increased in tb_queue_hotplug() */
+	tb_domain_put(tb);
+
 	kfree(ev);
 }
 
-- 
2.53.0



