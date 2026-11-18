Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026194;
	b=rRCynFFV9XCNP0l8h2CbiMkH9m+Gu+izSlMZE4xcf3vRAUpQCLbKM4LIFyw9K9GC8W9i
	 r5NV3R6PVGbgTipAO0Zutbxp73DMxCzMsicDcOkk/bkVbbqwToN/Monpe8l6HVny52R6f
	 5sGMwhh3g5w0px3uhYkpbZhXlQgjTVYoatrOpXRQUEkpf8Yh3rzoXqIMKc3ia3ciJIIwD
	 AfIkekvamCV1B+c7yeXF5Bsa928wzXMEySrxQVJbUA3My+Ai/SNdQAE4wEnUU/28eVoef
	 ihRQntGGzkJfR2IP90s1WVNjX/JZ0m3bp3Jo6qmrGZFm6w+BiIoHnoFV/HCsAQ3PNng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GfbI7K9sTv/JOSIZ9259egDWbjxTjuAOJ8GJLfbiQ+U=;
	b=vhZHOK1/rtA6/ix8gVPAguySs1PVxDfKOS4GG6bSwkaVSEKdSwY79rvaSy+18O1TnIA3
	 SXRzqKryjRMm6xBRCm/V4V7uESLhNj/dN6JFJNSNtCKGJtScYA/fD+ik7cpLyctVMJZfb
	 7g/UPBTvrs1p6mojj2JV/527PLii4M/ZgpGJrFVQTpYZUA1Q71QQzu6aPIOsf3hXLVjzO
	 wqJxBPhMkS8Cq6S/mQYX6Q+VFAd32BVpycEkNm+vSojebHwh6eR8Tg/o3hFMa5g0XRXef
	 C5Dv6ChVhcjyS83XG51WcKMiq6uGnC+lQszalTAKlznY3il85ewSrxUBKjS9VGJnB2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1dyKqsB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAE660A2637;
	Wed, 18 Nov 2026 18:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1dyKqsB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541AB1F000C5;
	Wed, 18 Nov 2026 18:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026193;
	bh=GfbI7K9sTv/JOSIZ9259egDWbjxTjuAOJ8GJLfbiQ+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1dyKqsBoaSxYhBxgd3FmvyocReLgaBtNOMy/Sl3OIpxeWhD2/Lr5unke/DF3KaKx
	 fK+7hY+SJ/dlij7RfFDP4Rk1RFrpla1x9shbopmvlncLwZvZ0g1LWWIOahFinwAc6L
	 Suu9wrgyAFWiFr2QStR4tzz+f95PowilKncyoZN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1349/2151] block: honor IOCB_NOWAIT in the block device buffered read path
Date: Wed, 18 Nov 2026 15:51:24 +0100
Message-ID: <20261118150211.180684433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit d16519a561f4ccc2cebbf52831435833cac1fec6 ]

blkdev_read_iter() takes inode_lock_shared() unconditionally around
filemap_read(). Unlike blkdev_write_iter(), it does not reject
IOCB_NOWAIT for buffered I/O, so a non-blocking read, or the buffered
tail of a short IOCB_NOWAIT direct read, blocks behind set_blocksize()
holding i_rwsem across sync_blockdev().

A preadv2(RWF_NOWAIT) issued while another thread changes the block
size with a dirty page cache blocks for as long as sync_blockdev()
takes, 4 to 6 seconds on a scsi_debug device with delay=5.

Use inode_trylock_shared() for IOCB_NOWAIT and return the bytes the
direct path already read, or -EAGAIN if none, when the lock is
contended, preserving NOWAIT semantics.

Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260802-blkdev-fixes-v1-0-a82fc549fd74%40columbia.edu?part=2
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Link: https://patch.msgid.link/20261009-blkdev-fixes-v6-4-307939c387df@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index de28ac38bcfef..1b3d86b85da9a 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -906,7 +906,15 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	 * Take i_rwsem and invalidate_lock to avoid racing with set_blocksize
 	 * changing i_blkbits/folio order and punching out the pagecache.
 	 */
-	inode_lock_shared(bd_inode);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock_shared(bd_inode)) {
+			if (!ret)
+				ret = -EAGAIN;
+			goto reexpand;
+		}
+	} else {
+		inode_lock_shared(bd_inode);
+	}
 	ret = filemap_read(iocb, to, ret);
 	inode_unlock_shared(bd_inode);
 
-- 
2.53.0



