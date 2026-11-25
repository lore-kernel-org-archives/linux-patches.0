Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618880;
	b=pHdryZ/ndQFiad9SXex5gD+q2ymIIZ8pCPn05PFtOSdebOLErItvSqGftOv3zfAZxZ5M
	 AK/VR4yV3jc6yuZAX0AjGA19qceDrkWO4nkaPw3qDmnB6vRizsRu+DITasje0p9K0Bw8+
	 fYmC9Mwl8urYJwwKql0kmChFxzoBAFiR9PbL1mJ2Kmo7a7iq9drfVSh6viEYu2DrFmJ3S
	 QrGKeMb388llEWpkPei7oVakpVPeH8ndfbuuvwTO4xSIXsszM3HQa8TH3QyuJootBt2XK
	 VlWPwPGAjlZmwM2EiiVLHhiZItD6hVwrciTCnxkkzELPwzlnHO5Ah1yY8c1X8HKr6kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3i421EmFC9wdzxkPR2tpufts9tvpyk15VdfpiDI7ldM=;
	b=M3uuLPtQhQiR4Jjj91NW/LnQ3yurG5ryXOQio85g948QQy1V/bJpIGNOxFMNOPm5fWso
	 nQTuYpGjfYlrn1rlmGf6Qwz9kI7mTNrClM2H3JSGhvloXBJfh1SPwRqBN8xjOUE7l0i2x
	 r1qPupl/FtDgcHl9sjrQnR5pYkgJ9hiLNUdJv655bq2x5SDMSzgBgrnBntSoM+TOrOFvc
	 Y+HzWUq3RVNEPP2vmdH/COjRUPfjm3WgBKv3Ea6n83JfelEZDNztMi8XiCKlEvXOIrA2i
	 9NxeSZFXnmYOwhPOWyvBOGgs++/ho+OboXLjMwhe7KZwiwryUzUvlxQ7KkDl7kE98KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9GNszCb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BFA606A31E;
	Wed, 25 Nov 2026 15:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9GNszCb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D769D1F000C6;
	Wed, 25 Nov 2026 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618880;
	bh=3i421EmFC9wdzxkPR2tpufts9tvpyk15VdfpiDI7ldM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9GNszCbc3bt+wE+1cyFxpAxcy9BscWrJ+pJFzZH0gmbMp+hTNqKkKa3MkLsVL8V1
	 0V4JwXZGi6T5p1Rth5E6J5VGh7MjYOuuG8RYWAeq+aBNam7R0Lx866fmli4wlkcr6u
	 iTDTUgFcxx7T3YQa41nlpv9PfjXtt4nelo+Fvec0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0419/1005] btrfs: zoned: fix possible UAF in wait_eb_writebacks()
Date: Wed, 25 Nov 2026 15:29:17 +0100
Message-ID: <20261125143831.567884463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 8ca411c7ad2c02ae65ae208a3f7483d6e0159c4f ]

wait_eb_writebacks() iterates the fs_info->buffer_tree xarray and waits
for the writeback of these extent-buffers. Waiting for writeback needs
to be done without the rcu_read_lock() held (because it can sleep) and
thus the loop drops the rcu_read_lock() before calling into
wait_on_extent_buffer_writeback(). But extent_buffers are freed through
RCU, so if btrfs_release_extent_buffer_rcu() is scheduled while we're
still waiting on the writeback, the extent_buffer will be freed causing
a use-after-free.

Similar to what is done in find_extent_buffer_nolock(), get a reference
to the extent_buffer before calling into
wait_on_extent_buffer_writeback() so a successful writeback does not
free the extent_buffer while we still have a reference to it.

Fixes: 2dd7e7bc0282 ("btrfs: zoned: wait for extent buffer IOs before finishing a zone")
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 232892b8542cf..a63ae60d7ba0d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2517,8 +2517,16 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
 			continue;
 		if (eb->start >= end)
 			break;
+		/*
+		 * Skip if we can't get the refcount for the extent buffer,
+		 * i.e. because it was already written back. Otherwise an eb
+		 * disappering underneath us can cause a use-after-free.
+		 */
+		if (!refcount_inc_not_zero(&eb->refs))
+			continue;
 		rcu_read_unlock();
 		wait_on_extent_buffer_writeback(eb);
+		free_extent_buffer(eb);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.53.0



