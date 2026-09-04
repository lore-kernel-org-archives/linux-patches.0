Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05D44195A0;
	Fri,  4 Sep 2026 06:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502337; cv=none; b=NV0xrwkcy6qhVI1PRaX/Ee9QGBGFNPkVg1Rf6aMkKUx+ZG9wC8K2JLIO42b2l0dWUAxl7PjN6xx1r9cd0PFzIkM0IbNGA2XpsiHsRXaqNH55jDUzE2bpJZgUCxH9Gd1jxFvWLahjiPlo/DB2C/+jRdBiKy0jt27a5JI1JlOGa/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502337; c=relaxed/simple;
	bh=5my52hmNdboBGsXTNlQd0XDCwF6b8pKsShwgDTul1Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbfZadLYMx5BUxLoy3vb+54C9V05ksJ5bfP9I9skGhDnVdJWfR+E8P6jo036ycvioslngdJQ1wC+CQ8prrrAnZFf+n4FNpJ70fWVqSux9lbj+sUjHJ8j6nIj35MjPqeKR27q1BKK2LAaZg9ULk1uIbHeVGJxkiq4Sik4buGoq9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMU2Hkju; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMU2Hkju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA011F00A3D;
	Fri,  4 Sep 2026 06:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502336;
	bh=m9ajRZ+RtGg2O7+YrvLIyjn1L4n0CkB8e/6bnr0UVZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMU2HkjuCPw4/L57OVTqFDLmbeW5zme9M+ouItOujD8Wbx0vMuWgy8PSwhhxUAqki
	 zd+dKLI52lu2BNL4hQFsoKWSVP7nd/wnpImY8O+Zhw3HTHYZZ1E4j0evuottDa+wNe
	 NURmqE+yfxxCAd0KJrNWncK+vd8y58DAAEAxvgwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 171/403] dm array: reject an array block whose value size is not the callers
Date: Fri,  4 Sep 2026 06:59:34 +0200
Message-ID: <20260904045738.749170586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


