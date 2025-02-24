Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F5D18B46C;
	Mon, 24 Feb 2025 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407792; cv=none; b=M8+oNOjSvV9zjEMoD0bUXiWUVqITqkfemiVw2bczizTpf7SQeeW2BR3jfuIUtFdYAeP0z8hb4Q7lqSfOdyAJ7eclHhg8pWMg385nhBFDOICnNAxtmxO34j6VBbFK2oAMaKD7h282wwzRpY+MR79KUhGM5HVzOIPqm5aVYwgteFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407792; c=relaxed/simple;
	bh=7IEbOsqWS/VkX5Xiq9/a5e7k6Uwx0hsbtM8o376JNpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmJ/zcIx2Rrg8gnxdl3RrJNhrDj281jkLSpKi5lQalLu3JqoFP06EUi0T50MfwdTqWQVnmKzAjctMJCLIIQfLi2WwB+N9iO5Ml9yuW+xRP2j2W9aYfISv7QK+k4SzW7BzL3bZI7ZdTiy5bs/Tg0uhlR8FFbAZzy77oQNmbTFCLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKeSf5qA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKeSf5qA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1556C4CED6;
	Mon, 24 Feb 2025 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407792;
	bh=7IEbOsqWS/VkX5Xiq9/a5e7k6Uwx0hsbtM8o376JNpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKeSf5qAKY45eKkfZDw8dlIIsuHFaF9LcYTRBAojf8ATFLYll7ZuzNW+4SXHbt8aN
	 aeY9L0R3MeMjJIONpPvYX37TBoxlFqcWaSWG7nYR6MzLc7qQt/MYv9yKp54cztxeuK
	 cWvh/8mzUDv1/3MszKAC5jGALSjQWm+twHw6LuV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 011/140] xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
Date: Mon, 24 Feb 2025 15:33:30 +0100
Message-ID: <20250224142603.453566621@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit b3f4e84e2f438a119b7ca8684a25452b3e57c0f0 upstream.

Just like xfs_attr3_leaf_split, xfs_attr_node_try_addname can return
-ENOSPC both for an actual failure to allocate a disk block, but also
to signal the caller to convert the format of the attr fork.  Use magic
1 to ask for the conversion here as well.

Note that unlike the similar issue in xfs_attr3_leaf_split, this one was
only found by code review.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -543,7 +543,7 @@ xfs_attr_node_addname(
 		return error;
 
 	error = xfs_attr_node_try_addname(attr);
-	if (error == -ENOSPC) {
+	if (error == 1) {
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
@@ -1380,9 +1380,12 @@ error:
 /*
  * Add a name to a Btree-format attribute list.
  *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
+ * This will involve walking down the Btree, and may involve splitting leaf
+ * nodes and even splitting intermediate nodes up to and including the root
+ * node (a special case of an intermediate node).
+ *
+ * If the tree was still in single leaf format and needs to converted to
+ * real node format return 1 and let the caller handle that.
  */
 static int
 xfs_attr_node_try_addname(
@@ -1404,7 +1407,7 @@ xfs_attr_node_try_addname(
 			 * out-of-line values so it looked like it *might*
 			 * have been a b-tree. Let the caller deal with this.
 			 */
-			error = -ENOSPC;
+			error = 1;
 			goto out;
 		}
 


