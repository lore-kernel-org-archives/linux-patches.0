Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018F43BCD04;
	Tue, 21 Jul 2026 21:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669292; cv=none; b=uOiP0b7dBFKbQ6qlB83K3MhqgSmVkVRdWVHcd6q/nuVzjh8Mahhv70YtmIA6r1ZPM0xcfu1/wh6Rrp9vWUC00I8fMo9Xl3EfjT6ohTcvJkrn4U0/Ko6p6DVajzSf7QcqEqtObJwDV9XAjGIqu8EGI+0fOBOIKzXs/HZk7aeFgVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669292; c=relaxed/simple;
	bh=y6rNaoetzwZzqdQH2T9fWqe0JANGODh3HX8FRahUYoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxqdvKk7AtcNYlMD7PEpXeqBsPF6i8YutotVES6OE6YPGbGQ/GjxZLhkBB9T1tv72pkPOBeRP4ccVTI7NJvrjWVy2LeUEY4TTF4Rnz7JM/l7MR8+DCdLoY5rB7KGI5Blh8s34Ey/bCbpNVXfZtuu9oEycTZd77a9CnUYCd+Hs9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykhJ/4+E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykhJ/4+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC7F1F00A3A;
	Tue, 21 Jul 2026 21:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669279;
	bh=jTPgegGE/gpOoERXomkgTCDDFyKi7u0VpxssIG+z5JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykhJ/4+EaNG2EVdhILK5nL6Admm0XkCe1gA8iwBcA8rUMhavdbwSs2o0ymOhWKGIr
	 vuC+NivFRh1owwu6+Y3wNjnHBfJwye/mzCnzWOjrBenTHEBGpfIzhsqRiVyLny0qYN
	 0GO5KUkmcCjCbXPjk33R5pIYjbFXg6FUwveu7BtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0495/1067] clk: at91: keep securam node alive while mapping it
Date: Tue, 21 Jul 2026 17:18:16 +0200
Message-ID: <20260721152435.687133761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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



