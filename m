Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831295;
	b=ecM7bl2URa3efd+Di7lbii7JxMlrHxWbEfA9GLuaEGJKdb+I+CvTPKt2epVzUjSoXKL2
	 k1hNzivd0P30s3LNaqs4Y7NsDsb+fvRvLxrKYOfplf1FoNhpFB2IWZyfBciTkn6Gwinf8
	 5QK0hC9X2c4lgoUYSwNCcDIiNarjqGhhhpXZ00T6IJQxEu9bmd8fHkxAUM/H8zwThKNNs
	 YwmPgCD1riHYrLcwDVG+y1reEWfcZgB6Gc0RAd4fMYOsDW6/bElKnw5ojF1/mR+nnrvyb
	 RzZQjN/+4spRlE1ro617C1r0m1TX9n5O7hQqC6w2Ues9BGW3DQYvRH5s9xvJhBIU7HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SJkIIF8/aNMSN0/Lpx1ji7P05JjKaY/04bkXeVhdSJs=;
	b=ZDL5EYwpY/1u5Ff1wVz1+zyrwJQbf16qoXCH1dBCSKvpEb0NzRIXujjNa/srIeNzkFIi
	 GtRzMbvxQy/CBJafV10GGrpSkL0L1bIjTsovXnZ2IlyCFeqrB67z5rrsrzJXQeHGJgyeb
	 QJqmLh7LGPMugj846WRqzD862jwFuWpSK72xYfwatzQPJLaGQbR2UUz9yox/jVc29isvH
	 SW8fHFFffC7RQMOE0pNTs479Pp21kFCFDqlB79qv2/tegd2baXeXWCJqTqVwS8e3+UryN
	 hP/TzpRiC6phMD49MCcEnZQRAfYQDfq/NLJIihMPI5OyqhomJZ704bmbgzEFEQMLm2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbtnF33A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A79606AC1C;
	Wed,  4 Nov 2026 22:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbtnF33A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38491F00919;
	Wed,  4 Nov 2026 22:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831295;
	bh=SJkIIF8/aNMSN0/Lpx1ji7P05JjKaY/04bkXeVhdSJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbtnF33Al7ITHCgSQ4RTo/fHOS+0FLw0jj9HrpR9EWWy4RNOAi+NGLbl4Vft2pGS4
	 mLjOXIRlQLO8BRoKDkOKSlljWZqPGs7xxYrKNvo3028lRIbYqP9bg3twnECsu3Y/LW
	 cX0DZtx1kRD1NBOqFI4r9pf2bECk5fDBIGBShYoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0617/1005] ntfs3: free replaced mount options after a grace period
Date: Wed,  4 Nov 2026 16:05:50 -0500
Message-ID: <20261104211101.109948462@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 56c3824de56b5275c02ff6b6aa27ddbacfbb9b25 ]

ntfs_fs_reconfigure() replaces the old mount options with new mount
options in sbi->options. The old mount options land in fs_context and
are freed as soon as remount returns. With a pathwalk held up in
ntfs_nls_to_utf16() between loading sbi->options and dereferencing it
while a remount replaces them:

  BUG: KASAN: slab-use-after-free in ntfs_nls_to_utf16+0x7ae/0x7c0
  Read of size 8 at addr ff110001044fd448 by task walker/98
  Call Trace:
   <TASK>
   ntfs_nls_to_utf16+0x7ae/0x7c0
   ntfs_d_hash+0x22b/0x500
   link_path_walk+0x11ad/0x1d30
   path_lookupat+0x63/0xb00
   filename_lookup+0x1f1/0x5b0
   vfs_statx+0xd7/0x3b0
  [...]
  Allocated by task 95:
   __kmalloc_node_track_caller_noprof+0x2a2/0x730
   kmemdup_noprof+0x25/0x50
   ntfs_fill_super+0x1e5/0x4550
  [...]
  Freed by task 97:
   kfree+0x1db/0x5b0
   put_fs_context+0x13c/0x7d0
   path_mount+0x54a/0x2130
   __x64_sys_mount+0x20c/0x270

