Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A6A2931F8;
	Thu, 17 Sep 2026 18:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668379; cv=none; b=A2m68cdpADSmk3j6i5od/Iwlt4EIwk2RR6VOVO/tMCCapL0t9vEtOUPuDANtEaA1TrXzNGvyzOgCSzNFAWF3xVyEPkuB+/39+zzJKPm3lNlZqATkf6c+jW2GSyeENglOUzPgGlPThh92Z+I151q1D01bCBZ7uRfoW2MTSzb6xOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668379; c=relaxed/simple;
	bh=1G2OMS50DgjJKVgJ+ZJEVPEHC2F7aH2vusOvvm8xars=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+ZrycAGd1NQBv8bHP0328VDLUH8YIv4Pwi97KbcfDH2ukEo7LaK4zM+fldzZl81rBDZRZNCJjfsChd+60YEwTtX1ncS4BTWvA8cmDfdv5iLNg9i9ZzEzCxo72+Vit56WxB/c8rVrfd3cfhmD02O1zTOMEIgzmmDgerI29oI/HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZztVQ0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZztVQ0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345871F000FF;
	Thu, 17 Sep 2026 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668377;
	bh=K2Qr9nXnM5+Z/j02z93DLn4JJo3UoSVhi0N/C5O2g4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZztVQ0a0Hr+wFray5sRBi6GwGVMMJ4S1UJAs9/MNXqWH93Ef8d3xKwsg2W10b9RE
	 6jYWN8xd5Ft0oHrQeFQdiKbrBe5YOO5+Lh8YEwcHt1InWwi9Sla1grfmP0OEdX33lx
	 n8KaYhs6YS/gq8qSG1i8TnzGkAeFsNrAXzG9ye7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0368/1102] fbdev: pm2fb: unwind WC setup on probe failure
Date: Thu, 17 Sep 2026 16:05:11 +0100
Message-ID: <20260917151548.889419603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f34429829b7d7..82408503c2812 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1711,6 +1711,7 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  err_exit_both:
 	kfree(info->pixmap.addr);
  err_exit_pixmap:
+	arch_phys_wc_del(default_par->wc_cookie);
 	iounmap(info->screen_base);
 	release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
  err_exit_mmio:
-- 
2.53.0



