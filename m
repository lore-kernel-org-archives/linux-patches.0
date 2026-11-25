Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621888;
	b=yFr0xUQ4LpYTKE2wZ1JW9Ieqg3EDEYKeJPRC9B8P31R2y5TM0caHyOU6NI+ewZnz81OH
	 Urup+PsOCguhgAkPY6BDwaeP8QfMykcB7Kc6w1Lt3W1t+zAKhz5xxvYYOWDsWxEGhM0eJ
	 yxfQcyKQfCN0xBMGN52WB29UYVxxyS8CeD3cZcLi1FsZn1fJlfZ7s9V8D+AoCcAc3eN4m
	 qHC74rr57Mnp2gvzMioKa29smjXjgTFRleCLywsYv850yHCMLKxLFysBBKvLBC3l2dB3o
	 jNN/1/yriQN+uLWZ/NPZ5NLnBHLLNItNmW8wW6m2GvftJ/GjQ6q6JkVLzcadxj5HKhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4WjiEW5Im/HuvyOhuyATvv4bW+lyQof4ThlX6uhnvqw=;
	b=jaNTOHcTmbm+B+suZpMg6C+m+XJwaU4J9oMMKCLV/j6i4x1mMsfhSMYTfwnvZUhMsCj1
	 WbSAOtaNhhaaS5HV4nZ2HrKNgU4Dwi5p/xehz8jX0j6eS/IsDetMro02EQU/W3Z5EsE2E
	 jtiAoznPQkfvH/HR8/Nharfk8LJJjnuK9+KJAwUyBsjnftNycu2aNQa+xD6aXgjY1H3vL
	 Tm/MbTpXWocRwYcwJpmvG42N3WzH9QnTMyERrAKWY4nYwMgyB0h3DNTBVF1OqmURoWvAX
	 RJEMwyjKfhS2MNY/lcRQxdcseIAmPTwR3QbHQc2EBz2nGEqr8AFLQ7Yc/VnO50Sd/zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPmp256R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA18606A333;
	Wed, 25 Nov 2026 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPmp256R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730BB1F000EE;
	Wed, 25 Nov 2026 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621888;
	bh=4WjiEW5Im/HuvyOhuyATvv4bW+lyQof4ThlX6uhnvqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPmp256RPDYCHW5lQ60VYsqkT5D6VBD29BE99qqKGdWLcB0A/LPQm/NB/IgRS/Zy4
	 gTBr2sqMTRIJZpJkPOkxWfUlVg0mcCOfp7cmYccs5BE9xS7qSENao0OR6IfdsRe8Pr
	 mHy1ivN2Xs6NyAblwQBh6yx91l3o+o2W+kH1W85k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 366/990] btrfs: zoned: fix possible UAF in wait_eb_writebacks()
Date: Wed, 25 Nov 2026 15:28:53 +0100
Message-ID: <20261125143830.665005177@linuxfoundation.org>
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
index 0ff693fea47c3..fe35bd531f70f 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2482,8 +2482,16 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
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



