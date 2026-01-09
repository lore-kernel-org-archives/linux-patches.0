Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E581531E8;
	Fri,  9 Jan 2026 12:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961642; cv=none; b=XlcFBgwcqJdSW+v5WVYmV3xrmohzb9M8Krs1pBz+a7finuTIdoqKcGmSFJLqOugCYyucOwb5U04H7EYiGhlBBD1XUeW+q+xYuWiNh+MzWwXZy9JMuH76iUiPGP0crIEdX8DDyyKEBN79o4V3ZbEjh0SUedQrnvxGOdquEhF5DxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961642; c=relaxed/simple;
	bh=CaIHTXbB20UGxQevxWWc1IjKt52zGK41QiqxGR5z3v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmr3x1DvUXkEmWcNtTpEX3wRDLuEl39o2y1joDKqa1acUu1Em+GJeO/WG7duLz7g1s6I4hEK3hynVKqYNr/ECD5VLhpRwzolXOApQ9tkCRHO05QvJNjSOj7fnO5/hZ9fs8EjH6YFSz/vm6OpdwmcMXWi6LJ1283LHsGuPm+bsf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoWSHRxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoWSHRxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2A1C4CEF1;
	Fri,  9 Jan 2026 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961642;
	bh=CaIHTXbB20UGxQevxWWc1IjKt52zGK41QiqxGR5z3v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoWSHRxx++DeVmzAgO5QfLSWM7WdCLB4YEbjrgIBezJfxlSyXveyW3dIO93veZXnb
	 zf+z2REuv90YPTGrFmucYuGEmxRJDCgCzxZJExeIJBtYU7zwGWHnXjB5lkvlOKKLan
	 juvtkUw+xS+Zf2bXo7zl0MP4T4sQZk1pLtGAQOFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/634] mfd: da9055: Fix missing regmap_del_irq_chip() in error path
Date: Fri,  9 Jan 2026 12:36:03 +0100
Message-ID: <20260109112120.635933037@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1b58acfd067ca16116b9234cd6b2d30cc8ab7502 ]

When da9055_device_init() fails after regmap_add_irq_chip()
succeeds but mfd_add_devices() fails, the error handling path
only calls mfd_remove_devices() but forgets to call
regmap_del_irq_chip(). This results in a resource leak.

Fix this by adding regmap_del_irq_chip() to the error path so
that resources are released properly.

Fixes: 2896434cf272 ("mfd: DA9055 core driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251010011737.1078-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9055-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index c3bcbd8905c6c..a520890090ba4 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -388,6 +388,7 @@ int da9055_device_init(struct da9055 *da9055)
 
 err:
 	mfd_remove_devices(da9055->dev);
+	regmap_del_irq_chip(da9055->chip_irq, da9055->irq_data);
 	return ret;
 }
 
-- 
2.51.0



