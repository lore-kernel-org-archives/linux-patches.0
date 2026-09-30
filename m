Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1994F4754;
	Wed, 30 Sep 2026 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784651; cv=none; b=mlFe4P6VT5ArmC3n4GsND3AmCELCFLsAs3NxjxZokzVQbdbcUW6veE9iYjvH26uIL0zjr674Vd5tTFA+/W1y4fYAUTZK/arGeXQ0LAk6D4Py7m/AnKMn4UO0KhZWfv/bgYHcMAtT6iOuLP6TwjKiqSBN5CqUZw6qUQ2LrmFn7tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784651; c=relaxed/simple;
	bh=F6BK8S/9Kh+hSoeGykmL9NRrHIbGPamNoHWRPEuLDhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5z2jjKbVZhJ6c4TCxnYdDrZH7rrvGphmS00dUf/olwXQov1ygiV30BeAHN6BrgdScb2YWobrZAPz3FvbfS6M3cg7VBMANcp+SQRCaykDns8m+WifuwBc+TKzmF1IUb7uL7NAVMr7jUbRjL+zN25pY36a4iMhmTrRP8vxhlXgLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moYIEa0Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moYIEa0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC841F00898;
	Wed, 30 Sep 2026 16:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784649;
	bh=k/5BmLU9PsBVemPCHBatUKGr7hnkkPxt0je31JwMtN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=moYIEa0Yg80/thzDgkHCeJvU1V+4Zn/XjZTxS6XDp1ElMbMMhkmwKquJJiH8nUlLS
	 2gloLn6Pc/06yuHsZlNb4/6l1YlKL/q/AoI+rDZTukBdEDZ2eZDfjU5sC/VXyA5hQ2
	 mQdVXmkzINhW/BgHG9tTyPQ2xUSzOMa4iojKSI8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 230/982] fbdev: pm2fb: unwind WC setup on probe failure
Date: Wed, 30 Sep 2026 17:16:06 +0200
Message-ID: <20260930152421.739521169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7a8609c40ae93..cd628e057f5bd 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1710,6 +1710,7 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  err_exit_both:
 	kfree(info->pixmap.addr);
  err_exit_pixmap:
+	arch_phys_wc_del(default_par->wc_cookie);
 	iounmap(info->screen_base);
 	release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
  err_exit_mmio:
-- 
2.53.0



