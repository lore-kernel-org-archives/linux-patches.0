Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B592BEFF5;
	Tue, 21 Jul 2026 20:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667224; cv=none; b=NjaYPATpwFETP+ag7bxOL0ZnumWzVfZfzpEx1b70Zs9f1D/rr5vM8JxEqZhg91pMJyh+Vw5dFpeqiTukAK6lcyIvvYHL8W66GBqxl2ySXgg8Hjyb0jG/GxAjxQfbLFA28GRGsSiZALNluAwVlkc+Bq7lT8zX7iARGIgh82GMoLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667224; c=relaxed/simple;
	bh=zH9B1gAsFDzg1Nux0y7NYz5TZcj0TyvmMctXD9HqDSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBu1H6DQG5T0GWy7TLKFmy6YZSLeyfTz+3MqOiDdqPJnyUtwhCFJ/lntnW/OWPuvGFxYcItyujGmEgGIHtV+EErE3aVpJxAj3wuPH0NLWd9dcnid+znBxrPxjWBumiKZ6WXNkGnb24ad12Pf+dKUDyuqo13krMmKIkzeBopk0r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PLc69RE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PLc69RE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE931F000E9;
	Tue, 21 Jul 2026 20:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667223;
	bh=eeinnvbRQ81ehCgkg7FCt0M67CC/+GDEk54xaJNynrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PLc69RE2Xs7c90aSrwRBTJ9VQY9r7KBR6t+PAMl5dWaPcS29lN6YP8bgOc6GFW/e
	 ejqZfIDvdy8cpfBnYD8voKTDomZXVy9IL/VHba46tYJUqgJ1GxZNZH59knU/jm5+yG
	 UdQlyTKUEI6UkgEbYiBXmb2psgD9vqHctUSnDSRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 0981/1266] fs/ntfs3: add depth limit to indx_find_buffer to prevent stack overflow
Date: Tue, 21 Jul 2026 17:23:38 +0200
Message-ID: <20260721152503.791219312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2016,13 +2016,21 @@ out1:
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
@@ -2043,7 +2051,8 @@ static struct indx_node *indx_find_buffe
 			if (err)
 				return ERR_PTR(err);
 
-			r = indx_find_buffer(indx, ni, root, vbn, n);
+			r = indx_find_buffer(indx, ni, root, vbn, n,
+					     depth + 1);
 			if (r)
 				return r;
 		}
@@ -2448,7 +2457,7 @@ int indx_delete_entry(struct ntfs_index
 
 		fnd_clear(fnd);
 
-		in = indx_find_buffer(indx, ni, root, sub_vbn, NULL);
+		in = indx_find_buffer(indx, ni, root, sub_vbn, NULL, 0);
 		if (IS_ERR(in)) {
 			err = PTR_ERR(in);
 			goto out;


