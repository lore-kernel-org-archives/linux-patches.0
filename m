Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831395;
	b=Rr3gh8Am0+YutzjmKqc7PmNSG+ec/UHnwaEQFFk66p41XKbiI/5HANUpAIbi/WmsBKJb
	 i6AhTt7KfGM27NITaytSmoY7C2ELBfym6eHbak1sYa72ZBfvHW0mUgoL5HUscWuQLFzX1
	 wWrnHOelhxuJ2X93aQCO92G3GWQAUfcGIEV5kUcrXyRjMwH119qBlceLTQWJBzx+wxH8o
	 1l9d+TjqR3v+0bbE0Hyxw9ejnRycfzPtI1Uex0PlTy9ya930jjC1D4LpuppNGAvWEP3wf
	 +JIpN/9aEoeHHjxzq7ct6baPsqqsUn4Ad08LjL+dUjUPi9Gwz+5wIULYUA7a2ndTuLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JbAlyNGGIje/rmGDAdRmII37dae6cA8cDKUSXK6yRhQ=;
	b=y1lICqlHtLywT5u56oACQDg70cRuUEANhkSMDz7WgSs9tm6ZXaBydmYxrOTMe5OmuHiK
	 Obg6FkRlSi8KRa+yc3TNRxSgZvcwUFZaxBKGmSCp889P5AWeQVhPigF0O26TX6+dMMz4c
	 5X9i5b58Oef+OQiA79ENoLNdDDJUPkqVWCJcU97QTaBn5YCtuzNnq2TE2wng6VPYpSsSt
	 6+zsobcER7vds19KjAh2o+zRlGZdLPFIdTuN0uk62dPEahaUBZvS2jNYvEkh6aediLsr1
	 yprpGQsbMjJGd6hcu/tAmWiC7K0yyfs973cRgNI2wX6SApcUimDX49GM9qtAmZaRErg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tfIfuopU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CB0606AB0B;
	Wed,  4 Nov 2026 22:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tfIfuopU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8072F1F00A02;
	Wed,  4 Nov 2026 22:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831395;
	bh=JbAlyNGGIje/rmGDAdRmII37dae6cA8cDKUSXK6yRhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tfIfuopUgukwDyfpDmPbRqX/9eKutPm3J9BmtbGzg51LlrdJqeoDk/Yqk1HuIASPU
	 MwGtvgO0+Kbu1vEig6QSshHPsJL+fgmVaVzDVfHUqI9Zqxj2IHFjGXCWU74xZxHVrS
	 5HBPRPqJqnRGjEp0eb9f9O1AMJMuiv/NUeoT+Wac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.18 0672/1005] landlock: Fix superblock use-after-free in release_inode()
Date: Wed,  4 Nov 2026 16:06:45 -0500
Message-ID: <20261104211102.472882628@linuxfoundation.org>
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

From: Günther Noack <gnoack@google.com>

commit 3e271a27c46fd591d1011c7de5a644a41e2010f1 upstream.

Without this fix, release_inode() (task 1) can race with a umount
operation in hook_sb_delete() (task 2).  The order of operations in
which the race occurs is:

* task 2: hook_sb_delete() arrives at the end of the function, waiting
  for landlock_superblock(sb)->inode_refs to become zero.
* task 1: release_inode(): does atomic_long_dec_and_test(), decrementing
  inode_refs to zero.
* task 2: gets woken up through some other means, sees that inode_refs
  is zero and returns.  The caller is the unmount operation and proceeds
  to release the superblock.
* task 1: Runs wake_up_var(&landlock_superblock(sb)->inode_refs),
  *dereferencing the sb_security on the freed-up superblock*.

Notably, wake_up_var() does not dereference the pointer passed to it,
and only uses it to determine an overapproximated set of tasks to wake
up. So while it's potentially possible for an attacker to provide a
different value for that pointer, this only results in the wrong set of
tasks getting woken up, and in this scenario, no further tasks are
actually waiting.

Nevertheless, KASAN detects it as a slab-use-after-free read on
sb->s_security:

  BUG: KASAN: slab-use-after-free in release_inode+0x196/0x290
  Read of size 8 at addr ffff888103b6c0a8 by task repro/217
   release_inode+0x196/0x290
   landlock_put_object+0x71/0x90
   landlock_free_rules+0x38/0xc0
   landlock_put_ruleset+0x47/0x130
   fop_ruleset_release+0x33/0x40
   __fput+0x305/0x780
  Freed by task 54:
   kfree+0x11c/0x390
   process_scheduled_works+0x766/0xe50
   worker_thread+0x7bc/0xb20

The fix is to determine &landlock_superblock(inode->i_sb)->inode_refs only once
earlier in release_inode(), and later use that precalculated address for the
wake_up_var() call, without having to dereference through the superblock.

Cc: stable@vger.kernel.org
Fixes: cb2c7d1a1776 ("landlock: Support filesystem access-control")
Assisted-by: LLM
Signed-off-by: Günther Noack <gnoack@google.com>
Link: https://patch.msgid.link/20261006105847.2541190-1-gnoack@google.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -57,7 +57,7 @@ static void release_inode(struct landloc
 	__releases(object->lock)
 {
 	struct inode *const inode = object->underobj;
-	struct super_block *sb;
+	atomic_long_t *inode_refs;
 
 	if (!inode) {
 		spin_unlock(&object->lock);
@@ -73,8 +73,8 @@ static void release_inode(struct landloc
 	 * Makes sure that if the filesystem is concurrently unmounted,
 	 * hook_sb_delete() will wait for us to finish iput().
 	 */
-	sb = inode->i_sb;
-	atomic_long_inc(&landlock_superblock(sb)->inode_refs);
+	inode_refs = &landlock_superblock(inode->i_sb)->inode_refs;
+	atomic_long_inc(inode_refs);
 	spin_unlock(&object->lock);
 	/*
 	 * Because object->underobj was not NULL, hook_sb_delete() and
@@ -88,8 +88,8 @@ static void release_inode(struct landloc
 	 */
 
 	iput(inode);
-	if (atomic_long_dec_and_test(&landlock_superblock(sb)->inode_refs))
-		wake_up_var(&landlock_superblock(sb)->inode_refs);
+	if (atomic_long_dec_and_test(inode_refs))
+		wake_up_var(inode_refs);
 }
 
 static const struct landlock_object_underops landlock_fs_underops = {


