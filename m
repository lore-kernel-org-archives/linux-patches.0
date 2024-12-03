Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8351F890F;
	Tue,  3 Dec 2024 16:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242850; cv=none; b=JNXAhuNP+lPvwPH4u+GfCJIxjoR6dkzblme4ndAc6BoJOUr0y2GN5DVio78oI6A0FbpDDo2bD+yZvfhXpDQPZ0oNvZ4kKPdesJZCZ2fEOdnCEs/Ujv/PFFmEdmggCz2DSEn2TK9FCrYKZXCJY6P172w3RPoq90e5SrJRkUTcdtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242850; c=relaxed/simple;
	bh=VF6H8IfHKlNoOkM9tRSMklfzABQ/O0iNTbm/Yw56nqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/47+X99PlViZco9HKNjQqE0+2VlWIxit1QZzoZc9OqG1G2GKR0WNPo3IaDrZ99wG4KZEoYHikCnw3Kuar97ErfScRLaNlryfD8IGllaPPnNag3bzBm0//e4DibJypOmKtCqlBw/6SfB6xOp53nuHAySOoITGK6qIhWkzASxz0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUwBE8sA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUwBE8sA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FE5C4CECF;
	Tue,  3 Dec 2024 16:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242850;
	bh=VF6H8IfHKlNoOkM9tRSMklfzABQ/O0iNTbm/Yw56nqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUwBE8sAMNfqJICeiaeOyZnPTMIsD8sigiK7hSZpfoaoQ7TqS8S+/PbOj+AdCc8k6
	 +cRi15+2ibyo42FDJDDiXI9ggDyrzwVfMDE0WOMEktUysVZc1NJAHct2nhoeG10975
	 kUAidpsRL/LGeOjRtzdu7H5rbobJnOYn2DASBFPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xianwei <zhang.xianwei8@zte.com.cn>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 821/826] brd: decrease the number of allocated pages which discarded
Date: Tue,  3 Dec 2024 15:49:08 +0100
Message-ID: <20241203144815.777461292@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Xianwei <zhang.xianwei8@zte.com.cn>

[ Upstream commit 82734209bedd65a8b508844bab652b464379bfdd ]

The number of allocated pages which discarded will not decrease.
Fix it.

Fixes: 9ead7efc6f3f ("brd: implement discard support")

Signed-off-by: Zhang Xianwei <zhang.xianwei8@zte.com.cn>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241128170056565nPKSz2vsP8K8X2uk2iaDG@zte.com.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/brd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 5a95671d81515..292f127cae0ab 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -231,8 +231,10 @@ static void brd_do_discard(struct brd_device *brd, sector_t sector, u32 size)
 	xa_lock(&brd->brd_pages);
 	while (size >= PAGE_SIZE && aligned_sector < rd_size * 2) {
 		page = __xa_erase(&brd->brd_pages, aligned_sector >> PAGE_SECTORS_SHIFT);
-		if (page)
+		if (page) {
 			__free_page(page);
+			brd->brd_nr_pages--;
+		}
 		aligned_sector += PAGE_SECTORS;
 		size -= PAGE_SIZE;
 	}
-- 
2.43.0



