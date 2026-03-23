Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391ED21D00A;
	Mon, 23 Mar 2026 14:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275179; cv=none; b=jkLQwaaQW0qLH1eVhVeOeb2ZV5Y+RoGkaW7Cs4r6nK+ayiqNExOM1fkGRUsg0GPrXUpV7TC4M9KKx0HhorARnr5Nu7Vx/Vkrbv/s+Cfc8prQsYSZ7SnjN6DUdqoMHaQKEKXE3wLt2UBdnTHk0TkSFT4UUm2S0vq4WoBCeaxL39M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275179; c=relaxed/simple;
	bh=zciGad+s09/KHQKR1GJ2+Y61XM13IFgRRF7UV7xDbsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liHkTLMbjuGgmGIRFyDkShevpfq/AMvDw+jdw+YHwVFO3N6SumjEl3Yh59q2LIL9rYStvCTxl3y5eKWqkLhuuyzBoGjyeu14iK+SpOEL1AbpDuONkdKPh0zCGtfwdkbvQaQdL+Y8AdAfwL8ihjgUnsytM55lpkZQemDcHiCUMkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3Pk8e78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3Pk8e78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD27C4CEF7;
	Mon, 23 Mar 2026 14:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275178;
	bh=zciGad+s09/KHQKR1GJ2+Y61XM13IFgRRF7UV7xDbsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3Pk8e78UUlLfCezQNFxqstiWjSitdXvsW9I6g8+anpXQm/npo2iNYIsqGjZhHLx2
	 lDFSJNWBpw1DMCu0YFzWrP1TXYtUNjQU1P2qbCc0TfrciA9bMJ8NVDbo80v+O4J8+q
	 YAXz64WKd+caMySEcA9eMchG2J8sGkpNdY1y+IIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/481] btrfs: move btrfs_crc32c_final into free-space-cache.c
Date: Mon, 23 Mar 2026 14:39:55 +0100
Message-ID: <20260323134525.574672963@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 102f2640a346e84cb5c2d19805a9dd38a776013c ]

This is the only place this helper is used, take it out of ctree.h and
move it into free-space-cache.c.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 511dc8912ae3 ("btrfs: fix incorrect key offset in error message in check_dev_extent_item()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h            | 5 -----
 fs/btrfs/free-space-cache.c | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bd84a8b774a68..96146b920bdd3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2827,11 +2827,6 @@ static inline u32 btrfs_crc32c(u32 crc, const void *address, unsigned length)
 	return crc32c(crc, address, length);
 }
 
-static inline void btrfs_crc32c_final(u32 crc, u8 *result)
-{
-	put_unaligned_le32(~crc, result);
-}
-
 static inline u64 btrfs_name_hash(const char *name, int len)
 {
        return crc32c((u32)~1, name, len);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 75ad735322c4a..9f4dae426037b 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -48,6 +48,11 @@ static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info, u64 offset,
 			      u64 bytes, bool update_stats);
 
+static void btrfs_crc32c_final(u32 crc, u8 *result)
+{
+	put_unaligned_le32(~crc, result);
+}
+
 static void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl)
 {
 	struct btrfs_free_space *info;
-- 
2.51.0



