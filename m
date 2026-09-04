Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08E42F9DA1;
	Fri,  4 Sep 2026 05:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500958; cv=none; b=BJQyZ4j1BemA/UmAaxTtB8kQqNHQ4Gz4kyYAWRW6pCkQibsm5MH4CZyON2CHKqr11Gw4BslcEH6bnyTfpRjhmYObYxxZV2Rlz7jSRqcpA3ijjc8yeje7xTvVdtnclOpKYwclMWd9Dg3V3X0fgcecRgC7WF+iarzyrq2uShwIk1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500958; c=relaxed/simple;
	bh=Ujj/mDsU2YhhdXypCOwYhvogHKH2Kp5GzFgtsg3kO84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlEgFwo/jASUg2rQaSh1j8wZSaMz1A3N04vJF/WrJwhhYGk7oQ5RlsaeMT9AE0JoO2BMnSeAgKLh0/9hV+nJN1VGyoOzdDTBBCTQYlBBBDVorDJWb3qG57e5lrpBxHyTjpSgSDIVxxhQ4Z1IDt90Rk4/hKBLX2C/d82BVfLm8F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUg/RBE7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUg/RBE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377C21F00A3D;
	Fri,  4 Sep 2026 05:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500957;
	bh=vmiGXT6j7DBNTIjJEj4L7aTkxujWaerz1+QoRmRPGyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUg/RBE7IbaYWKZVZrjY67eZWwRS0TgCe4wUwzYMVTYSg11ngqLYsrsVIP4e6FmTP
	 4YCr9Fi0j8Okw40iV3BBvEh7ydmKFVOVIbvMIAugsw1rRJIxIEORHWC+8yE0PwLN57
	 cDWst3siSB8rPbc5ku4ncTS3ch8xguze9agZK3e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 239/552] dm array: reject an array block whose value size is not the callers
Date: Fri,  4 Sep 2026 06:56:36 +0200
Message-ID: <20260904045754.897053331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -246,6 +246,14 @@ static int get_ablock(struct dm_array_in
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
 
@@ -308,6 +316,14 @@ static int __shadow_ablock(struct dm_arr
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
 


