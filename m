Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99F121E085;
	Thu, 12 Dec 2024 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018956; cv=none; b=PtlxMuyGLxKehzMVwV6oVkxKOVLfzI8diaJwWZzw5MDeEXxXKLYcn6QoQFHUmUjwDgTPo1iegRC4ROHm+tFhV63v9DQtJ0ooShwS9x3kwUzXix9esmk7h5C8uparXQELY2QssnlC+7pQZBB09+v2FuNHm0R7R7OV51aRXNChTw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018956; c=relaxed/simple;
	bh=91lRAg6rl/fkb+CmArkav4jRd9e6SVwELNKYA1gJ5ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJRTq1PI5vWjA9nTP4hR4ddCqGb9RUX0hpQzYS5YcOhJgRLhtj9GfRHMSIj3SSiTBs59/rkl8bClcR2ncZLhRpsFZHUJuApY+E8FDlbBKO71utUsDAPaZQBT9prC2Ztu5j2BK3vQlkkC3r+R32LO845Kes60h8Usw7uX5tRcwj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ts8o1gUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ts8o1gUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F175FC4CED0;
	Thu, 12 Dec 2024 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018956;
	bh=91lRAg6rl/fkb+CmArkav4jRd9e6SVwELNKYA1gJ5ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ts8o1gUXgctECwRIoWySMqAFWUjGNSLcih85GafeVpJXXVlkzmNGnAboBqqnkRF9Q
	 T1jFKy3FTdSaTxg73yKE7btmbm40gIc5P1eC+gnUwQOxQ/snDwjYs7eBHoQcGQtVft
	 bpZFBQy44i0h87S+fmATPIydpAFBtEcqM6Jsw60Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/772] netfs/fscache: Add a memory barrier for FSCACHE_VOLUME_CREATING
Date: Thu, 12 Dec 2024 15:50:06 +0100
Message-ID: <20241212144352.467942651@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 22f9400a6f3560629478e0a64247b8fcc811a24d ]

In fscache_create_volume(), there is a missing memory barrier between the
bit-clearing operation and the wake-up operation. This may cause a
situation where, after a wake-up, the bit-clearing operation hasn't been
detected yet, leading to an indefinite wait. The triggering process is as
follows:

  [cookie1]                [cookie2]                  [volume_work]
fscache_perform_lookup
  fscache_create_volume
                        fscache_perform_lookup
                          fscache_create_volume
			                        fscache_create_volume_work
                                                  cachefiles_acquire_volume
                                                  clear_and_wake_up_bit
    test_and_set_bit
                            test_and_set_bit
                              goto maybe_wait
      goto no_wait

In the above process, cookie1 and cookie2 has the same volume. When cookie1
enters the -no_wait- process, it will clear the bit and wake up the waiting
process. If a barrier is missing, it may cause cookie2 to remain in the
-wait- process indefinitely.

In commit 3288666c7256 ("fscache: Use clear_and_wake_up_bit() in
fscache_create_volume_work()"), barriers were added to similar operations
in fscache_create_volume_work(), but fscache_create_volume() was missed.

By combining the clear and wake operations into clear_and_wake_up_bit() to
fix this issue.

Fixes: bfa22da3ed65 ("fscache: Provide and use cache methods to lookup/create/free a volume")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://lore.kernel.org/r/20241107110649.3980193-6-wozizhi@huawei.com
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fscache/volume.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/fscache/volume.c b/fs/fscache/volume.c
index cb75c07b5281a..ced14ac78cc1c 100644
--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
@@ -322,8 +322,7 @@ void fscache_create_volume(struct fscache_volume *volume, bool wait)
 	}
 	return;
 no_wait:
-	clear_bit_unlock(FSCACHE_VOLUME_CREATING, &volume->flags);
-	wake_up_bit(&volume->flags, FSCACHE_VOLUME_CREATING);
+	clear_and_wake_up_bit(FSCACHE_VOLUME_CREATING, &volume->flags);
 }
 
 /*
-- 
2.43.0



