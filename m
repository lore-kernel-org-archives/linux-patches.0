Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83D732B11D;
	Sat, 30 May 2026 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160475; cv=none; b=nY8HXRsGr/CeeDXSvMMnWLe2I+zsp3uQqd8hoPAo+yuelpyAJkrNXxU8B+KYoyC37CUWnHJzFIyT+Y3h4jr3TtRyVGAl6mhF6qxt6NvFIOkTYTVViul9qbOLqN9ner2VrYT8ushg3ena867kNp+Zbh35/a9kNifVhSkkfy7b3wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160475; c=relaxed/simple;
	bh=TcnWZDFMUZ0nL1v1rEbHYjODfCQ/+l+ujqwn2FieoVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTA+iFgGpIp+/uKDFrjBhizT9zPuyDhmvK8K+lV56ef767SYVqTh3goZjzaTgymotnM3qF5j/GwoCOpcm0LlYTtZhuQ0zOSFoj5d8fomZGOtW2avoh6gfpngUsLnoAxXBtvyFdKQXChh3oq6a17aihkyW0aTnN9pWYqEw9dKFjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWDRvZ+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWDRvZ+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D191F00893;
	Sat, 30 May 2026 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160474;
	bh=dj+WRKY4/vwyXVr4+SFRBICOZeQzn1+S3MHmLqLvPvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWDRvZ+gYPlmRfVl2qt/ZWt6RY1QHERyixZae0hrE4SZfo2UfhD/itSSw8pnMCpc1
	 e4UayxiARepau3NniMOa0Ik4PBcg2SiUfv+n+yv5kUnRIXXUsV74mtcvWkrBkXZZmv
	 6H5u0XkqA0FVumq8Vop0/45KePA2wDSBxuAE9pts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 349/969] dm-thin: fix metadata refcount underflow
Date: Sat, 30 May 2026 17:57:53 +0200
Message-ID: <20260530160309.993837776@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -486,12 +486,20 @@ static int rebalance_children(struct sha
 
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
 


