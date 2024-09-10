Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7861418FDAF;
	Tue, 10 Sep 2024 10:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963720; cv=none; b=ZGA6r0IAguR5qdFGM4A+g/vd2xI8c2HY4Pkl3M/4ehnOanCIPK3seSxI3ko7xNQfphH7BCAx2n5i0sHK9Fni5q+zj56VyHdpOxQFpUwxnZJ5s1fBnH12GHezJVzV8UnLxJgty1fwLjSllWVqi1vx40xD94N0bQIEuJf+BAtrR5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963720; c=relaxed/simple;
	bh=3zIFA3K9GAHG52a8v/c5J9DNkcLbFLQ8amdwHFWAhkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fni6LtaseFaxOjhqxocTlv7R1DAt7UjHOINCaVJKHSQJZoi/j/M+5uD62bnJ5pcqWmuI6JnFPDlt0IXjOjMMQjxbYP/ud+CJC3ZXA6b7fOl9hQE9+Zi1QAsBz1nZhELvkf9X3qxJSZ87DJfzGKb/szjMlKbnDbqJpHBxgllyCBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5ZcauJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5ZcauJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B1BC4CEC3;
	Tue, 10 Sep 2024 10:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963720;
	bh=3zIFA3K9GAHG52a8v/c5J9DNkcLbFLQ8amdwHFWAhkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5ZcauJe0Uaxt70uqMD/R7oP0ooI02fLXHr+2AqQFWzmLbKZv3t2izCY/pfcIv+gH
	 5bxu9+F1gqd3zfyamTlvP6wxfcJ7tthtAwvZb258I7n+nXzMrxrj61ng8kwBHErkVe
	 Q1P0DEeC5SUcp/SkSVMXFIQpxpLvO5c/8IqDEOzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/214] btrfs: clean up our handling of refs == 0 in snapshot delete
Date: Tue, 10 Sep 2024 11:32:56 +0200
Message-ID: <20240910092605.033351676@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit b8ccef048354074a548f108e51d0557d6adfd3a3 ]

In reada we BUG_ON(refs == 0), which could be unkind since we aren't
holding a lock on the extent leaf and thus could get a transient
incorrect answer.  In walk_down_proc we also BUG_ON(refs == 0), which
could happen if we have extent tree corruption.  Change that to return
-EUCLEAN.  In do_walk_down() we catch this case and handle it correctly,
however we return -EIO, which -EUCLEAN is a more appropriate error code.
Finally in walk_up_proc we have the same BUG_ON(refs == 0), so convert
that to proper error handling.  Also adjust the error message so we can
actually do something with the information.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ea488b5f5cd8..8a526b9e8949 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5027,7 +5027,15 @@ static noinline void reada_walk_down(struct btrfs_trans_handle *trans,
 		/* We don't care about errors in readahead. */
 		if (ret < 0)
 			continue;
-		BUG_ON(refs == 0);
+
+		/*
+		 * This could be racey, it's conceivable that we raced and end
+		 * up with a bogus refs count, if that's the case just skip, if
+		 * we are actually corrupt we will notice when we look up
+		 * everything again with our locks.
+		 */
+		if (refs == 0)
+			continue;
 
 		if (wc->stage == DROP_REFERENCE) {
 			if (refs == 1)
@@ -5094,7 +5102,11 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 		BUG_ON(ret == -ENOMEM);
 		if (ret)
 			return ret;
-		BUG_ON(wc->refs[level] == 0);
+		if (unlikely(wc->refs[level] == 0)) {
+			btrfs_err(fs_info, "bytenr %llu has 0 references, expect > 0",
+				  eb->start);
+			return -EUCLEAN;
+		}
 	}
 
 	if (wc->stage == DROP_REFERENCE) {
@@ -5224,8 +5236,9 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 		goto out_unlock;
 
 	if (unlikely(wc->refs[level - 1] == 0)) {
-		btrfs_err(fs_info, "Missing references.");
-		ret = -EIO;
+		btrfs_err(fs_info, "bytenr %llu has 0 references, expect > 0",
+			  bytenr);
+		ret = -EUCLEAN;
 		goto out_unlock;
 	}
 	*lookup_info = 0;
@@ -5426,7 +5439,12 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 				path->locks[level] = 0;
 				return ret;
 			}
-			BUG_ON(wc->refs[level] == 0);
+			if (unlikely(wc->refs[level] == 0)) {
+				btrfs_tree_unlock_rw(eb, path->locks[level]);
+				btrfs_err(fs_info, "bytenr %llu has 0 references, expect > 0",
+					  eb->start);
+				return -EUCLEAN;
+			}
 			if (wc->refs[level] == 1) {
 				btrfs_tree_unlock_rw(eb, path->locks[level]);
 				path->locks[level] = 0;
-- 
2.43.0



