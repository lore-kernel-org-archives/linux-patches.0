Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B369EEA8;
	Sat, 30 May 2026 17:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161114; cv=none; b=fKPLAwg+dUNIIiJPCe35/UHJQdPNtjXKF8cvDvjp6RXlPcE8+hbhNk+sCzJNBewHKDtQmJwrgqKHi3Ig713VgVfHnU+HMjA0XvarjsXjn9jqLPgYMXE4s5MtYu+MLe7+eyS0xS3FL4d7Z0yldm3vaYINkAEcDsjL7SApv2pjpsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161114; c=relaxed/simple;
	bh=5VvyxMzmo14AKYAEul28uvy87Gg1wBXB0sk5t15fSSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO0jUDxCB5xAVkNps/NusBPWlDCgT0tucFo/WoL7xRNHkigGYt3sh522IlO4Fmc/65y16qF8hO8MzdJYYd9DULyJPMJnZISTgjqCpSVymQtZMI1Z7VSfyM00qKc91vWM0CednXs3M+y+8/nUJHU8XnNERZjHHY8PaXvvKFcAJkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNFzCzDL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNFzCzDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FC41F00893;
	Sat, 30 May 2026 17:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161113;
	bh=OcU/vcmEqw3cqRbGtv0rzHcx47R7G/XrXRCiFVC53/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNFzCzDLWCc9rRfDiG4dSSjb+efkHgJO/wcAlrbiso4Dz+11gFoJRTF7cMJyArCeD
	 ND4xkao4tcKfW8sDHQM502DN2v1RH2CPyEC3Z+5rPVnRWDSRcNWRpf3C/fC1odo5f3
	 aFthV9T1H37DzCoW+yhXhBAYtRnFGa1bhOIH/6rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 502/969] dm cache metadata: fix memory leak on metadata abort retry
Date: Sat, 30 May 2026 18:00:26 +0200
Message-ID: <20260530160314.189380227@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 044ca491d4086dc5bf233e9fcb71db52df32f633 ]

When failing to acquire the root_lock in dm_cache_metadata_abort because
the block_manager is read-only, the temporary block_manager created
outside the root_lock is not properly released, causing a memory leak.

Reproduce steps:

This can be reproduced by reloading a new table while the metadata
is read-only. While the second call to dm_cache_metadata_abort is
caused by lack of support for table preload in dm-cache, mentioned
in commit 9b1cc9f251af ("dm cache: share cache-metadata object across
inactive and active DM tables"), it exposes the memory leak in
dm_cache_metadata_abort when the function is called multiple times.
Specifically, dm-cache fails to sync the new cache object's mode during
preresume, creating the reproducer condition.

This issue could also occur through concurrent metadata_operation_failed
calls due to races in cache mode updates, but the table preload scenario
below provides a reliable reproducer.

1. Create a cache device with some faulty trailing metadata blocks

dmsetup create cmeta <<EOF
0 200 linear /dev/sdc 0
200 7992 error
EOF
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 131072 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 1 writethrough smq 0"

2. Suspend and resume the cache to start a new metadata transaction and
   trigger metadata io errors on the next metadata commit.

dmsetup suspend cache
dmsetup resume cache

3. Write to the cache device to update metadata

fio --filename=/dev/mapper/cache --name test --rw=randwrite --bs=4k \
--randrepeat=0 --direct=1 --size 64k

4. Preload the same table

dmsetup reload cache --table "$(dmsetup table cache)"

5. Resume the new table. This triggers the memory leak.

dmsetup suspend cache
dmsetup resume cache

kmemleak logs:

<snip>
unreferenced object 0xffff8880080c2010 (size 16):
  comm "dmsetup", pid 132, jiffies 4294982580
  hex dump (first 16 bytes):
    00 38 b9 07 80 88 ff ff 6a 6b 6b 6b 6b 6b 6b a5 ...
  backtrace (crc 3118f31c):
    kmemleak_alloc+0x28/0x40
    __kmalloc_cache_noprof+0x3d9/0x510
    dm_block_manager_create+0x51/0x140
    dm_cache_metadata_abort+0x85/0x320
    metadata_operation_failed+0x103/0x1e0
    cache_preresume+0xacd/0xe70
    dm_table_resume_targets+0xd3/0x320
    __dm_resume+0x1b/0xf0
    dm_resume+0x127/0x170
<snip>

Fixes: 352b837a5541 ("dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-metadata.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index e921327caa369..9c112ab72cbaa 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1017,6 +1017,12 @@ static bool cmd_write_lock(struct dm_cache_metadata *cmd)
 			return;			\
 	} while(0)
 
+#define WRITE_LOCK_OR_GOTO(cmd, label)		\
+	do {					\
+		if (!cmd_write_lock((cmd)))	\
+			goto label;		\
+	} while (0)
+
 #define WRITE_UNLOCK(cmd) \
 	up_write(&(cmd)->root_lock)
 
@@ -1814,11 +1820,8 @@ int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 CACHE_MAX_CONCURRENT_LOCKS);
 
-	WRITE_LOCK(cmd);
-	if (cmd->fail_io) {
-		WRITE_UNLOCK(cmd);
-		goto out;
-	}
+	/* cmd_write_lock() already checks fail_io with cmd->root_lock held */
+	WRITE_LOCK_OR_GOTO(cmd, out);
 
 	__destroy_persistent_data_objects(cmd, false);
 	old_bm = cmd->bm;
-- 
2.53.0



