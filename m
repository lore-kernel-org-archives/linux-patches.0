Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB60D347DD;
	Mon, 23 Jun 2025 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686195; cv=none; b=qCuj9JcZaj+4nM+kqGpHSwkEhpfSkKWWXonwfe/AbWtQE4CNLm3GUx+/jTicbCzd9zcrd7POiD2lKamt+Zh1E5/R36UZSDLfmSq7GXjmdyuVwVkKjXNVZDoHmBAwGg6BWrXfVG3F1sSu5VumifiapTboi9QIS/PkFZNcNgu2jdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686195; c=relaxed/simple;
	bh=s/fqaUEoxpBxil9Xr/zTXUv91GvSZojZpfXS80or/tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYWmofCFTmiK+i/Pz8XlIiM0Lu8VWk3leBoN4RDyLZ/OJcw6/i100AWMX8OrMGNv1Kxj6c05mA71PFoO7V3YdibH00qAzJjXGMLJBoyMimbUbqc3vtedpKhlR+wkgGmwZDfv4Kwi9uv7dbswzV06vmtjTfJUVXqcoJKh6fMI1SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meMib5Y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meMib5Y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5179C4CEEA;
	Mon, 23 Jun 2025 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686195;
	bh=s/fqaUEoxpBxil9Xr/zTXUv91GvSZojZpfXS80or/tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meMib5Y/00+eE6YvfsyCPy/3e9o6RC4cjdAHg7XJ3kFgthucfmLzBspQzINalB64f
	 mooKlPlItMMuYAgnYT+RqMiidYMim/c8jiC4Nz3x1l0JOCgLb389AaJOn0V/2KEG2s
	 Nrw2tCEbhHH8AKGkTHFPpPvSFRyWlkTHUVJybZR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/508] clk: bcm: rpi: Add NULL check in raspberrypi_clk_register()
Date: Mon, 23 Jun 2025 15:02:00 +0200
Message-ID: <20250623130647.082478420@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 73c46d9a93d071ca69858dea3f569111b03e549e ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
raspberrypi_clk_register() does not check for this case, which results
in a NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: 93d2725affd6 ("clk: bcm: rpi: Discover the firmware clocks")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20250402020513.42628-1-bsdhenrymartin@gmail.com
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 278f845572813..a7e18789839fe 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -290,6 +290,8 @@ static struct clk_hw *raspberrypi_clk_register(struct raspberrypi_clk *rpi,
 	init.name = devm_kasprintf(rpi->dev, GFP_KERNEL,
 				   "fw-clk-%s",
 				   rpi_firmware_clk_names[id]);
+	if (!init.name)
+		return ERR_PTR(-ENOMEM);
 	init.ops = &raspberrypi_firmware_clk_ops;
 	init.flags = CLK_GET_RATE_NOCACHE;
 
-- 
2.39.5



