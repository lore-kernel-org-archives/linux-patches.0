Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4204528D83B;
	Wed, 23 Apr 2025 15:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421924; cv=none; b=l/hMvKzFTu2mtBimr1y8g2F+v2aES8qqwV1qVY77ZEbxp4BeLy2tgrDoEaxwkBPjFPCC/Nqiyfm0bl7LADWbJRjjCdMfk8edRf7ZNM2vINxhUJPNisbnA9IPbXJAXp8rSTeiWsQA9Ed14sgXYdhbeb3VRHgtC1hF2oaSI31OFko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421924; c=relaxed/simple;
	bh=LcSHFVhh7IA2XQRbGoJ576xksbXf/MZ6aqrxlGk3w0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVPn9pbP73DapzvmPJwtmA4iJlH8lug2LKkLVkZ+jhiwkmPp1MLr+fYQ5Vp2LiX+Eqi9HqIVp3nDq4N+ysi+fn9s998Aw1lf7yUAlNCnu8fkpt2rcRDC00XIeWTb/pYz+lXhXttFPRGKtb/euYfOH1wo8Elpj9uczNKQTiwPD9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMThUwb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMThUwb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657EBC4CEE2;
	Wed, 23 Apr 2025 15:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421923;
	bh=LcSHFVhh7IA2XQRbGoJ576xksbXf/MZ6aqrxlGk3w0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMThUwb/fcZpK2rnKmKjq6uoUBFINChExMyPn9uIPMhjm55Yu1C6GhwS8Xar8sP8c
	 ych0cZb/cHbTBh9qYWraUunoQlZnyQyEcxOPJy5mY8NgoHiUbi311Gxv4q2kppCdB/
	 mfNoSCZ0HXW/jAChUlsvqIOHj+T4tzAstkTQW+xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/393] md/raid10: fix missing discard IO accounting
Date: Wed, 23 Apr 2025 16:42:22 +0200
Message-ID: <20250423142653.541046242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit d05af90d6218e9c8f1c2026990c3f53c1b41bfb0 ]

md_account_bio() is not called from raid10_handle_discard(), now that we
handle bitmap inside md_account_bio(), also fix missing
bitmap_startwrite for discard.

Test whole disk discard for 20G raid10:

Before:
Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
md0    48.00     16.00     0.00   0.00    5.42   341.33

After:
Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
md0    68.00  20462.00     0.00   0.00    2.65 308133.65

Link: https://lore.kernel.org/linux-raid/20250325015746.3195035-1-yukuai1@huaweicloud.com
Fixes: 528bc2cf2fcc ("md/raid10: enable io accounting")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c300fd609ef08..36b6bf3f8b29f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1756,6 +1756,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	 * The discard bio returns only first r10bio finishes
 	 */
 	if (first_copy) {
+		md_account_bio(mddev, &bio);
 		r10_bio->master_bio = bio;
 		set_bit(R10BIO_Discard, &r10_bio->state);
 		first_copy = false;
-- 
2.39.5



