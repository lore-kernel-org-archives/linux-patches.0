Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAD1235358;
	Sat, 12 Sep 2026 07:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198318; cv=none; b=TWshDcVHp2WmntRgYYOGTuGVfRY7FGPoDMfdEshAHc+tLILqoaOGgDqQNUpSIUaX4QWatNTJBOaMoFR72UAGT9ZcVL7vCxEVUEIaTV3+z17XUIRW1h2a1WrULhZKKuOofubezAZqrpodI+8IMr7+SaKCySOZLkL/xEmjwTs/SgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198318; c=relaxed/simple;
	bh=Msz4hxvaAT0nOnYs3zJBfbv7UP8MZQ+MCTf7omIR0GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1yUz/iIoMS0HkZFZsQPwRjmLn4SlUffIySvHMrPGk/DfxXqOmlSZzooyrdaAJxIPAXR2EPlKwEsOl3p4iEXp7Y3EjT7KPCgUNFpZvPn5mPDH0s+CxGPQf+ID8pRwUNuDRntwrRVPkHcU2ewqjIDnZ+pgj8XhsBSdVVJsmIPMtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lszLFJrk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lszLFJrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E90B1F000FF;
	Sat, 12 Sep 2026 07:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198316;
	bh=WIRokxwz92mFca3SSeE14lxjrrdpFLys0TaUSSOinDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lszLFJrkpyEvx5GjAEnSkzZMkcCo0Mrs9eBxS8Q+mWVp8teFEIV3/Q/ys6qMQDqQr
	 kLKeVK3OJNJGFyqy98QxlOw4OZcG0qHyTFoOsF8a1el0u4jpUKi94yYystnEBD0qhb
	 EA9eb56zDiivIRHdrdoO8fZ6Us8BGf7C7beSYRpc=
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
Subject: [PATCH 7.2 0354/1815] crash_dump: release keyring reference at the correct time
Date: Sat, 12 Sep 2026 08:35:04 +0200
Message-ID: <20260912065657.220206360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index cb875ddb6ba68..c685497cd470e 100644
--- a/kernel/crash_dump_dm_crypt.c
+++ b/kernel/crash_dump_dm_crypt.c
@@ -81,7 +81,6 @@ static int add_key_to_keyring(struct dm_crypt_key *dm_key,
 		kexec_dprintk("Error when adding key");
 	}
 
-	key_ref_put(keyring_ref);
 	return r;
 }
 
@@ -104,6 +103,7 @@ static int restore_dm_crypt_keys_to_thread_keyring(void)
 	struct dm_crypt_key *key;
 	size_t keys_header_size;
 	key_ref_t keyring_ref;
+	int ret = 0;
 	u64 addr;
 
 	/* find the target keyring (which must be writable) */
@@ -118,7 +118,8 @@ static int restore_dm_crypt_keys_to_thread_keyring(void)
 	dm_crypt_keys_read((char *)&key_count, sizeof(key_count), &addr);
 	if (key_count > KEY_NUM_MAX) {
 		kexec_dprintk("Failed to read the number of dm-crypt keys\n");
-		return -1;
+		ret = -1;
+		goto out;
 	}
 
 	kexec_dprintk("There are %u keys\n", key_count);
@@ -126,8 +127,10 @@ static int restore_dm_crypt_keys_to_thread_keyring(void)
 
 	keys_header_size = get_keys_header_size(key_count);
 	keys_header = kzalloc(keys_header_size, GFP_KERNEL);
-	if (!keys_header)
-		return -ENOMEM;
+	if (!keys_header) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	dm_crypt_keys_read((char *)keys_header, keys_header_size, &addr);
 
@@ -137,7 +140,9 @@ static int restore_dm_crypt_keys_to_thread_keyring(void)
 		add_key_to_keyring(key, keyring_ref);
 	}
 
-	return 0;
+out:
+	key_ref_put(keyring_ref);
+	return ret;
 }
 
 static int read_key_from_user_keyring(struct dm_crypt_key *dm_key)
-- 
2.53.0



