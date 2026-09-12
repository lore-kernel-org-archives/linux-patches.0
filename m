Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B557B3630A5;
	Sat, 12 Sep 2026 08:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203114; cv=none; b=aRgSeangrQ/p2exo3Apyygcc4L8V8oKmgY6RsugUhkWPVA8Bjo1grSFd12IzCfRdEeu/LNwarZC8hey+nSHHVWCyfHun87/yWY94Gqx5LqC6ONMKW4OPWlOW91/hqr7nDVvLraYCZ6AIP30tnEjZ+S8wDZQo2OMBe/HVmacotUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203114; c=relaxed/simple;
	bh=axSVCjrpEuIDiuZV+W4lp371sM5fkGrE2cFIpHZN4lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKzz6a1cc0a7g+88ywKqhYm0BpPfxkeuQQhem5LUXoaRN1OqjBqG/ntNZqakhSK8n4ouS6H3WQvz/NuuXTnBe5tW0sG/Vu5csOdS7ZNTASCLvAkOjsE8DLAulcR11wTeOAYDkHzgwej+TyVkS8A+/4dK/dcorMxbILKjSJzGqbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oq2C8K58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oq2C8K58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEC51F000FF;
	Sat, 12 Sep 2026 08:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203113;
	bh=7Sdt6JhD5KjA84qxmUQww/uzxDAxVObpI9N2xiJ7SPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oq2C8K58ekPLggHd3UXGsdY6xWQC1IF5/dYWzH1mxu2KPd8qolWe7Oug+G4uTq4jP
	 PxH3KdAvct4y53lthidNV1yTa8HkN5XdexmxSVM+s+fJD7PaKxj2NUXAmEsy4n8NTD
	 xNiUSRzFaAiNEnqL73YSx3KP8lyj2IH7l9AaXv80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1343/1815] nvme-apple: Dont set a DMA direction for commands without a data transfer
Date: Sat, 12 Sep 2026 08:51:33 +0200
Message-ID: <20260912065720.552728459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 089637a373fdc..60dffd3fa0fbc 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -341,7 +341,9 @@ static void apple_nvme_submit_cmd_t8103(struct apple_nvme_queue *q,
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



