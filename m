Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433548635C;
	Tue, 26 Aug 2025 11:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207191; cv=none; b=CpUW8T8lNh3WR947DnQLE/Sm8CR6U/yEoILIgM1bVgzTDutjufyrkbP57vZYWghpskpWZmMb0SLg95R/T1loHLusHW8fbMTp7UJXmQw9x2dFVjo567hzB0JDxDd8J0em3UPSzJEPqH8EhN5lQ/K15C9CD+1Bfz0tv1ca2v/PYbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207191; c=relaxed/simple;
	bh=24R/xeVdUpy5WS5kWs0qk4QLaKnpId53y79CqM0Cb9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pm94jlBzOAM3kAhpHGfYL1SIKZTN4IXNyDTxLElrCSf9WVPcoYh0dvbARKgTvsIzHg5oXgAUGa6LrtS4IhE63wZsiIgSZzt9hzTdVHu/s20i8Uqm2nYdHIuSywaPe0Hx8jkPi+tuN/xpqJqzlYm3gZYGSi3ERbCxVkuNiZqM0es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGUcXaxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGUcXaxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BEBC4CEF1;
	Tue, 26 Aug 2025 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207190;
	bh=24R/xeVdUpy5WS5kWs0qk4QLaKnpId53y79CqM0Cb9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGUcXaxQy/eqV1vPet/RXEbQO+qFG7ysP58bvqkScuKMJ7Mt8fI1N+vM1sZich7Vq
	 vDdfglgeLe5TjOSoCC5Xyn5qfaoW9oWX+IlcqQhHTzPL0NJ4WLJpDb+s9u8rX9vJap
	 g2QGyLIEf5WssVEoCmoWZEb+6h/1jklqUzZieM5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 044/457] btrfs: zoned: fix write time activation failure for metadata block group
Date: Tue, 26 Aug 2025 13:05:28 +0200
Message-ID: <20250826110938.432862357@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 5c4b93f4c8e5c53574c1a48d66a27a2c68b414af upstream.

Since commit 13bb483d32ab ("btrfs: zoned: activate metadata block group on
write time"), we activate a metadata block group at the write time. If the
zone capacity is small enough, we can allocate the entire region before the
first write. Then, we hit the btrfs_zoned_bg_is_full() in
btrfs_zone_activate() and the activation fails.

For a data block group, we activate it at the allocation time and we should
check the fullness condition in the caller side. Add, a WARN to check the
fullness condition.

For a metadata block group, we don't need the fullness check because we
activate it at the write time. Instead, activating it once it is written
should be invalid. Catch that with a WARN too.

Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2169,10 +2169,15 @@ bool btrfs_zone_activate(struct btrfs_bl
 		goto out_unlock;
 	}
 
-	/* No space left */
-	if (btrfs_zoned_bg_is_full(block_group)) {
-		ret = false;
-		goto out_unlock;
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA) {
+		/* The caller should check if the block group is full. */
+		if (WARN_ON_ONCE(btrfs_zoned_bg_is_full(block_group))) {
+			ret = false;
+			goto out_unlock;
+		}
+	} else {
+		/* Since it is already written, it should have been active. */
+		WARN_ON_ONCE(block_group->meta_write_pointer != block_group->start);
 	}
 
 	for (i = 0; i < map->num_stripes; i++) {


