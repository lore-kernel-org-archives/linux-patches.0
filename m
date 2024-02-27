Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82CF13B7A2;
	Tue, 27 Feb 2024 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041845; cv=none; b=VQjhJRJkCVAAyztN5zrbxEuo0X6VVP4WY3LCkA1UVdBhfKCTlUWnuVkAVFrpG+dCN4a5qiCsAJor8w4uHq8s+ZPkbKXEM8POkSb7sVVds2h2VP0jWRD6TVmFEKJe8LUYV/tRL6A1ftr8OE1KqkPCzbXtYM/E817I64qFi9xpeRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041845; c=relaxed/simple;
	bh=/jy5Rgrn6GQ/wkg7j8r51CGRXo3DcpHBYVFPwhwbPqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gW12qx5k4zWdmeIvrNajI6iw/2cVPKt4Y8Zhp5aM5sdIXoDp7PfBH2/bHVXD32Po76ok41SbcFboY1vgNsHkefggNiu7TtwRfMo6kdCFF921gMGgGoLhRnZb0Z4rAW52mieEqjosm/mZTpkUa8r/qHjvzcSGg/gS/GtcV+MgX4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ao5M0e9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ao5M0e9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3698C433C7;
	Tue, 27 Feb 2024 13:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041845;
	bh=/jy5Rgrn6GQ/wkg7j8r51CGRXo3DcpHBYVFPwhwbPqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ao5M0e9CAwWY3ASyV7agE2+3r+aMfFxcW8ZJ2yZfnowP9R8mBSHAST+J3qPK/+64z
	 ludqd9j5LWXEl86IRjObaiDtet8SD28QUIeODZaDSNmtkez5xV3qDmTvs9GLHXQvAF
	 E40ejiu07VlpibS69Gf7MQqaHHphmt773U+VDAT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/299] fs/ntfs3: Correct function is_rst_area_valid
Date: Tue, 27 Feb 2024 14:23:19 +0100
Message-ID: <20240227131628.744503686@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



