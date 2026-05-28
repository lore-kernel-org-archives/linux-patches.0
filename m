Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0DA2FD7C3;
	Thu, 28 May 2026 20:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998733; cv=none; b=Fm6zhqvRE0otUAHM3HSNeUlLagflaNqVQFN9xqROFN/qI66BCUKTW3tfBTICo5oX+6UAdQGebuWLfyaG1/m5YQVt1kzI2EPSpyQ6w4HHtUP3JELhIsuwnFKz5Kq66KLhraBhHS392lQLrlmJVB78biETFXxEkkc2Z5MR5mkiydE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998733; c=relaxed/simple;
	bh=MSwSzDAjJgQqBdo2KBO9r2MnWeMD+u3M6tuX7R50+l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoV3nQo+jNMpIAVKHlthBgkcrZjO3UXPzc4gJWu2wVUYPO2UFR/NNuHR6yGvdv6KkITtDs5wQFDZXpQB1PJpaQm1G9s+Twf15yMSjOSbEGImzcIzj+zGCGcdXiCn+azbZYVGL5ldnEuRlAgIkXGkkEkfrlbfS0pP6gIAn9UCAS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLu3VnQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLu3VnQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC701F000E9;
	Thu, 28 May 2026 20:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998732;
	bh=UI/QwO3VNpwyUOg1SKBgCVDhTMmn8TjAH5d8tg5Bc4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLu3VnQaOjVNLVGgrH9u6r+54etdlo2Q1U3afJYQHvC5e5qHHXFjvnDJU1MOve2ky
	 wfs7UKnwtbcVDyP/FlwRe1TVTlvMtxCfCzJTXF5reOh966hC/LL43VYus6ngyHScVO
	 UHA+II+m70dKA7UGG1FDMyBDKq5LR97fP3tkli1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 242/461] nvme: fix bio leak on mapping failure
Date: Thu, 28 May 2026 21:46:11 +0200
Message-ID: <20260528194654.149109665@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 2279cd9c61a330e5de4d6eb0bc422820dd6fdf36 ]

The local bio is always NULL, so we'd leak the bio if the integrity
mapping failed. Just get it directly from the request.

Fixes: d0d1d522316e91f ("blk-map: provide the bdev to bio if one exists")
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 8844bbd395159..77c668282d996 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -122,7 +122,6 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	bool supports_metadata = bdev && blk_get_integrity(bdev->bd_disk);
 	struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
 	bool has_metadata = meta_buffer && meta_len;
-	struct bio *bio = NULL;
 	int ret;
 
 	if (!nvme_ctrl_sgl_supported(ctrl))
@@ -154,8 +153,8 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	return ret;
 
 out_unmap:
-	if (bio)
-		blk_rq_unmap_user(bio);
+	if (req->bio)
+		blk_rq_unmap_user(req->bio);
 	return ret;
 }
 
-- 
2.53.0



