Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5C6347FEC;
	Sat, 12 Sep 2026 13:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218026; cv=none; b=dIKdpsi+I6o5aot0pI70qGikguKFnWHd8xei7Ust/4YFlgMIe/Y+yBtuJrtORFnZ9O4/BnPvgwpt4CdkPikorab58YMydatAd9c7Ej05a5bfD1jwYPM1nx1GU+SwqLcvQnhrsgYVQaA5Ll6laxnBr3+/HKlyUGGV6ibbQJx90Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218026; c=relaxed/simple;
	bh=lQXfUhZOAdFgZf8c1/0wP46f0jK6ZPIFf5LDwuDRjTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nt5up0e1UU4kMWPCAbDR5JVy1WhNe30MQ3s56FK8N+N+bRml/GgE0X57ePSfj5NE4ZYbMjl/Xz9UOBeQiIZH4cjgmXcCXUwOFCDJcwBUNkia/toG5KARWSQyYf9w/HZSLUw+QUMk1hf5gy8PpCRQH9lnG/xTqGI6gjhRXxFbeCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSHTBAN/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSHTBAN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063B91F000FF;
	Sat, 12 Sep 2026 13:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218025;
	bh=9kGlVYkBoTtBhqFcmGQqizSlpTca9VI6Zd1raeT1v60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSHTBAN/iWD3jLbR3JlKS3MAgxzNPqG9EzrgH7B8Modtp1ztckObaNnk/vB21UOCb
	 hSg4IdNPipu6MO34mzPDmDLSmCIxoVLTjIGZUHeY1sV9mqyhvsWr6Vi79/CU8ki8Xg
	 iGaqARa7TAXiYt20HU14gSjCetC8uxC8KbNzuaHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1058/1376] nvme-apple: Dont set a DMA direction for commands without a data transfer
Date: Sat, 12 Sep 2026 08:58:04 +0200
Message-ID: <20260912065631.139819107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

[ Upstream commit 94dd5804938d6681dbf26f023b1356d511f4fc48 ]

Setting the DMA direction for commands that don't do any transfer likely
triggered the PRP NULL check for which we needed a chicken bit. That bit
has disappeared starting with macOS 15 so let's just do this correctly
instead.

Fixes: 5bd2927aceba ("nvme-apple: Add initial Apple SoC NVMe driver")
Tested-by: Joshua Peisach <jpeisach@ubuntu.com>
Tested-by: Janne Grunau <j@jannau.net>
Tested-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 4f69170631d3a..3d0443cf55f42 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -310,7 +310,9 @@ static void apple_nvme_submit_cmd(struct apple_nvme_queue *q,
 	tcb->length = cmd->rw.length;
 	tcb->command_id = tag;
 
-	if (nvme_is_write(cmd))
+	if (!cmd->common.dptr.prp1)
+		tcb->dma_flags = 0;
+	else if (nvme_is_write(cmd))
 		tcb->dma_flags = APPLE_ANS_TCB_DMA_TO_DEVICE;
 	else
 		tcb->dma_flags = APPLE_ANS_TCB_DMA_FROM_DEVICE;
-- 
2.53.0



