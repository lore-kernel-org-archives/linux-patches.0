Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63863CC33F;
	Tue, 16 Jun 2026 17:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632161; cv=none; b=tE77/ufdkbwrmWOvoqWzKtwR1whPqJlCfGhxY7MQJz4aEijJ7Be6oyIrbLnL4gCTXnbi0KJUov5ChxSiiO5viJ4oB8qfKsKZZIrKDnPYjhJtXQHEGdMX/wn76oSnek8YR1qINeO5qHwu7lsXNxdUfQYayB4HRhVDmPE4QL/4YRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632161; c=relaxed/simple;
	bh=HSxT6hwjNRql6ZtQ8NUVbgCxrZvfLHxDtEXa94QHJGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVDarnN3WAcnet9A++dUz5v01kZ9AWAJB950zY8ueUOd9W9ZrSvwei/BY6yBaJK+SNZYw4kEMZb1BkqBf0gFVgrC1qGbQNENXZ1p26krIjMokikUf/m24EMLndS1MlUbMlEtirnNkORB9DpCD7+Vch0un8QdlxecXukcQOcq5B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSg0IQJ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSg0IQJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9986E1F000E9;
	Tue, 16 Jun 2026 17:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632160;
	bh=08PEuCm8Mqk5vJkAlHa4B5H0auk3Q93mD989HH+40zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSg0IQJ2mCQ9FBfzXxFT0/KfuAcxO8KY2/oAHga6mgNnxWIAEUAgSkQUqA83ENRx/
	 /gDzLkbfio+S7KLBiULR1L/1lHjA/K/EvirQvdA4QOVFhUoyWE59+VNP08MWcJZWHh
	 Bh1mYv91v8b0j+5l/5lFqpfBYK1rmDuBwSZRFnAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seohyeon Maeng <bioloidgp@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 358/522] udf: fix partition descriptor append bookkeeping
Date: Tue, 16 Jun 2026 20:28:25 +0530
Message-ID: <20260616145142.539676324@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Seohyeon Maeng <bioloidgp@gmail.com>

[ Upstream commit 08841b06fa64d8edbd1a21ca6e613420c90cc4b8 ]

Mounting a crafted UDF image with repeated partition descriptors can
trigger a heap out-of-bounds write in part_descs_loc[].

handle_partition_descriptor() deduplicates entries by partition number,
but appended slots never record partnum. As a result duplicate
Partition Descriptors are appended repeatedly and num_part_descs keeps
growing.

Once the table is full, the growth path still sizes the allocation from
partnum even though inserts are indexed by num_part_descs. If partnum is
already aligned to PART_DESC_ALLOC_STEP, ALIGN(partnum, step) can keep
the old capacity and the next append writes past the end of the table.

Store partnum in the appended slot and size growth from the next append
count so deduplication and capacity tracking follow the same model.

Fixes: ee4af50ca94f ("udf: Fix mounting of Win7 created UDF filesystems")
Cc: stable@vger.kernel.org
Signed-off-by: Seohyeon Maeng <bioloidgp@gmail.com>
Link: https://patch.msgid.link/20260310081652.21220-1-bioloidgp@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
[ replaced kzalloc_objs() helper with equivalent kcalloc() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1657,8 +1657,9 @@ static struct udf_vds_record *handle_par
 			return &(data->part_descs_loc[i].rec);
 	if (data->num_part_descs >= data->size_part_descs) {
 		struct part_desc_seq_scan_data *new_loc;
-		unsigned int new_size = ALIGN(partnum, PART_DESC_ALLOC_STEP);
+		unsigned int new_size;
 
+		new_size = data->num_part_descs + PART_DESC_ALLOC_STEP;
 		new_loc = kcalloc(new_size, sizeof(*new_loc), GFP_KERNEL);
 		if (!new_loc)
 			return ERR_PTR(-ENOMEM);
@@ -1668,6 +1669,7 @@ static struct udf_vds_record *handle_par
 		data->part_descs_loc = new_loc;
 		data->size_part_descs = new_size;
 	}
+	data->part_descs_loc[data->num_part_descs].partnum = partnum;
 	return &(data->part_descs_loc[data->num_part_descs++].rec);
 }
 


