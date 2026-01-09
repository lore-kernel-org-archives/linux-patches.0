Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E3D31ED6D;
	Fri,  9 Jan 2026 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962183; cv=none; b=shuh46sadNjAGoXhgfntvfg586zBIWeMuOStWvuqY3f7+vZSryYvQ3cP4cBMJtDqTrUqmP+P8A5VnzTLRc5Kug/3qR2WuP4vuV71vkS2B1ytqx52ZL23YFKKGJ+dahcSKKrv+/lbygynIBvncsSaghE55YZTRF6i20QNf9KYnM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962183; c=relaxed/simple;
	bh=Af7U+ldP4WP6vwgALNA+sDS+d1UiFbQ9LKHU7PpN2Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLYp8Xij6atHEp1bLCCZ4+lMPktnXLaLpZGgPELMetJI9YTY2VxqtrcCWSOwMscQo5aN9ka6Pl0DCciITGmUPf51Wq5IqrY7st0VP2LFGcLvcHor5v19M4icKUQLbYr2eGmXhKrYRKNsGSnE1Cq/qFExDYXvoEurejs/C6C2Aw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEWcy0lO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEWcy0lO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17EDC4CEF1;
	Fri,  9 Jan 2026 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962183;
	bh=Af7U+ldP4WP6vwgALNA+sDS+d1UiFbQ9LKHU7PpN2Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEWcy0lOjiP4zq1ftn7HhZEqe6xIwvJacTtW8UR6/07dTdlgW9fIxDfDz6fEi8FuT
	 Aw8KzrJ4AXp5//UJnUv9hz3mWvSDyIE4JkdrS6q1NGTNSc5b3NXbL7zK3B7cak9Yiv
	 h9hX6vnQa94OedQ04/524x+5JSCwfn+TvvdrAGSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 274/634] MIPS: Fix a reference leak bug in ip22_check_gio()
Date: Fri,  9 Jan 2026 12:39:12 +0100
Message-ID: <20260109112127.843871861@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 680ad315caaa2860df411cb378bf3614d96c7648 ]

If gio_device_register fails, gio_dev_put() is required to
drop the gio_dev device reference.

Fixes: e84de0c61905 ("MIPS: GIO bus support for SGI IP22/28")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sgi-ip22/ip22-gio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/sgi-ip22/ip22-gio.c b/arch/mips/sgi-ip22/ip22-gio.c
index 8686e8c1c4e5..5b3d3d208db0 100644
--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -373,7 +373,8 @@ static void ip22_check_gio(int slotno, unsigned long addr, int irq)
 		gio_dev->resource.flags = IORESOURCE_MEM;
 		gio_dev->irq = irq;
 		dev_set_name(&gio_dev->dev, "%d", slotno);
-		gio_device_register(gio_dev);
+		if (gio_device_register(gio_dev))
+			gio_dev_put(gio_dev);
 	} else
 		printk(KERN_INFO "GIO: slot %d : Empty\n", slotno);
 }
-- 
2.51.0



