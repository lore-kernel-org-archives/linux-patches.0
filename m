Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A22C260569;
	Tue, 30 Sep 2025 14:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244063; cv=none; b=OPIdbdyRaIXwEPAe55vc/Ra9ufLSoDLk/Il/zRwxFWTbQyAvRKfMk9zOIU+v/tTREsotGd0W0Ga63XuMtKlMHdElsTMT7MEDudG7kg2LGxMT6DBL+Iph8A5udgYhizCn+OKt9L+z/SzpZxcuAxv4DL+vAsEIMNdIGeXWaTWN/pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244063; c=relaxed/simple;
	bh=CiBYDhqwGmXYphK83GTHRDpnJWeFO7d8p21l7UNvKqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gi1yFueJhR8P0ZVU15Y4fVnL18luNhUKOwmXYcdGcGAw9a0zrqU2mm9fKBAplHef1VtztkuMbB776tsTBhl/yUdq2e7wzKStNKvIUB0VSKxszjFAgeLwaAWc2MqpS0acKB9FAYVKKsHyi0UeheQ8SLO0nU/uJTBawHX8n3Rl6IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfSwg0Qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfSwg0Qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C732EC4CEF0;
	Tue, 30 Sep 2025 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244063;
	bh=CiBYDhqwGmXYphK83GTHRDpnJWeFO7d8p21l7UNvKqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfSwg0QsoAukYbFxkaT2LJZcFVKObeGIR7LbBdASrRkLvsTrXy11SMC26NeWhKKwb
	 mBC20RuH7JlMStHgdB6H6R9cQuNv0jNTIYJIdShsuTPcDXmBpazsqYfj5ePD3/5zwG
	 Cg7SfI2mcN62Scu4VXOMVOnJMtL012qAoF8eOtGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/122] mtd: Add check for devm_kcalloc()
Date: Tue, 30 Sep 2025 16:45:36 +0200
Message-ID: <20250930143823.187734468@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 2aee30bb10d7bad0a60255059c9ce1b84cf0130e ]

Add a check for devm_kcalloc() to ensure successful allocation.

Fixes: 78c08247b9d3 ("mtd: Support kmsg dumper based on pstore/blk")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdpstore.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/mtdpstore.c
+++ b/drivers/mtd/mtdpstore.c
@@ -423,6 +423,9 @@ static void mtdpstore_notify_add(struct
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, mtd->erasesize));
 	cxt->badmap = devm_kcalloc(&mtd->dev, longcnt, sizeof(long), GFP_KERNEL);
 
+	if (!cxt->rmmap || !cxt->usedmap || !cxt->badmap)
+		return;
+
 	cxt->dev.total_size = mtd->size;
 	/* just support dmesg right now */
 	cxt->dev.flags = PSTORE_FLAGS_DMESG;


