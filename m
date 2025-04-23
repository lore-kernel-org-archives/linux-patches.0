Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7818A143736;
	Wed, 23 Apr 2025 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420097; cv=none; b=ZWfweRNUNlwDlKhrHn7xItSVD3aNrUUgsgBZ0CvkfWeDG/z9i3bbPk2f9GiZUn+MLdx7rUOIkQGj2YcPufLs0RpZV/G4wYS9aCEN/+XBlSHX7FyeDy+Z3ngRIxpPESbg5MY5GThBaWABzHc0pJCZPDriyDlrLImxS30wCd8Jz1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420097; c=relaxed/simple;
	bh=U0gXrbJPDB+zwu8UioTJxG6jvZLctjJMJILmNJ29ynQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPQfQb8pgufQgbEZp6uH4wwzNNvSytGreGFpTdZpz20fYhx9GXAFk3l8ULUqg8zD53ObEioV9SRhkoTECLhc8NvSyP99liCqn0glvOpcwRXLbHYTURCjblZspxG7UZAzMMediWxoswrnseyQjwhXqHFmczFRxI/KC79AbRmIWfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6L4kUhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6L4kUhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCE6C4CEE3;
	Wed, 23 Apr 2025 14:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420097;
	bh=U0gXrbJPDB+zwu8UioTJxG6jvZLctjJMJILmNJ29ynQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6L4kUhEgO8WKEYVRxEpmhbkmRjhpUhmh7rpA4T5KdceQ+sdfYSLTQAz9F8VJtqas
	 6JATrwCrsEzF/zgoInI/zw6pVuOrVyVRJYAZ3E7xQgQTMJc12gnXpuRM5cUZY2UzLl
	 lGdomgQ7Wfjtrb7hOlMdXOuiJNHYG/RG8Sp+7T8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlong Xing <yunlong.xing@unisoc.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 059/241] loop: aio inherit the ioprio of original request
Date: Wed, 23 Apr 2025 16:42:03 +0200
Message-ID: <20250423142623.017042589@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for buffered I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c05fe27a96b64..1a4dbd4116069 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -471,7 +471,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	cmd->iocb.ki_filp = file;
 	cmd->iocb.ki_complete = lo_rw_aio_complete;
 	cmd->iocb.ki_flags = IOCB_DIRECT;
-	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
+	cmd->iocb.ki_ioprio = req_get_ioprio(rq);
 
 	if (rw == ITER_SOURCE)
 		ret = file->f_op->write_iter(&cmd->iocb, &iter);
-- 
2.39.5



