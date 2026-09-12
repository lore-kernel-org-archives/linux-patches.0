Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A59019D8BC;
	Sat, 12 Sep 2026 09:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207122; cv=none; b=ShdlMUFBETlWaizKpESTRNPbQik7vgPqaNEpX+ySUr7mKNCW0M3mRtFZp3vHByH95yBiaR0gUMTfeOeq3thEDRUkpGZ+tqX76y9iMD/4LjDCpWj172AHYfq8ZHRzyNGEHRhmDW8q6lfJ1cfj1SnvZOmBsFDFnSKrvWWH8y0t6iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207122; c=relaxed/simple;
	bh=OC2SjxaKt9eyaKSootClkTh5jNd4ERfaoBaALqy5OXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2sIVQVVLCZY7I/CbeH4pcM7Du+DFys2KY/n1je5F2ehoxPxzM+FpVmJT1tNTd+4JpJ003ABmkDSCr1ZKXDj5MKL4pVF2eBHtAGgr384Wa/v45GpIqG1CTa1iWMlZLt4hdMvt7Z07SKSxoFvt8c9iWkGA8rsB0dioSiv7WQCkQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4oouW+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4oouW+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE211F000FF;
	Sat, 12 Sep 2026 09:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207121;
	bh=1pxMbECnG64DXb7AvJtF1vsaX9wjhVGmrMQiKETpjJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4oouW+uBiHrGsCGRxnkIsS+tjjtjLhopMLRkxCwQpBOYtD8rlgU3+MzoOQW9YhI1
	 pb+hkAtr9WggV5RhN5OO33RWkdZVvBftizquJ48FRMDqQPLzT6rgHh5htdV6DFenqG
	 T1lBZ5e3Upx1gy3VEY14yGWkJ2M1bzwWOvqbbynE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Bradley Morgan <include@grrlz.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Coiby Xu <Coiby.Xu@gmail.com>
Subject: [PATCH 6.18 0348/1518] crash_dump: release keyring reference at the correct time
Date: Sat, 12 Sep 2026 08:41:57 +0200
Message-ID: <20260912065631.346224117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit ada2e5a44e99113e08ad9b7b71396c6c572204da ]

restore_dm_crypt_keys_to_thread_keyring() gets a reference to the user
keyring before restoring the saved dm-crypt keys.

The same keyring reference is then passed to add_key_to_keyring() for each
saved key, but add_key_to_keyring() drops that reference on every call.
This is only balanced when exactly one key is restored. With multiple
keys, the keyring reference is dropped too many times and may trigger a
refcount underflow or use-after-free.

When more than five keys are restored, a refcount underflow/use-after-free
warning can be triggered.

The early error paths after lookup_user_key() also return without dropping
the keyring reference.

Keep ownership of the keyring reference in
restore_dm_crypt_keys_to_thread_keyring(), drop it once on all exit paths,
and make add_key_to_keyring() only use the reference without consuming it.

Fixes: 62f17d9df692 ("crash_dump: retrieve dm crypt keys in kdump kernel")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-and-tested-by: Coiby Xu <Coiby.Xu@gmail.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Link: https://patch.msgid.link/20260704112509.3717884-1-lgs201920130244@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/crash_dump_dm_crypt.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/crash_dump_dm_crypt.c b/kernel/crash_dump_dm_crypt.c
index 9501b0704f19f..12e38922ca741 100644
--- a/kernel/crash_dump_dm_crypt.c
+++ b/kernel/crash_dump_dm_crypt.c
@@ -80,7 +80,6 @@ static int add_key_to_keyring(struct dm_crypt_key *dm_key,
 		kexec_dprintk("Error when adding key");
 	}
 
-	key_ref_put(keyring_ref);
 	return r;
 }
 
@@ -103,6 +102,7 @@ static int restore_dm_crypt_keys_to_thread_keyring(void)
 	struct dm_crypt_key *key;
 	size_t keys_header_size;
 	key_ref_t keyring_ref;
+	int ret = 0;
 	u64 addr;
 
 	/* find the target keyring (which must be writable) */
@@ -117,7 +117,8 @@ static int restore_dm_crypt_keys_to_thread_keyring(void)
 	dm_crypt_keys_read((char *)&key_count, sizeof(key_count), &addr);
 	if (key_count < 0 || key_count > KEY_NUM_MAX) {
 		kexec_dprintk("Failed to read the number of dm-crypt keys\n");
-		return -1;
+		ret = -1;
+		goto out;
 	}
 
 	kexec_dprintk("There are %u keys\n", key_count);
@@ -125,8 +126,10 @@ static int restore_dm_crypt_keys_to_thread_keyring(void)
 
 	keys_header_size = get_keys_header_size(key_count);
 	keys_header = kzalloc(keys_header_size, GFP_KERNEL);
-	if (!keys_header)
-		return -ENOMEM;
+	if (!keys_header) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	dm_crypt_keys_read((char *)keys_header, keys_header_size, &addr);
 
@@ -136,7 +139,9 @@ static int restore_dm_crypt_keys_to_thread_keyring(void)
 		add_key_to_keyring(key, keyring_ref);
 	}
 
-	return 0;
+out:
+	key_ref_put(keyring_ref);
+	return ret;
 }
 
 static int read_key_from_user_keying(struct dm_crypt_key *dm_key)
-- 
2.53.0



