Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F20F2BE7A7;
	Tue, 26 Aug 2025 11:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208987; cv=none; b=CDFG8qEHml/0H3mYweJ1MISUj7mvBCS30fi2OthJkxYMrLKdZ6kPhul7A1a25tdYMk4adIQuqXOLufk8fSAwz+B0jvSVpzq0RzouDP0kkUAdZEmbpgbjXm8MEIoTp+4EYCBEBTH+g5V6kKfv4KgOdQvhZwI/WdIDbFHGEURlksQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208987; c=relaxed/simple;
	bh=NSfQdpHbM/MI0XnaR7PbOuq+agSoLcR8s/lIGPt+Rdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxC0kIiLmU0NMHYDhBVT1TtYOA9dhgfA87VQzoEVrdjmO4UV402ukdSXfofCsIs+z8E/dALWrkrVKoh4v7s1NOfZDHpOzI4aU0indQ/0fxJuhYYyv7dBbFVRnFRMbF2yQqILOgs2wUCnRIG4xF57btqPRyinVnUww6APjokPyzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cd7Swccu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cd7Swccu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCF2C4CEF1;
	Tue, 26 Aug 2025 11:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208987;
	bh=NSfQdpHbM/MI0XnaR7PbOuq+agSoLcR8s/lIGPt+Rdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cd7SwccubiaA6QVG21NK11kyiyRMKL/+yAyfNCm39G236wBYaof7k3tnF6uSOuJnz
	 ac3raVP8nv5jxKYBeT32d4J13wZK+fpXIEEWFW1tnpmD+yX0MREpi2fBVPv12cvuPa
	 O5aea6RF6WF9UcTFHQy24Xednls/eX8QqgIr+4x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/322] alloc_fdtable(): change calling conventions.
Date: Tue, 26 Aug 2025 13:12:17 +0200
Message-ID: <20250826110923.838858168@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 1d3b4bec3ce55e0c46cdce7d0402dbd6b4af3a3d ]

First of all, tell it how many slots do we want, not which slot
is wanted.  It makes one caller (dup_fd()) more straightforward
and doesn't harm another (expand_fdtable()).

Furthermore, make it return ERR_PTR() on failure rather than
returning NULL.  Simplifies the callers.

Simplify the size calculation, while we are at it - note that we
always have slots_wanted greater than BITS_PER_LONG.  What the
rules boil down to is
	* use the smallest power of two large enough to give us
that many slots
	* on 32bit skip 64 and 128 - the minimal capacity we want
there is 256 slots (i.e. 1Kb fd array).
	* on 64bit don't skip anything, the minimal capacity is
128 - and we'll never be asked for 64 or less.  128 slots means
1Kb fd array, again.
	* on 128bit, if that ever happens, don't skip anything -
we'll never be asked for 128 or less, so the fd array allocation
will be at least 2Kb.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 75 +++++++++++++++++++++----------------------------------
 1 file changed, 29 insertions(+), 46 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 4579c3296498..bfc9eb9e7229 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -90,18 +90,11 @@ static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
  * 'unsigned long' in some places, but simply because that is how the Linux
  * kernel bitmaps are defined to work: they are not "bits in an array of bytes",
  * they are very much "bits in an array of unsigned long".
- *
- * The ALIGN(nr, BITS_PER_LONG) here is for clarity: since we just multiplied
- * by that "1024/sizeof(ptr)" before, we already know there are sufficient
- * clear low bits. Clang seems to realize that, gcc ends up being confused.
- *
- * On a 128-bit machine, the ALIGN() would actually matter. In the meantime,
- * let's consider it documentation (and maybe a test-case for gcc to improve
- * its code generation ;)
  */
