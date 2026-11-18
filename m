Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039829;
	b=45P4iE+nLOwyENK3pBjHE9H1j+xA8tXJcY8Xu2bLj4fZYRobaKRs21PFcGIWpOcNazzI
	 7gWcVtG2fa4IKMORQCY/074dbeXVFIkyw/srPwfefNlnHRKYL6WkIyGfQ7xOqrXQY5w7d
	 cdYqKB0M2nHx+7ttVeXT9SosqjYi1Ch8f3zKn3x4ZKPk7SuaIgPx0eEz5vqmHvMe7hJk7
	 ay8yKzZn4ySU9bd4FPRQma/a3cq71I4AgHoZwQyvnYf0XGw4fqM1GyaYq+byvEQotbcNN
	 6nxCWR7d4iHEExziHMwBxXbhBHQyUTFkr2oyRRmvOSGhRR/M23UM+lXVVWFBPaMY27g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QwA2PQLPo4RTrsP0rD0RzblmJws6Zz2WLoRWqORBvlc=;
	b=K2nmk/lcGta+qC+2V+CKqdmp/zgQIeSld1PhI54XPcY9ha68cwZXVFLcVxWDA3GKC2a6
	 OyqfL0HRft8O+3EjnHDpalVlPO/xXnFZxummOqeTIjWtK+WUWlXAxQ57yui8SJto2xf9R
	 OECnYx0zrbTE7JmbZjEAU7WnLFlPdxfH+sLPbUxe87sfil3C7BAEZcoeimxmJEnUaRYuD
	 swOXMtbc8F7k5b9lqZP0aIOSOX/IlSG4MvDMGA9x73qniRhnedjZ9U2lZXH+owltGMBZD
	 be29z+YP8Bbv5Dm7TYy/xq3/O3cbqjZFVSV2RE20fdpcPk9c4kYp4J1StNR2o9ryDYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRj6SHfu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3998C606A31C;
	Wed, 18 Nov 2026 22:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRj6SHfu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8651F000C4;
	Wed, 18 Nov 2026 22:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039829;
	bh=QwA2PQLPo4RTrsP0rD0RzblmJws6Zz2WLoRWqORBvlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRj6SHfuMtoCyiqyxSg3NTIrQaqrCifNGeFNmknzynbgdm6RrgXgyIlodfLWYzi89
	 fguQr8sera+xkF/cp8Lrm4tXe9DMUOT+fjF3weEfe06HATt99YaF/jR4kRXFdVSaW6
	 MUbS7L+AFQMrQ5HQlSj/R7ZZ7FcvU7jvqI4L8B4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2241/3318] md/raid10: fix missing wakeup in wait_barrier_nolock
Date: Wed, 18 Nov 2026 15:47:43 +0100
Message-ID: <20261118150429.082332595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit f00eb0ff45793383d5a62db2d2aea63ada0ccdbd ]

Fuzz testing triggered a hung raid10d thread:

INFO: task md0_raid10 blocked for more than 120 seconds.
Call Trace:
 raid10d
 md_thread
 kthread

wait_barrier_nolock() speculatively increments nr_pending. If a
concurrent writer changes resync_lock's sequence, it rolls the count back
with atomic_dec_and_test(). The rollback currently wakes wait_barrier only
when nr_pending reaches zero.

freeze_array() can be waiting for nr_pending == nr_queued + extra while
array_freeze_pending is set. If the rollback changes nr_pending from 2 to
1, the condition becomes true but no wakeup is sent, leaving raid10d
blocked indefinitely.

Also wake wait_barrier when array_freeze_pending is set, matching
allow_barrier().

Fixes: b9b083f9044a ("md/raid10: convert resync_lock to use seqlock")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260817033340.418119-3-wozizhi@huawei.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2f06b406d9147..90849d282adc5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1014,7 +1014,8 @@ static bool wait_barrier_nolock(struct r10conf *conf)
 	if (!read_seqretry(&conf->resync_lock, seq))
 		return true;
 
-	if (atomic_dec_and_test(&conf->nr_pending))
+	if (atomic_dec_and_test(&conf->nr_pending) ||
+	    READ_ONCE(conf->array_freeze_pending))
 		wake_up_barrier(conf);
 
 	return false;
-- 
2.53.0



