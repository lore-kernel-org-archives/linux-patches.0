Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF5413B29C;
	Tue, 27 Feb 2024 14:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043315; cv=none; b=nKgmh6pHw5ywizySFoVHr922lBc8bTgTbTABPxw2+ODhGNElJkidQ3S1HKHHVfWGFRVHNMLLMFwX+vv1FvpwMkWh8IV0o7gq+ZUN9OW60pXoR3YUEIxGL3WgIpFcUEiGOUhGqSA6IVTrReROPs5ZVksMEgKjzN5QaSkH514E2KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043315; c=relaxed/simple;
	bh=N6xCC1VBjtntBxjov/SweZ/TvPUzRv4OHx79s0fnrwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/y5cdwgCa1K9StJLm9zrDJ54xfGGGPwAZKKOHT1tuBrr5JHomnLq+RCsPmcRsgJtl74Z7z/bSLWx9MCjk+bF/m0X9Eu9qTtw6ZXqNNCxbdK+r4xcybb3OgXk1f8bSLqchoSeiyx+jgdUveeFGhwDwJeGB3/KH8dPrZTTLv/O64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1/KpxKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1/KpxKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24532C433F1;
	Tue, 27 Feb 2024 14:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043315;
	bh=N6xCC1VBjtntBxjov/SweZ/TvPUzRv4OHx79s0fnrwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1/KpxKBmJSPu3GeHc058p7NsDOtu7PYd4uwSBDKQ+9mDRZ5/wt8+es/oryeO/95X
	 kQuxSpbJp54xM7V314CqeRjDFPKZMIl9qrJnpA7PAWke5ao0h7AFiCPdKeS8Ap2eE5
	 flUM11ma3CHXr98lNUPF3EqcviVLZxI7CLyIDC24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/195] fs/ntfs3: Correct function is_rst_area_valid
Date: Tue, 27 Feb 2024 14:25:24 +0100
Message-ID: <20240227131612.585111706@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 710cb5aa5a65b..d53ef128fa733 100644
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



