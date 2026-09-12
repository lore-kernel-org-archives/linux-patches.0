Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6BB284B37;
	Sat, 12 Sep 2026 15:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227285; cv=none; b=MLAo8rwH5NauWsCP8T8uJYgdUds4oxDkuco4XaZFU+aG03jogCzxuaT19npAGQKrjHCKXMFNnaHzIPOugZ+8K3URi24ngr9U2HRLsdeXHawk3uZtNGWsFugKXIn4j/uoQEGHng2QU9aoYyoiSARRvM16etDQdwUNHxieBluCogY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227285; c=relaxed/simple;
	bh=0iI7T/A9kw+KGbJxywo2TLkDSNFw5oQpQ6hPUwCKbTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdoI33ElvkKf1Df8NHE0E/MRpZLPRp3fhshBRDuPvJObfpQX3KH030Pr0wyS+N/u6kNEE3YuLgCGdPcnKIguT12OoJQIRSMmJFK5p40GPB5Zj8oNXIFDogLiZpREZlV4BE4ojskzqc7YCK2aS28fRiVNR87SXKwJnWYiyHvvKAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzh+5i0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzh+5i0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B171F000FF;
	Sat, 12 Sep 2026 15:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227284;
	bh=4BbV3TNvsbeHqGAoNhlTiw+ruV7Ura4NPk4ctRgv9rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzh+5i0VvhKxUXMVKrhbA68Pkj2O1MOg0sUwHyQSU0Pw+Y+KcxGRgT03XbBzxRmJS
	 2NkH7uAmilHqbJ0LSM2qssf8dvL8dWTImMQSaSi4xtsnHAoL/OqvKCeJCo+p4iLMUm
	 vvywuPt7ce0iWIORS7gaENFTRk3Jneiw6+4o2g5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0107/1191] dm array: reject an array block whose value size is not the callers
Date: Sat, 12 Sep 2026 08:47:15 +0200
Message-ID: <20260912065550.588003584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -224,6 +224,14 @@ static int get_ablock(struct dm_array_in
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
 
@@ -286,6 +294,14 @@ static int __shadow_ablock(struct dm_arr
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
 


