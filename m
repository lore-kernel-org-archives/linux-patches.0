Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207577;
	b=ZsuYSV36sprfL0xY5IirT+vArQQEH8jj9EeWKlxnOybx2g7bivmJEGvVRJq/8K2j1b/G
	 PiJllrCNBaFbpNiXjHzqpwR1zxcfRMlXV3xAbfJ/Ha4bPkWW6BBV2EDNkbOXN1p3xN3/O
	 3p1XmBsGEH5XZl89oYLpIef2sAJv/TRbOF2vtyHlTlayrlMMxQxDinKzwPol4SZgAxUzG
	 NR576VcZaJmkOzkufaY4Z+jFmF/GHIYGYmVrlVDl1t8N8x0jrxn3TN3O821vOH+flkTCv
	 iGRikijFrfbuZiFqhrTM7ouO7wurhoX1YbAMB8Lu3mQqM6tRzrjn7RIoSO/sloW+gsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r+0Izrx5o1xAURUuCj/2YfJcl2T0HkNKLxVKuIV76EU=;
	b=RjywWFtyfTKhSm5HNO3HxdrGLBBAl3fJcVMjjc16cgsr1yV+W7pjG3QfRFw7/UYVYCHC
	 dsFerPnZ0y9MUb1RMloEh1pWXRdyCQOpzCt/3kLR8mW1Xw5g9hxq7HE1Id0xqEeA9ZuiX
	 MR4H8g1mnzWa5Q97ipP+vCK0k6128lAcP5HZAGCvq8FhzxYHZ0SvhqYEXppS1zbMMIpiL
	 1/W+eCZYxThJMRc4SSfdOeKSkD4TRfZStkFPUJRwVD+M+FANC6HeZYAu+jb5tWEUGwIz/
	 vSLmDUyE9waC3t3Ie+glThXScoA+untA7XIyp2if8p23639RzsbXlZrxVEdd72Lq3NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZUa/1oBU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6308606A31A;
	Wed, 28 Oct 2026 17:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZUa/1oBU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3391F01825;
	Wed, 28 Oct 2026 17:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207576;
	bh=r+0Izrx5o1xAURUuCj/2YfJcl2T0HkNKLxVKuIV76EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUa/1oBUsDXIMhXScXQpppQ9qokXFuIQsqxxDp+X/mlwb+SIbs+NJIn2q+NQpjFqw
	 T1npXxt9VfHEJ7IuPsiVGpYzXZeR4M+5oMbhd6lBgxEtCOQC5hBbSjrM19mj84T11I
	 1iBN/klcIpsWC+FNtYfWu10QFHokShtDM0+IcYh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 064/247] unicode: free the map after a grace period
Date: Wed, 28 Oct 2026 17:57:47 +0100
Message-ID: <20261028165948.902827082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -51,6 +51,7 @@ struct unicode_map {
 	unsigned int version;
 	const struct utf8data *ntab[UTF8_NMAX];
 	const struct utf8data_table *tables;
+	struct rcu_head rcu;
 };
 
 int utf8_validate(const struct unicode_map *um, const struct qstr *str);


