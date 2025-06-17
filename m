Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876CE2DF3C9;
	Tue, 17 Jun 2025 15:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174511; cv=none; b=aM1Gt67vJJhH57/ytupqdVjqxH81P6yhVuLYSO15BjYWiA0NP4uCUyIO2WG8vmQIp3Av/TEKk3hK2oEz1BrV9/jvKpYQgqnb/YSwAzli6SGn6sIVJ/leuh5tV9U7HZD663nCEToSev3tv3WWWsokklpmVaQ3CcVA1bRWl4UzojE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174511; c=relaxed/simple;
	bh=q9Rq33MRrxNLfTI+F4sia/9ns/IW9R9+tNZG3PPyNbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxbMZbHGi8z+I61PPzwHutQ8htxo5/s/zFyM/znuDavIFLxk8uJTP4bRKBbFi2Zz8QGmiDbo8xD/ZY9zvtuqZe4hBtjQjmXqAiuuztgbaizjZk1d9d8pLuymthwVeVjCqUKWzgQ778+6p6wEs1Snxjjn0E+Or98+5nKnnaWUJeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/t5HI32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/t5HI32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E279CC4CEE7;
	Tue, 17 Jun 2025 15:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174511;
	bh=q9Rq33MRrxNLfTI+F4sia/9ns/IW9R9+tNZG3PPyNbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/t5HI32kWR83hYFVD2XpBavtEk2WkARTVNJ3Xi1EdKpf5Zm6DqpK4e1DsV+ebmQs
	 rwc/C+nzTIr/VX80U0Or19xSJfVtdOTdlPZYtyo6Hs/3b3iyPi0tSU+sx97k6QqBmz
	 nL1nrRg2aqIw0r+KGqxjWHAh0mI64fICDCa4G+WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/512] btrfs: scrub: fix a wrong error type when metadata bytenr mismatches
Date: Tue, 17 Jun 2025 17:19:54 +0200
Message-ID: <20250617152420.699438376@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit f2c19541e421b3235efc515dad88b581f00592ae ]

When the bytenr doesn't match for a metadata tree block, we will report
it as an csum error, which is incorrect and should be reported as a
metadata error instead.

Fixes: a3ddbaebc7c9 ("btrfs: scrub: introduce a helper to verify one metadata block")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 51eb41d18c3e5..3fcc7c092c5ec 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -619,7 +619,7 @@ static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr
 	memcpy(on_disk_csum, header->csum, fs_info->csum_size);
 
 	if (logical != btrfs_stack_header_bytenr(header)) {
-		bitmap_set(&stripe->csum_error_bitmap, sector_nr, sectors_per_tree);
+		bitmap_set(&stripe->meta_error_bitmap, sector_nr, sectors_per_tree);
 		bitmap_set(&stripe->error_bitmap, sector_nr, sectors_per_tree);
 		btrfs_warn_rl(fs_info,
 		"tree block %llu mirror %u has bad bytenr, has %llu want %llu",
-- 
2.39.5



