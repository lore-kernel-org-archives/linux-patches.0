Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1203D279352;
	Tue,  8 Apr 2025 12:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116921; cv=none; b=uvnEcL0d+grfK7y7c44n+jBtn4MVebRfcSSXEjOyVU6du3/x4BcoPmQcHWRX6x7Xv7wpMpZzhYIXNFtynx7//vWvgNVCl2puSK417GqbaGOK1mIINg31upZXBbm2XHrfqblgajcKFZWrbqRybwj7XpDylcqtlRSNKm7OLDPuNwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116921; c=relaxed/simple;
	bh=T1zb3Kt5ZYiBzymyZNaakm/nFntKIUkUuf2hOAuQbuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHAGJYYiIdlJkyDzDzIZb8VfppC8gym66dBnFebBR/mCHIkIPSf60axqCVNsPHxULwgm/XaOcLA2nrRU/f5iBGA/p2xVHka1B5iQsKjRHPblNwX4mH1bcuitpVceX6x12mbQb7MKS+s6uNMeatwqyH2q9HudvTqlme0vHeHJ+vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8xcnVTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8xcnVTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAE5C4CEE5;
	Tue,  8 Apr 2025 12:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116920;
	bh=T1zb3Kt5ZYiBzymyZNaakm/nFntKIUkUuf2hOAuQbuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8xcnVTMBBC6wEzCY2TFegEsZU74Lrc0gAWjJYJ3gAuAhiJfHFakiJcSk7jM00kvT
	 X5zWTZ7nNQyVF35bE2xTJsPnMbMuaQLD/BNNlNLEZuqGEHjEK9Y4D5dKnS2d71fE1c
	 Lml9qgBbSVuuQMlsknV/xJDA3Xjeh4saURmywMCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 319/423] nvme/ioctl: dont warn on vectorized uring_cmd with fixed buffer
Date: Tue,  8 Apr 2025 12:50:45 +0200
Message-ID: <20250408104853.244333228@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit eada75467fca0b016b9b22212637c07216135c20 ]

The vectorized io_uring NVMe passthru opcodes don't yet support fixed
buffers. But since userspace can trigger this condition based on the
io_uring SQE parameters, it shouldn't cause a kernel warning.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: 23fd22e55b76 ("nvme: wire up fixed buffer support for nvme passthrough")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index e4daac9c24401..a1b3c538a4bd2 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -141,7 +141,7 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		struct iov_iter iter;
 
 		/* fixedbufs is only for non-vectored io */
-		if (WARN_ON_ONCE(flags & NVME_IOCTL_VEC)) {
+		if (flags & NVME_IOCTL_VEC) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.39.5



