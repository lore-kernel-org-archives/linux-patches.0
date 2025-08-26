Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B4A34F463;
	Tue, 26 Aug 2025 11:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207711; cv=none; b=XF2DafLuVBdsj6oPzpik5A7xbGVOwPdB3zwNKu2pGVUFXJr/Jmb++e+FG5CqOo7NRTU+7TLYp3id5Ji1rk0sQfaP1dODArPnoQSEMAi8OmTyk1toUsfovM/+dPJnhiZmoU/sn5iFFq2VfGar1fEX31xeRuBeIxSjRM1Lqc52t/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207711; c=relaxed/simple;
	bh=BabndgU++ah8ifY/Rwpbp31OtBe9raq8COAGmOBVLEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvzsc/aYynGxfQW6qLfJfIYR3cm/+9fwEaEhGjtxmwyfbaRqOEmiMN1mxkJ8jArlREUZLqHJ1OWEF+9vHjerOYPJgeM6QXReYpbGrPeq3pNUIXHVida5nAUfhCuji9Df++743WnFXEhW6JCMY7o3r9Ba5SyDOksjQaoADuhIguw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03n+dkTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03n+dkTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F153BC4CEF1;
	Tue, 26 Aug 2025 11:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207711;
	bh=BabndgU++ah8ifY/Rwpbp31OtBe9raq8COAGmOBVLEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03n+dkTyRXuw29LcOIUvB6B+RF2AOo+n+uqQmepNvKJESIpAbT/1K0UiSm0fLGmDV
	 svmNY/r/dc11/RvdQYbpzWvYdIwMopN9bivmWJDifIrx3k/URMqEb+8zQFfw6P5Old
	 61UNoYbqSFARVtdIoAcGU5/1cXNEu26VQ6RJysa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Charalampos Mitrodimas <charmitro@posteo.net>
Subject: [PATCH 6.16 281/457] debugfs: fix mount options not being applied
Date: Tue, 26 Aug 2025 13:09:25 +0200
Message-ID: <20250826110944.324005009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charalampos Mitrodimas <charmitro@posteo.net>

commit ba6cc29351b1fa0cb9adce91b88b9f3c3cbe9c46 upstream.

Mount options (uid, gid, mode) are silently ignored when debugfs is
mounted. This is a regression introduced during the conversion to the
new mount API.

When the mount API conversion was done, the parsed options were never
applied to the superblock when it was reused. As a result, the mount
options were ignored when debugfs was mounted.

Fix this by following the same pattern as the tracefs fix in commit
e4d32142d1de ("tracing: Fix tracefs mount options"). Call
debugfs_reconfigure() in debugfs_get_tree() to apply the mount options
to the superblock after it has been created or reused.

As an example, with the bug the "mode" mount option is ignored:

  $ mount -o mode=0666 -t debugfs debugfs /tmp/debugfs_test
  $ mount | grep debugfs_test
  debugfs on /tmp/debugfs_test type debugfs (rw,relatime)
  $ ls -ld /tmp/debugfs_test
  drwx------ 25 root root 0 Aug  4 14:16 /tmp/debugfs_test

With the fix applied, it works as expected:

  $ mount -o mode=0666 -t debugfs debugfs /tmp/debugfs_test
  $ mount | grep debugfs_test
  debugfs on /tmp/debugfs_test type debugfs (rw,relatime,mode=666)
  $ ls -ld /tmp/debugfs_test
  drw-rw-rw- 37 root root 0 Aug  2 17:28 /tmp/debugfs_test

Fixes: a20971c18752 ("vfs: Convert debugfs to use the new mount API")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220406
Cc: stable <stable@kernel.org>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
Link: https://lore.kernel.org/r/20250816-debugfs-mount-opts-v3-1-d271dad57b5b@posteo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -183,6 +183,9 @@ static int debugfs_reconfigure(struct fs
 	struct debugfs_fs_info *sb_opts = sb->s_fs_info;
 	struct debugfs_fs_info *new_opts = fc->s_fs_info;
 
+	if (!new_opts)
+		return 0;
+
 	sync_filesystem(sb);
 
 	/* structure copy of new mount options to sb */
@@ -282,10 +285,16 @@ static int debugfs_fill_super(struct sup
 
 static int debugfs_get_tree(struct fs_context *fc)
 {
+	int err;
+
 	if (!(debugfs_allow & DEBUGFS_ALLOW_API))
 		return -EPERM;
 
-	return get_tree_single(fc, debugfs_fill_super);
+	err = get_tree_single(fc, debugfs_fill_super);
+	if (err)
+		return err;
+
+	return debugfs_reconfigure(fc);
 }
 
 static void debugfs_free_fc(struct fs_context *fc)


