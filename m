Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47671548C;
	Tue,  8 Jul 2025 16:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992738; cv=none; b=Bb1uylTSw6SHWSseiLw0+F1KwL0qOSKdhZj9kfZfTqQcKlIhrhH0D4fRG1rXnGF+iIShYXYa1dECwct3UAyywcQRi4OdhUDRGSAwH5EOeLMpuskXewvU7SI1q8SmgByQH/S31X+E4gf8IqTTiXGrNbPz0tTU7oo32SkQVUSEDYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992738; c=relaxed/simple;
	bh=mrdLOo5GJw+oRVclQZAFnapCcv8ZQXtFfxqSPhbILeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXqkMK8B4TdRST2iW6N5mbVw26Ej4JmtGpxXlYyQgWsXddduzPI3YzfNipnucpMQlwOO6XTrV/51BFxLhtEzyfE9Cwz7jAi06Gm32SUbugXGE99FVBQIjLj3xDeCcdtXsMXSQB98NjU4SiqsHXbL5flQZU+mfEszZoB8QkMDdc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcEnmrlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcEnmrlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF7DC4CEED;
	Tue,  8 Jul 2025 16:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992738;
	bh=mrdLOo5GJw+oRVclQZAFnapCcv8ZQXtFfxqSPhbILeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcEnmrluAW6lLUPikW2wy55s2pwK8pKpb9Ur25UHj9DZRiz3qqQp/TFcZ73m5iwup
	 dInzI4PH3xYWXf3xSNQmOcg3JrlzLFfOzH7EcHOnSvIseeCdo0mBOGFRoKv3Xwf3A/
	 ylss+JSn20sNGkHGHnOxlsxfrCbH+wBdB7tK4Jo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/232] nvmet: fix memory leak of bio integrity
Date: Tue,  8 Jul 2025 18:20:58 +0200
Message-ID: <20250708162243.085800691@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit 190f4c2c863af7cc5bb354b70e0805f06419c038 ]

If nvmet receives commands with metadata there is a continuous memory
leak of kmalloc-128 slab or more precisely bio->bi_integrity.

Since commit bf4c89fc8797 ("block: don't call bio_uninit from bio_endio")
each user of bio_init has to use bio_uninit as well. Otherwise the bio
integrity is not getting free. Nvmet uses bio_init for inline bios.

Uninit the inline bio to complete deallocation of integrity in bio.

Fixes: bf4c89fc8797 ("block: don't call bio_uninit from bio_endio")
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/nvmet.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 190f55e6d7532..3062562c096a1 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -714,6 +714,8 @@ static inline void nvmet_req_bio_put(struct nvmet_req *req, struct bio *bio)
 {
 	if (bio != &req->b.inline_bio)
 		bio_put(bio);
+	else
+		bio_uninit(bio);
 }
 
 #ifdef CONFIG_NVME_TARGET_AUTH
-- 
2.39.5



