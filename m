Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B875A24CEEA;
	Sat, 12 Sep 2026 11:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210865; cv=none; b=N2/yQvKdrf6bL8LXsWADWCM/bs1NIDytRNDpDOAhJRsuNs16Ji/oFFQ0Hrzuv+lZdNc8VHiOQSlZWUJCEs5s8bh2zYWf9W+vTF9iL6hYqy/tpsxa8PVGSostia/6OmrJuVR0t1wO2DvVHD/qkAUxyDfLVtogrhkBT+xkDAubTHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210865; c=relaxed/simple;
	bh=fCndc7/s0KnzwcLgCkcK/oczazAlfNyEoOdKDbtY49c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mob+ZZZ3TpxYNiaSwmYWYaBiz6FRSFwDY8ZNgT2RotE/yIY7jaGf499PwToC4020xzi9MJQ9QFScx+VT0cDg6A9xSFSS7gS9kDVFhuj/J8LMvbytuVyUqHhRbISjsA+nZwcj20VahI+6+D1r5H+lYImmMg/yJZs24sHsgRLBIUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuW9+mFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuW9+mFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F921F000FF;
	Sat, 12 Sep 2026 11:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210864;
	bh=lLozXqj2jDRDzVjEx8OOSXQ5/VZ5RwkFJtrqmq523vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YuW9+mFiziDA0Vb8UVVGBRkU5n8XpCAM/sUAyl8kNx9ya7egIZ/ynlO9OVEVuZTop
	 yIdd4eI54cAEYQcR7ja7hm6JDpiEyiRmqBs0vFw2IRJofJgPmidwIHYMKp2qAZku/m
	 LWPsrj8DaUXnZCEyItZdyEbOngwI/0IWWdBTcav4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1114/1518] nvme-apple: Dont set a DMA direction for commands without a data transfer
Date: Sat, 12 Sep 2026 08:54:43 +0200
Message-ID: <20260912065648.653374073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ef3a969d68430..ff2b5d063024b 100644
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



