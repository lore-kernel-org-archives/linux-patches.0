Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDD127EC91;
	Wed, 23 Apr 2025 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419610; cv=none; b=ea0JxjSMTUtaIjptr2F1keqlp9TEyGo+Xel0g+tzRQKfeulbd2HK5agsQocWM2yggQKVVbQG0vXQEnocAD78j6XbpV6+AjCE0hJztxgpnKR1iP2XaWzCBR+TB045wjdHFK4ZNq/sBYBftgcAqYm27fxFswThcYGU+Y5WL0RYYH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419610; c=relaxed/simple;
	bh=JbeAlUdCUUugWBlxoWGrr1XsI1e4q8rrQxw74RoiNqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIcBIJId45VJXlrYjbmfpSkTDV6UeGfwVQYEnUWkWZSBkGULO4SkfoFEWIvgZkeYoOyLHOS7JDg82VG8DLHh96tgmKIqxFNpstq9Q3IvpWRVXLVgIDLrtwW+vHd8qcjnuwfj55YwRSx9376Iu41ygQr2V/BybTVXTS719CInZtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAtObwFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAtObwFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E105C4CEE2;
	Wed, 23 Apr 2025 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419610;
	bh=JbeAlUdCUUugWBlxoWGrr1XsI1e4q8rrQxw74RoiNqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAtObwFYh4oeXEvy5WeWtZjyQMyLiWuxyUNCYqeFY7utRenTKd9m9AVvbPWGB5l5y
	 KVwjOs0cuIg1BSPPReWJBVPoD7NRw3xBmIhHDasL6y/hNqFzz4RvPnLyGQi0qoiSC3
	 2ARZhXUiDRES2mnnAPnhgCPTBD41t4I48ubkg75Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/223] md/raid10: fix missing discard IO accounting
Date: Wed, 23 Apr 2025 16:41:23 +0200
Message-ID: <20250423142617.580729571@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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
index a214fed4f1622..cc194f6ec18da 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1687,6 +1687,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	 * The discard bio returns only first r10bio finishes
 	 */
 	if (first_copy) {
+		md_account_bio(mddev, &bio);
 		r10_bio->master_bio = bio;
 		set_bit(R10BIO_Discard, &r10_bio->state);
 		first_copy = false;
-- 
2.39.5



