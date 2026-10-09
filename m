Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B283D8912;
	Fri,  9 Oct 2026 14:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555692; cv=none; b=p156rxDAB9YrjqJS//uboqIEP+MBbPMNAr1q4IbxfUysArbb1G+s02Vk1aC9DmK+L7J9xx8dNEbZ1/6SCbUJlSv/J1NEkVy4xSLaCproSWFXQKkLYz9dDE5MqWunljaXDYKwwJKdnuH6T997suYpb2KfqlXylhMyz++uJgE4UB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555692; c=relaxed/simple;
	bh=AUYV1IJR17qk5J0C3Mjas0mijaJ0QaAJ/QWDEgAmkFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbBQCipHvwiN1gskiFcSPGLjdWsZMPpvbWgRTXRAylkwdxvbSFd/VntBP3f8+KjpmNnhBemY/cA9RF/51WnzjULJCKFC8jGK8jkNg1PD+JQ9kdzuokUKSs+AJrvm/GfNhG6nXXDvVin9oetbUWB1Z1eUsy6zYAJ0SUJhwaQtl0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYQVxNX5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYQVxNX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9991F00898;
	Fri,  9 Oct 2026 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555691;
	bh=1ZsmRGB60Bz0mzSnLjSuR0Wpso/hDiswok79jOPIZ9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYQVxNX5aUXW1NyyxxMwgMqWN2lOZytWP7yBykBBuzT7MnnQCcgn+rjAzGTnp+g4D
	 1ZtJG4fX85Z58YLS4hpDjCCoP5HmcJ6dBaGQ+6G4WY7Xq8q/TebheECMDxs4VRsOvl
	 coAivAiTE2dSZw6/V1evhIhecpb+FbeTSH+mH5fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaifeng Wang <kaifengw@google.com>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Mina Almasry <almasrymina@google.com>,
	Simon Horman <horms@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/403] net: page_pool: fix use-after-free in page_pool_recycle_ring_bulk()
Date: Fri,  9 Oct 2026 16:07:41 +0200
Message-ID: <20261009140954.425101556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit bdea4980182e3badac74f04df6c07492b91c569e ]

With CONFIG_PAGE_POOL_STATS=y, page_pool_recycle_ring_bulk() updates
the recycle stats after dropping the producer lock. If it just recycled
the last inflight netmems of a pool being destroyed, page_pool_release()
can pass its producer-lock barrier and free the pool before
recycle_stat_add() runs.

Commit fcc680a647ba7 ("page_pool: allow mixing PPs within one bulk")
moved this stat update after the unlock. Commit 271683bb2cf32
("page_pool: Fix use-after-free in page_pool_recycle_in_ring") later
added the barrier, but only fixed page_pool_recycle_in_ring(). Move
the update back under the lock.

Fixes: fcc680a647ba7 ("page_pool: allow mixing PPs within one bulk")
Link: https://lore.kernel.org/r/179028939171.2160803.706522228583664641@kernel.org
Cc: Kaifeng Wang <kaifengw@google.com>
Cc: Dong Chenchen <dongchenchen2@huawei.com>
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20260925144127.1445667-1-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index d1fa5640a9128..e02bdee3c5fdf 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -949,8 +949,8 @@ static void page_pool_recycle_ring_bulk(struct page_pool *pool,
 		}
 	}
 
-	page_pool_producer_unlock(pool, in_softirq);
 	recycle_stat_add(pool, ring, i);
+	page_pool_producer_unlock(pool, in_softirq);
 
 	/* Hopefully all pages were returned into ptr_ring */
 	if (likely(i == bulk_len))
-- 
2.53.0



