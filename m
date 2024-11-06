Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A781DF99A;
	Wed,  6 Nov 2024 12:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896399; cv=none; b=CIOORm7sKi/BRtrkwsfpEsasVnoD1vCCCtXRBm8wIAxbHN7MrN5UaF7cmk4S+A+feiK6s917lqw9mvKX+ICY+s9SzT/kBS2tQgFt/BoDggOFsMvoa0qgMVgU3tyKiYlALYvcMq+Tp6ORKpZc72u0NhjKYqyPxdx6mjwod6WwhnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896399; c=relaxed/simple;
	bh=2+4hbXzfuC3i0M8Lz/fVGMfwxpXud2YxWYTMfk9Govo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7jcRoBvoDCmPPvtYMTpwDVIlvXHoBVSYZRpXGJdgu/Z2YpLV+ZORmviJPlEViVoCmVo6DdU5zCCuCjYTBUwatcSG6b6rJzmZOue338AWQJnYkOuzdpdjTxPHwptAPLr0Zivg6ixrDRNmr7y/sud3jjPht9dHOGEEa+579vbvV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHfX42aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHfX42aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094CBC4CED3;
	Wed,  6 Nov 2024 12:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896399;
	bh=2+4hbXzfuC3i0M8Lz/fVGMfwxpXud2YxWYTMfk9Govo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHfX42aUxmPl1GWdHkAGYUzXX3Gk59/1NrvEbDva1HGDGpbytM2BP6JAfgl3E3ys6
	 o1d2prGv0EvOvN579xp/e1XffxWGP3+4yfaJ84PmoW7LcsgK/7SPhFPQlu2kQsU0hw
	 onW4hIWV/PL+0m9YzwnHJyeGnkq+iUzRl/9OT67M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 188/245] nvme: re-fix error-handling for io_uring nvme-passthrough
Date: Wed,  6 Nov 2024 13:04:01 +0100
Message-ID: <20241106120323.871466738@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 5eed4fb274cd6579f2fb4190b11c4c86c553cd06 ]

This was previously fixed with commit 1147dd0503564fa0e0348
("nvme: fix error-handling for io_uring nvme-passthrough"), but the
change was mistakenly undone in a later commit.

Fixes: d6aacee9255e7f ("nvme: use bio_integrity_map_user")
Cc: stable@vger.kernel.org
Reported-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 15c93ce07e263..2cb35c4528a93 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -423,10 +423,13 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	struct io_uring_cmd *ioucmd = req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 
-	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED) {
 		pdu->status = -EINTR;
-	else
+	} else {
 		pdu->status = nvme_req(req)->status;
+		if (!pdu->status)
+			pdu->status = blk_status_to_errno(err);
+	}
 	pdu->result = le64_to_cpu(nvme_req(req)->result.u64);
 
 	/*
-- 
2.43.0



