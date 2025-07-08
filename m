Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF562E540B;
	Tue,  8 Jul 2025 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993846; cv=none; b=X5MTkir1KV6ADHjAs7JYYWyhmCmrX13AJvNbdrq2yI71OtnZJpHkNKkEDmjuxP1dXUa3CxwSeR2yHy3NM7EDKdj2Mpg8olUg0nRJNVj3WJycFk1a99voAQiGSPtUoOPW0do+8TH2pdLPYpTThFpnciRnqtGXSQwQN8KQsNAzQxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993846; c=relaxed/simple;
	bh=P7u7dK2cRCvjQdW4pYMIOl7E3j0pNQnuXQ1BxpybrXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErFVNBgnXrAi23qHjBiWhLqT0CcphIpXNUEQpcT7mLdUv+i81mq15OUkc6peRTOkcGM+slsy3TzrD/DzZrdQx1WqMjbUIeX2khYg074zFTYT0gg28fJ9bszKkcd0esu7j+0NBunF7cBo91PXqJelw/IH4EI0qlfnr7w6M8Ub8yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAZJGNfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAZJGNfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCD9C4CEED;
	Tue,  8 Jul 2025 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993846;
	bh=P7u7dK2cRCvjQdW4pYMIOl7E3j0pNQnuXQ1BxpybrXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAZJGNfnEiooyWzCzpXDMsHfIzDn9l2rouHirtRGc++rg0FVVQi2C8K8adgM4UDgA
	 d8bForNbK9fLmiTUTYHe7FgWUXarRoft+1SoD2TBpiHha6JWaQuY+48LnCqQjC1b1L
	 42OSzh4DvKc1yfeW670JUGEQrk842pdt+c1793rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/160] md/md-bitmap: fix dm-raid max_write_behind setting
Date: Tue,  8 Jul 2025 18:20:47 +0200
Message-ID: <20250708162231.793853948@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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
index b26e22dd9ba2e..cb84a4ab8d70f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -546,7 +546,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
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



