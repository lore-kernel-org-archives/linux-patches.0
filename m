Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244A93D410D;
	Thu, 15 Jan 2026 17:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499337; cv=none; b=QG12d+4jQD6rmwMGOomrrJDRjTMoZsElWKOH1WBPdmAJNggXTvjej3vQHNnmMcuNQ/5wMbQIuWlbEBJyICj/Z65kV/VnfEKmxxoXixSDN4Gt5QRXPZu5ebIhllarQOhy9nvAS20VtDTaveS6DSPQW1p/waXgmJBJNlJe3MyDPF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499337; c=relaxed/simple;
	bh=h+B9ljePNF7S19YqGcw7Xca1tsf3WqWhy23j+8BXQq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NV+x8hPdlEuKhBI6/vycrZcd7bt0KvCZV0gzZVIFCWM4xYGccEpTwcW5XlK1nflo9jakyk8GaBzYPsFQ6FIPN5n6iok5MQNPx4Y8fRtpuhpwZgnPNJ2P6MQHp7weTRAvhEUg7P1vLWcbPeLXPUst5BnW48XXq9SNXt6jghvKHZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVFvl26M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVFvl26M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC23C116D0;
	Thu, 15 Jan 2026 17:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499337;
	bh=h+B9ljePNF7S19YqGcw7Xca1tsf3WqWhy23j+8BXQq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVFvl26MlMj6U+FjykB6eSWyWrrgd+vwP6AiBjjGVQZC0XmBdwQWJxnNut6y8tyuN
	 f+159fCKccD0bUiW1DX1X+Wnwlg4uSCsckLx1pn7fFTVxswjHx3eUNb3prATl9eElm
	 bQ07m+ls/xb0/XP3tQpc/BR6vCkSbH6CZHgAgcRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/451] MIPS: Fix a reference leak bug in ip22_check_gio()
Date: Thu, 15 Jan 2026 17:46:31 +0100
Message-ID: <20260115164237.777555014@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index de0768a49ee8..ef671680740e 100644
--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -372,7 +372,8 @@ static void ip22_check_gio(int slotno, unsigned long addr, int irq)
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



