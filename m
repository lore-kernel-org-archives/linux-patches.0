Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2233320F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C88C433C7;
	Fri, 21 Jul 2023 19:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967116;
	bh=UQx8SAWk/fgroSmg50IBhpRzWH+Un8K2E901e2gS/Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpCOyhAvtbFyAV2GGlB0inp1CrBe4dNQ4pmYkvIdNdhnT2xzzPPojtQVmK7+N0guf
	 tApRgUcRgpwCWbmZkWaTWzHQQo6AUn8eWkFRDq1S5BC3AM1oe9etlELaQyZU0A+ncS
	 Y2jyY36gl2joce5Z4cNa4uwCCvjfzbHe+uNizoGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Eric Biggers <ebiggers@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/223] blk-crypto: use dynamic lock class for blk_crypto_profile::lock
Date: Fri, 21 Jul 2023 18:04:35 +0200
Message-ID: <20230721160521.820503228@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 2fb48d88e77f29bf9d278f25bcfe82cf59a0e09b ]

When a device-mapper device is passing through the inline encryption
support of an underlying device, calls to blk_crypto_evict_key() take
the blk_crypto_profile::lock of the device-mapper device, then take the
blk_crypto_profile::lock of the underlying device (nested).  This isn't
a real deadlock, but it causes a lockdep report because there is only
one lock class for all instances of this lock.

Lockdep subclasses don't really work here because the hierarchy of block
devices is dynamic and could have more than 2 levels.

Instead, register a dynamic lock class for each blk_crypto_profile, and
associate that with the lock.

This avoids false-positive lockdep reports like the following:

    ============================================
    WARNING: possible recursive locking detected
    6.4.0-rc5 #2 Not tainted
    --------------------------------------------
    fscryptctl/1421 is trying to acquire lock:
    ffffff80829ca418 (&profile->lock){++++}-{3:3}, at: __blk_crypto_evict_key+0x44/0x1c0

                   but task is already holding lock:
    ffffff8086b68ca8 (&profile->lock){++++}-{3:3}, at: __blk_crypto_evict_key+0xc8/0x1c0

                   other info that might help us debug this:
     Possible unsafe locking scenario:

           CPU0
           ----
      lock(&profile->lock);
      lock(&profile->lock);

                    *** DEADLOCK ***

     May be due to missing lock nesting notation

Fixes: 1b2628397058 ("block: Keyslot Manager for Inline Encryption")
Reported-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230610061139.212085-1-ebiggers@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-crypto-profile.c         | 12 ++++++++++--
 include/linux/blk-crypto-profile.h |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 3290c03c9918d..aa7fc1436893c 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -79,7 +79,14 @@ int blk_crypto_profile_init(struct blk_crypto_profile *profile,
 	unsigned int slot_hashtable_size;
 
 	memset(profile, 0, sizeof(*profile));
-	init_rwsem(&profile->lock);
+
+	/*
+	 * profile->lock of an underlying device can nest inside profile->lock
+	 * of a device-mapper device, so use a dynamic lock class to avoid
+	 * false-positive lockdep reports.
+	 */
+	lockdep_register_key(&profile->lockdep_key);
+	__init_rwsem(&profile->lock, "&profile->lock", &profile->lockdep_key);
 
 	if (num_slots == 0)
 		return 0;
@@ -89,7 +96,7 @@ int blk_crypto_profile_init(struct blk_crypto_profile *profile,
 	profile->slots = kvcalloc(num_slots, sizeof(profile->slots[0]),
 				  GFP_KERNEL);
 	if (!profile->slots)
-		return -ENOMEM;
+		goto err_destroy;
 
 	profile->num_slots = num_slots;
 
@@ -441,6 +448,7 @@ void blk_crypto_profile_destroy(struct blk_crypto_profile *profile)
 {
 	if (!profile)
 		return;
+	lockdep_unregister_key(&profile->lockdep_key);
 	kvfree(profile->slot_hashtable);
 	kvfree_sensitive(profile->slots,
 			 sizeof(profile->slots[0]) * profile->num_slots);
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index e6802b69cdd64..90ab33cb5d0ef 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -111,6 +111,7 @@ struct blk_crypto_profile {
 	 * keyslots while ensuring that they can't be changed concurrently.
 	 */
 	struct rw_semaphore lock;
+	struct lock_class_key lockdep_key;
 
 	/* List of idle slots, with least recently used slot at front */
 	wait_queue_head_t idle_slots_wait_queue;
-- 
2.39.2



