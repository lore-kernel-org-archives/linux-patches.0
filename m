Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B674E3EEF;
	Fri,  9 Oct 2026 14:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556136; cv=none; b=W4CJ5Vs2TECWG9YGOZE0+9zorHoFCnrCKdsB9komvbLuLF5qsKd50j57kPHnjPSB6+3bI/HXoQN7svoVqsvpb9yjvn2EAdOxNcL+sFhvZ9b3LzCIZPftf/xRQtcpuxOQWRXyaE46DIkLO1zlXmP4TFH9nRbxeXl+jPxnSvSuaaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556136; c=relaxed/simple;
	bh=JKeojmMtuxa5EvHAlsSa/T+CrKRz7zJv7rtAjavd3RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tDxUmOJIfyTAkyJfZLztlu0KRurwt6a6E87/wYE30UuPI4cOPM+DidzPNFY9QBgNncVqB0kRL3xscC5IjfjjKBo0sx/liwvTbb9i1BiNEStvMUvT/I5g28D7MjhjAQWfaNRdigKXtzpRv7r0PkH2n1D0InnS0DaCC7oudQM8h2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4o3gzRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4o3gzRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFF11F000FF;
	Fri,  9 Oct 2026 14:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556135;
	bh=j8BPIlJrHB/hQ3pMSK1BenAwTlQhzLr8rX/zkUki7+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4o3gzRAQduzmEYPngzNXksG7DTzwvVRl3kCxqKWWTamutTx0g6seUNurh33MXj51
	 TecGxLsT1c1BPrjME33ssFwjrQ3p7SEHr78utq4Z9MwxXfXhoegS8SdRCvDZOxiak9
	 WOLjLaSn9QfQpfYL5Xp4DpMn2L8R6gF77ctgfHSc=
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
Subject: [PATCH 7.2 126/428] net: page_pool: fix use-after-free in page_pool_recycle_ring_bulk()
Date: Fri,  9 Oct 2026 16:07:43 +0200
Message-ID: <20261009140948.956355342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8f8956fb061be..34ce99514d724 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -951,8 +951,8 @@ static void page_pool_recycle_ring_bulk(struct page_pool *pool,
 		}
 	}
 
-	page_pool_producer_unlock(pool, in_softirq);
 	recycle_stat_add(pool, ring, i);
+	page_pool_producer_unlock(pool, in_softirq);
 
 	/* Hopefully all pages were returned into ptr_ring */
 	if (likely(i == bulk_len))
-- 
2.53.0



