Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2094BEE3C;
	Sat, 12 Sep 2026 16:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231225; cv=none; b=dB2CA4cN/TxhoPwmhKInPHrQZRfB+ccAv+/RrY7yUxn/yNA1pQLt7uHbpiRY2HSPZqIthbedfijAmZsMg1ZAztg+ZK5ple1dBJyLtatUuiyJXTkl8cyoJ6QN9pr/IUrtUGWKCgukzuZEDNpoeTDdoSSfldkepTyIFjTbkD2yHT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231225; c=relaxed/simple;
	bh=oPIeWfjmnMKzHdcHaehWmQNsGoLLbwan4xzNdCcDVl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM/wth7JS37a9b4FbRQE2khrMtqnTsGWOsXZCkipm1d505wecZu5tPBLqRjaefj9K5N+6jxjrtdD/oyOAGrtDJWsYy+bZEaYQ0EmWyz+znFppTINMskTgkDK7r9VEmvDVCExdwgFFssSJOPNd+vY2E9+sJ+ppS7rE0VWjkI9spM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnH7DalX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnH7DalX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFC41F000FF;
	Sat, 12 Sep 2026 16:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231223;
	bh=cap7cYx2ZfASzbhmhhry3bgiWWJh1nX2C5fjuigfLvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnH7DalXhIxyMYAVMXeZERjo8pfp8UgMfhMg/slR07NJyzVxp8ni5Fajnq4suENux
	 qkSzkSFttIDbGmGx0Jl5wrylkqYsR33o0K7ejXdfel2w3hjszUC9hAOYf2Mibl8Liq
	 8E5rEav7bZTEauSQ7+uuj7lLCQjNJc73Z48aMThs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0954/1191] nvme-apple: Dont set a DMA direction for commands without a data transfer
Date: Sat, 12 Sep 2026 09:01:22 +0200
Message-ID: <20260912065609.650684263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e6f29b402b71a..90d92728db6dd 100644
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



