Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C96338E8DD;
	Fri,  4 Sep 2026 05:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498895; cv=none; b=oxSzFZaTfUP7zYp8O+PuWyslYEZZArNo4qL5CQnFuAu4Qv+R/Asbj0GCdUhdewCIX0yHtgpQp8/wBz3hkO40iVHe+QniUFp1Jrs4Ci5j810sy9Jrua/r6haLutgJ1HrnrGlLc31t/JBDN8AIvurfAsUGLb+gAZXd5R3GOEATF6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498895; c=relaxed/simple;
	bh=1PpVZKRxrzedfuQbKiSE35UgcOY4BMxYwNo0QLZMWRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZCZXIXwNC6tLM2LNKC06VPbyEqAIv/6Nd6rxpgFxnne8eDjnrKnZbnxarRDtrR7tM1BOd2QowhInec7sxKeaRPPJu6KQvjxTYRQivJg/Vx+iRmV4N2thdBa6IyNtMumLvaQPGYCMkiNLEE5Fv5PcW/a+xaGw4Gp1HPezHg20SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSo2TwP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSo2TwP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EA91F00A3D;
	Fri,  4 Sep 2026 05:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498894;
	bh=IUx44OUnyqkXec3yC5NShwBDqiOVproqzhUk6dZZCrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSo2TwP0YEveOTVrAGF/GITTKgVqxHjBFqGAo3xzB7DP95wVLonQycyFtILKhMWkD
	 ctJ9pTm9mYkAzKMKDFtIA7rxJY+MY3yGlmIZenA1WcwWzpDSz1aP3V5SkT2dEcRpmM
	 nFdkylZIwo3iT1HoNg30I1HPRiPSeG+ayM4jA/ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.2 226/713] btrfs: drop recovered reloc root refs on recovery failure
Date: Fri,  4 Sep 2026 06:53:14 +0200
Message-ID: <20260904045808.887258853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Guanghui Yang <3497809730@qq.com>

commit 6d8ba4572922e336f0b59a80751b018e1e135164 upstream.

During relocation recovery, each fs root gets a reference to its relocation
root. If loading or adding a later root fails, or if the first transaction
commit fails, btrfs_recover_relocation() jumps to out_unset before
merge_reloc_roots() and clean_dirty_subvols().

put_reloc_control() drops the list-owned relocation root references, but it
does not clear fs_root->reloc_root or drop the references owned by those
pointers. Mount cleanup only drops them when BTRFS_FS_ERROR is set, so an
error such as -ENOMEM while processing a later root can leave references
behind.

Keep temporary references to the fs roots associated during recovery. On
failure, clear their reloc_root pointers and drop the corresponding
references. Once the first transaction commit succeeds, drop only the
temporary fs root references and let the normal merge and cleanup paths
handle the relocation roots.

Fault injection on a pending-relocation image confirmed the cleanup gap.
With an injected first-commit failure, 25 fs roots had reloc_root set with
fs_error=0. With this fix, the same failure path drops that count to 0
before mount fails.

Fixes: f44deb7442ed ("btrfs: hold a ref on the root->reloc_root")
CC: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5555,6 +5555,24 @@ static noinline_for_stack int mark_garba
 	return ret;
 }
 
+static void release_recovered_fs_roots(struct list_head *roots, bool drop_reloc_refs)
+{
+	struct btrfs_root *root;
+	struct btrfs_root *next;
+
+	list_for_each_entry_safe(root, next, roots, reloc_dirty_list) {
+		list_del_init(&root->reloc_dirty_list);
+		if (drop_reloc_refs) {
+			struct btrfs_root *reloc_root = root->reloc_root;
+
+			ASSERT(reloc_root);
+			root->reloc_root = NULL;
+			btrfs_put_root(reloc_root);
+		}
+		btrfs_put_root(root);
+	}
+}
+
 /*
  * recover relocation interrupted by system crash.
  *
@@ -5564,6 +5582,7 @@ static noinline_for_stack int mark_garba
 int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 {
 	LIST_HEAD(reloc_roots);
+	LIST_HEAD(recovered_roots);
 	struct btrfs_key key;
 	struct btrfs_root *fs_root;
 	struct btrfs_root *reloc_root;
@@ -5680,7 +5699,7 @@ int btrfs_recover_relocation(struct btrf
 			ret = PTR_ERR(fs_root);
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
 			btrfs_end_transaction(trans);
-			goto out_unset;
+			goto out_drop_reloc_refs;
 		}
 
 		ret = __add_reloc_root(reloc_root, rc);
@@ -5689,15 +5708,17 @@ int btrfs_recover_relocation(struct btrf
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
 			btrfs_put_root(fs_root);
 			btrfs_end_transaction(trans);
-			goto out_unset;
+			goto out_drop_reloc_refs;
 		}
+		ASSERT(list_empty(&fs_root->reloc_dirty_list));
 		fs_root->reloc_root = btrfs_grab_root(reloc_root);
-		btrfs_put_root(fs_root);
+		list_add_tail(&fs_root->reloc_dirty_list, &recovered_roots);
 	}
 
 	ret = btrfs_commit_transaction(trans);
 	if (ret)
-		goto out_unset;
+		goto out_drop_reloc_refs;
+	release_recovered_fs_roots(&recovered_roots, false);
 
 	merge_reloc_roots(rc);
 
@@ -5713,6 +5734,8 @@ out_clean:
 	ret2 = clean_dirty_subvols(rc);
 	if (ret2 < 0 && !ret)
 		ret = ret2;
+out_drop_reloc_refs:
+	release_recovered_fs_roots(&recovered_roots, true);
 out_unset:
 	unset_reloc_control(rc);
 	reloc_chunk_end(fs_info);


