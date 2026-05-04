Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBB23DE423;
	Mon,  4 May 2026 14:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903439; cv=none; b=Fs+/R833MHuJSHGEWI9EGv1txVcwd8yDmze0dhKfaAKw673ceJ8V0TmmVk0uyi19TDOHACj4FeZYf8nlLuL2lAlulbiTN0A664FWtmfHpsl4l1WJy4b9fJL1I5mso9RPf7iEIVQLWqYv+bwS4uQlAIKny3PcxtdlHyDJWAosbNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903439; c=relaxed/simple;
	bh=2lTfuOqR/eO3PI10oixb7Uy7fGyeUZHM4+1cMzlCM3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W18RbfQaB6K2ezQ0XRC44NiGP+9U/itQtvIbC+YFpsABkO0GHaAMJyFab+LZ4NFPpMGrefCulwtviXuEvxHklHfgkqn35x//dkNSE3pPfJZikOLyg7KoVeTfZIixUqepNZwJ9y0j8HxQnmBRuKVxnmAhfeD0gPJm+k91uCWdyLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMTxllB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMTxllB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6277C2BCB8;
	Mon,  4 May 2026 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903439;
	bh=2lTfuOqR/eO3PI10oixb7Uy7fGyeUZHM4+1cMzlCM3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMTxllB0TLCm16r4siiWqXTo9O72qthny7OZV4NYj50FWF431hk+vtTVdjTa1NfIv
	 zJB3Aa9yJcGpmlNz69KoTIPmYuvzToKVoSkoNzV5J+SJ8VvNTgLh+in+ZFuPK8TmaE
	 k/40c/Uy0ljnFKyt7S0wMo3pTkQ1Q68jFArY/F78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seohyeon Maeng <bioloidgp@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 7.0 233/307] udf: fix partition descriptor append bookkeeping
Date: Mon,  4 May 2026 15:51:58 +0200
Message-ID: <20260504135151.616076967@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Seohyeon Maeng <bioloidgp@gmail.com>

commit 08841b06fa64d8edbd1a21ca6e613420c90cc4b8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1694,8 +1694,9 @@ static struct udf_vds_record *handle_par
 			return &(data->part_descs_loc[i].rec);
 	if (data->num_part_descs >= data->size_part_descs) {
 		struct part_desc_seq_scan_data *new_loc;
-		unsigned int new_size = ALIGN(partnum, PART_DESC_ALLOC_STEP);
+		unsigned int new_size;
 
+		new_size = data->num_part_descs + PART_DESC_ALLOC_STEP;
 		new_loc = kzalloc_objs(*new_loc, new_size);
 		if (!new_loc)
 			return ERR_PTR(-ENOMEM);
@@ -1705,6 +1706,7 @@ static struct udf_vds_record *handle_par
 		data->part_descs_loc = new_loc;
 		data->size_part_descs = new_size;
 	}
+	data->part_descs_loc[data->num_part_descs].partnum = partnum;
 	return &(data->part_descs_loc[data->num_part_descs++].rec);
 }
 


