Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4B82571C6;
	Thu, 17 Apr 2025 18:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915770; cv=none; b=STpcb9+nqe1PJh08YowjieImqn+R5D4wMEStidLQS02VvV+g6mMa4g6BrLK+EyTzpG2SJUeUVzpKZV70uZEHf4U3Al3mPHduX4qWSu90xPnqzeLdN6OCOHAyRIV+8xIW5brhSKobwETW0/Aznf5XEJvbCQ+GI4xaJAYswYL2q3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915770; c=relaxed/simple;
	bh=q/kSTZ0fr3FAlhKGhSYm3L7xt3y34hcUgeHFqygn1dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Olj6/wU19lM9FoFCyYQIhzrEV0hzN+AzU5v3vU74UFmLRP4TAJ6ihL8ysuTtIu5vqOo6/3k6BUCRSerC2jEBm4LqHwE3ubpxEAi3jl2gJBTmhq5/DxwCPtzcIafhvNslQrEjSYQ159PMNbrK/vdj5ywGhEobH66ItbULOioWtPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktYIznE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktYIznE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09662C4CEE4;
	Thu, 17 Apr 2025 18:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915770;
	bh=q/kSTZ0fr3FAlhKGhSYm3L7xt3y34hcUgeHFqygn1dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktYIznE2gxEkDc5vifu0DECZFOARrDPfJ7/f1dHEffSL5FTR+bfYRI4edl5gk+4YC
	 nTxQVtGsGYy8ZVi5BuTnRCRqwlBrkgxO7umoVSDuxV1e1SGDKzs4p1aYfxe2KlLI5i
	 q33T2V8vYjHFxUABtz1gpGDbdG4/4d0k5iISl2nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 235/393] mtd: Add check for devm_kcalloc()
Date: Thu, 17 Apr 2025 19:50:44 +0200
Message-ID: <20250417175117.050286524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 2aee30bb10d7bad0a60255059c9ce1b84cf0130e upstream.

Add a check for devm_kcalloc() to ensure successful allocation.

Fixes: 78c08247b9d3 ("mtd: Support kmsg dumper based on pstore/blk")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdpstore.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/mtdpstore.c
+++ b/drivers/mtd/mtdpstore.c
@@ -423,6 +423,9 @@ static void mtdpstore_notify_add(struct
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, mtd->erasesize));
 	cxt->badmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
 
+	if (!cxt->rmmap || !cxt->usedmap || !cxt->badmap)
+		return;
+
 	/* just support dmesg right now */
 	cxt->dev.flags = PSTORE_FLAGS_DMESG;
 	cxt->dev.zone.read = mtdpstore_read;


