Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991FA46D2D9;
	Tue, 21 Jul 2026 18:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658695; cv=none; b=G9+3TvosWCmyPpKmXHX2JPifK+ZAtZSN8eKEv0EdDo8jLiRU6hG8+36KMkWtoLt7Br9UPGyNLSxoxwpIw/j7RS0KZNjrn91tSFveaGR7vCxPr1b8UnjEHZDbMAIczSNRCmTN93ox1/UxgBOpsky9o6TNybSV0LPeRP+ULy33Ph8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658695; c=relaxed/simple;
	bh=qFlrX9KHinoqwI6MDEpaqIZBNbQwH3MMcQVX2XTNBzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UntMFlA5Ik84xEfkoMCEFWtpJ9G877+AFeU3+85Z1JegW5/povzE4k5jAvywwBHlCxcQFKjKOML0C8cjfv9zOAVmpwGF0AFERcuTHB47KMHX9aiPjeZO8MD63d6HSm6Gy2Mwp2Jf9vOnknE/Wo0AO3vH3R488z0D64y7dkSlM2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faXbupMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faXbupMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054CC1F000E9;
	Tue, 21 Jul 2026 18:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658694;
	bh=X1kwuwOlEXlKSoG8cq12mTvXK2V/sFznhgxAQ10gZ9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=faXbupMMj03NFKnz7x/qaiCFvSWbIrd/FgdenPgmOWGQ8zo7YSnrAEor0mQDaSzi5
	 hG6Ga+NevT7J4cV8isxCmfw5Rk+LLs5zgPGhvsyeBhj2azjgBwPXqtGJSbMLgNdNcw
	 eR5K3Gi4TlosEuNYhNB3nlFIAUK8/WNoY20Z5EqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.18 1239/1611] fs/ntfs3: add depth limit to indx_find_buffer to prevent stack overflow
Date: Tue, 21 Jul 2026 17:22:35 +0200
Message-ID: <20260721152543.309450069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


