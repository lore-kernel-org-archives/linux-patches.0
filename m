Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625354;
	b=lCQiIbgeCrWfsxs17FZp9F0peXQncX85EaNuTHRqtVhRVSqC6vqSq9dZMceLa1IIAH5C
	 TiAHcFw7xS2l2HpUC/nkyNsMtaCtogMyGPJGPIV+BwLNJ2we9h7YmUSOKGLr4sAiwZl8r
	 iq2GboA6LyV6utV45azrXIfnDrqcmqVum78AAkuxWjlvFUMcW4dmip4fpeOOsciPwJHnc
	 KayoDTpCOPyvEt6t20v1YxE5CvBttw5Xh70xLAYpjgYVusELgEIfNoApzXGINio9dJ03M
	 lk3rvRhMwuqtCHuJTIy6yqyU7XlEkiCSTrZEYqUnmtwH0bLE8vD9U4RDqT7sDcvol/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b7Bgt9g+W8wVAYabtt3lk+d/YTvk5oT4KXMv7V7w1Xg=;
	b=I/HUOIQBJTxYlR/6/O1OUp6zcUBga0T/6gtBvHhm6F9WO7sciFkYCXXHYnW+eVwpHLTn
	 1/za/46bjYIFyxcFNi+0DZf/uAW1ld8rXyEKBgniYK+NICWqf3mt41OD+B54R+GX6LyDs
	 +kiMqVgKAaYdf2k7yXa1CEKzrFP8OzUbzR6BGpMoEcgRJRlsFBPP8SwNJUzLoq0TEJemU
	 k2ZC8AWaEdnU/cZoqlJ0dRbhcbjeYkt8gMSlLfJS4Zrh4TfLsBXu05YxAqcg8i1tUBbQO
	 upWJXAGRhL8bvVKZZeysWLEcUeq8pC7FaK6OdL8sb9jzDKoGs9DTvmHNFcSwBggQ2ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJIQ2a28;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874C9606A31E;
	Wed, 25 Nov 2026 16:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJIQ2a28
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D670B1F000C6;
	Wed, 25 Nov 2026 16:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625354;
	bh=b7Bgt9g+W8wVAYabtt3lk+d/YTvk5oT4KXMv7V7w1Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJIQ2a28Dnryg4E4+DnZjbki2HOSGzy9LAt+a6tyBQxRYdb+mvToifJ5vTCGWdzBd
	 BHoQeBStdiJMEzKbWC+gIeZVYfSmELmOs3XrS/M0xcg0nUWNVJgMLV71883POvpNIV
	 PaGhfZMOyGpNfVl/gNk6jm4pOF++Q1rY7eqv/tBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 489/816] btrfs: roll back sprout setup after device add failure
Date: Wed, 25 Nov 2026 15:33:57 +0100
Message-ID: <20261125143900.511766016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit f5166f53b60b4d1ee9957c0baccd3b09735001d4 ]

btrfs_init_new_device() calls btrfs_setup_sprout() before creating the
first writable chunks for a seed filesystem. That moves the seed devices
out of fs_info->fs_devices, clears the seeding state and installs a new
fsid for the sprout filesystem.

If a later step fails, the error path removes the new device but leaves
fs_info->fs_devices in the partially initialized sprout state.  The
mounted filesystem can then be left with no open devices after the
failed device add.

Add the inverse of btrfs_setup_sprout() and use it from the error path
so the mounted seed filesystem is restored before the temporary
seed_devices copy is released.

Fixes: 2b82032c34ec ("Btrfs: Seed device support")
Assisted-by: Codex:gpt-5
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
[ Fix a conflict with per-profile available space, revert sprout before
  updating per-profile available space estimation. ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ sashal: Dropped the context line calling btrfs_update_per_profile_avail() after the rollback call, since that helper doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b6ed1190a63d7..0652c630743e8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2715,6 +2715,41 @@ static void btrfs_setup_sprout(struct btrfs_fs_info *fs_info,
 	btrfs_set_super_flags(disk_super, super_flags);
 }
 
+static void btrfs_rollback_sprout(struct btrfs_fs_info *fs_info,
+				  struct btrfs_fs_devices *seed_devices)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_super_block *disk_super = fs_info->super_copy;
+	struct btrfs_device *device;
+	u64 super_flags;
+
+	lockdep_assert_held(&uuid_mutex);
+	lockdep_assert_held(&fs_devices->device_list_mutex);
+
+	list_del_init(&seed_devices->seed_list);
+	list_splice_init_rcu(&seed_devices->devices, &fs_devices->devices, synchronize_rcu);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		device->fs_devices = fs_devices;
+	}
+
+	fs_devices->seeding = true;
+	fs_devices->num_devices = seed_devices->num_devices;
+	fs_devices->open_devices = seed_devices->open_devices;
+	fs_devices->missing_devices = seed_devices->missing_devices;
+	fs_devices->rotating = seed_devices->rotating;
+	fs_devices->latest_dev = seed_devices->latest_dev;
+
+	memcpy(fs_devices->fsid, seed_devices->fsid, BTRFS_FSID_SIZE);
+	memcpy(fs_devices->metadata_uuid, seed_devices->metadata_uuid, BTRFS_FSID_SIZE);
+	memcpy(disk_super->fsid, seed_devices->fsid, BTRFS_FSID_SIZE);
+
+	super_flags = (btrfs_super_flags(disk_super) | BTRFS_SUPER_FLAG_SEEDING);
+	btrfs_set_super_flags(disk_super, super_flags);
+
+	seed_devices->opened = 0;
+	free_fs_devices(seed_devices);
+}
+
 /*
  * Store the expected generation for seed devices in device items.
  */
@@ -3027,6 +3062,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 				    orig_super_total_bytes);
 	btrfs_set_super_num_devices(fs_info->super_copy,
 				    orig_super_num_devices);
+	if (seeding_dev)
+		btrfs_rollback_sprout(fs_info, seed_devices);
 	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 error_trans:
-- 
2.53.0



