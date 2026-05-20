Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BA43A4526;
	Wed, 20 May 2026 17:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297913; cv=none; b=gqzS4hfFwXvmKy8hlwP+L3ldTuMAPDuqxF0jdQkdSaFNkSKfAVDd/AiKlAS2fZ6T+2YzwcSf42Gbvd+b2D0rvq+p2Jqs2vNUaV5syd7sfNwJEZJ1PGNvKM0LLK7zInpuoZ9+CvgXC/brbcxPcIL9QlvR49PEoWxgC2LBqi8yylA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297913; c=relaxed/simple;
	bh=9J5jY5j/DGKzhxJ7GlTqJxq3/Q9dH1qqqcxogpGSDu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkVxo5Mpf6Lj1/95W40EfH77r0vRu0B0FSEd3ldOk5cUyt8OZ9o/HYs3+1e8v9Mk+c197oQUK4cZL8+J8ldl2JZdAY+KwCRZot4SLjb1y4/FARl4zB9Khbx2WF07+u93bvRPHJwkZCcpFAQ+3QZ6rqrcTBTh1dl6/G/aq82l+hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bj0Rkzud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bj0Rkzud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC0A1F000E9;
	Wed, 20 May 2026 17:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297912;
	bh=SjxXPFsZs5Cns8nU2fRPJ8TCA/Nb2XRsi4ZGE/Vhpww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bj0Rkzud9y0/PNUiKzg0laWRhRFHryEN8jelS9tLF/W2wevKTGvElNJDQ0jQH9VrC
	 j0QTnBORLd9CoU0OhvfdWyZfVmc5RzpxbIQBcezJPvuj6+4VMSSHSfJA8hANtM6eJh
	 5f6/5UA7Bb6H1YKUQLjp4z13QDxnoqybPIPY7vGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/957] dm log: fix out-of-bounds write due to region_count overflow
Date: Wed, 20 May 2026 18:11:33 +0200
Message-ID: <20260520162139.094176165@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bced5a783ee33..4a1369b8f44a0 100644
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
 
 	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
 	if (!lc) {
-- 
2.53.0



