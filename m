Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211898;
	b=VQHaDgh6KKW1RxCACncYEoOOWDXOAk1xEt/Z+x2sB0VCAc0r8L3IVLHxmHjZ7Dv4js6A
	 6ybeMxslv78beCFRmsmjCHDLXdkgZTeBwbEMB1FXnY9xE93er/HBLIATaRa7RGouPhDfH
	 xCvV1HDTi5GWH8LyTas9SH7KteQIiEWauwcuR/pcPyA48sCUX/esV4KXljYE8ypegn6qU
	 Jqeac0wmJGnu6XsRzKFc1aUrsm/sfUIy6QKlSFqTrvGMblR5N/WTpcCHpwwgo+FqfWzuJ
	 5cCuoctrk+E8PDTz52viDZBMIjSISoXoiekPFmetOjIoeSFUqXQbrUgWlrL/XlmSu/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YR6NyAQF8GeOez4MP03pE7KlWAodWNFoLp59CIMRM98=;
	b=axwRFf/kW8nuRim1C4j2k6sBaylXi5f2tJeWerAzi521tpvlBDVlIZF+jyvn+kGlms/7
	 xrARz5NKtBHRs5n4+cFeUHZ6v7zkHu75vmKEvD6sHi+CHTdWwSAE+VHdpk31pd1p7qAxq
	 NgchKCk9HpCdeB6EWPoS0IjuPSY7L8N4PfW1Kg83FmFORKsDkfKV9Fc76RVYGo3V7wFtW
	 yryuizNsYIdPMJhGg364pF1uNN/JqdEaZ1f5KQQen//y+VmuT+YPoYJ+mTwWu5muASIqX
	 7WNVFf4s3VhQp3r1CMNK+pvPnC80dx7cg/hr1PghiAbtjVnkk6xuIjVL5yCp946O9Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DD/7wnLN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CA5606A31C;
	Wed, 28 Oct 2026 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DD/7wnLN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301611F01825;
	Wed, 28 Oct 2026 18:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211897;
	bh=YR6NyAQF8GeOez4MP03pE7KlWAodWNFoLp59CIMRM98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DD/7wnLNSPrE2KK5yq9j/6sysN3S679K3nExUdleJlgJoeVDZgaqw5yD2MQQslEak
	 W9Xq8MmgC8pk5Fy2cFqe0ckxdpI5JzMwVqqdbNmnp62MzWxvvZKuBGRKGaMRsk7PnP
	 mDE6OKSWbGu8srCbBz+olVK90xNYcX7aEzmJ3Q70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Yangkai <sunyangkai@fygo.io>,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 539/571] dm-integrity: require stable writes for internal hash modes
Date: Wed, 28 Oct 2026 18:01:26 +0100
Message-ID: <20261028170020.824200727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit b2fd92f016e9d692fd3c8c08d0ee014e9212279d ]

dm-integrity direct, bitmap and inline internal-hash modes compute
integrity tags from the pages carried by the write bio.  The lower data
write also uses those pages, so the tag and the data write depend on the
same memory contents staying unchanged while writeback is in flight.

Without stable writes, a buffered writer can modify a writeback folio
after dm-integrity has submitted the data bio and before the lower device
has consumed the data.  After a crash, this can leave data from the later
contents with a tag calculated from the earlier contents, causing
permanent checksum failures on read.

Set BLK_FEAT_STABLE_WRITES for internal-hash D, B and I modes so
filesystems wait for writeback folios to become stable before modifying
them again.  Journal mode is left unchanged because it copies data into
the journal before computing and persisting the tag.

Tested using dm-delay over a virtio-blk test disk, dm-integrity
internal_hash:crc32c and no-journal ext4.  The D and B reproducers both
failed with checksum errors before this change and completed with
READ_RC=0 and zero mismatches after it.

Fixes: 7eada909bfd7 ("dm: add integrity target")
Cc: stable@vger.kernel.org
Reported-by: Sun Yangkai <sunyangkai@fygo.io>
Link: https://github.com/chencheng-fnnas/reproducer/blob/main/dm-integrity-writeback-race.py
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[ sashal: Adapted BLK_FEAT_STABLE_WRITES to QUEUE_FLAG_STABLE_WRITES through a new target flag. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c     | 3 +++
 drivers/md/dm-table.c         | 2 +-
 include/linux/device-mapper.h | 5 +++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index cebffb0b5a1af..7e8b5361c64c6 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3360,6 +3360,9 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
 	}
+
+	if (ic->internal_hash && (ic->mode == 'D' || ic->mode == 'B'))
+		ti->needs_stable_writes = true;
 }
 
 static void calculate_journal_section_size(struct dm_integrity_c *ic)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0f815bcf751f1..b9fe92337b36f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1974,7 +1974,7 @@ static int device_requires_stable_pages(struct dm_target *ti,
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return blk_queue_stable_writes(q);
+	return ti->needs_stable_writes || blk_queue_stable_writes(q);
 }
 
 int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 114553b487ef4..3cd473e166a81 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -356,6 +356,11 @@ struct dm_target {
 	 */
 	bool discards_supported:1;
 
+	/*
+	 * Set if this target requires stable data during writeback.
+	 */
+	bool needs_stable_writes:1;
+
 	/*
 	 * Set if we need to limit the number of in-flight bios when swapping.
 	 */
-- 
2.53.0



