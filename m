Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774635;
	b=n/tB28oa4HEOX22q96ZRPAPOeyyamyO2pieSLysPjCIpkUCUa6I/cBvuKP3Y49s1BQJV
	 +p/kt3dhmPuwGHaIXQXU7c3MnafMoixRIlsRkPzEyy6g928k0G/NNI3G1p7XzROJ0AO7N
	 HG/uTCtbYAxCUcsHf9YXyfEKJ8GPRnV28YcO1QcnguhutDtGUN3xKIXe1IdDj3lYd+R6T
	 tg0E8HSNOmGvXxS39CYv7AxQjoP2vkKFYF1vZEjo1ACAwZta9Khg3KXKp+VNlvXZj2PWx
	 5jer9LV08qoJjSJ0bFRHFLaZm4iDmQdaFrWS2ZND0I4ABr+cBqHhusLjKEJBYmWQSeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OHe+zLptj81b5/7pNSOIdU05utLNwp+3d0K0kwang5Q=;
	b=4cw10yjP1V+kK9R7sQWSVIG8qCrTlHUQ7vHfjgnpJo3D1KfD6Cmwe8M8KDVSasINhFeB
	 tpY54tNaMJ2z3vt9nbezDMBxTwagb4iIRxftPtVYcYxZ1om9j16SO7/J0TnLfUNhdue3E
	 Bai99c7KVlvE7ZLCb77lGS0q3l2d0p73iziwZ4hqug+1fnITbY6QjvwOqBZcX225elSDG
	 eLXqhcq9GD9hzpYxnM5JnmU5tKE+i2kCT9AAivDZT0CpV4bqEh9b2qPwh4OzpoH73pepx
	 NCys7hnUH8IiwJUGb0Sme9F9C/dofXU4pt3O4QfuK7iaJpbUkxEZAIkGMPRfuNLb39g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+QAbwgF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708D3606A31A;
	Fri, 23 Oct 2026 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+QAbwgF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B451F01825;
	Fri, 23 Oct 2026 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774635;
	bh=OHe+zLptj81b5/7pNSOIdU05utLNwp+3d0K0kwang5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+QAbwgFROjT/V8VQYW+0WjuvNBpccFobqd2CJJTb022SL8NYkrXRQo3I8FRLJKk7
	 VutQavrydFq2nK8JSbCfkUj18La/Nb9gqZDzhhBfLqfKLLpVY35kUiEf/xrQ2WxizM
	 L6XjDABDFoscwM4/3FsJGe+zb8Gti5ZgRUeLBRVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 107/242] unicode: free the map after a grace period
Date: Fri, 23 Oct 2026 18:39:09 +0200
Message-ID: <20261023163716.312538010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit a96c5299bd7305eb984377681eb3222a57376405 upstream.

generic_ci_d_hash() and generic_ci_d_compare() read sb->s_encoding and
dereference the unicode map while a pathwalk in rcu mode holds nothing
but rcu_read_lock(). The filesystems that use them, ext4, f2fs and
tmpfs, drop the map with utf8_unload() from ->put_super(), which runs
when the last reference to the mount goes away. A lookup that is still
inside such a filesystem at that point reads a freed map.

With a pathwalk held up in utf8_casefold_hash() while the last reference
to a casefolded tmpfs goes away:

  BUG: KASAN: slab-use-after-free in utf8nlookup+0x74c/0x950
  Read of size 8 at addr ff110001030fe658 by task walker/98
  Call Trace:
   <TASK>
   utf8nlookup+0x74c/0x950
   utf8byte+0x160/0x1560
   utf8_casefold_hash+0x167/0x230
   generic_ci_d_hash+0xdd/0x1c0
   link_path_walk+0x11ad/0x1d30
   path_lookupat+0x63/0xb00
   filename_lookup+0x1f1/0x5b0
   vfs_statx+0xd7/0x3b0
  [...]
  Allocated by task 94:
   __kmalloc_cache_noprof+0x249/0x560
   utf8_load+0x4e/0x570
   shmem_parse_opt_casefold.isra.0+0x92/0x270
  [...]
  Freed by task 97:
   kfree+0x1db/0x5b0
   shmem_put_super+0x72/0x170
   generic_shutdown_super+0x14c/0x530
   kill_anon_super+0x3a/0x60
   deactivate_locked_super+0x9c/0xf0
   cleanup_mnt+0x9f/0x130

So far that has been hard to hit. umount(2) waits for a grace period
in namespace_unlock() before it drops the mount, so only a mount whose
last reference goes away elsewhere, like the close of a file or a chdir
out of a lazily unmounted directory, can race a walker. So it is
reachable.

Delay the free until a grace period has passed. The map and the data
table it holds a reference to then outlive any pathwalk that found the
superblock before the mount went away. The reference on the data table
module is dropped from the rcu callback as well. utf8-core is built in
whenever CONFIG_UNICODE is set, so there is no module exit that would
have to wait for the callbacks.

Overlayfs points the s_encoding of an overlay at the map of its first
layer without taking a reference of its own. That stays correct. The
layer is held by the overlay, so its map is dropped only after the
overlay is gone.

Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009-work-fixes-rcu-v1-6-7446d2d335e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/unicode/utf8-core.c  |   21 +++++++++++++++++----
 include/linux/unicode.h |    1 +
 2 files changed, 18 insertions(+), 4 deletions(-)

--- a/fs/unicode/utf8-core.c
+++ b/fs/unicode/utf8-core.c
@@ -3,6 +3,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 #include <linux/parser.h>
 #include <linux/errno.h>
 #include <linux/stringhash.h>
@@ -205,12 +206,24 @@ out_free_um:
 }
 EXPORT_SYMBOL(utf8_load);
 
+static void utf8_unload_rcu(struct rcu_head *head)
+{
+	struct unicode_map *um = container_of(head, struct unicode_map, rcu);
+
+	symbol_put(utf8_data_table);
+	kfree(um);
+}
+
+/*
+ * A pathwalk in rcu mode may still be in ->d_hash() or ->d_compare() of a
+ * filesystem that is being torn down and read the map through its
+ * superblock, so the map and the tables it points to have to outlive the
+ * grace period.
+ */
 void utf8_unload(struct unicode_map *um)
 {
-	if (um) {
-		symbol_put(utf8_data_table);
-		kfree(um);
-	}
+	if (um)
+		call_rcu(&um->rcu, utf8_unload_rcu);
 }
 EXPORT_SYMBOL(utf8_unload);
 
--- a/include/linux/unicode.h
+++ b/include/linux/unicode.h
@@ -53,6 +53,7 @@ struct unicode_map {
 	unsigned int version;
 	const struct utf8data *ntab[UTF8_NMAX];
 	const struct utf8data_table *tables;
+	struct rcu_head rcu;
 };
 
 int utf8_validate(const struct unicode_map *um, const struct qstr *str);


