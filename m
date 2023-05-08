Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848A71549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC385C433EF;
	Mon,  8 May 2023 09:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539595;
	bh=NP4/iYd+Ib/sSl6WsMDfwbQDIlmEk0Qpoo0tbXiIBuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqKplskllf3LlDn6Z48haQm0kLaE89gaQP1qR+88+4qz9LJ1hHpiTNLa/R4DEkxUI
	 9e+mhbyNnoOzqVL8ja0rfKnHkr43F/6DTUM6AJatGr4pK5Ll9Gd6VcY3jf/Vu12y59
	 QBUy74PXbQaeqeRTp8SQLy6R6DC4pKDsJHnNx1jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 043/611] blk-crypto: move internal only declarations to blk-crypto-internal.h
Date: Mon,  8 May 2023 11:38:05 +0200
Message-Id: <20230508094423.247439033@linuxfoundation.org>
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

commit 3569788c08235c6f3e9e6ca724b2df44787ff487 upstream.

 blk_crypto_get_keyslot, blk_crypto_put_keyslot, __blk_crypto_evict_key
and __blk_crypto_cfg_supported are only used internally by the
blk-crypto code, so move the out of blk-crypto-profile.h, which is
included by drivers that supply blk-crypto functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221114042944.1009870-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-crypto-internal.h        |   12 ++++++++++++
 include/linux/blk-crypto-profile.h |   12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -65,6 +65,18 @@ static inline bool blk_crypto_rq_is_encr
 	return rq->crypt_ctx;
 }
 
+blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
+				    const struct blk_crypto_key *key,
+				    struct blk_crypto_keyslot **slot_ptr);
+
+void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
+
+int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
+			   const struct blk_crypto_key *key);
+
+bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
+				const struct blk_crypto_config *cfg);
+
 #else /* CONFIG_BLK_INLINE_ENCRYPTION */
 
 static inline int blk_crypto_sysfs_register(struct request_queue *q)
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -138,18 +138,6 @@ int devm_blk_crypto_profile_init(struct
 
 unsigned int blk_crypto_keyslot_index(struct blk_crypto_keyslot *slot);
 
-blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
-				    const struct blk_crypto_key *key,
-				    struct blk_crypto_keyslot **slot_ptr);
-
-void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
-
-bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
-				const struct blk_crypto_config *cfg);
-
-int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
-			   const struct blk_crypto_key *key);
-
 void blk_crypto_reprogram_all_keys(struct blk_crypto_profile *profile);
 
 void blk_crypto_profile_destroy(struct blk_crypto_profile *profile);


