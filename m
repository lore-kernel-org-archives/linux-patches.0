Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DFF375AAA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301625; cv=none; b=WBSnIbVohfPzti8NAFpUp8rj/eM3Ke8Trr9dZmOt9IWDvUFlAHzf1OnEoyR6KrZf28wd39YUs46XQZa2RrIKgOA42gCejdrSqHH3KlzHnsejuI950rEDuHP5jXZX0TYBNBAdhxqAZ4qJkaCEhmHx2cdbjedLjHBSpfnPrO5TcDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301625; c=relaxed/simple;
	bh=mGjJqr2bLuqmF7siDZETL9TJiVks8jJ+bgPMXXiLmxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkHzv3m1RwJV5pGX23SwIRWMX166ETbfRDCiwmbYs0oL1bzcFjdZ9D5gcPb/UKwgVwE90v8OIKomVH0tk/lXa5aX+/CRJhINgOSbtPTjlI0APVJBLpDq5EeCyvKmjdOjLEn9/7zHkvGG2gqnxHFRlUokGfLFA3EIFxkrfCLyuUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDVLilxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDVLilxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8204C2BC87;
	Sat, 28 Feb 2026 18:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301625;
	bh=mGjJqr2bLuqmF7siDZETL9TJiVks8jJ+bgPMXXiLmxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDVLilxFaiz5moEICrrMhoOWc1Y941zmjXiMo4c2izoIG04vMssPGcNNSxuUZqQIj
	 dgZeM21sYpZK3F0Z9kZIMRBUAXgUumKSFLWtyIDlw/xG4+xUVb1TquU38bhfiL2ght
	 24jK0KyHZGTrqe9V4VkPbJqCghBm0JeGDVH9BSCwEO5XPhQV4bf5B7+TQHRzQ/1njy
	 vjFdVbdiT8M0h9wvBBWt0YW9lgeH9FKuKbWisRFKidEOLI0h8kp4wc3N59/bwMKtGP
	 C9C4rZwLv5RhePl8TjSIuQ3qckW5EH/Wk36YQyX6KTAyMyLfRJ+e6bcYy1r2rx9qV7
	 6IVssTymSnOSg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/385] i3c: dw: Fix memory leak in dw_i3c_master_i2c_xfers()
Date: Sat, 28 Feb 2026 12:53:58 -0500
Message-ID: <20260228180011.1568201-16-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 2537089413514caaa9a5fdeeac3a34d45100f747 ]

The dw_i3c_master_i2c_xfers() function allocates memory for the xfer
structure using dw_i3c_master_alloc_xfer(). If pm_runtime_resume_and_get()
fails, the function returns without freeing the allocated xfer, resulting
in a memory leak.

Add a dw_i3c_master_free_xfer() call to the error path to ensure the
allocated memory is properly freed.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 62fe9d06f570 ("i3c: dw: Add power management support")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260126081121.644099-1-zilin@seu.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index eca54cbc1c29a..4c019c746f231 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1102,6 +1102,7 @@ static int dw_i3c_master_i2c_xfers(struct i2c_dev_desc *dev,
 		dev_err(master->dev,
 			"<%s> cannot resume i3c bus master, err: %d\n",
 			__func__, ret);
+		dw_i3c_master_free_xfer(xfer);
 		return ret;
 	}
 
-- 
2.51.0

