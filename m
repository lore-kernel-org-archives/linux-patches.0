Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC6749659;
	Mon, 14 Oct 2024 14:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917761; cv=none; b=GYIUUBZp+86mwepz9bkoX+y6i6chDBHYHiX9vTt1dsNDxfRneUfr/ARXcHu6O2HHH9wOZcYvhgJIdgdCsSVGOcVN7dkbYhGDX01vYDObmdHSP32pAbtnMl2jW1LCJBmeLM6tCsywXl8gbrlxISWA5DzkafGYVe8PvjG/QBfOXfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917761; c=relaxed/simple;
	bh=Wx3zTevK0xybRBlu4Fow57kCTNmaGwAHRe/uZcJeqkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZlB+dGMmX1LgmCq6izT5vDWWOGYaNVZwJcm489MZStNKwMm2TOn++XTPy+IUgmvTKAO5DaiFMO0kJeRRc+usu0yvbB5YaywYOGCdS7OVb+fc7npP/x0HBBJNOiG6UzxJ8tr1nTHqCaM4d7/JaNrpKlI0dpwo4xvK1LW7zaCtYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8NCRNCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8NCRNCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BB1C4CECF;
	Mon, 14 Oct 2024 14:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917761;
	bh=Wx3zTevK0xybRBlu4Fow57kCTNmaGwAHRe/uZcJeqkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N8NCRNCz8vzqCZ8lvwgHtNvPQvhGUFiT+67XNu05z6FFF+0o2crdZTlbns5tFz6ms
	 CprL5tl/H9zmtGB7/kZicWpoFHTqoRnCrCEfwwnqtAYqkTd1zSYEBQRobIeH9kjpNw
	 11YcPnzHTocRt/os0ttHGt2wxY3fVY/9JAicZzKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/798] fbdev: hpfb: Fix an error handling path in hpfb_dio_probe()
Date: Mon, 14 Oct 2024 16:10:49 +0200
Message-ID: <20241014141221.665620370@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit aa578e897520f32ae12bec487f2474357d01ca9c ]

If an error occurs after request_mem_region(), a corresponding
release_mem_region() should be called, as already done in the remove
function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hpfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/hpfb.c b/drivers/video/fbdev/hpfb.c
index cdd44e5deafe4..27f33121ee2ef 100644
--- a/drivers/video/fbdev/hpfb.c
+++ b/drivers/video/fbdev/hpfb.c
@@ -344,6 +344,7 @@ static int hpfb_dio_probe(struct dio_dev *d, const struct dio_device_id *ent)
 	if (hpfb_init_one(paddr, vaddr)) {
 		if (d->scode >= DIOII_SCBASE)
 			iounmap((void *)vaddr);
+		release_mem_region(d->resource.start, resource_size(&d->resource));
 		return -ENOMEM;
 	}
 	return 0;
-- 
2.43.0



