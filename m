Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E15345758;
	Tue, 26 Aug 2025 13:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216622; cv=none; b=M/IR1jVx6M472jj+1KRV9T/OUgOurrZz1mKBXbp1ve0g/388TrKXA2LFOFmBbdfkhTz2/DC+BxvZNHa4hgOxWtfWphDwg47zbM9LN6WdnmpZEpesUYaXQra7teLPAkal6Qdd8lFJHEvzq604ubH3a9IpHPqkJFYUvYBwZ7W1oEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216622; c=relaxed/simple;
	bh=30DaLl62I0gFkyGgmZ0a0phDh74LVRZNkdprM8nR9QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWl7LT9xbe7OrJQkT84eZOgSknRt77LjGbtGrAUhagb63nGYZL/Qt78L5zfw9KoBnM28nLb3fVBxaUC7m4u6XN/oAbyI20bww76a1hLxFhJ8sN2BVJ00oTObYmkD4jaFriTW1i/kZDX2p38nMZA9SkMFKW7nJgS/h6Q3uEt2ni8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0edMyPhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0edMyPhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85F4C113D0;
	Tue, 26 Aug 2025 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216622;
	bh=30DaLl62I0gFkyGgmZ0a0phDh74LVRZNkdprM8nR9QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0edMyPhrGDae+31YdyLz786xZdHe3cJqk4e9dA7dC0MHAqobbjsLJe6KieSvVKZ0U
	 tvM46bJQMuVUsuS4qMdYeZyzQME+fE3Or3QaoNncRmuHhzMD3aCyC5yUCthzIKmwhq
	 IZH6wiESho6BI2w0aDMowGs0NpihXc2QyymDfnz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 481/644] mtd: rawnand: fsmc: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:09:32 +0200
Message-ID: <20250826110958.405395034@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 6c4dab38431fee3d39a841d66ba6f2890b31b005 upstream.

The DMA map functions can fail and should be tested for errors.

Fixes: 4774fb0a48aa ("mtd: nand/fsmc: Add DMA support")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Rule: add
Link: https://lore.kernel.org/stable/20250702065806.20983-2-fourier.thomas%40gmail.com
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -503,6 +503,8 @@ static int dma_xfer(struct fsmc_nand_dat
 
 	dma_dev = chan->device;
 	dma_addr = dma_map_single(dma_dev->dev, buffer, len, direction);
+	if (dma_mapping_error(dma_dev->dev, dma_addr))
+		return -EINVAL;
 
 	if (direction == DMA_TO_DEVICE) {
 		dma_src = dma_addr;


