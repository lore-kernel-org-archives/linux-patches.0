Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9D51CFA9;
	Tue, 27 Feb 2024 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040750; cv=none; b=NYVlLY1YZIpLVKZLE3CiS/PCzyFSjXwa9s/lTFN6n5/YZiiMxGqb78qdKW+ls1jBD7i0OYajcuXtG9y8+jO9YX96vchpLaiFXXZDwwA07ABjsRZt4/ynvMtiuY4TL78iy2/F1hB0b/d4j6UEJ3EONbfx9W4X+9aGwEOPOTLEUkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040750; c=relaxed/simple;
	bh=rYyD1OSWisHYfsABNTkcqyA2Hj/56EJtDOruAHNn0ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfoDOPUpgj2vEv673hxAChGKC7mZg6K/wJGHQ+1L9zudVAnamh1ehVOUBX1juhai4c/543IkZbeLKfJ5HzIAooNgkjlIRnyisbX0yqG0pXPMlHZU35siERqJynjh32PXdVf4XUhvmxj+2c5neHWynHchq11hIgIprToxQRxDYUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vl3RDdj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vl3RDdj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5896C433F1;
	Tue, 27 Feb 2024 13:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040750;
	bh=rYyD1OSWisHYfsABNTkcqyA2Hj/56EJtDOruAHNn0ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vl3RDdj3WogqGUoMni6ig2cHGMyJHgC07JqCKigCzZ9EaE+YnoGSSJguiUfKn4RYn
	 QTeLRYsa/1tG6BOe7I6CrQND5OyNwE0RCGp4bZ8Xb6h1135Syo9HqQRqvPRBT+pF9x
	 lXs/4BkSF8TryYjawd8KAKWN6a6plQNEQOhfYuwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 097/334] fs/ntfs3: Correct function is_rst_area_valid
Date: Tue, 27 Feb 2024 14:19:15 +0100
Message-ID: <20240227131633.634268803@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1b7dd28e14c4728ae1a815605ca33ffb4ce1b309 ]

Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 7dbb000fc6911..855519713bf79 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -465,7 +465,7 @@ static inline bool is_rst_area_valid(const struct RESTART_HDR *rhdr)
 {
 	const struct RESTART_AREA *ra;
 	u16 cl, fl, ul;
-	u32 off, l_size, file_dat_bits, file_size_round;
+	u32 off, l_size, seq_bits;
 	u16 ro = le16_to_cpu(rhdr->ra_off);
 	u32 sys_page = le32_to_cpu(rhdr->sys_page_size);
 
@@ -511,13 +511,15 @@ static inline bool is_rst_area_valid(const struct RESTART_HDR *rhdr)
 	/* Make sure the sequence number bits match the log file size. */
 	l_size = le64_to_cpu(ra->l_size);
 
-	file_dat_bits = sizeof(u64) * 8 - le32_to_cpu(ra->seq_num_bits);
-	file_size_round = 1u << (file_dat_bits + 3);
-	if (file_size_round != l_size &&
-	    (file_size_round < l_size || (file_size_round / 2) > l_size)) {
-		return false;
+	seq_bits = sizeof(u64) * 8 + 3;
+	while (l_size) {
+		l_size >>= 1;
+		seq_bits -= 1;
 	}
 
+	if (seq_bits != ra->seq_num_bits)
+		return false;
+
 	/* The log page data offset and record header length must be quad-aligned. */
 	if (!IS_ALIGNED(le16_to_cpu(ra->data_off), 8) ||
 	    !IS_ALIGNED(le16_to_cpu(ra->rec_hdr_len), 8))
-- 
2.43.0



