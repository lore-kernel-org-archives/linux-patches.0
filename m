Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831124;
	b=KTCb9qX1dMH2qQSbs2d5SCc7beKVkk1a8FEDc8dfqISG2le+K+DUG87ymTDRFo+Gkf10
	 w56jUKzgeSAa7gLsQ/tRRKFjlDYJKcCBLdTWJggvcuDGjfiIha5knmd4P7hcWa3nWzK4M
	 8aDo479pk+7FdDDvQZ26wl/Q0JSY0ymaGTByfZ5VgFt9iOGB3h4DfBnLa+HaUbLsXvbla
	 nPmR8+SCCeGV/dE78hJHphoESnrRKGislmscq+6Z3kfxXzGTkv4WGK2+4Tdv/Plzztb6g
	 qrVzQU7FFV26qzOMdlLjUDsMQ8JHhccMJ0llw3ROiqm4/8JDDUBRr5zYpf/IZD4iylQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/ww0ru1yJ7siN6JkkUIjwHGN903AORw6eTAi7qPQEnI=;
	b=BD329Z9NmxJpU1OOnbr7ximyFiP42k6pkCFuRk/442z1VzzPzXk2pCV4kid9KFkAzK4W
	 mxDKolPR3loqZRkGJiPbBlUgHucsCjUPLthzKS75F65ssIehK1eeFqx8nuOmvJJr2F/Ww
	 hlJ7e1xinozccZfFAdX+VfyQDJ7LZpssWys6xvWjgJR1ahriH09YDm8Tmver6ZiRmDlQ3
	 cpdtzWBXtKjGXi8JRIjYhDD/T7Rf2RvpxDWMQP2AmVTtcjdyuxl7tEwldszHNEEkmz+4U
	 VRLV1xsjOPBtvmnbrpT+sIn8GRoCi3lsOId+H3KkxDtxL0fmIAGExIGenJeirA4XmtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nsegK/+C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3DE606B3B8;
	Wed,  4 Nov 2026 22:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nsegK/+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416751F000C1;
	Wed,  4 Nov 2026 22:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831123;
	bh=/ww0ru1yJ7siN6JkkUIjwHGN903AORw6eTAi7qPQEnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsegK/+Ca0K7bQ+eWidQBVokuE8EQtXmqs11o7iXQovcLHER8mgUt1xCMlB/gC+l5
	 hICHGqMXGJpax1litJ7SJu/uhT4njLQkBiITq0zol9aYsBnGyelvg5tiShw0rj9U64
	 w9sRE+nBaZE3qCiSgKzFmhbfL4NvJ7MLRMSiMVN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0517/1005] blk-crypto: fix NULL deref and UAF in __blk_crypto_evict_key()
Date: Wed,  4 Nov 2026 16:04:10 -0500
Message-ID: <20261104211058.413177103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

commit c8c53d669d4e45b3a804013251a34387d7e11bfb upstream.

Sashiko reported a possible NULL pointer dereference, triggered by the
following flow:

  dm-inlinecrypt ctor            # first use of the fallback
   ├─ blk_crypto_init_key()      # succeeds, ctx->key.size != 0
   ├─ blk_crypto_start_using_key()
   │   ├─ hw-wrapped key: -EOPNOTSUPP
   │   │    # profile never allocated (NULL)
   │   └─ raw key: fallback_start_using_mode()
   │      └─ blk_crypto_fallback_init() fails
   │         └─ kfree(profile)   # not NULLed
   ├─ goto bad
   └─ inlinecrypt_dtr()          # evicts whenever key.size is set
      └─ blk_crypto_evict_key()
         └─ blk_crypto_config_supported_natively() = false
            └─ blk_crypto_fallback_evict_key()
               └─ __blk_crypto_evict_key(blk_crypto_fallback_profile)
                  └─ profile->num_slots # BOOM!!!

This issue can be reproduced using the following commands:

  dd if=/dev/zero of=/tmp/backing bs=1M count=64
  LOOP=$(losetup -f --show /tmp/backing)
  SZ=$(blockdev --getsz $LOOP)
  KEY=$(head -c 64 /dev/urandom | od -An -tx1 | tr -d ' \n')
  dmsetup create ic --table "0 $SZ inlinecrypt aes-xts-plain64 \
    $KEY 0 $LOOP 0 1 keytype:hw-wrapped"

And the following oops is triggered:

  ==================================================================
  blk-crypto: loop0: no support for wrapped keys
  Oops: general protection fault, probably for non-canonical address
        0xdffffc000000000b: 0000 [#1] SMP KASAN PTI
  KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
  CPU: 5 UID: 0 PID: 901 Comm: dmsetup 7.3.0-rc3 #1 PREEMPT(lazy)
  RIP: 0010:__blk_crypto_evict_key+0x2e/0x3b0
  Call Trace:
   blk_crypto_evict_key+0x24c/0x320
   inlinecrypt_dtr+0xf6/0x160
   inlinecrypt_ctr+0x2d3/0xbd0
   dm_table_add_target+0x661/0xf40
   table_load+0x1c4/0x490
   ctl_ioctl+0x32f/0x5f0
   dm_ctl_ioctl+0xe/0x20
  ==================================================================

dm-inlinecrypt is the only caller that can evict a key that was never
started, as fscrypt frees such a key without evicting it.

Fix this by returning early from blk_crypto_fallback_evict_key() when
tfms_inited[] is not set for the key's mode.  tfms_inited[] is only set
after blk_crypto_fallback_init() has successfully initialized the
profile, so the crash above is no longer reachable.

The bug has been latent since commit c984ff1423ae ("blk-crypto:
dynamically allocate fallback profile") was merged in v6.5, and only
became actually triggerable when commit e7f57d2c47e2 ("dm-inlinecrypt:
add target for inline block device encryption") was merged in v7.2.

Fixes: c984ff1423ae ("blk-crypto: dynamically allocate fallback profile")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://patch.msgid.link/sashiko-outbox-167341@kernel.org
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Link: https://patch.msgid.link/20261014155131.GB322435@quark
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://patch.msgid.link/20261023081908.3505413-1-libaokun@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-crypto-fallback.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -465,6 +465,12 @@ bool blk_crypto_fallback_bio_prep(struct
 
 int blk_crypto_fallback_evict_key(const struct blk_crypto_key *key)
 {
+	/*
+	 * Pairs with smp_store_release() in
+	 * blk_crypto_fallback_start_using_mode()
+	 */
+	if (!smp_load_acquire(&tfms_inited[key->crypto_cfg.crypto_mode]))
+		return 0;
 	return __blk_crypto_evict_key(blk_crypto_fallback_profile, key);
 }
 


