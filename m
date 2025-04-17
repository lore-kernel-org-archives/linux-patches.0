Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CD9256C84;
	Thu, 17 Apr 2025 18:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913234; cv=none; b=f6DGzum/xa0odPhYdRQAHgtVyGCbrA+JslIpHhgxERtahPBGYBW6iKno074xdawgTqXBbzwXzeYiCYx8T9O/tk21VKXN2cGujFMTlMQNubPjgZxwdoxNK4qgVULB8xvtBY8CB+OQoERrWdpCtqtmfP2PcS3mXEAZPKn7El8NFGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913234; c=relaxed/simple;
	bh=7rgBi8xRddwsiQGmJwQaRp+oG9zLQzH3DrGfJtjt0ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3Z6ZSfxVDvd4UGtpYXpUp8p16zJi2GJGj6dAaQRPGiFQ3k+Ez/7dsmSLlBE0AvCj/NLzxjN2EnInU4lX82tOU2/u5RrHkMlnQYwImjAxK9Cgf4w/kih3E+7BkhqmrK7D2meRzpEdavJJ36QrUsdrvIOy/NzGUaTWuyPk9sOR4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nz50TwYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nz50TwYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D13C4CEE4;
	Thu, 17 Apr 2025 18:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913234;
	bh=7rgBi8xRddwsiQGmJwQaRp+oG9zLQzH3DrGfJtjt0ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nz50TwYyfVTCCQ/2iwG+LjcIRGsYoFn8zwtE6A6MIccHnYWUHQaJxgvy4v9FzBwGL
	 dUclYItIfZyrZ0RfAsC7CJ/M+ayFkMSnxg8t0pW0e2ulL8AKKDWwS1/KYBnyToTU8z
	 rN8/6Q+3TLbIWoQ6ZJW0/T/DtiqaH40y6d/kCEco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.14 272/449] mtd: Add check for devm_kcalloc()
Date: Thu, 17 Apr 2025 19:49:20 +0200
Message-ID: <20250417175128.996581806@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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


