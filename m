Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29CA1C5799;
	Sat, 12 Sep 2026 15:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225249; cv=none; b=mfKmvb5y6RImDVci2FMmqNQqBwWGkx1AGe+DxWWUDybFE6JpEkB/bm7bDsKIDqI3X6lTflzDWh7gSTNPcoPsplTz8YcZVwlqPLP94bGePv7wmhvgHxFvCbKPbGXOWEyQfuIFMbwRo0+WJOA4B6NVIvjYNmBgISaSJer9srt8/RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225249; c=relaxed/simple;
	bh=ast6h7De9nD9/F8DkD5aVO3nSw83SRXjyJpeVJCkQxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuJLLnDcrUJmuO+JKRH/mMyIQLD2cFfH+U8ETk0KbAZ4pzZyNFkrwTRnkO2XvmxfCJ0Gx4AmGpXc9q0JCKWb+x3s+W0UoZevOI9h18d7AM+w8Cfa6filrhDsqRpUwSDX5jZ2w5/OtyU/X3wH8HZklH/Q98KKi5EFAC6+iEFbxnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKZj7+5b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKZj7+5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1A31F000FF;
	Sat, 12 Sep 2026 15:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225247;
	bh=CcpB9Iqz48UsyyfVohq3WMqiO+w6OOaNIpIiaLC0eJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKZj7+5bC/MVgfKDfdep2ca5XW/daFX4gLknueOAToIzTXmHif45M0bpvKj5ZpYN/
	 P/pcQQ0ZWzJBbaER/xx823I3y3oFpwmBPAFWjNZZlawn4esKFkZ49p6Hj+4clwXBwO
	 IVGEf1Q7TCx1+0qLa30wWietSvBioLtPGLI5KHRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1159/1424] nvme-apple: Dont set a DMA direction for commands without a data transfer
Date: Sat, 12 Sep 2026 08:59:51 +0200
Message-ID: <20260912065633.251210424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c2a8c5dcd9537..932b706240f27 100644
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



