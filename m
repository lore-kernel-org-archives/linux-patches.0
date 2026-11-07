Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063648;
	b=xMRL+RLUbjZ3Y7A0ZZnQVc+158tJXSf3k0MOIq836wvI1a10qVwRuFporFLl+0zP25C/
	 /LQjult2KNNniHwV2PN2sBECQi9QKXX9VGzl8Or2v420I1ssYlVJ8PZiqomSdf1OP2fJS
	 ZDVF+nDePvu5v+niZVxfdJ8TLFryKhRs2fWGqZYB/VkcFz+2FEemmyGj5SnbngyfXR4QG
	 65/h4yZL8ABHbEY9sbbouPGEilqVR6N8X6Ht6x2K0C2Yq6W8Kcb61DQxGyJSa7tREPHNF
	 uDksee270hRswkfyBxZjOsLiCq5yWPBuOvCelpzR/8i3JI1798TZi0IYtaE5FkZf/CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Wn7OUruhnlZ4cGBoAbS5KMg0ITM8nGT7eqkpYzDVm/Y=;
	b=n9dtrd77ldu5csqrN2bXlu1TLrXuWnVrF6YjWZlhXja9wilN9M6kd5U/EALWodaqcMrz
	 QzguarQn+0HFBfivGaOLCUYaupfr3dAkXQID2x2e9cOl+QWnapefmYzF2TI7+r9k0NAvz
	 7/HhGyLZzYTjpTx7Snt4P3M1dykpiDkch5SiIkFm8SM+dLz+LoxV5kxipCh8GRQbaraLz
	 5VDPo09kuve6udxfExhww6IcAKsOZ1mI/Lbu6mEMeB3uzvf0S6XZ6pzA+2fyGedWwoBhq
	 pYdL+/IGZqJ8Q3RRrjMo4ju1WO635bsyzyOddskt/6XDxfAelg5R9KvIeIT417s1yIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5xUdkwA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9261660A6F46;
	Sat,  7 Nov 2026 15:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5xUdkwA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4247B1F0089F;
	Sat,  7 Nov 2026 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063648;
	bh=Wn7OUruhnlZ4cGBoAbS5KMg0ITM8nGT7eqkpYzDVm/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5xUdkwAvJusU0cnsn7v9AdGn9rDc4/DkDgmPaAGVCJle2DqQWvhZktZ56IIEZFh8
	 qo0XOg0C8Cd8YPP4LqmHzJZkzJz8TTP2FOEUwAdsX6Skbui7Z2x4hWbCiu5hN5+VVK
	 uXoReY5bGXnx9Sv/0fz3qWUYiqstx4iciEuAc1DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 761/869] fscrypt: Fix missing barrier in fscrypt_find_mode_key()
Date: Sat,  7 Nov 2026 08:57:23 -0500
Message-ID: <20261107134918.515893063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

[ Upstream commit cf66375465b9ca531f5c294f468db1df293c178c ]

fscrypt_find_mode_key() walks an RCU list and hands out a per-mode
key without an acquire:

  setup task
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  setup_per_mode_enc_key()
   ├─ fscrypt_prepare_key()
   │  └─ fscrypt_prepare_inline_crypt_key()
   │     └─ blk_crypto_start_using_key()
   │        └─ blk_crypto_fallback_start_using_mode()
   │           ├─ init profile, keyslots, tfms[]
   │           └─ smp_store_release(tfms_inited[mode])  # init order
   └─ list_add_tail_rcu(&new_node->link, ...)  # release -> finder

  finding task (later submits the I/O itself)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  fscrypt_find_mode_key()
   ├─ list_for_each_entry_rcu(node, ...)
   └─ return &node->key                 # no acquire, chain breaks
  ...
  blk_crypto_fallback_bio_prep()        # WRITE path
   ├─ tfms_inited[mode]                 # addr-dep, reads true
   ├─ blk_crypto_fallback_profile       # no dependency
   ├─ blk_crypto_keyslots               # no dependency
   └─ slotp->tfms[mode]                 # no dependency

RCU publishes the node and the key reachable from it, so
tfms_inited[mode] reads true through the address dependency.  The
independent fallback globals are not covered by it and can be read as
uninitialized.

On a weakly ordered machine, a WRITE bio can crash in
blk_crypto_get_keyslot() or crypto_sync_skcipher_setkey().

Other tasks reach the key through fscrypt_inode_info's
cmpxchg_release()/smp_load_acquire(), which is already ordered after
the list walk; only the finding task's own later I/O was not.

Fix this by upgrading the control dependency to an acquire with
smp_acquire__after_ctrl_dep() once a matching entry has been found.

Fixes: dd015b566d50 ("fscrypt: Fix key setup in edge case with multiple data unit sizes")
Cc: stable@vger.kernel.org
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20261014161153.GC322435@quark
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20261024104350.2257313-1-libaokun@linux.alibaba.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/crypto/keysetup.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index f27997ef9a08c..707552228ed62 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -207,8 +207,14 @@ fscrypt_find_mode_key(struct fscrypt_master_key *mk, u8 hkdf_context,
 		if (node->hkdf_context == hkdf_context &&
 		    node->mode_num == mode_num &&
 		    node->data_unit_bits == ci->ci_data_unit_bits &&
-		    fscrypt_is_key_prepared(&node->key, ci))
+		    fscrypt_is_key_prepared(&node->key, ci)) {
+			/*
+			 * Upgrade the RCU dereference to a full ACQUIRE, so
+			 * that blk-crypto global state is seen as initialized.
+			 */
+			smp_acquire__after_ctrl_dep();
 			return &node->key;
+		}
 	}
 	return NULL;
 }
-- 
2.53.0



