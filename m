Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1C234A3C1;
	Tue,  6 Jan 2026 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719926; cv=none; b=Ci/OVQc9yssgkYctbDQSOxuRnfS2ePpVWz8F9FiCtvAfdfYzzvfSEy8iYZtRhzerxOEn0OeJGs3yEUIZZcpHMxheIlkpbhI2JFTMClbc8vFb35f7GDixRR+i2LDW8NdgaRpmpfw9qBpTJt8NLSyuarg6BA+TZ78+UpZLH2eamv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719926; c=relaxed/simple;
	bh=fEbM3mfPeqPIp5jKtv2c5kVfFJXmnjKCyK93ZTerFFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3THHxGtbSyXA3Ff2QYAMVjzabPbzs69iMuDm4HIpQ0N3mNYJXYd7rT9Um3nN++EfmrsMtjXmTEd3M6ZytpjieRC7v44wwbWkgTyt1nJeE4tkThA0QWcvy0nXX5w/I3eeaHzgOecRHhE+FLbsFG8B+NGmk4CAWE47KLGd3z6yEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4S+OmJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4S+OmJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFB5C116C6;
	Tue,  6 Jan 2026 17:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719926;
	bh=fEbM3mfPeqPIp5jKtv2c5kVfFJXmnjKCyK93ZTerFFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4S+OmJXKyzENSUaLPrNWMDfFf7yZ3gAfw3he2sqROEUsfylEZH0S+dWl/e601DZe
	 czo/Xlg9djaEE86b3b7ft+Oc3w9qVN6nUpXs0cxDeSKYefZlrXWxS/mMPdh22o1DnD
	 nt7xbrEwhZIhYSyWbzY4EXtDYegf79537R2/0G64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/567] MIPS: Fix a reference leak bug in ip22_check_gio()
Date: Tue,  6 Jan 2026 17:57:45 +0100
Message-ID: <20260106170454.401085025@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
index d20eec742bfa..f6e66c858e69 100644
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



