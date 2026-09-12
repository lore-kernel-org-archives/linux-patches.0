Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD82547989B;
	Sat, 12 Sep 2026 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232831; cv=none; b=rCbZfCIFJ6Wyz+TcBb7QCRqQ8i0eunsb0sgbA9Sxq2rKv+4PCkhOrBtpWNucEW47ufaRJ+YnEsfGo/UuYK/drc5TsabA9C/49uAZvhZZEDobTTJBLt6bzkP7ZcLuIikCZfqZphP8zltxTZ6dq8u2L3avPB68DKssIhT4ykcO6EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232831; c=relaxed/simple;
	bh=ULYjuyuUpNEZLgcGLYPpbmAf5/6DIk3f0YG1xcW2s4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4bksEcScYQEVw3Qv81xyEeeKW0O/+dbT9b80Ti0HmV0sT+1Ym+ZnetcjlNs2JJZdPQANaYWrsoOJV/4xZA2uRqWXizGnej5Usv8ZVj9x43d3TjzPbCSR5V0/K5wt8MzDT8eOq0LMz6Q3xu6/fUWU2WZC9e1xdbngIhN6Do+Hgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TM3u8qn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TM3u8qn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D6A1F000FF;
	Sat, 12 Sep 2026 17:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232829;
	bh=wSPMpoXj646eIYehQlB8Tm+LQtS2l54v7CRzw23MrMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TM3u8qn4/Fl9KujN0nx5rlnPx8FcpMxavt1GkFpB6Oh7tOYrObDTItllkAdgOUeGC
	 ymHGmENRi1Cd5h5FsorvcS57pAzoNGM+Q7gU8vJ36q3fWx22BPhrde1mDHI7LuvLd6
	 PcF520Em3W24egNGtvjW9u/gsfMwHfKEq3tYWWHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 091/935] dm array: reject an array block whose value size is not the callers
Date: Sat, 12 Sep 2026 08:52:01 +0200
Message-ID: <20260912065528.911201858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 4538a287bdf5d0f9a379c678e5262b9f5783f547 upstream.

array_block_check() can only compare the header against itself, so a block
with value_size 4 and max_entries 1018 is internally consistent and passes.
dm-cache keeps two arrays -- mappings at 8 bytes and hints at 4 -- and the
roots for both live in the superblock. Point the mappings root at a hint
block and __load_mappings() walks it through an info whose value size is 8,
so element_at() strides 8 bytes over 4-byte entries and reaches offset 8160
of a 4096-byte block.

get_ablock() and __shadow_ablock() are the two places that hold the block
and the caller at once. Reject there when the two value sizes disagree.
Arrays only ever read their own blocks, so this fires on crafted metadata
only.

Fixes: 6513c29f44f2 ("dm persistent data: add transactional array")
Suggested-by: Ming-Hung Tsai <mtsai@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-array.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -223,6 +223,14 @@ static int get_ablock(struct dm_array_in
 		return r;
 
 	*ab = dm_block_data(*block);
+	if (le32_to_cpu((*ab)->value_size) != info->value_type.size) {
+		DMERR_LIMIT("%s failed: value_size %u != wanted %u", __func__,
+			    le32_to_cpu((*ab)->value_size),
+			    info->value_type.size);
+		dm_tm_unlock(info->btree_info.tm, *block);
+		return -EILSEQ;
+	}
+
 	return 0;
 }
 
@@ -285,6 +293,14 @@ static int __shadow_ablock(struct dm_arr
 		return r;
 
 	*ab = dm_block_data(*block);
+	if (le32_to_cpu((*ab)->value_size) != info->value_type.size) {
+		DMERR_LIMIT("%s failed: value_size %u != wanted %u", __func__,
+			    le32_to_cpu((*ab)->value_size),
+			    info->value_type.size);
+		dm_tm_unlock(info->btree_info.tm, *block);
+		return -EILSEQ;
+	}
+
 	if (inc)
 		inc_ablock_entries(info, *ab);
 


