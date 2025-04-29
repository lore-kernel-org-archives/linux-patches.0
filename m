Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0D538FB0;
	Tue, 29 Apr 2025 17:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949557; cv=none; b=aYOUvP1fqFBfDHi5OhGIYcGL6HiM+QbeumXFPISerjNk6wmmQvk8XRkglduFXJEtPgafH+cYG3OgNTBjgBl77Z2c7+aSRyEpwlyUKqbpB+P2yqKt79p0KdlrgWvT3Gwx15m2RBJr96zL2kzaTCOD4pZoIwKh8NCJm8WLueVOMSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949557; c=relaxed/simple;
	bh=QcMjeA8IIgxYaYrvEq2gRdPdkLdPv1N6uWwItR9b9Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueWVtRALILtVy7cUEtd3PFU8ZM0im9C6o+KYXH6xGWk61CSi1hZ3CohJ3/K43JElB/AUk26RGCyc1daVSK6Sjz3n+4XPYq8CaEjWzmek25jh9+78+vW2J3mfVceaH2jU9ZUWcoVI8hJ0WyrtsMZkI7QHix6nnLjxHW2x6atQX30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcGhbCRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcGhbCRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D69CC4CEE3;
	Tue, 29 Apr 2025 17:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949557;
	bh=QcMjeA8IIgxYaYrvEq2gRdPdkLdPv1N6uWwItR9b9Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcGhbCRu61eU+EqWhnSlfGmn21qFhxvT+UPOIBoU//tRGm6bMNPpJGeasvLtl6d9e
	 Uh9LwXORV9wWqwpGb/L8R7dVliwR6UXPKLWIn0uBxIbMytyw+ilBOg48eh8E+aevR/
	 1jVJYdBepq0B1olnm1Ih2Tg++GZjmjy5VxVXt+Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlong Xing <yunlong.xing@unisoc.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 357/373] loop: aio inherit the ioprio of original request
Date: Tue, 29 Apr 2025 18:43:54 +0200
Message-ID: <20250429161137.812491885@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Yunlong Xing <yunlong.xing@unisoc.com>

[ Upstream commit 1fdb8188c3d505452b40cdb365b1bb32be533a8e ]

Set cmd->iocb.ki_ioprio to the ioprio of loop device's request.
The purpose is to inherit the original request ioprio in the aio
flow.

Signed-off-by: Yunlong Xing <yunlong.xing@unisoc.com>
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250414030159.501180-1-yunlong.xing@unisoc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 4b7318f1a6f33..a612370dd9ecf 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -605,7 +605,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	cmd->iocb.ki_filp = file;
 	cmd->iocb.ki_complete = lo_rw_aio_complete;
 	cmd->iocb.ki_flags = IOCB_DIRECT;
-	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
+	cmd->iocb.ki_ioprio = req_get_ioprio(rq);
 
 	if (rw == WRITE)
 		ret = call_write_iter(file, &cmd->iocb, &iter);
-- 
2.39.5



