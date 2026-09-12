Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B13C36EAA4;
	Sat, 12 Sep 2026 07:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199435; cv=none; b=cNVNvTcFFMijJOV21Gsw1g3LrHVlr4UaAzN5FXJ/E1XFHg6JOYGZC44Nb5/HalvNJmmBUkV7Mb9bJqPj8F4RKUmKcQexOcQH4s/ytVBJutFVAIbylO4ZZzo721Ih7EaYzaGT2ykiPTv6+N19UA3vLMFDS+ESQY/ukFHJlVK1J+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199435; c=relaxed/simple;
	bh=NhZvSGurV5y1lcBr6HPZh2NXndowPJJ32FMLMzhkrm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcPi3FH9K2/l9+belbTo7vbgfxTBT1a3JAvJF8J8L6enkdAyMK87NDfxp4TWHfqVFloCnaJ/xbHzmUbnx1+NjwoYfxZWJ/Gi+KLfxVaBFJSUbUut8yuulqPO8uRQlB+PDlIgqUoqWau4Tc3MtivEcub4oyjkQZbCwkJ+MTsc3cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFS1W3UJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFS1W3UJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159DE1F000FF;
	Sat, 12 Sep 2026 07:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199434;
	bh=ie+5TJpYy4VybN5fjBo04Y2sGG/itXK0WyO/ZWnOcpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CFS1W3UJQk2AzH6FVgd4BKfwD65T824CqQffWjj1YE7ecw3CFMLfRHBtkglB/clml
	 mv0KposaHS8lfgxO+rbMh3fmo9Ji7veIepIav6m5HrORVLMOY6G0n5PHe/04vPDTim
	 4hoW7HSWOCeLgSmaL2WWaeOLtOGl/NemneyYqlGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0583/1815] RDMA/core: Fix potential use after free in counter_release()
Date: Sat, 12 Sep 2026 08:38:53 +0200
Message-ID: <20260912065702.567848077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index a9e189194c130..a2c85840c501a 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -234,7 +234,6 @@ static void rdma_counter_free(struct rdma_counter *counter)
 
 	mutex_unlock(&port_counter->lock);
 
-	rdma_restrack_del(&counter->res);
 	rdma_free_hw_stats_struct(counter->stats);
 	kfree(counter);
 }
@@ -329,6 +328,7 @@ static void counter_release(struct kref *kref)
 
 	counter = container_of(kref, struct rdma_counter, kref);
 	counter_history_stat_update(counter);
+	rdma_restrack_del(&counter->res);
 	counter->device->ops.counter_dealloc(counter);
 	rdma_counter_free(counter);
 }
@@ -490,7 +490,8 @@ static struct rdma_counter *rdma_get_counter_by_id(struct ib_device *dev,
 		return NULL;
 
 	counter = container_of(res, struct rdma_counter, res);
-	kref_get(&counter->kref);
+	if (!kref_get_unless_zero(&counter->kref))
+		counter = NULL;
 	rdma_restrack_put(res);
 
 	return counter;
-- 
2.53.0



