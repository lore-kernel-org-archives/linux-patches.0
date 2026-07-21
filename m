Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38FB356746;
	Tue, 21 Jul 2026 19:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663702; cv=none; b=If24JmsUviIPMNTLPl4BZkPIPki50MzZ5VXHHL8b9NoHQguq2kAYRhW2c2eGlQ68GYKp0UzGsraGPDFOLXJRbvkjmaJhguSzO7yPPwM8350K1v8ts4Yuq8EuD9zdfbMo/vy02gz68svT+Mmu9hIjOmjWlbA5kIVyE2PnSQUymTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663702; c=relaxed/simple;
	bh=eOxzk+dXM7pmd8XOdnuViI8fQOniBzcyIsLVj5DOsfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMcXMq7e5IBOqSuRcTlaE48spCj0FuFcdMr0FdCeqMA78UeZ7DjhnBmJq+rYW8RmAGbIWJrLEbymlHXLNIc9hMkAZMdhVSfFwiYRhblBgoCcCCGCSigyj0GliIu4n9IraW/A8+m1yg4QINy1wwvpwKW6K6WmydIvhr0s1fNtlwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RL96edqL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RL96edqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174291F000E9;
	Tue, 21 Jul 2026 19:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663700;
	bh=Kn4YxMo3obJXl/VXnB61N7LKFBIVI73/031zByiaLCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RL96edqLrPeVvr/mcG6UMcO5M9H0C3IJVPov68BCaiV8VNEOf6FiZcGTtuokdci2f
	 Mm76cFQE9g0fDm/zz+xTXSHqsgFLJQaaxoHKHCiHkr5RPDSUVqNbkcIR3mwQFU7+R4
	 m++IFYjtrkpD4Qs4wEOgGKLwQfLgX3sAiNPo90H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 0920/1276] fs/ntfs3: add depth limit to indx_find_buffer to prevent stack overflow
Date: Tue, 21 Jul 2026 17:22:43 +0200
Message-ID: <20260721152506.624566080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 1ebd684b8f627f75bc3e03f8b2ad8400fd1f02cd upstream.

indx_find_buffer() recursively descends the B+ tree index with no depth
limit.  A crafted NTFS image with circular index node references causes
unbounded recursion, overflowing the kernel stack and panicking the
system.

This is reachable by mounting a malicious NTFS filesystem (e.g. from a
USB drive via desktop automount) and deleting a file whose index entry
triggers the rebalancing fallback path in indx_delete_entry().

Add a depth parameter and bail out with -EINVAL when it reaches the
fnd->nodes array bound, matching the constraint already enforced by
fnd_push() in indx_find().

The related function indx_find() was previously patched for a similar
infinite-loop issue (commit 1732053c8a6b), but indx_find_buffer() was
missed.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/index.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -2014,13 +2014,21 @@ out1:
 static struct indx_node *indx_find_buffer(struct ntfs_index *indx,
 					  struct ntfs_inode *ni,
 					  const struct INDEX_ROOT *root,
-					  __le64 vbn, struct indx_node *n)
+					  __le64 vbn, struct indx_node *n,
+					  int depth)
 {
 	int err;
 	const struct NTFS_DE *e;
 	struct indx_node *r;
 	const struct INDEX_HDR *hdr = n ? &n->index->ihdr : &root->ihdr;
 
+	/*
+	 * Limit recursion depth to prevent stack overflow from crafted
+	 * images.  Use the same bound as the fnd->nodes array (20).
+	 */
+	if (depth > ARRAY_SIZE(((struct ntfs_fnd *)NULL)->nodes))
+		return ERR_PTR(-EINVAL);
+
 	/* Step 1: Scan one level. */
 	for (e = hdr_first_de(hdr);; e = hdr_next_de(hdr, e)) {
 		if (!e)
@@ -2041,7 +2049,8 @@ static struct indx_node *indx_find_buffe
 			if (err)
 				return ERR_PTR(err);
 
-			r = indx_find_buffer(indx, ni, root, vbn, n);
+			r = indx_find_buffer(indx, ni, root, vbn, n,
+					     depth + 1);
 			if (r)
 				return r;
 		}
@@ -2446,7 +2455,7 @@ int indx_delete_entry(struct ntfs_index
 
 		fnd_clear(fnd);
 
-		in = indx_find_buffer(indx, ni, root, sub_vbn, NULL);
+		in = indx_find_buffer(indx, ni, root, sub_vbn, NULL, 0);
 		if (IS_ERR(in)) {
 			err = PTR_ERR(in);
 			goto out;


