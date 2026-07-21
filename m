Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6767A3B6356;
	Tue, 21 Jul 2026 20:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666302; cv=none; b=RCBborkPoox41yu1cxebbFAiHO+ULZT/VX8bJSQdzW/+at9FVwk06QNgvEGuGiU1V3mqxkVidq9dlPbjsQFKH7LFSXxgAiNmYRyDCA/1q4wI6v+ROP1cSaozJGQ/oHt7NxsphIwwqNVCKA3Mw/O2evU/4I+qsKPaj6ldtoeYMxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666302; c=relaxed/simple;
	bh=s555sy/F243hLEZ50+28igHnXEyc+IjA6+ZzY8WqLI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpeS41B2RoaxjyOpd3nZnLw2mphQjrZagwdPlFkUqol4et9U0gyKPQra+V6QsC80zD0rnsl2fTB8A+Uv7su+vpLw/OoG6N16qqqI+1zatgzKhkkzQmLPVSEJpMBj19ENNPRzw/dubsrJs9jDsv0p53lbJy8ZuXXdeNeXJKmxRco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDxhZRQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDxhZRQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9141F00A3E;
	Tue, 21 Jul 2026 20:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666298;
	bh=JGnN+WZcza5U1et/fCXaEjP19eIYnrOa6QwdYYRUTlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDxhZRQBq+MqelFdS1gyT4gMTDZDgrPkYE1tBckl2OSGKcXpmqVHLmuVX/wkO6xLn
	 FLDG2tNyiHrpsKUCwqOP2Ckk/rw+vTFvzud/8x+QXsxqY+rTr+HOglOx/muzjVSDT9
	 38cmIEI0cUEE2CiCxGDnWK516eFlAmB0fOTzq1qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0629/1266] clk: at91: keep securam node alive while mapping it
Date: Tue, 21 Jul 2026 17:17:46 +0200
Message-ID: <20260721152455.933539773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 22fa1c39ba6fe726b547c877c924379b7fee260a ]

pmc_register_ops() gets an owned reference to the
"atmel,sama5d2-securam" node with of_find_compatible_node().  The
success path dropped that reference before passing the node to
of_iomap(), leaving of_iomap() to consume a node pointer after the caller
had released its reference.

Move of_node_put() after of_iomap() so the node remains referenced for
the mapping operation.  The unavailable-node error path already releases
the reference.

Fixes: 4d21be864092 ("clk: at91: pmc: execute suspend/resume only for backup mode")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://patch.msgid.link/20260529042051.1626978-1-dbgh9129@gmail.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/pmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 5aa9c1f1c8866d..40bdc1c80ab086 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -176,9 +176,9 @@ static int __init pmc_register_ops(void)
 		of_node_put(np);
 		return -ENODEV;
 	}
-	of_node_put(np);
 
 	at91_pmc_backup_suspend = of_iomap(np, 0);
+	of_node_put(np);
 	if (!at91_pmc_backup_suspend) {
 		pr_warn("%s(): unable to map securam\n", __func__);
 		return -ENOMEM;
-- 
2.53.0



