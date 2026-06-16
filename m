Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B095D44BC94;
	Tue, 16 Jun 2026 15:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624137; cv=none; b=kWZxeOfhbZbvZhDSCpIh5RBkWfCgOPpvm4/lJzfs2cMAfgCBjnFRQGv0expwsY0uflbwANfZmx/JnP1Ao7K5U0nbhA92AOvhRMPIo3xcu3a3VHvJerZDBo0+n82lRikxbBw7WYq4Udj9iK90rRqBg74GBcV5I5JmKsVz/pIrNa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624137; c=relaxed/simple;
	bh=rfwsQpjYVFX1KQacJTzVjWQWAEihAWci1JMlRo2Bfhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIg/GcRsthFGdVB+nc+COgFJP5/y5yFhnj3kY84q5U90fCXHQQuRhcVpInu+/cqRmrWard3Uh01c7r9yXV8OOeZBXJyXoY1c5sTRUH6nbjotCYRk2IHh3356aDpLXxERQW6qUdzCTZ9l/X4ugo1gMaO84t8r10IDNR0tohWxwhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJgzkTEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJgzkTEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EF71F000E9;
	Tue, 16 Jun 2026 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624136;
	bh=v14IlF8yd/kxWzSGeplMgh5nH5lbHvJBLrYiIWVIpGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJgzkTEBbtxnHCxSysR0MFU9ukvaVquQ9FStbts/Vg3vZAVpg3DTrI4xZT3DPebXs
	 dN/dOY3X45SntzihSyLMpWQziKfrSZRd1ipBeQnJFut6cDf4crGAW5szoRnFj9tMcf
	 ozj2xfJwYWDWMlYYMKkA8jaln/n0xUTgwDp/7IhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexander Dahl <ada@thorsis.com>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 7.0 281/378] memory: atmel-ebi: Allow deferred probing
Date: Tue, 16 Jun 2026 20:28:32 +0530
Message-ID: <20260616145124.901118143@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Dahl <ada@thorsis.com>

commit 754d60ad1c91895be0bc7d771fbf9fb3c9448640 upstream.

After removing of_platform_default_populate() calls the atmel-ebi driver
was affected by deferred probing.  platform_driver_probe() is
incompatible with deferred probing.  This led to atmel-ebi driver
eventually not being probed on at91 sam9x60-curiosity and other sam9x60
based boards.  Subsequently the nand-controller driver (nand-controller
being a child node of ebi) on that platform was not probed and thus raw
NAND flash was inaccessible, preventing devices to boot with rootfs on
raw NAND flash (e.g. with UBI/UBIFS).

Fixes: 0b0f7e6539a7 ("ARM: at91: remove unnecessary of_platform_default_populate calls")
Cc: stable@vger.kernel.org
Suggested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Alexander Dahl <ada@thorsis.com>
Link: https://patch.msgid.link/20260429125930.844790-1-ada@thorsis.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/atmel-ebi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/atmel-ebi.c b/drivers/memory/atmel-ebi.c
index 8db970da9af9..1e8e8aba2542 100644
--- a/drivers/memory/atmel-ebi.c
+++ b/drivers/memory/atmel-ebi.c
@@ -628,10 +628,11 @@ static __maybe_unused int atmel_ebi_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(atmel_ebi_pm_ops, NULL, atmel_ebi_resume);
 
 static struct platform_driver atmel_ebi_driver = {
+	.probe = atmel_ebi_probe,
 	.driver = {
 		.name = "atmel-ebi",
 		.of_match_table	= atmel_ebi_id_table,
 		.pm = &atmel_ebi_pm_ops,
 	},
 };
-builtin_platform_driver_probe(atmel_ebi_driver, atmel_ebi_probe);
+builtin_platform_driver(atmel_ebi_driver);
-- 
2.54.0