That info is needed in rcu lookup in the dentry hash and dentry compary
methods for ntfs3 and causes a UAF today. Delay freeing with an rcu
grace period.

ntfs_nls_to_utf16() reads ->nls and ->ads once under rcu_read_lock() so
the hooks pair with the release in ntfs_fs_reconfigure(). That also
covers callers outside of rcu pathwalk such as ntfs_lookup(). They don't
hold rcu_read_lock() themselves and wouldn't be protected by the grace
period otherwise. Remount refuses to change the iocharset so ->nls stays
valid after rcu_read_unlock().

Fixes: a3a956c78efa ("fs/ntfs3: Add option "nocase"")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009-work-fixes-rcu-v1-8-7446d2d335e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Dropped the ads snapshot and its later use in ntfs_nls_to_utf16() because the ADS option and delimiter code don't exist here, keeping only the RCU snapshot of nls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c     |  9 ++++++++-
 fs/ntfs3/ntfs_fs.h |  2 ++
 fs/ntfs3/super.c   | 16 +++++++++++++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 6d588efaf9fdf..9441a98feb5b9 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -185,11 +185,18 @@ int ntfs_nls_to_utf16(struct ntfs_sb_info *sbi, const u8 *name, u32 name_len,
 {
 	int ret, slen;
 	const u8 *end;
-	struct nls_table *nls = sbi->options->nls;
+	struct ntfs_mount_options *opts;
+	struct nls_table *nls;
 	u16 *uname = uni->name;
 
 	static_assert(sizeof(wchar_t) == sizeof(u16));
 
+	/* ntfs_fs_reconfigure() may replace the options, but not ->nls */
+	rcu_read_lock();
+	opts = READ_ONCE(sbi->options);
+	nls = opts->nls;
+	rcu_read_unlock();
+
 	if (!nls) {
 		/* utf8 -> utf16 */
 		ret = _utf8s_to_utf16s(name, name_len, endian, uname, max_ulen);
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 9cacca3397055..f7ca4ea54e40a 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -90,6 +90,8 @@ enum utf16_endian;
 struct ntfs_mount_options {
 	char *nls_name;
 	struct nls_table *nls;
+	/* ->d_hash() and ->d_compare() read the options in rcu pathwalk */
+	struct rcu_head rcu;
 
 	kuid_t fs_uid;
 	kgid_t fs_gid;
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 74f071ace3ad7..8b37eb0204114 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -249,6 +249,11 @@ static inline void put_mount_options(struct ntfs_mount_options *options)
 	kfree(options);
 }
 
+static void put_mount_options_rcu(struct rcu_head *head)
+{
+	put_mount_options(container_of(head, struct ntfs_mount_options, rcu));
+}
+
 enum Opt {
 	Opt_uid,
 	Opt_gid,
@@ -413,6 +418,7 @@ static int ntfs_fs_reconfigure(struct fs_context *fc)
 	struct super_block *sb = fc->root->d_sb;
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 	struct ntfs_mount_options *new_opts = fc->fs_private;
+	struct ntfs_mount_options *old_opts;
 	int ro_rw;
 
 	/* If ntfs3 is used as legacy ntfs enforce read-only mode. */
@@ -449,7 +455,15 @@ static int ntfs_fs_reconfigure(struct fs_context *fc)
 
 out:
 	sync_filesystem(sb);
-	swap(sbi->options, fc->fs_private);
+	old_opts = sbi->options;
+	/* pairs with the READ_ONCE() in ntfs_nls_to_utf16() */
+	smp_store_release(&sbi->options, new_opts);
+	fc->fs_private = NULL;
+	/*
+	 * ntfs_d_hash() and ntfs_d_compare() of a pathwalk in rcu mode may
+	 * still read the old options through the sbi.
+	 */
+	call_rcu(&old_opts->rcu, put_mount_options_rcu);
 
 	return 0;
 }
-- 
2.53.0



