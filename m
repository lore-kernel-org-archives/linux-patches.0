Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1893EDE5C;
	Tue, 12 May 2026 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609399; cv=none; b=YzfMxLZnxOrQZ+ussg8ndKlyeqSllS5aWsi+dh6A6YEEsuVZxIe1aK3Un00IeI3QHOoo8sNVNKHif01lqPOLWNo5AwbxCrLwsFmARATNhYieelLupv6HYEucIkGdnmtXGqDz4dhXOZ1SjOoptqKdeKzV7ul7gVytrRYoecMPL8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609399; c=relaxed/simple;
	bh=x7u/iZfnrgSdQI6zMc3NkPxQlYeOTQvqTEP2PoHmFrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKoJSYZa1Gm2qpRS30SSkT7seo3KATqizPG7XZkneKobsr3TRRv2aO6DeXA+KuVqoVoYL55KumQ17nJqKyUO6RAa+cqx4MohZ3zAbVjoJBT4oAQ5fu45pu9AAsplndgTmbQsG+KtR4fzVd6NcvEABhLgcuedvJtBnMQmh9ijLT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0gavwDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0gavwDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A6CC2BCB0;
	Tue, 12 May 2026 18:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609398;
	bh=x7u/iZfnrgSdQI6zMc3NkPxQlYeOTQvqTEP2PoHmFrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0gavwDHzRJnlLbwlumnIBwZwT6rgxwGSmsjh27xUBC91h5OlfjOn+nnDnMJkpaQ1
	 XJoMG/UsB89O7/GD/GxBHPdA+Xbm9/AkkxRMjACk5Z+IUhgT2RxlXOXUV4YZm+TGTb
	 9TRrny29UBRJKJb9UX67AXIZVBJ1EASS5R5QQ2y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.0 180/307] dm-thin: fix metadata refcount underflow
Date: Tue, 12 May 2026 19:39:35 +0200
Message-ID: <20260512173943.916227939@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 09a65adc7d8bbfce06392cb6d375468e2728ead5 upstream.

There's a bug in dm-thin in the function rebalance_children. If the
internal btree node has one entry, the code tries to copy all btree
entries from the node's child to the node itself and then decrement the
child's reference count.

If the child node is shared (it has reference count > 1), we won't free
it, so there would be two pointers to each of the grandchildren nodes.
But the reference counts of the grandchildren is not increased, thus the
reference count doesn't match the number of pointers that point to the
grandchildren. This results in "device mapper: space map common: unable
to decrement block" errors.

Fix this bug by incrementing reference counts on the grandchildren if the
btree node is shared.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 3241b1d3e0aa ("dm: add persistent data library")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-btree-remove.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -490,12 +490,20 @@ static int rebalance_children(struct sha
 
 	if (le32_to_cpu(n->header.nr_entries) == 1) {
 		struct dm_block *child;
+		int is_shared;
 		dm_block_t b = value64(n, 0);
 
+		r = dm_tm_block_is_shared(info->tm, b, &is_shared);
+		if (r)
+			return r;
+
 		r = dm_tm_read_lock(info->tm, b, &btree_node_validator, &child);
 		if (r)
 			return r;
 
+		if (is_shared)
+			inc_children(info->tm, dm_block_data(child), vt);
+
 		memcpy(n, dm_block_data(child),
 		       dm_bm_block_size(dm_tm_get_bm(info->tm)));
 


