Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69C61A3142;
	Tue, 15 Jul 2025 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586356; cv=none; b=X8DzlMEEbXGZqk1zTN9HrXHfMojU1m70+v9UOMTpGhglmSfBCnlnQ4l115W1rQXXh3YpZZ/IWQ8M1aOceHDie+pPvWOs588wg6RiNW9YH12N5ZVAkML1MY2+lDp64wWdH55sJm2G+xNvtYg9KrpQqCb0+FbhkbQwGRfQt0njEkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586356; c=relaxed/simple;
	bh=B8QJsYHFqByveVlI0nvk1FGESFnm+51uDe5y8LfG6rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKBp8QWLtx8ZZH9wrJmHjUaaNvP1KeuubYLgouUo1BwhIMBEo0eASbBBJEdoBoRSqv8zojPY3BGFDRk+T/D4vKkeinZdC3beKxReMgNupk1Kjl6Y4aPt+I9c7wSJU1j4c7WYsZSlcnlplkgfFR1kTtzphOcjN0tnCnJhu1iflxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOymY30k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOymY30k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E1DC4CEE3;
	Tue, 15 Jul 2025 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586356;
	bh=B8QJsYHFqByveVlI0nvk1FGESFnm+51uDe5y8LfG6rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOymY30kfv4cz8qqIZ9oOcAXs5++zpkfF7I7r0JGE6ImirtKSm3bj67M6x50o3hFl
	 JCySOcFVL3MiOxOXjFWjreAhSI808xrqbRrja4xTF12x1swLmflpPaukzwDKVVvBKQ
	 83IGn+xVMGsNAhSFlZNZIU4HJheTXIHGRD8cyVTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/148] md/md-bitmap: fix dm-raid max_write_behind setting
Date: Tue, 15 Jul 2025 15:12:07 +0200
Message-ID: <20250715130800.514944934@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8fc85b6251e48..feff5b29d0985 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -549,7 +549,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
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



