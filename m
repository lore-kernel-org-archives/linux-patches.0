Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A51268C73;
	Tue, 12 Aug 2025 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021406; cv=none; b=RzqFNVOIZ/g4SIYnOBOEUeFPSXVaRxxeKt1uTIYRxDKZm4FRGZtaP9lOaVM+VF0x+Th9O6Mt0vmt/mJozFy24Hg7C20VZ8vu71KvLsRkw7BtqL3f++xd89I9LW63xjZnwXTfS4whi/cgZ0qATPCvwueXa4EmfvGCNl0vQ9eXPao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021406; c=relaxed/simple;
	bh=d3E8ZLOT2ej5yykEszbxUJsSLH5paAX192ar0IBfwAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKl3bcH/wcoa9BwtWHKxs2gpTMgY4nNbBVvztoMqYvvntC1AAdGaNmL1L8Jh2XuwBBV9kl11R4/MvYtPxL3KDLMdnA8LHPSNexnF52QvgyXjQ0gSqbnOOB9HbeYtC50oggO4Kdw4kZ2DTGyEHQEt2DKt05rGV3oqpdCSyicLtBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxeyV86R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxeyV86R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B091DC4CEF0;
	Tue, 12 Aug 2025 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021406;
	bh=d3E8ZLOT2ej5yykEszbxUJsSLH5paAX192ar0IBfwAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxeyV86RqXV0+GGimRirgWNzRCsitCW//H7BJsc/YZPuS0PNNpuWqI6LVBlW9Bl22
	 zS6WGisRI/fBvZEbHCcTL1BMqeOTWn8HoUkZegR/p9xh3C3V6zoW7TbIu2v2KJeZcR
	 7CQzR+oHslXAFDf/sKlPB2jot+2jnRkhhRn2RyCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	David Lechner <david@lechnology.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/262] clk: davinci: Add NULL check in davinci_lpsc_clk_register()
Date: Tue, 12 Aug 2025 19:28:20 +0200
Message-ID: <20250812172957.863972712@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 13de464f445d42738fe18c9a28bab056ba3a290a ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
davinci_lpsc_clk_register() does not check for this case, which results
in a NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue and ensuring
no resources are left allocated.

Fixes: c6ed4d734bc7 ("clk: davinci: New driver for davinci PSC clocks")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://lore.kernel.org/r/20250401131341.26800-1-bsdhenrymartin@gmail.com
Reviewed-by: David Lechner <david@lechnology.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/davinci/psc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/davinci/psc.c b/drivers/clk/davinci/psc.c
index cd85d9f158b0..6f7b8f082ad3 100644
--- a/drivers/clk/davinci/psc.c
+++ b/drivers/clk/davinci/psc.c
@@ -278,6 +278,11 @@ davinci_lpsc_clk_register(struct device *dev, const char *name,
 
 	lpsc->pm_domain.name = devm_kasprintf(dev, GFP_KERNEL, "%s: %s",
 					      best_dev_name(dev), name);
+	if (!lpsc->pm_domain.name) {
+		clk_hw_unregister(&lpsc->hw);
+		kfree(lpsc);
+		return ERR_PTR(-ENOMEM);
+	}
 	lpsc->pm_domain.attach_dev = davinci_psc_genpd_attach_dev;
 	lpsc->pm_domain.detach_dev = davinci_psc_genpd_detach_dev;
 	lpsc->pm_domain.flags = GENPD_FLAG_PM_CLK;
-- 
2.39.5



