Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA1D503900;
	Wed, 30 Sep 2026 15:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782730; cv=none; b=ugZxZrpUtLCDWrat7iwcoVB9xkqTGUtC9W6vkHBto74pKurY8B9FbvT/ZA5D+gsn+kry+1hmI4LkzqbFMP+fNDrUUifAidDAjtbLoOfvmCdRy1bj/WAFRr62PTK2LOxNUuhDYuxa9fl2ScnS5bJ5VXomWZbihS1SRHO51hmmKV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782730; c=relaxed/simple;
	bh=kms/fOXmilRhaTL/KG67UD4R0Uu4DraxmWgWLCsIz6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNjg0+QKfua41uGpnobFm7hCzAs3SwYkwJXUdg6Nks9R/6I11K4mQDm5VHu+m3ICYkW5SQ9ESN2v5/EjcC0BifvVWOa3hSbjdPbGRjxJ0ZN6mdDYLy+/a/rdLkkVKKvusr0VkTt7kjkwcXrEMy/XL14msdrndEBZDqt+nB94iP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAbp7xl2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAbp7xl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C761F000FF;
	Wed, 30 Sep 2026 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782726;
	bh=ICcTfNDNUJbMqn2SpV29IGQhcKvObhfPl68kSDKRDOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAbp7xl2C5Sh4mSbAKfRq8cpbe/UtRWhYBGV6mq9looH1lI89nDuiFl35+argMZ8Q
	 VeQPQ+y1Cz4wz2wd5cswaiam6H+0Qvh/gtl0YsucgfGbtDGONC/ZAPCDUx9ATwtTvY
	 xgHUSME8BdNoyanlMAV6ywDCz4wsfTOZUa68SmMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/595] fbdev: pm2fb: unwind WC setup on probe failure
Date: Wed, 30 Sep 2026 17:20:40 +0200
Message-ID: <20260930152350.895871966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 16eb19f0c90af03bda6ba66586d7bb0e9cf85b43 ]

Add arch_phys_wc_del() on error path to keep the
write-combining setup balanced when later probe
steps fail.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pm2fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index 87b6a929a6b39..d7145a6c73545 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1706,6 +1706,7 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  err_exit_both:
 	kfree(info->pixmap.addr);
  err_exit_pixmap:
+	arch_phys_wc_del(default_par->wc_cookie);
 	iounmap(info->screen_base);
 	release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
  err_exit_mmio:
-- 
2.53.0



