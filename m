Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE78E47D959;
	Sat, 12 Sep 2026 18:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238379; cv=none; b=h4cgNpLEwYDTXrXfnRtZncVUOkfGXmM43fpSStQpkTzPtwz8psRKX1jNJy9HSbPF8GMX5QTviw4G2H7xlkE/LfArtMH/n+0QGlXwrMmmSoRWn8bQgOXMBikH+Xd3EVZzlEBOZ+bEkdBE28R5HmPwhohRX7HQulbSMowEX1Bc32A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238379; c=relaxed/simple;
	bh=Rxk4EJNT9VeHNmoNNR4tvNXy6h1sNNN9bgHwBwCOe7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W42D7p8gwdbdJTLky+wuMY6ezV9Hn+DPBNG04g84rudBOkDDmieiaaDZiUl7MN4iCe4npO0a3J1zS83FdaHh7AIu+k7P8oovEnfwAo5gmVJwMJsvqARKSZonHOv7zBtte497VRBnVYOkXAOqRLC2q+tXz+TEpEhEOEJaLvSUUr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUbfGQSY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUbfGQSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103A61F000FF;
	Sat, 12 Sep 2026 18:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238374;
	bh=vO0C2jgg8jCFLvvLUoOPsyelngaKvIQWGy3/cyFwaKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUbfGQSYqRCb6GK2Ih+tM7I+YSctkY5hzxOQazOjFToxnFt3LdsHbc1IXmy+CRhMC
	 w2bHW6Y5IwVB/cr2eKMh8vm5ajz5SgGDmFkMfPgl4km6qEkAYo8GUhg0ex0Pk1ZlWE
	 GzTUKySUdWXNpGcAEBZ2BZM4+50k3/j3Ftzl0FuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Min zhang <zhangmin2026@yeah.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 406/935] clk: hisilicon: reset: Use devm_kzalloc to initialize hisi_reset_controller
Date: Sat, 12 Sep 2026 08:57:16 +0200
Message-ID: <20260912065536.135882887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Min zhang <zhangmin2026@yeah.net>

[ Upstream commit a8036f4591542de4b38ec81d3e2ba47bc0b2652b ]

Using devm_kmalloc() does not zero-initialize the allocated structure.
Uninitialized members in struct hisi_reset_controller may contain garbage
data, which can cause reset_controller_register() to fail unexpectedly.

Replace devm_kmalloc() with devm_kzalloc() to ensure all structure fields
are properly zero-initialized.

Fixes: 97b7129cd2afb ("reset: hisilicon: change the definition of hisi_reset_init")
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Min zhang <zhangmin2026@yeah.net>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/hisilicon/reset.c b/drivers/clk/hisilicon/reset.c
index 93cee17db8b16..c3b7daac93132 100644
--- a/drivers/clk/hisilicon/reset.c
+++ b/drivers/clk/hisilicon/reset.c
@@ -91,7 +91,7 @@ struct hisi_reset_controller *hisi_reset_init(struct platform_device *pdev)
 {
 	struct hisi_reset_controller *rstc;
 
-	rstc = devm_kmalloc(&pdev->dev, sizeof(*rstc), GFP_KERNEL);
+	rstc = devm_kzalloc(&pdev->dev, sizeof(*rstc), GFP_KERNEL);
 	if (!rstc)
 		return NULL;
 
-- 
2.53.0



