Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27DF44AB8A;
	Tue, 21 Jul 2026 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670070; cv=none; b=bdh9ZTq5ijGQ3yUUjDQkB5J0GjvB47Jsm4VHPyd5flJ0UHPdDC0+gd9rMCnzPH6WLlFOhAL4d1azC8YR+k8Bd4RYzg41X4iM8BLIl1kx7u15ZGOhJs87em1sfAO9XOhvAQccTuR2HUivr9y+ijb1q4j0nOyQjEHtNndQCjm0YZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670070; c=relaxed/simple;
	bh=I6zEYsPfhbNfgPw5ON+HlEtOjck4jrCIMnxCt5ncHjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZkD5iLrugNJsHpInGW5AomqI3jqc+FEP69XsQT9EtfV3i8L3kiehGTghlGdHx7UBiwzYlWpQmqeZvJb3tZqlxRnaLtPNixTxAR3ZEHwbqsijVl8VMAyIKo++gWw9wzwWuiPmeJtgO67z4fpB3tViCK34Xxa1Y3YPg/ZsEjbZd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrLWH70Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrLWH70Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C4A1F00A3A;
	Tue, 21 Jul 2026 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670068;
	bh=bU/D8rn0EYfbia2T23h+MKPikQvS/jcq2TgtTORhpHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZrLWH70ZNGEfu0EuqwBrHrlOsI//iodsGuK9CD1Dos6tODrPzjyM4MzyIZrMx2Ol8
	 1dwvKEG1cn3RVbNVN/SgvCW5HW4TuKR9Z3u1PcN5+VeHO4bBSX9OjGXZcAtKry0uVU
	 d/xfEjKmnU+LlUR6D5uuv8K2dvO5Vx9cjAfKrJyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 0791/1067] fs/ntfs3: add depth limit to indx_find_buffer to prevent stack overflow
Date: Tue, 21 Jul 2026 17:23:12 +0200
Message-ID: <20260721152442.257632761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1991,13 +1991,21 @@ out1:
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
@@ -2018,7 +2026,8 @@ static struct indx_node *indx_find_buffe
 			if (err)
 				return ERR_PTR(err);
 
-			r = indx_find_buffer(indx, ni, root, vbn, n);
+			r = indx_find_buffer(indx, ni, root, vbn, n,
+					     depth + 1);
 			if (r)
 				return r;
 		}
@@ -2419,7 +2428,7 @@ int indx_delete_entry(struct ntfs_index
 
 		fnd_clear(fnd);
 
-		in = indx_find_buffer(indx, ni, root, sub_vbn, NULL);
+		in = indx_find_buffer(indx, ni, root, sub_vbn, NULL, 0);
 		if (IS_ERR(in)) {
 			err = PTR_ERR(in);
 			goto out;


