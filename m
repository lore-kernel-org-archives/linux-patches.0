Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5CA2522B9;
	Wed, 23 Apr 2025 14:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419734; cv=none; b=d4fX4B5ww6QmlG0zJE4K+EdUzeW8ArZuZxoIX07dZV75ejl5gamL4QQK7qlHg8dWESzZthJyrFN+Mcu+uOIh/1YDDjfbY/7g5R3e3sEKymHrG2dh5Ls5zZ6sg4Ven9ICurx4quQEP2NffDxe2AnyEiSDJY67WCeLZslhd3p+h1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419734; c=relaxed/simple;
	bh=5sArxFwfGIgtn/BvFRrMx/7e3Woi6UoB4u7tySoDY4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpZ3VnEvVXZgqb70er0MjYhDSBXNQYn00lvXCGRuT7B/dducjov4AFzCW9OkFBXhNIL4zvdyCyyK5Br8lZh3u/MqBwEoOJj5IMakNJZsg9f/Cb7DaIJfuYbH7qOZ7K75IseTYDjFJKZKcR78AY/+IOTUKPS2OiMhzCjA51A34RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlqIsSpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlqIsSpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AEEC4CEE2;
	Wed, 23 Apr 2025 14:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419734;
	bh=5sArxFwfGIgtn/BvFRrMx/7e3Woi6UoB4u7tySoDY4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlqIsSpbckABHTBFSmBaOPH6ls8f5lnhB8jcBSvNLCrDHv7jP1fNRD/7xbsorO8/s
	 3lAzpLKAk2o855WkGv58wtln6+p6nW2s5PvrMtZE0RY4TzrNTojqxfH1s8FfFIZ4oe
	 KqBG19rChiow3+QIADkme3dIYhuHZmQ1pR2jTdII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 009/241] md/raid10: fix missing discard IO accounting
Date: Wed, 23 Apr 2025 16:41:13 +0200
Message-ID: <20250423142620.907158149@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index af010b64be63b..76a75925b7138 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1734,6 +1734,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	 * The discard bio returns only first r10bio finishes
 	 */
 	if (first_copy) {
+		md_account_bio(mddev, &bio);
 		r10_bio->master_bio = bio;
 		set_bit(R10BIO_Discard, &r10_bio->state);
 		first_copy = false;
-- 
2.39.5



