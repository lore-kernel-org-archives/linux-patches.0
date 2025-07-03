Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BF02EF64D;
	Thu,  3 Jul 2025 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555466; cv=none; b=UNwt/E1sIWZU2aaeU2xKGchiCkMcMYZCSmuyy8rPkwERSpRXGtK0oRlIofSlCf1h+BZC4rHZOYhK0YyF2yHDphAWrLU54/7tlKYBtpRDH5tbmfbqDG+gr1xwb0SecXYo8LV8amSrzNXOz/hkn+jSU5eX81rwjUF11wkz+v23BOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555466; c=relaxed/simple;
	bh=EykCqYh9zAKVysivYDCXHnENReghjqd8mvkJ6vb48/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwdONLWT9MdhMQCO30kH8DwBeHLyyCSYS+qIUp7OQZjb0yjYNyYmm75znREkBspWiYAlEE34s/S34TjVOvqdpAKUINDdYHNCj5jZt/y5ZHaGQOXqA34ItN+fljdTFtJTgP2gjShd4SzDx6Ac+V2KR1ulpntsN8dCWPrshAhg/DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aq2XhbFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aq2XhbFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225EBC4CEE3;
	Thu,  3 Jul 2025 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555466;
	bh=EykCqYh9zAKVysivYDCXHnENReghjqd8mvkJ6vb48/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aq2XhbFYoYlsyYVrTQIqC2tBTx1rehZR+uKHkgkS4LU+bWKCJFEaxy5DBsF5pQbS+
	 JShfQNpwJs8Np/alAGM2LvxBFS7lbbGLjI6yf4xF0TUvn21Rh+QyR6LFZUr4zkIlGB
	 mYL5xMZFSkbB3qDEBk33O2wSXLcIirPwh17nMJQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/139] md/md-bitmap: fix dm-raid max_write_behind setting
Date: Thu,  3 Jul 2025 16:41:25 +0200
Message-ID: <20250703143942.051102151@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

[ Upstream commit 2afe17794cfed5f80295b1b9facd66e6f65e5002 ]

It's supposed to be COUNTER_MAX / 2, not COUNTER_MAX.

Link: https://lore.kernel.org/linux-raid/20250524061320.370630-14-yukuai1@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 8317e07b326d0..21decb97bc050 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -589,7 +589,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 	 * is a good choice?  We choose COUNTER_MAX / 2 arbitrarily.
 	 */
 	write_behind = bitmap->mddev->bitmap_info.max_write_behind;
-	if (write_behind > COUNTER_MAX)
+	if (write_behind > COUNTER_MAX / 2)
 		write_behind = COUNTER_MAX / 2;
 	sb->write_behind = cpu_to_le32(write_behind);
 	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
-- 
2.39.5



