Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCDA3B0598;
	Thu, 30 Jul 2026 15:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424818; cv=none; b=mKM4ywTOIE4U22UKE0fqTxIAz/YN/awOpRpYtDBfUrfRGN12g9PDQS75npxMH7fyU/w8I+hkmyscXpR2IiV2dUO3SeQkznJXt6Ev6HWerX+7DsW2JZwoTKg7CfMZ3z9VfxRUcE1ix5M3XnctQiHSMemX4zjTLLu0goWfWQCY2hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424818; c=relaxed/simple;
	bh=KqertNnBWKOwR2moQluWVFszRYzGaS0Btes9xYgCuVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQBV4RvrquFnvTQ+TMNKnjjB+fbixF0YtT07L2CQjCBZECRr3XrhR+G6rLM9TEBeCfbPW/JevX9uhHIISAD0zbMm5lG85oK4MUBJ+N7ZHghGWztdMzRFjopmGVEOAkzTZH6dxLOig/JJFKny+FE5iES1apjKwMbGz5sIe28mGv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfn+ed6n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfn+ed6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F5A1F000E9;
	Thu, 30 Jul 2026 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424817;
	bh=Oc/B8cC3u9zXHTS7+MzcBhqG+vGiBXar6+pqjVOCV80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfn+ed6n9OgltSHqhRglHvkcnjJEjE2HQvzVYjNPJRW/JqKe5qyr9bt1sysW6aqDV
	 rM9Pc8ETY+60Lb5j0WPKvqK0oBcDSXp4XwIIfjD8g6rAUfjG4lsnYnTjzw7TWUwx5R
	 Sc09hyETKCbzTu8UPpjPYIx9RbBx7EVqq7DnneGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 527/675] fscrypt: Add missing superblock check in find_or_insert_direct_key()
Date: Thu, 30 Jul 2026 16:14:17 +0200
Message-ID: <20260730141456.345737387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit b5fa40226e71c17847b9ff2816c6ca4133d0d994 upstream.

The legacy 'fscrypt_direct_keys' table caches master keys that are used
by v1 encryption policies that have FSCRYPT_POLICY_FLAG_DIRECT_KEY.
It's just a global table for all filesystems (since the keys can be
provided by the legacy process-subscribed keyrings mechanism, which
makes it difficult to reuse super_block::s_master_keys).

The entries in it ('struct fscrypt_direct_key') do contain a super_block
pointer, though, for passing to fscrypt_destroy_inline_crypt_key() when
the last inode that references the key is evicted.

However, when finding the fscrypt_direct_key for an inode, we weren't
actually comparing the super_block pointer.  As a result, inodes with
different super_blocks could point to the same fscrypt_direct_key.  That
could extend the lifetime of a fscrypt_direct_key beyond the
super_block it points to, causing a use-after-free later.

Fix this by creating distinct fscrypt_direct_key structs for distinct
super_block structs.

Note that this problem doesn't exist in the v2 policy equivalent
("per-mode keys"), since the data structures there are per super_block.

Fixes: 22e9947a4b2b ("fscrypt: stop holding extra request_queue references")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260717044303.425265-1-ebiggers%40kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260719033120.122120-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/crypto/keysetup_v1.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -190,13 +190,19 @@ find_or_insert_direct_key(struct fscrypt
 		if (memcmp(ci->ci_policy.v1.master_key_descriptor,
 			   dk->dk_descriptor, FSCRYPT_KEY_DESCRIPTOR_SIZE) != 0)
 			continue;
+		/* The sb is used at eviction time, so it must be the same. */
+		if (ci->ci_inode->i_sb != dk->dk_sb)
+			continue;
 		if (ci->ci_mode != dk->dk_mode)
 			continue;
 		if (!fscrypt_is_key_prepared(&dk->dk_key, ci))
 			continue;
 		if (crypto_memneq(raw_key, dk->dk_raw, ci->ci_mode->keysize))
 			continue;
-		/* using existing tfm with same (descriptor, mode, raw_key) */
+		/*
+		 * Use an existing prepared key with the same (descriptor, sb,
+		 * mode, inlinecrypt, raw_key) combination.
+		 */
 		refcount_inc(&dk->dk_refcount);
 		spin_unlock(&fscrypt_direct_keys_lock);
 		free_direct_key(to_insert);