-static struct fdtable * alloc_fdtable(unsigned int nr)
+static struct fdtable *alloc_fdtable(unsigned int slots_wanted)
 {
 	struct fdtable *fdt;
+	unsigned int nr;
 	void *data;
 
 	/*
@@ -109,22 +102,32 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	 * Allocation steps are keyed to the size of the fdarray, since it
 	 * grows far faster than any of the other dynamic data. We try to fit
 	 * the fdarray into comfortable page-tuned chunks: starting at 1024B
-	 * and growing in powers of two from there on.
+	 * and growing in powers of two from there on.  Since we called only
+	 * with slots_wanted > BITS_PER_LONG (embedded instance in files->fdtab
+	 * already gives BITS_PER_LONG slots), the above boils down to
+	 * 1.  use the smallest power of two large enough to give us that many
+	 * slots.
+	 * 2.  on 32bit skip 64 and 128 - the minimal capacity we want there is
+	 * 256 slots (i.e. 1Kb fd array).
+	 * 3.  on 64bit don't skip anything, 1Kb fd array means 128 slots there
+	 * and we are never going to be asked for 64 or less.
 	 */
-	nr /= (1024 / sizeof(struct file *));
-	nr = roundup_pow_of_two(nr + 1);
-	nr *= (1024 / sizeof(struct file *));
-	nr = ALIGN(nr, BITS_PER_LONG);
+	if (IS_ENABLED(CONFIG_32BIT) && slots_wanted < 256)
+		nr = 256;
+	else
+		nr = roundup_pow_of_two(slots_wanted);
 	/*
 	 * Note that this can drive nr *below* what we had passed if sysctl_nr_open
-	 * had been set lower between the check in expand_files() and here.  Deal
-	 * with that in caller, it's cheaper that way.
+	 * had been set lower between the check in expand_files() and here.
 	 *
 	 * We make sure that nr remains a multiple of BITS_PER_LONG - otherwise
 	 * bitmaps handling below becomes unpleasant, to put it mildly...
 	 */
-	if (unlikely(nr > sysctl_nr_open))
-		nr = ((sysctl_nr_open - 1) | (BITS_PER_LONG - 1)) + 1;
+	if (unlikely(nr > sysctl_nr_open)) {
+		nr = round_down(sysctl_nr_open, BITS_PER_LONG);
+		if (nr < slots_wanted)
+			return ERR_PTR(-EMFILE);
+	}
 
 	/*
 	 * Check if the allocation size would exceed INT_MAX. kvmalloc_array()
@@ -168,7 +171,7 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 out_fdt:
 	kfree(fdt);
 out:
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 /*
@@ -185,7 +188,7 @@ static int expand_fdtable(struct files_struct *files, unsigned int nr)
 	struct fdtable *new_fdt, *cur_fdt;
 
 	spin_unlock(&files->file_lock);
-	new_fdt = alloc_fdtable(nr);
+	new_fdt = alloc_fdtable(nr + 1);
 
 	/* make sure all fd_install() have seen resize_in_progress
 	 * or have finished their rcu_read_lock_sched() section.
@@ -194,16 +197,8 @@ static int expand_fdtable(struct files_struct *files, unsigned int nr)
 		synchronize_rcu();
 
 	spin_lock(&files->file_lock);
-	if (!new_fdt)
-		return -ENOMEM;
-	/*
-	 * extremely unlikely race - sysctl_nr_open decreased between the check in
-	 * caller and alloc_fdtable().  Cheaper to catch it here...
-	 */
-	if (unlikely(new_fdt->max_fds <= nr)) {
-		__free_fdtable(new_fdt);
-		return -EMFILE;
-	}
+	if (IS_ERR(new_fdt))
+		return PTR_ERR(new_fdt);
 	cur_fdt = files_fdtable(files);
 	BUG_ON(nr < cur_fdt->max_fds);
 	copy_fdtable(new_fdt, cur_fdt);
@@ -322,7 +317,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, struct fd_range *punch_ho
 	struct file **old_fds, **new_fds;
 	unsigned int open_files, i;
 	struct fdtable *old_fdt, *new_fdt;
-	int error;
 
 	newf = kmem_cache_alloc(files_cachep, GFP_KERNEL);
 	if (!newf)
@@ -354,17 +348,10 @@ struct files_struct *dup_fd(struct files_struct *oldf, struct fd_range *punch_ho
 		if (new_fdt != &newf->fdtab)
 			__free_fdtable(new_fdt);
 
-		new_fdt = alloc_fdtable(open_files - 1);
-		if (!new_fdt) {
-			error = -ENOMEM;
-			goto out_release;
-		}
-
-		/* beyond sysctl_nr_open; nothing to do */
-		if (unlikely(new_fdt->max_fds < open_files)) {
-			__free_fdtable(new_fdt);
-			error = -EMFILE;
-			goto out_release;
+		new_fdt = alloc_fdtable(open_files);
+		if (IS_ERR(new_fdt)) {
+			kmem_cache_free(files_cachep, newf);
+			return ERR_CAST(new_fdt);
 		}
 
 		/*
@@ -413,10 +400,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, struct fd_range *punch_ho
 	rcu_assign_pointer(newf->fdt, new_fdt);
 
 	return newf;
-
-out_release:
-	kmem_cache_free(files_cachep, newf);
-	return ERR_PTR(error);
 }
 
 static struct fdtable *close_files(struct files_struct * files)
-- 
2.50.1



