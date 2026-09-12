Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E257F4BEE4C;
	Sat, 12 Sep 2026 14:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223713; cv=none; b=SvtcHndz4EMBWi4teexX8JcQfiVOj1EhPJjufYfCyGgig24j7fAlmH0oUJHb9ew/wCjLaJ043ekI1IGF+BXC5C6NyarBtGSuGL1d9SaH431eSTYI22U6j6pCYKL5uUf9PwE7vACWZH3Hr6wpGRqPahOFATj4L5TggbKlH3P6CTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223713; c=relaxed/simple;
	bh=GHTAXX3l45HJDFP+vICA2guhyhgeTVXIzEN0T2pAX6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7AjqRHCKp5h1fVWlxhgIHY1AkEOqYVcFZVqjbWQ1gJzoZGk2j3aOqS+OISezgkE6EPweI0HFIo7tzjkj7s2gdq3GhSC88bREUJ6NsjnG9iFPDS6LWerqqmrNxPqpXwAyk6flmQvW4HAT9CBks8SByvjY4P7IlzymuwHvGQuWOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdL88rVg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdL88rVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B93B1F000FF;
	Sat, 12 Sep 2026 14:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223711;
	bh=0DFQYaIuUvNgvLB8ddfx8V4W/U+kt33ylvY8CdbMlts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdL88rVgteloWtD6+OKXQNC6PLt2WSb4ykguQUWu3cGFD9/RZq2NVSOVwMd1s7RCM
	 O3cIfajvP9EP/YuugA/u3yGr3xZcF/U0UbL4iP1sjOtWFcm4OTHDtxzxh0WLGmYRR+
	 SSKrD/IoZBrcuPjy7VW7iUrH/y0D2qcJCGYL7uXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0844/1424] RDMA/core: Fix potential use after free in counter_release()
Date: Sat, 12 Sep 2026 08:54:36 +0200
Message-ID: <20260912065626.210697728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d41af5ab6403a..8cbca897fc531 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -217,7 +217,6 @@ static void rdma_counter_free(struct rdma_counter *counter)
 
 	mutex_unlock(&port_counter->lock);
 
-	rdma_restrack_del(&counter->res);
 	rdma_free_hw_stats_struct(counter->stats);
 	kfree(counter);
 }
@@ -312,6 +311,7 @@ static void counter_release(struct kref *kref)
 
 	counter = container_of(kref, struct rdma_counter, kref);
 	counter_history_stat_update(counter);
+	rdma_restrack_del(&counter->res);
 	counter->device->ops.counter_dealloc(counter);
 	rdma_counter_free(counter);
 }
@@ -472,7 +472,8 @@ static struct rdma_counter *rdma_get_counter_by_id(struct ib_device *dev,
 		return NULL;
 
 	counter = container_of(res, struct rdma_counter, res);
-	kref_get(&counter->kref);
+	if (!kref_get_unless_zero(&counter->kref))
+		counter = NULL;
 	rdma_restrack_put(res);
 
 	return counter;
-- 
2.53.0



