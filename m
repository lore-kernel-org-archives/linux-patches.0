Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934DB1E98F3;
	Thu, 30 Jan 2025 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246624; cv=none; b=hiStMc8jd/2BFisjdWZNFY8hCje7U3ZFJzLWorQEq9tQHJqMB0tpBHd4gdXhS0eTtxN7CoxhUm3D1Hop0HYdSLHjfpNgrMHwNal4uyp/QwVmQj4TNsYXELvKkpeLLhuYS5B0jOxXRCq7jKdV95nj0H7gLt07n9FlvU0C9e+zuZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246624; c=relaxed/simple;
	bh=I6t78E8T7Rzt3Bfir9QChyn92Vb3lVfB4ZiqD6kVzi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKBG1iapO9Bbp5uZcScLEXe414K1VIotyIxJ8B+kSbvRE9bZU5wMb/oJ6TL8JfuZ1My3TJQodjJz8V8Kn5p6xhwroO33pvMERQPtRNpTdLj6GrOtb5R4BFk6Ok2LphkswVcJRw50cduuN8RhA558u4fjTVAIDw9mcgGPzKugm00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfsqCIgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfsqCIgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167A2C4CED2;
	Thu, 30 Jan 2025 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246624;
	bh=I6t78E8T7Rzt3Bfir9QChyn92Vb3lVfB4ZiqD6kVzi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfsqCIgp/haF6u7Uu72d6U0leEJGwRA++xYEL5w6wh2ji/OX4Zy8voZZA3Ud5u9mB
	 VcEZPw0A6zS3pZ3gR3vTIDEx+d1+K78kQccQSTVHpRx2YVPPHPfjToMHgWY2myayFo
	 AznwbSSPEFZ3we4UGzaivkdZUYBZ5mv39zZSU5E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/91] dm array: fix cursor index when skipping across block boundaries
Date: Thu, 30 Jan 2025 15:00:23 +0100
Message-ID: <20250130140133.849020544@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 0bb1968da2737ba68fd63857d1af2b301a18d3bf ]

dm_array_cursor_skip() seeks to the target position by loading array
blocks iteratively until the specified number of entries to skip is
reached. When seeking across block boundaries, it uses
dm_array_cursor_next() to step into the next block.
dm_array_cursor_skip() must first move the cursor index to the end
of the current block; otherwise, the cursor position could incorrectly
remain in the same block, causing the actual number of skipped entries
to be much smaller than expected.

This bug affects cache resizing in v2 metadata and could lead to data
loss if the fast device is shrunk during the first-time resume. For
example:

1. create a cache metadata consists of 32768 blocks, with a dirty block
   assigned to the second bitmap block. cache_restore v1.0 is required.

cat <<EOF >> cmeta.xml
<superblock uuid="" block_size="64" nr_cache_blocks="32768" \
policy="smq" hint_width="4">
  <mappings>
    <mapping cache_block="32767" origin_block="0" dirty="true"/>
  </mappings>
</superblock>
EOF
dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
cache_restore -i cmeta.xml -o /dev/mapper/cmeta --metadata-version=2

2. bring up the cache while attempt to discard all the blocks belonging
   to the second bitmap block (block# 32576 to 32767). The last command
   is expected to fail, but it actually succeeds.

dmsetup create cdata --table "0 2084864 linear /dev/sdc 8192"
dmsetup create corig --table "0 65536 linear /dev/sdc 2105344"
dmsetup create cache --table "0 65536 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 64 2 metadata2 writeback smq \
2 migration_threshold 0"

In addition to the reproducer described above, this fix can be
verified using the "array_cursor/skip" tests in dm-unit:
  dm-unit run /pdata/array_cursor/skip/ --kernel-dir <KERNEL_DIR>

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: 9b696229aa7d ("dm persistent data: add cursor skip functions to the cursor APIs")
Reviewed-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/persistent-data/dm-array.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index f97de343a398..4d434d89eadd 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -993,6 +993,7 @@ int dm_array_cursor_skip(struct dm_array_cursor *c, uint32_t count)
 		}
 
 		count -= remaining;
+		c->index += (remaining - 1);
 		r = dm_array_cursor_next(c);
 
 	} while (!r);
-- 
2.39.5



