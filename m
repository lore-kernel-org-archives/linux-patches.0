Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAA9293443;
	Tue, 17 Jun 2025 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174437; cv=none; b=IO4puWSeQ2kIsunT0GG8vukjlagdPafylDJznsQDUcsF/pPiDRKsTy1Er7XdLKaJEC7jbjnyifJcXPfcK6qPafShW2YtyiJ1PHT8NV9oBa2kJKA1/9ofY33ll2vRs5s1IOAJTVjbVwGsVjeZrU8ey9ffE2Gw0x1y7OvA9Gh/wzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174437; c=relaxed/simple;
	bh=qQlbvoeBR8XFL5vST9cHQG5ylSWppn2blaGQPV63ARg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCIiLXc4vgT4Gn/KuDfyv1FEImyZXN0QDjsXviT49kpOgH4FDAkbJt45Ii5bqEapA+PZjhBGEDEPVEdj4mEpoJ2GPurqgPupV05lxYAqXMcbGS6chjzCi+nTX8za3GU0d4ZAo1DvTEc82+6VBuYOkkriqdncrDSo1kh/uAQOk6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU7aKYLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU7aKYLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A79FC4CEE3;
	Tue, 17 Jun 2025 15:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174436;
	bh=qQlbvoeBR8XFL5vST9cHQG5ylSWppn2blaGQPV63ARg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UU7aKYLDPUEwZN+oibiOUNKjtW1NPH/zA9W/iFtiYeCN9h9gT4U+ArUfTQWzt8ASr
	 yO6V/6S8Uj7locUSbov70zVjQMv6xrSoEvX+iiLIs64lEp34E+K5dOi8uzA8JY360e
	 QWGud0NOUiXyri82zOzNhgnjVPH8jaIR7njsCmVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/512] brd: fix aligned_sector from brd_do_discard()
Date: Tue, 17 Jun 2025 17:19:45 +0200
Message-ID: <20250617152420.310729835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

[ Upstream commit d4099f8893b057ad7e8d61df76bdeaf807ebd679 ]

The calculation is just wrong, fix it by round_up().

Fixes: 9ead7efc6f3f ("brd: implement discard support")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250506061756.2970934-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/brd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 292f127cae0ab..9549cd71e083b 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -224,7 +224,7 @@ static int brd_do_bvec(struct brd_device *brd, struct page *page,
 
 static void brd_do_discard(struct brd_device *brd, sector_t sector, u32 size)
 {
-	sector_t aligned_sector = (sector + PAGE_SECTORS) & ~PAGE_SECTORS;
+	sector_t aligned_sector = round_up(sector, PAGE_SECTORS);
 	struct page *page;
 
 	size -= (aligned_sector - sector) * SECTOR_SIZE;
-- 
2.39.5



