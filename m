Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FD929B78B;
	Sat, 30 May 2026 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164050; cv=none; b=tYSdH+Q7qiYPKy/dgFxny2TzHt7W+x55vKTZ5DER4oahxGGRt7Au8uNaNsjpij+y1ZDBA2guTpTU7gR1R50iJd5OsYhW10BGA8vPp9RLZ3YumEhkViT7J9J59UfMbYMxLYTbH6mMvPwPkMjWAefZTC9T84VIgg2/f3ARjrjCO4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164050; c=relaxed/simple;
	bh=65agZjixqRN5ISSoo/4hjE/gUH1OhmsDnpjVU7X5egU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzDPUFZyOwhkP/ixGBg/C4GZMrAKPBeGhwvRybugmM5bBdjuVRnqLEoLIu4XgFQkdugjoGlkF4RViD55rCeds2YZ/mNpbZjzie7Hd8BNQL3n/IIbgyIxAeHm4inATxMzHBGVSFClYp87XH/jxlHwYsqRlnQWgnPtXv9CUQEyZms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sd7MPBy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sd7MPBy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D521F00893;
	Sat, 30 May 2026 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164049;
	bh=MHNVcHLiP6X3nK9Yzq8a3c+dZgod5uzJcd2pnUr0J4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sd7MPBy4V9gRZIETE3qi+JXqfSms5RnA7u/2ARa5OcDR9JvG65E0q52ye08mbt5Qj
	 quDW108SQm43TQdL7wkH/DXZRu4UDMn1G6syGLGEo01sfD185QWvLW3oots3morNFk
	 tZmLqbzjWSBYxr+ePE2m9hI3AkB2EcLyCaq5Pf/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/776] dm log: fix out-of-bounds write due to region_count overflow
Date: Sat, 30 May 2026 18:02:34 +0200
Message-ID: <20260530160251.789794453@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b40741bedfd43..7258e2fe00e8d 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -368,7 +368,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 
 	struct log_c *lc;
 	uint32_t region_size;
-	unsigned int region_count;
+	sector_t region_count;
 	size_t bitset_size, buf_size;
 	int r;
 	char dummy;
@@ -397,6 +397,10 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
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



