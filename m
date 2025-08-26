Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1DE352078;
	Tue, 26 Aug 2025 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216339; cv=none; b=Rr4lMp8tN1O8dlXzFEKSkhEDhjs5EJXruYdqFc2TTBE8VbfLp00Q8LWVmO1DBOrTM5BLTWbOdEtHOeOJUTLRviDcUx+5K768w/k6LRtzUHyxWmd1Vq15OZR5EglQsAIFLIIPKGG8ex42oEEO989Kuka55TQbNHEYkpvxVvbKKuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216339; c=relaxed/simple;
	bh=jnhu0gEJwY6pZLeT03JQiRG6gTkvi7gDWbowNcait8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/5zArZndFwN9ZStUxPeWcwrT/c49gjftSt6lPE5jZtEuMNyKQTcCNZziYqgJ4GNVVYi/CAQ6Gn2XSfeVSWKlPCGji5fKUrQckFYN80fEsF1JKZN86tAQ/QIl5Gs3+NjbJsUAxYtF7oQcLuG30iX23OLMpKEJwAMjfHWc78gXhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHcThzxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHcThzxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1F9C4CEF1;
	Tue, 26 Aug 2025 13:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216339;
	bh=jnhu0gEJwY6pZLeT03JQiRG6gTkvi7gDWbowNcait8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHcThzxa0Blh2x6ZQeoOfKvA+7VJJMTkpINRh6z6S4jKw9S4RJ9U4ZIgzp6DBDL3r
	 ozB7xuiwwC/+E/G+OrIdbCOcE6DM2d+jd4uePRDLv5ZcgqpZPz/2IrLp6A/RE8EOFQ
	 sZpBWktf8MOF91v+EbviFYOZPHU/dyPLA94H4bak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 374/644] net: dsa: b53: prevent DIS_LEARNING access on BCM5325
Date: Tue, 26 Aug 2025 13:07:45 +0200
Message-ID: <20250826110955.686937984@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 800728abd9f83bda4de62a30ce62a8b41c242020 ]

BCM5325 doesn't implement DIS_LEARNING register so we should avoid reading
or writing it.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://patch.msgid.link/20250614080000.1884236-10-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 2def9ed34beb..ef6191d753e8 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -561,6 +561,9 @@ static void b53_port_set_learning(struct b53_device *dev, int port,
 {
 	u16 reg;
 
+	if (is5325(dev))
+		return;
+
 	b53_read16(dev, B53_CTRL_PAGE, B53_DIS_LEARNING, &reg);
 	if (learning)
 		reg &= ~BIT(port);
@@ -2034,7 +2037,13 @@ int b53_br_flags_pre(struct dsa_switch *ds, int port,
 		     struct switchdev_brport_flags flags,
 		     struct netlink_ext_ack *extack)
 {
-	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD | BR_LEARNING))
+	struct b53_device *dev = ds->priv;
+	unsigned long mask = (BR_FLOOD | BR_MCAST_FLOOD);
+
+	if (!is5325(dev))
+		mask |= BR_LEARNING;
+
+	if (flags.mask & ~mask)
 		return -EINVAL;
 
 	return 0;
-- 
2.39.5



