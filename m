Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9BB43CEC7;
	Tue, 16 Jun 2026 18:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634539; cv=none; b=PgnfsQi7yg+GBMkmkjujbM9JcQtLJ6qwv3rGKg93JYXyzJBYAbB9GJO3OnMnYIMcptxpB2VGKycmonrdHG6Q6KshUVM4GCFS8QacMyYMis7q8y8uaU3P1DXjrxIAI8+S576A3qoSr7eScIJwq4pCyaI/68uVz0sjerge093n5h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634539; c=relaxed/simple;
	bh=sacLKDoR/XsWpdhHtaKdPUzXbsCfD2oYfUFtDv7RI/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baZ0zPtapjlp7L81BPU6gEXRveAccK+d4zUu5/sAZsnDxVRz0v59KndtltVDJs7Su/YyI8JlF9vaGf6raxBVaojgIqenT0xOVE5BhaHfVmEQfI29C/6Tc04gVsQxyPrLdJoKOKR+JXj7Viemtcu9pxwRggkeTJR0aFr7oRU+3JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zz1vr874; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zz1vr874"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD511F000E9;
	Tue, 16 Jun 2026 18:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634538;
	bh=3lShzoSu2lnNxAVFvC3o2yz+h5oQN0TIEjr3unrNVu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zz1vr874ut6VYrIBZbJLwWILuoZhIL8BRRji0oP+GpGR5cqpTyub0poUFQ2CcUXt3
	 kuevEI1lcP91k8PrlLqLsx4iA7leNqiXCd0K4eS4iPmaIyCp/RFdFPlUnj6RB38uzr
	 hmriDaRAh0HqA8a245SqgDK7li1hTXd7VgvB6/7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seohyeon Maeng <bioloidgp@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/411] udf: fix partition descriptor append bookkeeping
Date: Tue, 16 Jun 2026 20:28:42 +0530
Message-ID: <20260616145116.253903414@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1658,8 +1658,9 @@ static struct udf_vds_record *handle_par
 			return &(data->part_descs_loc[i].rec);
 	if (data->num_part_descs >= data->size_part_descs) {
 		struct part_desc_seq_scan_data *new_loc;
-		unsigned int new_size = ALIGN(partnum, PART_DESC_ALLOC_STEP);
+		unsigned int new_size;
 
+		new_size = data->num_part_descs + PART_DESC_ALLOC_STEP;
 		new_loc = kcalloc(new_size, sizeof(*new_loc), GFP_KERNEL);
 		if (!new_loc)
 			return ERR_PTR(-ENOMEM);
@@ -1669,6 +1670,7 @@ static struct udf_vds_record *handle_par
 		data->part_descs_loc = new_loc;
 		data->size_part_descs = new_size;
 	}
+	data->part_descs_loc[data->num_part_descs].partnum = partnum;
 	return &(data->part_descs_loc[data->num_part_descs++].rec);
 }
 


