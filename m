Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040101;
	b=qt3FC4DsLPRJWlCmK4FDP/ppLiN0GIdmC3tfWD4mqmSar7D9ziNxkzL2qdIiwif8XONx
	 PBQAPzX8YnTkmQAPjZzsGvL6rnsoQYREOOAmHVJIW8I02RRR0cQH7rDCJE473sI7N+KBR
	 umm5AZMxQgzzTEIdKWytP2Bn+GJ8iyxAK9mva8k2YGSWZg6LtIGBZknTi6E1ng+fOodKe
	 +KXN7epKJ9qtCAA+6ju64nIgeeLJIxwgJovMAv2DBhj2CiJFuVVa6tvStcfXBfBQACJ2x
	 1BqwdSFlmj50UIb05Yiq1t9f7b0Z0pYcuy8KUHovLBWZKZjy4RPEpei+qthJyKrIihA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Izb+lm1qAdcU7+9tcmCtFedOOfBUdnguv/OSr2VgeKw=;
	b=0dtWTPXFFnxSybvJcMMgLXyyEjzTpN60IeDADi0sA+D+KhNU6ZZgk8IsS2rLRf3akgK0
	 GNTjr9qc6enhQk9WMeyaJhtwjLr9tmSgzlUE6b3w/K/lD5So+IGQjwJh5Tgy+JS5wqMKg
	 7oFqznqfy8zOvHm5S+/ikKetQonO8o7/jfpPEEg0+oO/In/GEfy1Qhu+Ttqt16P9B8QoB
	 HwIcjrbzOeDHFASYOtws+JTznBn5+8CLYiVkU9HMK4FwuWCy627zNYRlydrhKFq5kIs6y
	 /LmQ6UmeNBOxRDm38Fa/p0DVWpili5Zq36CvJxUF/Oi4NgT7f0+OuQE7rwKLXM6mwRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mz6NO3Fl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB47606A32C;
	Wed, 18 Nov 2026 22:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mz6NO3Fl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCDF1F000C8;
	Wed, 18 Nov 2026 22:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040101;
	bh=Izb+lm1qAdcU7+9tcmCtFedOOfBUdnguv/OSr2VgeKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mz6NO3FlRUFl+8b5UOVveR1OuTveGp5q7Hr9GAJ2b8TZoorQJtHbO/f1VTUGqAe6F
	 z73iCj4Bdjffarx7k6wtpacDcCLh6XAEmUtRhf6ERd1tHow5kLF53m/9ktK5C+Iqxk
	 0wBPIOHB6EVim3y+vyos7JvolCgncnS7E1mOEM1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2337/3318] ext2: drain in-flight DIO before buffered write fallback
Date: Wed, 18 Nov 2026 15:49:19 +0100
Message-ID: <20261118150431.748207925@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 1e2ef9f221e142ed19d874a71b2cae7fabbaf138 ]

An asynchronous direct write can remain in flight after the inode lock is
released.  If another direct write falls back to buffered I/O while the
first write is still pending, generic_perform_write() can dirty pages
before the first write completes its post-I/O page cache invalidation.
The invalidation then finds dirty pages, reports a page cache invalidation
failure, and records -EIO in the mapping error sequence.  A later fsync()
therefore returns -EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed the same race in
ext4.  Ext2 has an equivalent fallback after iomap_dio_rw() returns
-ENOTBLK or a short write, but does not drain other in-flight DIO before
dirtying the page cache.

Wait for in-flight DIO before calling generic_perform_write() in the
fallback path.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning and made a subsequent fsync() return
-EIO:

  Page cache invalidation failure on direct I/O.  Possible data corruption
  due to collision with buffered I/O!

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.alibaba.com
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260924105125.577714-2-yaojiale02@163.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index fbf416dea1300..90dd529fcedca 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -251,6 +251,13 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		int ret2;
 
 		iocb->ki_flags &= ~IOCB_DIRECT;
+
+		/*
+		 * Prevent concurrent direct I/O and buffered I/O to the same file
+		 * range. Wait for in-flight DIO to finish before dirtying pages.
+		 */
+		inode_dio_wait(inode);
+
 		pos = iocb->ki_pos;
 		status = generic_perform_write(iocb, from);
 		if (unlikely(status < 0)) {
-- 
2.53.0



