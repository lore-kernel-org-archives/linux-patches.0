Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E135213A258;
	Thu,  3 Jul 2025 14:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554033; cv=none; b=TJF8YfRp8HBcZ4e469TnENqo3O5qmUzefXXPsUCxX2DiXAkIllfZ3Va/DJRg4wdhxcl75KQRflve3IILqUVaIn7an0dKlle9+pcSSeAj8u3ZnY60483k9dsqM+609adAtYvpP+vrDq03jDwx2QRw3oL6kvwNwd18bp5C8tUUKfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554033; c=relaxed/simple;
	bh=0aSlaV3xrqzXIbqEtxuqO2dyVDqWIZwTIc90T8UIMQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7A5Sf3PxLWt6zyWuQd52R1sptRwEVk8xDI+4+j0tSLLW8DAB5B4pFTxdkHSyMn6hi9PNB3ACNyuUTegvwM05HTQzhuT9l0CthrRh8U0/qZIQBlm9Z+VjALoVLttzz8KRcBEIKNWxmTuPJKiF+47YXUoEsrgcT79QsO4s97RpIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0vvxnR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0vvxnR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4F5C4CEF0;
	Thu,  3 Jul 2025 14:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554032;
	bh=0aSlaV3xrqzXIbqEtxuqO2dyVDqWIZwTIc90T8UIMQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0vvxnR53RdIdC+Be30jRkBQRS9NiuSN9scF922ySTNmPG2i4BvUXQLdIULN07c1Q
	 BD+ZB58zUIZp/FbzHvzEgMcSnuM8RROt41sFMDnIKFLCunJoUEEPlATNfzffODHx2e
	 MKmg5L8ZR1VOBUhakNRQAgR4qYsk0hSG5FIBOMds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/218] md/md-bitmap: fix dm-raid max_write_behind setting
Date: Thu,  3 Jul 2025 16:39:36 +0200
Message-ID: <20250703143957.085773508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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
index fbb4f57010da6..c12359fd3a420 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -787,7 +787,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
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



