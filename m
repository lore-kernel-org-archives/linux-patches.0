Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496DD46D0B7;
	Tue, 21 Jul 2026 18:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660268; cv=none; b=QHykWJiA5LnOmRbKUBC+8Jq2NGFtN17T2Mc9XIDtMWKbCFU2AmDRp18DjsB5SoVpvIwL/qWFwQ0OSO9aFkCY56sT0h1rYUiw3+6HCWmrCBaa10eHLhLElqx/qd0l1ttLbg74uj2+VlLvs65vC2wqhv2RfK9hC7YhCXvkx39kwBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660268; c=relaxed/simple;
	bh=4b1SDpaF2/15bjT9wkaPV2pyksBS1gIvSkYowmLxJT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaUKMJdTsqrmUE2wlv3XTvvzHpx2dpVCB/4armapkkGNVwD/1QiHKQFnq7cSyRGA3l3suiZ+MIuTMGAppe7uZKqBaL0I05SQRUCkeB8l799wphEPGCIVxfIN0p7J7EiqSNIbkYqi0RRttbvQqEQLN2Q4o4TVAGzKR6ksoi4H7hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1J6ul0cf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1J6ul0cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FF61F000E9;
	Tue, 21 Jul 2026 18:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660263;
	bh=mwq7u6De46BIsII2sbLjtl3uJyVNqCOpltMlDbwYTQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1J6ul0cfq65RbL2M94zUjq5rxGufhiQsLx41U6t67XsUFHKVwzAz49YafvR/s6BPO
	 855T2DO8JA+N2o5r2NfbmZ1fINTp9ozbBPX4gLe5n1S78HwVfU0wQLrOYTeiUNbSgr
	 6ZClZnuwXmoTg7SlMSg/3BgVaR3zbzhOcKH7LYaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0912/2077] clk: at91: keep securam node alive while mapping it
Date: Tue, 21 Jul 2026 17:09:45 +0200
Message-ID: <20260721152614.327740233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index b618a5e00b0068..03a6c31d6aa8b5 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -180,9 +180,9 @@ static int __init pmc_register_ops(void)
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



