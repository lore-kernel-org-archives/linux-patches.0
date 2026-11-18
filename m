Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019582;
	b=MqGSN+x5q2+qatc728M1uBzU6MJZAWdFrLmjBNOAWAe80vtNp0N5XmBH5g6d5um8sLOY
	 HehS6uya4qvYmevAGus/PLmnjioy9r87N5sZVBU8aGldqyyJPstABZAGeLBkQsXXA7rh+
	 5dAuNLb0jV5OtepvVgEH8CZAgl18zVNu0sMPpy0uMI601cGTFlVKYlrmgOAbi3L3o6hqP
	 zOJC5UIUKrvlw6VqkQWadQJK8BAUxIpKxep6fKn/ZnhPhnoxab4fC/yThnfj0M5TyL4V1
	 +rtvDFmUMbWzM6cgeKM7Z7tmnQBi+lfozJ+RUhZNwxqYb/rTPQx2nTVeKwSxpxPqeCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FGUjlz7Gxp5mmTBT6LO+FMFnIiHZkw1FMpsqH0v5MeM=;
	b=MOSfElcAGk1jlgDjHrpFHj1ccSNKfhUXB46yZ1+gil1gc6W5yp98pc3RuEgcdtX/O46Q
	 liQb6yXAb9p9FuEfPniy9aRgSyYLTw0zfvnOuCSr5BfCyxWAbzsZCxgTZsU8+4dfXZPUt
	 nhBXTurolqEBHs6hBwPM+q4vnjVMiCFTNb9c5zXe3y7CGo7tVCUFtmV7Ibdx2RXu0nPmp
	 IYehNI39XAcKSKmipDQgexnigfWbihX88/L3PeNHFJcMs4lEnEWmyn4L2SHXx+jwYRB0Z
	 DxSiGnrSSqRlDRqHYF8b3tTkPlEBLIH6sHdpUk9Ie8l1+yBatHnGn7QnGz81QerM0lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjgdLZZf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F31B606A325;
	Wed, 18 Nov 2026 16:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjgdLZZf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C341F000C9;
	Wed, 18 Nov 2026 16:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019582;
	bh=FGUjlz7Gxp5mmTBT6LO+FMFnIiHZkw1FMpsqH0v5MeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjgdLZZfRD/XRCjo6UBfntDhIpkblhzYU/XsZnsDUUcJVuU9CbB+SsBkFAVQ1VpI7
	 JdRcPKV+GlKtukyxlm+d8POuTI/gqrm98k+WFcUJoi+W9c3INooBN/c01hQTFhT/Cz
	 YPaMKxgr8XpF//tFw46gR4KEcVToK8aEq9VsAC5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1646/2651] block: dont fall back to buffered I/O for atomic writes
Date: Wed, 18 Nov 2026 15:48:06 +0100
Message-ID: <20261118150347.059699537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 9fd1afea19fa7c4ba438a1d162739e0832073a4c ]

blkdev_direct_write() turns an -EBUSY from page cache invalidation into
a 0 return, so an IOCB_ATOMIC write is retried in full through
blkdev_buffered_write(), with no atomicity guarantee.

Skip the buffered fallback in blkdev_write_iter() for IOCB_ATOMIC, as
it already does for IOCB_NOWAIT, so the -EBUSY case returns -EAGAIN and
the caller retries, matching __iomap_dio_rw().

ext4 has the same fallback and only warns in it. For block devices the
fallback can be skipped before any I/O is submitted, so fail early
instead.

Fixes: caf336f81b3a ("block: Add fops atomic write support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260802-blkdev-fixes-v1-0-a82fc549fd74%40columbia.edu?part=2
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Link: https://patch.msgid.link/20261009-blkdev-fixes-v6-6-307939c387df@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index a5af145bd0116..562cc52af5aa2 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -787,10 +787,11 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = blkdev_direct_write(iocb, from);
 		if (ret >= 0 && iov_iter_count(from)) {
-			if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_ATOMIC)) {
 				/*
 				 * The buffered fallback blocks on i_rwsem and
-				 * on writeback of the data it copied: return
+				 * on writeback of the data it copied, and
+				 * can't provide torn-write protection: return
 				 * the short direct write instead and let the
 				 * caller retry. The bytes already written
 				 * still need a flush if REQ_FUA was not set.
-- 
2.53.0



