Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062159;
	b=koJ1yoogEFc95Qy9y+DDbD6lnS1DxXYV8E6t6y7YummcsN3ckQ5ziffEV/bapVrqjJsU
	 lq6gD+RJbtOOoINuU9y5q5SooVx8hhKcno5OZ4TDTb/jkuWsG2IDo0AxqMe8i9VBqCt2i
	 LpV7P3mdwrbnt7KzH90n3pw249bc/bAG+j0kPsqY6BmXj6iiovXhP26jDSZVOn04eh89d
	 uWkK0JDcHg3Q1grQ1FhMyb3iEARkXJK1Fm4M5KYue7n1vtdKgTQW46xKb5zBFnSFsg6AN
	 bgTs6V6HT1orX48XiJXCe+12+RICWGm4FwA7QbZaiqdut6pkfvOZShPlSCBFj+GxmdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SJx0ab1sayzKyEHBwe7x4CphYM5W9HhtXoMTeN4a/1Q=;
	b=rpUjfoShClvLDL/KG52slbF6SQKffpTXIOu5X4jsB+Vm5HtZWHHmuIpsyjeNocsyxTz0
	 j7HeR1REeShephYj7dvceH/GAJ4bQmRHGdV/T852Z4Pa/sluPQ75eiUStyCJ/zpYEGgoo
	 3EVI+fLny7fvUNJaFfH31bUQgNXYPvnUAtvMRnvKsPAyX64e3XNiH1LbYIUQzGqsjBYSH
	 H9Vb4K38ue9j63vDnvQI5tfVMUCKNJPuQhJwwno0vF+F3ard0KezYhSQhUgQFYFzKSCvB
	 V1jvfeo2WU7f14EqOjD1q5OT09fEf2+lJnAU5TQ72xelVb27oVNzzFL+TirbgexPO2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=czIi2rXA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC79606A326;
	Sat,  7 Nov 2026 14:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=czIi2rXA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC131F008A3;
	Sat,  7 Nov 2026 14:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062159;
	bh=SJx0ab1sayzKyEHBwe7x4CphYM5W9HhtXoMTeN4a/1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czIi2rXAvVlIlzH72Js+VKrqCDkiEv9o3vK8huSDEHRPc9GhvEWIscIIsPfJLd7LJ
	 NJpXjo/ZFjcDM44VXV8T2Ab7E/66yN1tiALZypSx/z8CDHidruUNpfpxuMl1xnFcOl
	 N0Xw4DUXgpX0NhKAhuZWxubq0slj8ZNvvm28khHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1123/1536] dm-writecache: report I/O error if flush failed
Date: Sat,  7 Nov 2026 08:52:19 -0500
Message-ID: <20261107135029.252100303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 78a6afc2999d26e5a30a56db77db34c22b88f5d5 ]

There was a bug that if writecache_flush fails due to I/O error, the
error is not reported in the FUA bio. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: opencode:big-pickle
Cc: stable@vger.kernel.org
Fixes: 48debafe4f2f ("dm: add writecache target")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 7ce8847b34041..d9e0008c32372 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1492,10 +1492,13 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 		}
 	} while (bio->bi_iter.bi_size);
 
-	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks))
+	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		writecache_flush(wc);
-	else
+		if (writecache_has_error(wc))
+			bio->bi_status = BLK_STS_IOERR;
+	} else {
 		writecache_schedule_autocommit(wc);
+	}
 
 	return WC_MAP_SUBMIT;
 }
-- 
2.53.0



