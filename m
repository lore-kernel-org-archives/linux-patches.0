Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE67411A09;
	Thu, 30 Jul 2026 14:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423044; cv=none; b=fIp6zidXwFieVVjxY1EutVmP8t7LsgV3qxlzlORETRo1DvEjUzP9yKRHkmdWF6jiAewqlVef6CaAIARukG2Q3gSQQn9xleBq91cRXTcRzvm/I8TiCBLKUkXRBBsEBZJWhq66u21yf7z9HvR613Bv8n0H/UEBGHIO2+u38m1F6Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423044; c=relaxed/simple;
	bh=qHmbYNaoESmBJ6lPddS8yVOnFV6X4OV6GRwZ2WmaMKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXdXzBtoq5yXiPAM4zvzJykdqosBeHMumhoVPqsoKZ2E+jSJ0U8RIglaG0+nurMbBY6+9Fc3+zFOq/bbqlIDa7+zYQNFvpNN8n/4FPUFohf44Usauz4e5g+KiOuSs1B8EZVj2FdTHY21SCyNXUacQCU2R+h7pNuNxpV9SVJnC7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEQI5l2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEQI5l2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AF91F000E9;
	Thu, 30 Jul 2026 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423043;
	bh=OOdU39ge77KGD21anU7LbbynpsVafsQ6PogI+jt+JHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEQI5l2NuvK9DGJRqi13UtUmPnYYPzi1eOnWQq1tb3VYETZjccIS3SdH48Hz7SLDC
	 IO3DeQrgYDL/CVqTx0odNpV5axnJzp27vHppFgVFOw0RkkThA6DMSSkZEtHLZ11SbM
	 Gj4XH9HmFm0PGB/1lXHteXfG3QmHjyp/Q0pw+v/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.1 644/744] fscrypt: Add missing superblock check in find_or_insert_direct_key()
Date: Thu, 30 Jul 2026 16:15:17 +0200
Message-ID: <20260730141457.959347981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -147,13 +147,19 @@ find_or_insert_direct_key(struct fscrypt
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


