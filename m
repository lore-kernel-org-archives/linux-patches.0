Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F54F1549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9141C433D2;
	Mon,  8 May 2023 09:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539592;
	bh=Su3z3FPAG783e7UBfk1wjhLMdJ48fUsYar7QM2XQ4ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uB2bY+KBnKyVQbjG/pfARCdS1Ldn4ZmMNfAnQ11SvMjfmc3kTGTXRRtaIcCHahhJ
	 uGILcHflwHu9zrmeQPWI+ybNpQoKnhw8IvcbVMoXar7a7mQWbSkZQeRvMFDjhwWNA+
	 nGJJGhnoQMGsPJg+aiIATe9reNHwbpZwc/9cioGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 042/611] blk-crypto: add a blk_crypto_config_supported_natively helper
Date: Mon,  8 May 2023 11:38:04 +0200
Message-Id: <20230508094423.210497614@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit 6715c98b6cf003f26b1b2f655393134e9d999a05 upstream.

Add a blk_crypto_config_supported_natively helper that wraps
__blk_crypto_cfg_supported to retrieve the crypto_profile from the
request queue.  With this fscrypt can stop including
blk-crypto-profile.h and rely on the public consumer interface in
blk-crypto.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221114042944.1009870-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-crypto.c         |   21 ++++++++++++---------
 fs/crypto/inline_crypt.c   |    6 ++----
 include/linux/blk-crypto.h |    2 ++
 3 files changed, 16 insertions(+), 13 deletions(-)

--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -267,7 +267,6 @@ bool __blk_crypto_bio_prep(struct bio **
 {
 	struct bio *bio = *bio_ptr;
 	const struct blk_crypto_key *bc_key = bio->bi_crypt_context->bc_key;
-	struct blk_crypto_profile *profile;
 
 	/* Error if bio has no data. */
 	if (WARN_ON_ONCE(!bio_has_data(bio))) {
@@ -284,10 +283,9 @@ bool __blk_crypto_bio_prep(struct bio **
 	 * Success if device supports the encryption context, or if we succeeded
 	 * in falling back to the crypto API.
 	 */
-	profile = bdev_get_queue(bio->bi_bdev)->crypto_profile;
-	if (__blk_crypto_cfg_supported(profile, &bc_key->crypto_cfg))
+	if (blk_crypto_config_supported_natively(bio->bi_bdev,
+						 &bc_key->crypto_cfg))
 		return true;
-
 	if (blk_crypto_fallback_bio_prep(bio_ptr))
 		return true;
 fail:
@@ -352,6 +350,13 @@ int blk_crypto_init_key(struct blk_crypt
 	return 0;
 }
 
+bool blk_crypto_config_supported_natively(struct block_device *bdev,
+					  const struct blk_crypto_config *cfg)
+{
+	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
+					  cfg);
+}
+
 /*
  * Check if bios with @cfg can be en/decrypted by blk-crypto (i.e. either the
  * block_device it's submitted to supports inline crypto, or the
@@ -361,8 +366,7 @@ bool blk_crypto_config_supported(struct
 				 const struct blk_crypto_config *cfg)
 {
 	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-	       __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-					  cfg);
+	       blk_crypto_config_supported_natively(bdev, cfg);
 }
 
 /**
@@ -383,8 +387,7 @@ bool blk_crypto_config_supported(struct
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key)
 {
-	if (__blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-			&key->crypto_cfg))
+	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return 0;
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
@@ -407,7 +410,7 @@ int blk_crypto_evict_key(struct block_de
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (__blk_crypto_cfg_supported(q->crypto_profile, &key->crypto_cfg))
+	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return __blk_crypto_evict_key(q->crypto_profile, key);
 
 	/*
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -12,7 +12,7 @@
  * provides the key and IV to use.
  */
 
-#include <linux/blk-crypto-profile.h>
+#include <linux/blk-crypto.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/sched/mm.h>
@@ -77,10 +77,8 @@ static void fscrypt_log_blk_crypto_impl(
 	unsigned int i;
 
 	for (i = 0; i < num_devs; i++) {
-		struct request_queue *q = bdev_get_queue(devs[i]);
-
 		if (!IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-		    __blk_crypto_cfg_supported(q->crypto_profile, cfg)) {
+		    blk_crypto_config_supported_natively(devs[i], cfg)) {
 			if (!xchg(&mode->logged_blk_crypto_native, 1))
 				pr_info("fscrypt: %s using blk-crypto (native)\n",
 					mode->friendly_name);
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -97,6 +97,8 @@ int blk_crypto_start_using_key(struct bl
 int blk_crypto_evict_key(struct block_device *bdev,
 			 const struct blk_crypto_key *key);
 
+bool blk_crypto_config_supported_natively(struct block_device *bdev,
+					  const struct blk_crypto_config *cfg);
 bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg);
 


