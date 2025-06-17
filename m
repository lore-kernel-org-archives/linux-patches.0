Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8762E9730;
	Tue, 17 Jun 2025 15:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174372; cv=none; b=fRU7SMfE/PDMGPBBZXm3CoRKvcdOzUTWqC/E+xVV+9PE+4N59m67QXTvUOQwuqLFmkt82YfFwsBqySwn2zOtiqdPdesFZ9cuQk6XQXIh/tFiNNYBVPAyFQUhDFm6gLXvgb+rfJoChWly6Vipeh8Wxr5e5vdW/u75poVXBhSIae0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174372; c=relaxed/simple;
	bh=NXPuEXf2810vsYzWdtRkFdBxi1hWsJ0Kao1bwrWgJAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdX3/e+2kxiArzUqlnMJiSAS/hfAK3p6yI4DEXNUkujHK3f4Q6LQlxCBKqphUCkCq2E6eaQOjxsSkyfEf6lZ6Aotypm0TZ2w1YT7ElnWgazVMzuL1g96M2f+xwA6VxCFzijDqGg5W+KkiLp6t5+NJ0wFl3Uad3iPCqOSa/645dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNIozAvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNIozAvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CABC4CEE3;
	Tue, 17 Jun 2025 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174371;
	bh=NXPuEXf2810vsYzWdtRkFdBxi1hWsJ0Kao1bwrWgJAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNIozAvVXMj/dN8Q+hGESbBhl4w42zDPQb+Yd+kv27n5qHULhyzvhSNUkC4TOc9jN
	 hvHogk7mqSajoeH9mTpcrFEiZUxKNIryiTgc3XG/fpU6vOlCLXfkk7RsDwwZju0yIR
	 3Kr4E43eWnjtRi0cq9gxv4QtFLFH6I38zcfnaOU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/356] btrfs: scrub: fix a wrong error type when metadata bytenr mismatches
Date: Tue, 17 Jun 2025 17:22:27 +0200
Message-ID: <20250617152339.519216893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 97c17025b31e6..7632d652a1257 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -620,7 +620,7 @@ static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr
 	memcpy(on_disk_csum, header->csum, fs_info->csum_size);
 
 	if (logical != btrfs_stack_header_bytenr(header)) {
-		bitmap_set(&stripe->csum_error_bitmap, sector_nr, sectors_per_tree);
+		bitmap_set(&stripe->meta_error_bitmap, sector_nr, sectors_per_tree);
 		bitmap_set(&stripe->error_bitmap, sector_nr, sectors_per_tree);
 		btrfs_warn_rl(fs_info,
 		"tree block %llu mirror %u has bad bytenr, has %llu want %llu",
-- 
2.39.5



