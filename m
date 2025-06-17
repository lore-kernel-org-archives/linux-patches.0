Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AA21E8332;
	Tue, 17 Jun 2025 15:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175013; cv=none; b=FGX+1AX2NwoD5apTApZmm2KGoXml8CqO2mikX5On67ZbbsuJC4BCM1Dn10fJbKQP7DUU92bRcgQ2b5xujrHhHVBPigWBgJgxpcdZhTFvDLJE3JfdnKocF6+V38VNO3yHo3YRpgIvKfeM3H3hzfOz3T7mgkjwzeI7O6GDRzrWDG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175013; c=relaxed/simple;
	bh=oT0UOmi+UCCMkb9nvy6VJKSI6BCATesMgovR//KKrjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fr8mreMl0UNBrIs43m5aTOkQ/+BrOrI+ThMAsRWhcIOs2//6UIIs/rD7o1t56NCdRO3VXbCDZHb6nzfzw387f6sZlOA6mb4VvsvJxZOC30JbsIwB4EBcri6pPEAS1QqyODCVVrgqGaJpM4q2QdwZMpmv8wjSRQMzwYrf81pN9Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdxyoI3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdxyoI3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D630C4CEE3;
	Tue, 17 Jun 2025 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175013;
	bh=oT0UOmi+UCCMkb9nvy6VJKSI6BCATesMgovR//KKrjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdxyoI3CW1BYqOYNBJJKWQaQDC8RwxuHIb9ACf7BdddnxrS9ej1cT7VtOpaW08q9N
	 iiPZQiv2J3mclyMkiNpEVW6rZRTHx6uMfYCovJTul7cuMYg8lt95Uu+lmmyiK8JrGO
	 e3rYL6S6WKSvcAC711o5yu3+4mU/D49tqGTekb44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 041/780] btrfs: scrub: fix a wrong error type when metadata bytenr mismatches
Date: Tue, 17 Jun 2025 17:15:49 +0200
Message-ID: <20250617152453.168188898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 61812298325a2..4c525a0408125 100644
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



