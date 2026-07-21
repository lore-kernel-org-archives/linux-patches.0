Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAEF47126F;
	Tue, 21 Jul 2026 18:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657072; cv=none; b=EtSYeY2lC/DHDkKZ178IGq4n+roM9XTO3hUAMsNB5IPVbwD1i+H75mmMrmQewa8hk6Z2wnlKCjd3WjuegibHISm7CupIH2/Xhnyt4J2ZgWiysAE+NU9Y5sb49eXl+WDZ0tZix/L9utT/f5wOdE3MqrA0nEhou6MbGdbjBVhHIGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657072; c=relaxed/simple;
	bh=wvBcRYclFlvtxN4IA98NAb8uLjbsRf4KkPpsB7Mnwdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7HsoduHaxOBW2z+bipGvSEfulk5LEbNahRsb6CnR7JK9aX0Tv9uGsWOdz2MjEx5x1DMLMjrGqcdhoXPW62m98lBXZbKE2GFuo7QxtHjI1jztH9WhoTlWQpUZM+bD/Yuik2Lx/eVefbmoJbLPAU4p+M6iZC+JWkHT6bBFzpP8x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqIZMFTN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqIZMFTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E921F000E9;
	Tue, 21 Jul 2026 18:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657071;
	bh=6xPOmGjfuEht+R3MJ8OJ7/eAh5oQFJPx6agKl8LnnWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqIZMFTNjqqg66o3U+rN6UbXde7/+YEHUMprFbRBUI2dryg0lblyOZ61rTrGqZATg
	 1ncko5wkLKG8n1JTA1mBHHL7PgUTVv7IWflGf/RuXfkrjUP4AZMz9PjThH8g+2JWit
	 ZP4W6MYLxCi4QdGL1AV4aTj8Tpea5LKU0oZcfJGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0626/1611] clk: at91: keep securam node alive while mapping it
Date: Tue, 21 Jul 2026 17:12:22 +0200
Message-ID: <20260721152529.469332827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index acf780a8158900..4ef4f7b9d0bd16 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -177,9 +177,9 @@ static int __init pmc_register_ops(void)
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



