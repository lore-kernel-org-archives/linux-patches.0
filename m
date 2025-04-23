Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5351827F4D9;
	Wed, 23 Apr 2025 15:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421032; cv=none; b=R3+HLBSntr8Hwa5V+SWgbzI1gAqHt022Y19lqGJSeKizT4ixg6lfCdh/b6a1AGIVvuFqySl0kIoyYUw3RQTGg6pLNCD2LWcjTh8R6xN0mBY1KwTKAvsk3ZVPrj1pfK6ADzHqBsbOmJqPGU4khzthcufU2Y+e8TTXcK6Ez5WEn58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421032; c=relaxed/simple;
	bh=qcugQ59Gf5hyA0swEso0Vq90cFVJCgFGT7BzcYIhAcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLn2oCbAiyEeU5Tk1/j2e+nqWoBICcUhjKE17rvLVel0F4O4fJbc7APMxuffvkM2pDLYqB4WNhAkE/pjlR6WitwBmtkSDcIMChGw8dceg4teEZ6ovZcWHU6P3fNpE5AD9URJFVvPmAw10JPBwB6f01xtb+uW8RYOuzuNo3+i6ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geb/xcb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geb/xcb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFC1C4CEE2;
	Wed, 23 Apr 2025 15:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421030;
	bh=qcugQ59Gf5hyA0swEso0Vq90cFVJCgFGT7BzcYIhAcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geb/xcb81U/Eks42MlmVRTzcLiULPfRStNKVtvjqiJP+9LEDL1Qe+vafIS5Ndc5dL
	 bKOGFrwkmUIvMKn8jxIfsMyvNYCiKM/tyIZ1Y2LmVXSVW2eVdHsE6stl/POLIHIn/n
	 GtS9vOu02P14vJUTBuhlSa4AJNpetwOP6HRlt8qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 102/291] mtd: Add check for devm_kcalloc()
Date: Wed, 23 Apr 2025 16:41:31 +0200
Message-ID: <20250423142628.519755619@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


