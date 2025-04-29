Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32CC2528F1;
	Tue, 29 Apr 2025 17:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948836; cv=none; b=oWloOTFSb60i8PwKoYRrhzaCnXmL6aJSRQba2QDmqTbzJfSLFVKP267VSj8m4cOd5PRdzfOZsQJFpcj9oPMqP2LNf5P9vsaHs4xuGUxvoerCNfhvA3M6Sh/2AowP2wrhOlQqfeOfomWa4sshv6McJImGyMOsGv59ekGPjkVngPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948836; c=relaxed/simple;
	bh=0dKhmXcJEMA6Y+10g+u5oEpeKMJOQR+ICARTUFrzxTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQeINPCuOV1uhp/fTi5ikS2jcrwcgCz+XhkF0a/1YeI57XFFuA9PDodo8PoRgPIQ/fGiROUeXEafYtrg8B/EgkD6uAi9RrnEUDMDHi6KbKK2Q3rB3Eery/SqvNQxF+h/Z2s7sO2IgD2v7c2AI1BTe7vpUa8rgVSzz1qzsoOND6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHfYbl6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHfYbl6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35176C4CEE9;
	Tue, 29 Apr 2025 17:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948836;
	bh=0dKhmXcJEMA6Y+10g+u5oEpeKMJOQR+ICARTUFrzxTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHfYbl6oZjmjx60voAR36U5w9swR/OA7aKh8kfO5G6vgoe+uHx0CzbUyjvdnrEPaw
	 iJnjkzmoComTCpGhWkNqWycVc+kzS8GfWlrAhnXdteYVzWNp0d5KBiiaAysLNmOHxB
	 RxkfHaH1vTqZ942PWHpQut6IzMKIVtaBzLeVSImI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/373] md/raid10: fix missing discard IO accounting
Date: Tue, 29 Apr 2025 18:40:09 +0200
Message-ID: <20250429161128.596931365@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bdd5a564e3191..e6c0e24cb9ae2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1771,6 +1771,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	 * The discard bio returns only first r10bio finishes
 	 */
 	if (first_copy) {
+		md_account_bio(mddev, &bio);
 		r10_bio->master_bio = bio;
 		set_bit(R10BIO_Discard, &r10_bio->state);
 		first_copy = false;
-- 
2.39.5



