Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B6FC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EF7C433D2;
	Mon, 15 May 2023 17:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172042;
	bh=HEYw3oZHss1TYFer8WLrAXSiqgR99bFvofa/vzJDCnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAmvjzyO8QD+k5xdKYh5keVruiOFgbz/NIuKpF161jKvx9+NTxsRGzil7W+3xM/D5
	 mLAdRiqNvVhMSFjGacAVMxJbVK4X+zO7+qFgWguR7ahCL0pYvW+j48N9AbSYWB7UCZ
	 Qy0NsC9F5mGOaUGHTbdLQwepyVN6hKsiUHjrqy/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 025/381] blk-crypto: make blk_crypto_evict_key() return void
Date: Mon, 15 May 2023 18:24:36 +0200
Message-Id: <20230515161737.922936206@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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

commit 70493a63ba04f754f7a7dd53a4fcc82700181490 upstream.

blk_crypto_evict_key() is only called in contexts such as inode eviction
where failure is not an option.  So there is nothing the caller can do
with errors except log them.  (dm-table.c does "use" the error code, but
only to pass on to upper layers, so it doesn't really count.)

Just make blk_crypto_evict_key() return void and log errors itself.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230315183907.53675-2-ebiggers@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-crypto.c         |   22 ++++++++++------------
 include/linux/blk-crypto.h |    4 ++--
 2 files changed, 12 insertions(+), 14 deletions(-)

--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include <linux/keyslot-manager.h>
 #include <linux/module.h>
+#include <linux/ratelimit.h>
 #include <linux/slab.h>
 
 #include "blk-crypto-internal.h"
@@ -393,19 +394,16 @@ int blk_crypto_start_using_key(const str
  * Upper layers (filesystems) must call this function to ensure that a key is
  * evicted from any hardware that it might have been programmed into.  The key
  * must not be in use by any in-flight IO when this function is called.
- *
- * Return: 0 on success or if key is not present in the q's ksm, -err on error.
  */
-int blk_crypto_evict_key(struct request_queue *q,
-			 const struct blk_crypto_key *key)
+void blk_crypto_evict_key(struct request_queue *q,
+			  const struct blk_crypto_key *key)
 {
-	if (blk_ksm_crypto_cfg_supported(q->ksm, &key->crypto_cfg))
-		return blk_ksm_evict_key(q->ksm, key);
+	int err;
 
-	/*
-	 * If the request queue's associated inline encryption hardware didn't
-	 * have support for the key, then the key might have been programmed
-	 * into the fallback keyslot manager, so try to evict from there.
-	 */
-	return blk_crypto_fallback_evict_key(key);
+	if (blk_ksm_crypto_cfg_supported(q->ksm, &key->crypto_cfg))
+		err = blk_ksm_evict_key(q->ksm, key);
+	else
+		err = blk_crypto_fallback_evict_key(key);
+	if (err)
+		pr_warn_ratelimited("error %d evicting key\n", err);
 }
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -97,8 +97,8 @@ int blk_crypto_init_key(struct blk_crypt
 int blk_crypto_start_using_key(const struct blk_crypto_key *key,
 			       struct request_queue *q);
 
-int blk_crypto_evict_key(struct request_queue *q,
-			 const struct blk_crypto_key *key);
+void blk_crypto_evict_key(struct request_queue *q,
+			  const struct blk_crypto_key *key);
 
 bool blk_crypto_config_supported(struct request_queue *q,
 				 const struct blk_crypto_config *cfg);


