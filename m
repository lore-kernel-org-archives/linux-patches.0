Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F44C470126;
	Tue, 21 Jul 2026 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662456; cv=none; b=GM4i8EBM3y/d5xmYKUveZoxxkEutO2M38Lzwx0kujHqtqSM1OQKje+P7Rxxm3FvXHYsr63P+Ughj05EFU+v24R6RHs4kXy17ANPJjMmv1k8uaDJyW2ZSVpyyFaW/qnpuMYo12atHp/iSh8fNVDMB94BCJ3pTqopo1WlDOSkxoXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662456; c=relaxed/simple;
	bh=G7Xx3AIYvyBaxUnNwqXR5BGzgREEtJled8+mTR4QCzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Shl1nQXyQByJ/Q04hqKr4HMv1WkfZtk7Ccpenjq1aTV7u6QZG100RlkqKYR3VsHWUzW0de4xXZJMz6WQRJrjKbOJIBRBrWYShE+O9GEce7ZUHs2nnxL6PFj7N1xsSaqA8oLhmc86odnEjYPc1uLUAO/R5ngNxojnqwwZ2jjbBhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIbNGyQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIbNGyQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62A61F000E9;
	Tue, 21 Jul 2026 19:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662454;
	bh=bytlKp+oMnKEot5I6NyhYJ5sdQoJq3RoP8xLDIrYYu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIbNGyQZ4y3W67LWsWD036cQmoekYaLsxzt3eb0WnJLzAbcUb1Np743ICNmqStClQ
	 W/BYwr7wgiTC70Ga36cO94AyNZ1YRSrU1mIjX6FwNWIScQuZYeFBfk5K3KvFm7z85i
	 2gmTCr5WmHF0YxKvCnUicn/V3ldlKC4TrUl17kuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0450/1276] clk: at91: keep securam node alive while mapping it
Date: Tue, 21 Jul 2026 17:14:53 +0200
Message-ID: <20260721152456.173247589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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



