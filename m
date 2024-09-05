Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322AD1925AA;
	Thu,  5 Sep 2024 09:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529400; cv=none; b=AASrhwR7q+cfh2gspby/zhI2kXQErcJPBXNQwwyPWYCZhR5ffCPBCaJHjwwGrnlE45IvsvWMUj296/rFfhaX+c28bicNH160Ky9oqc7AwfcX233U9w3dPITCDRxegbgT20JWybx6V5NJ/GFqMPfFdcCssYv3aTgpCFskreD+t2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529400; c=relaxed/simple;
	bh=odAYq1r0/4b49snAdubZk8TU/7AuuAJw3tM+qH6K0+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeLD7jO5rjkPtlSHrG63O/lLKvLOoQzK9iHJyCGmGjyCyAsNMsPGbDuRKSZlTvePWbOyvVueNlwOCN+HrXcFENmrnHVW2nHGscR5oaWUMQ5CQByj7C6vYT+RauG5XE2G2BSe0ecIQioNKKfN4slAyL3Sed6Z1f/LDfrGXUAKITk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUVfFnL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUVfFnL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B901C4CEC3;
	Thu,  5 Sep 2024 09:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529399;
	bh=odAYq1r0/4b49snAdubZk8TU/7AuuAJw3tM+qH6K0+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUVfFnL11pD7D7LvLuM3/QROvpG1yPfPc9ab+eGsYkrXU/B6m60sEXcqiyAxTVeVn
	 54/Np1oIODrolee5apEumFRXb760/+6j/bOYAL4V3IlfDYwdfdVjfIjn5bGlOUpa4b
	 knzbljqo12I3TvWvAjL+99J02XSVtZ04nsKWcb6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 020/184] btrfs: factor out stripe length calculation into a helper
Date: Thu,  5 Sep 2024 11:38:53 +0200
Message-ID: <20240905093733.035433476@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 33eb1e5db351e2c0e652d878b66b8a6d4d013135 ]

Currently there are two locations which need to calculate the real
length of a stripe (which can be at the end of a chunk, and the chunk
size may not always be 64K aligned).

Factor them into a helper as we're going to have a third user soon.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d7caa3732f074..9712169593980 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1648,14 +1648,20 @@ static void scrub_reset_stripe(struct scrub_stripe *stripe)
 	}
 }
 
+static u32 stripe_length(const struct scrub_stripe *stripe)
+{
+	ASSERT(stripe->bg);
+
+	return min(BTRFS_STRIPE_LEN,
+		   stripe->bg->start + stripe->bg->length - stripe->logical);
+}
+
 static void scrub_submit_extent_sector_read(struct scrub_ctx *sctx,
 					    struct scrub_stripe *stripe)
 {
 	struct btrfs_fs_info *fs_info = stripe->bg->fs_info;
 	struct btrfs_bio *bbio = NULL;
-	unsigned int nr_sectors = min(BTRFS_STRIPE_LEN, stripe->bg->start +
-				      stripe->bg->length - stripe->logical) >>
-				  fs_info->sectorsize_bits;
+	unsigned int nr_sectors = stripe_length(stripe) >> fs_info->sectorsize_bits;
 	u64 stripe_len = BTRFS_STRIPE_LEN;
 	int mirror = stripe->mirror_num;
 	int i;
@@ -1729,9 +1735,7 @@ static void scrub_submit_initial_read(struct scrub_ctx *sctx,
 {
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	struct btrfs_bio *bbio;
-	unsigned int nr_sectors = min(BTRFS_STRIPE_LEN, stripe->bg->start +
-				      stripe->bg->length - stripe->logical) >>
-				  fs_info->sectorsize_bits;
+	unsigned int nr_sectors = stripe_length(stripe) >> fs_info->sectorsize_bits;
 	int mirror = stripe->mirror_num;
 
 	ASSERT(stripe->bg);
-- 
2.43.0



