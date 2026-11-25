Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623457;
	b=NedgFkoeuJyKPyZdeKs8J9c0NRI3hDx5UrAHKvdbDdfMVvlihSvJG7Eiu0BRAZPru2Ac
	 s+fuD4E+lIoGsvxRR4sq+3iqQB5fENiRb/9k5FcVwBabquPRXaHNJbStdMgpbsaHpa+Vt
	 WROxWwKbE5pysGx1t1Rd00o1Mwik9azdT9DFQChtlYBIO0PeI/CkkJIZqqCEb7oJSfPda
	 WkeprPgGsBzBR0u7YM2+WS4exKMSqOd3V6ufyhlrwIjThF6+NEnGTNkKjWzIfJWEprgTm
	 M6Jd58f6woaAkMoeaVajOD1c4EZt7Evi5u8QaByG+eIzmVT6k6j37B22zNjkTb6kvVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bgDtdGSVFVurlVpx6//VlyuGPoxgoSv5N4+8xaFDC0U=;
	b=dDxd97l+ZXLXDf9TZrYP/kNHOKp1ipYlKTZA2QSTO9f5pl5SQcTeFn0nnZDyRovXZbdv
	 QVJnquclm+t+zi0qJ47ATFuJ8FwWx5N9ouLvibKAmZRfbmjvDW6gflVDG3+s8XlNrXVH+
	 /UJBp74J/uJ0dHJQH2vxeLu32IkPe77ymALdewEAmY4OuNc2tG6o/iuxjd3ipA6Z8d0xR
	 uv/OXlnJbyUlnHWJXwAamygw6DRzt//S8KsWGY47ozCqyEMostJKjTm06Z6YuOpJs1Ux5
	 XZs21otLsSB5Ct7REGX8xvtoHEIcbA7kEDxItRnBpl1v1dQs2KHgLAkyWpAqjAtGMGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6DJyCtM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7914606A321;
	Wed, 25 Nov 2026 16:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6DJyCtM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BAB1F000C0;
	Wed, 25 Nov 2026 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623456;
	bh=bgDtdGSVFVurlVpx6//VlyuGPoxgoSv5N4+8xaFDC0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6DJyCtMft7rtUeVW/15XNpZVf9uHfwFJ0hnDvHeOcc30XAXYMSH16prNobwqSgYz
	 SeKfpYDCG7Mnqn+VFbb8uf9t+wcHVrO7tGNrUy06C6/z/rR0qA5iwPGu56o4HCVNYL
	 69JzlDlfXFMnfNweb0FET0z6+4nUQnAqjrGBGzAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com,
	wuyuehong <wuyuehong@cmss.chinamobile.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 865/990] dm snapshot: fix discard_granularity unit in snapshot_io_hints
Date: Wed, 25 Nov 2026 15:37:12 +0100
Message-ID: <20261125143842.286687974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: wuyuehong <wuyuehong@cmss.chinamobile.com>

commit d7216d7be2bbfdf3312695b6e41a4fc7c5e22902 upstream.

snapshot_io_hints() copies the snapshot store's chunk_size, which is
in 512-byte sectors, into queue_limits.discard_granularity, which, like
all other members of struct queue_limits, is in bytes.

For snapshots with a chunk size smaller than 512 sectors, e.g. the
16 KiB (32-sector) chunks created by the syzkaller reproducer, the
resulting granularity is smaller than a single sector.  When
dm_calculate_queue_limits() then stacks the target limits into the
table limits:

	blk_stack_limits(limits, &ti_limits, 0)

queue_limit_discard_alignment() truncates that granularity to zero
sectors and sector_div() divides by zero:

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:queue_limit_discard_alignment block/blk-settings.c:645 [inline]
  RIP: 0010:blk_stack_limits+0x1105/0x2d00 block/blk-settings.c:916
  Call Trace:
   dm_calculate_queue_limits+0x70c/0x1510 drivers/md/dm-table.c:1823
   dm_setup_md_queue+0x199/0x4f0 drivers/md/dm.c:2618
   table_load+0x4fd/0x8a0 drivers/md/dm-ioctl.c:1661

The divide fault itself only became reachable when commit e924da7d6622
("block: Drop granularity check in queue_limit_discard_alignment()")
removed the check for a sub-sector granularity in v6.13.  Kernels
before that returned a zero discard alignment instead of faulting, but
they still advertised a granularity 512 times too small.

Use the same chunk_size << SECTOR_SHIFT conversion that
io_overlaps_chunk() already applies to turn chunk_size into bytes.

Fixes: 2e6023850e17 ("dm snapshot: add optional discard support features")
Reported-by: syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1288484b13bf6af3620d
Cc: stable@vger.kernel.org
Signed-off-by: wuyuehong <wuyuehong@cmss.chinamobile.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-snap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2420,7 +2420,7 @@ static void snapshot_io_hints(struct dm_
 			snap = snap_src;
 
 		/* All discards are split on chunk_size boundary */
-		limits->discard_granularity = snap->store->chunk_size;
+		limits->discard_granularity = snap->store->chunk_size << SECTOR_SHIFT;
 		limits->max_hw_discard_sectors = snap->store->chunk_size;
 
 		up_read(&_origins_lock);


