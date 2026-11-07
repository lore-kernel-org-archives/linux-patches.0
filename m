Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062616;
	b=0OJS+H+5dMWmRLdjC+X6QlJfKJXDJMXPDCA2icFwuc2yoiAENyb3C8BMRMX9dGFEHaOw
	 iBKQ5valghrjo3YRyAyR7deUwDhSXlNA8v533clNPwU3MFWXihT4WgM1ZH07ZMoQUX1Nr
	 7OkBD7TK0F3nvV+uidgXGX/JmsHU8q8bti1oLcQ3NoGtQiqTqVDPI6aWK8e1GojrUcco9
	 f/Z5uYWLjdU7gg5QipbNHPyU3fAQ3SmG9JclxsAORTbb8dyP80g57hmavumvhf/Eh+Bq3
	 S/+CFIyIwZMve7KSoEo9ZCnYShNMO00V6k270l9W5ZJW5x1MrJ3C0Mhsd0vSiW5XTTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+A/lpGU1FsFkrbwHUdMzMRgMrfQ0beBhd8beD+NYGns=;
	b=EDNVZzipnaFp7tKJcawkBBLcb509usJBGSYqGkjkLSGEQt1vZ134AuHv7DptPNmvdAq3
	 WxPXfvRxBoRXHBzWf5wqyGxfOzcXbIhUI7+aDyzCjwekQqvbU8dBtavzG18MkSy2RTCIc
	 2/6qaMysaldfscMucPDBw6AzYM0LkQ/SR1Aw8WlNyDmvm1KlbGJZrLOt1mo6Nzj6XG17L
	 6whpLPtSwDSOjEmWfYpJ/GmxhRiJb+aQxXtdTQ+7MQn/F7zuhPj8qkAMUs6FoCcP1S6Lc
	 l46TikFm3dRoq2ZpcPdC2kH5LJzZHKxgx2f0dpf3ZdM2t/VxTKzyaMUUlkYM7n9b04g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tPyHAMj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C3D606A333;
	Sat,  7 Nov 2026 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tPyHAMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC901F0089F;
	Sat,  7 Nov 2026 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062616;
	bh=+A/lpGU1FsFkrbwHUdMzMRgMrfQ0beBhd8beD+NYGns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tPyHAMjI5XB2eSezE34souw2aXz+5BcW6tNzXt180aSkudNLjNaEc1JP/SRA6Jdm
	 4hguIhi4wlhS1OVqbp0w6fZeXx8VDsMW5zmmj4q32S0djhXYt/mwRDSsUBQ2C0Mqyt
	 PxM/KbPPRbYP2oNks96lmBXg1mtGfmHOCV4z4Cgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1449/1536] fscrypt: Fix missing barrier in fscrypt_find_mode_key()
Date: Sat,  7 Nov 2026 08:57:45 -0500
Message-ID: <20261107135038.534236580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 71586440d0437..40ec9ad2bcaf7 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -203,8 +203,14 @@ fscrypt_find_mode_key(struct fscrypt_master_key *mk, u8 hkdf_context,
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



