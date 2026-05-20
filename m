Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB4F250BEC;
	Wed, 20 May 2026 16:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295041; cv=none; b=CfbleHxh7GeKGwEvZYNg31RgVyf1I9FY8TsSbmHUb+cV+taz+Wn23Oii5MG0UAEeSmwke1NM/uON6U6fjyek2GPkjuO6FUNvFdFp6q9SPS+Wovh95WXbNAJS291RPPRKDlr/MuPKyn8PGsaB806GB8Tqb12B0CD0afx4WaS5HpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295041; c=relaxed/simple;
	bh=zlM02wBg/wafV+2kRI4UqYYjJn/f+qgLUhIuOEkAfqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktsOLjCXDaPdLceZbIjkJSpDsaP12Grw1/ponSzadbti5q/QoiczdAHFOpRfNxUcRFb+8dkZ+Eg6kkVTtV+hyRiwmUEN0jS011aiOPlKa/svcCKBVHSE1iQWuatgVUaaEoxG62cbzC/Zy4iQjKlbvCfEKOgKI7hufIjn9QN/eYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9vc0mgg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9vc0mgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC3A1F000E9;
	Wed, 20 May 2026 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295040;
	bh=6HfQh8cIzKiDzpQ8dJcc5UWYfp/XUNuak/UwP3dO+K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9vc0mggI5xta5ndlkNjrXyWr8XeXuVpDFJKgx1U7FofvUSoxyhMTG1Ny5dFaA89w
	 e22GS7a/1q8X18P1MNNG4Naijl/pv/Y5cdpnMdyHfYTeEOyGGCnnSSgZwezcSUnU2t
	 tld2wvmxegwU17EGvRgQWvDKI/diXzQx2vTCKKWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0269/1146] dm log: fix out-of-bounds write due to region_count overflow
Date: Wed, 20 May 2026 18:08:39 +0200
Message-ID: <20260520162154.310805666@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit c20e36b7631d83e7535877f08af8b0af72c44b1a ]

The local variable region_count in create_log_context() is declared as
unsigned int (32-bit), but dm_sector_div_up() returns sector_t (64-bit).
When a device-mapper target has a sufficiently large ti->len with a small
region_size, the division result can exceed UINT_MAX. The truncated
value is then used to calculate bitset_size, causing clean_bits,
sync_bits, and recovering_bits to be allocated far smaller than needed
for the actual number of regions.

Subsequent log operations (log_set_bit, log_clear_bit, log_test_bit) use
region indices derived from the full untruncated region space, causing
out-of-bounds writes to kernel heap memory allocated by vmalloc.

This can be reproduced by creating a mirror target whose region_count
overflows 32 bits:

  dmsetup create bigzero --table '0 8589934594 zero'
  dmsetup create mymirror --table '0 8589934594 mirror \
    core 2 2 nosync 2 /dev/mapper/bigzero 0 \
    /dev/mapper/bigzero 0'

The status output confirms the truncation (sync_count=1 instead of
4294967297, because 0x100000001 was truncated to 1):

  $ dmsetup status mymirror
  0 8589934594 mirror 2 254:1 254:1 1/4294967297 ...

This leads to a kernel crash in core_in_sync:

  BUG: scheduling while atomic: (udev-worker)/9150/0x00000000
  RIP: 0010:core_in_sync+0x14/0x30 [dm_log]
  CR2: 0000000000000008
  Fixing recursive fault but reboot is needed!

Fix by widening the local region_count to sector_t and adding an
explicit overflow check before the value is assigned to lc->region_count.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-log.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 1aa6a4a7d2323..d316757a328be 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -373,7 +373,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 
 	struct log_c *lc;
 	uint32_t region_size;
-	unsigned int region_count;
+	sector_t region_count;
 	size_t bitset_size, buf_size;
 	int r;
 	char dummy;
@@ -401,6 +401,10 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 	}
 
 	region_count = dm_sector_div_up(ti->len, region_size);
+	if (region_count > UINT_MAX) {
+		DMWARN("region count exceeds limit of %u", UINT_MAX);
+		return -EINVAL;
+	}
 
 	lc = kmalloc_obj(*lc);
 	if (!lc) {
-- 
2.53.0



