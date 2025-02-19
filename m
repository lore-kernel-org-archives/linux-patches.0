Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21F81C5F0C;
	Wed, 19 Feb 2025 09:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956474; cv=none; b=gTW4sLj4C4dKK3QG7LN8s3IC9rebVhbBR0HsZgoyISy9rTvKsy2nFnjh3k74EgdNVm/iWTJGGHmaVE8ZNE+TZ+TSxO9lWVIh7vLhocUu7GBWWWIhMHN4R1T4YwH4Eywa+wotLsL7tXII8mnY/r2JHl7cIfxTiQsntXUEuHWdgt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956474; c=relaxed/simple;
	bh=Hh7VrLDhzXAfD4cCoFZizzrR+UFtKjJyCDeaH0wGgWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MW17yQ83jhqjkmtfuT2Lf7OjjMOrcVf3lL4iXI6OsnENyov3/d/KZP+xlneOk2f+WmMcyfNYdkxP5rA6eXJqUJjQhiC1jEuRoft7JRS54SYndypHC3aVM9HsPDRP9NFYA7thcFS3u7TU2P9V/mNLC5jjcWcvXGJlovNg8zg+N20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZuQT02/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZuQT02/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE25CC4CED1;
	Wed, 19 Feb 2025 09:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956474;
	bh=Hh7VrLDhzXAfD4cCoFZizzrR+UFtKjJyCDeaH0wGgWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZuQT02/JAXO/eXp5a4iYbe2sNaEdhQiUdDK0pIGB/WdOCsemzkBUqqTJsW1YleR4
	 HtXlPDYcUSCCoFE7vatTkmU2zbO7Pkbu+34U7KufXzWbIwEQzFRL7oE8SFtHVWCacY
	 43QUXSPz83oLOhyIEuFdqwTf0iIJdJb2Hj4gizIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/578] media: marvell: Add check for clk_enable()
Date: Wed, 19 Feb 2025 09:23:15 +0100
Message-ID: <20250219082700.478172990@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

[ Upstream commit 11f68d2ba2e1521a608af773bf788e8cfa260f68 ]

Add check for the return value of clk_enable() to guarantee the success.

Fixes: 81a409bfd551 ("media: marvell-ccic: provide a clock for the sensor")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
[Sakari Ailus: Fix spelling in commit message.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell/mcam-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell/mcam-core.c b/drivers/media/platform/marvell/mcam-core.c
index ad4a7922d0d74..22d1d11cd195a 100644
--- a/drivers/media/platform/marvell/mcam-core.c
+++ b/drivers/media/platform/marvell/mcam-core.c
@@ -935,7 +935,12 @@ static int mclk_enable(struct clk_hw *hw)
 	ret = pm_runtime_resume_and_get(cam->dev);
 	if (ret < 0)
 		return ret;
-	clk_enable(cam->clk[0]);
+	ret = clk_enable(cam->clk[0]);
+	if (ret) {
+		pm_runtime_put(cam->dev);
+		return ret;
+	}
+
 	mcam_reg_write(cam, REG_CLKCTRL, (mclk_src << 29) | mclk_div);
 	mcam_ctlr_power_up(cam);
 
-- 
2.39.5



