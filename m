Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3644E37F8B2;
	Sat, 12 Sep 2026 10:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207947; cv=none; b=WkdF3kPGkhYacR7k1lw4ndde5WvpMsKGfek8MYUmRtFrhHKVVzYNO33cJFgYe5e3VAflobnwJp674fXlFS3UpZ0KvY6bfOYsLyI4joRUiwRps8UiVjIXrPLdk18pYmaeX3jOz/FevWoMUBJD74YbHuiCvygQgsFfj0L4JXvcbE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207947; c=relaxed/simple;
	bh=UNGx6guK7SWk2NEhRZijt/GiBxtYW/bxOoMThIQDJLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYdjsHrhVtxo34CIg3mlkcXMVqxSGBzEXvoECeMIG17MvPVkE61OJFik1aWRysf9eTm9BagFLav3hXeS273WahK7B/B9NgjbUMzdhlwDavCl1BBvnVV1H4+3alI4ZQri5VXAK8l8ufRbsPpU5CmI2KW0Vsxnb05sVy7rnj3uaoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnpUX7PV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnpUX7PV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A13E1F000FF;
	Sat, 12 Sep 2026 10:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207946;
	bh=r84wsry3w61nYWCXpWJvl96njTKV9+DPQFg0bMsRt0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnpUX7PVJSD1ncx9YtH8YNdLuVS+XkuwtgvrbTIW4SaB6FmXQyFR3ZP/P/uu7d82i
	 2xYeBCiSvsnoqVTD65nWGSjsLKfYd5FdfRuRgApPdq+lyBzQZgo1cT0s6vlFUgokGR
	 QytnzbfLWP//75IxvqEpp9fVv7bypd1sQsHtUuCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0518/1518] RDMA/core: Fix potential use after free in counter_release()
Date: Sat, 12 Sep 2026 08:44:47 +0200
Message-ID: <20260912065635.162535143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 235ef2d0e750885c29340b0fc40620a7a4f52e12 ]

When accessing a counter via the netlink path the only synchronization
mechanism for the said counter is rdma_restrack_get().
Currently, rdma_restrack_del() is invoked at the end of
counter_release(), which is too late, since by that point
vendor-specific resources associated with the counter might already be
freed. This can leave a short window where the counter remains
accessible through restrack, leading to a potential use-after-free.

Fix this by moving the rdma_restrack_del() call to be before the
freeing of the vendor-specific resources, ensuring that the counter is
removed from restrack before its internal resources are released.
This guarantees that no new users hold references to a counter that is
in the process of destruction.

Fixes: 99fa331dc862 ("RDMA/counter: Add "auto" configuration mode support")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260713-restrack-uaf-fix-resub-v2-5-bbe8bb270d51@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/counters.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 5dad5d77ce274..5dfd64b0449dc 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -226,7 +226,6 @@ static void rdma_counter_free(struct rdma_counter *counter)
 
 	mutex_unlock(&port_counter->lock);
 
-	rdma_restrack_del(&counter->res);
 	rdma_free_hw_stats_struct(counter->stats);
 	kfree(counter);
 }
@@ -321,6 +320,7 @@ static void counter_release(struct kref *kref)
 
 	counter = container_of(kref, struct rdma_counter, kref);
 	counter_history_stat_update(counter);
+	rdma_restrack_del(&counter->res);
 	counter->device->ops.counter_dealloc(counter);
 	rdma_counter_free(counter);
 }
@@ -482,7 +482,8 @@ static struct rdma_counter *rdma_get_counter_by_id(struct ib_device *dev,
 		return NULL;
 
 	counter = container_of(res, struct rdma_counter, res);
-	kref_get(&counter->kref);
+	if (!kref_get_unless_zero(&counter->kref))
+		counter = NULL;
 	rdma_restrack_put(res);
 
 	return counter;
-- 
2.53.0



