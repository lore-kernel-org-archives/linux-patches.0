Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2152BE058;
	Tue, 26 Aug 2025 13:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214497; cv=none; b=UbvT0+qNXDt2jM6qFjq22cU/8gN3INWzcaWISwc4MnAvaW63pzFyUasSvFx3kKhszktVRJlQioCY6Br2p/dtnLAwQlGFTGQvmCUM2ZzU7D/grHkxafr3CIRNzhNuxotDm6ZAzXFS6V8+qeiHuKVDfzieFPOALdR4a/qisFMfhTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214497; c=relaxed/simple;
	bh=SCSYI3jJrPO+pda3OVDzaOGbeHNJ1i4CjJCge4Kj/aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b2wHfU4tI5eyGW8grljmd9QKfdXw4x5z851ZpJuoyJecRFSWeId3vGsez49YIUAEVJawUYW8TkZNWJXynEgN2oxrguUC7AN/lC44YsE/87e/571uRgmp7gw/FJGC3XhgqPi4rSMYLyJBZrTxvmxGu0nVv0a2cNz8L1bCNmJXm3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xH5w1asZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xH5w1asZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C725C4CEF1;
	Tue, 26 Aug 2025 13:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214495;
	bh=SCSYI3jJrPO+pda3OVDzaOGbeHNJ1i4CjJCge4Kj/aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xH5w1asZO09+gY5km6cWdd0CmJ+bZCpV84pgaf2KTopDS9xZNWf1hKH5XQe4rMfhe
	 9LEyl2NLjsuYRe5f/kOiX/+yMpxUrFnh2o2lzyjVK9OB8qLznalufO1BWg8sOWjpSN
	 udzGQH+63YaZ8VQY6vyTpE2eFSZwRmpDMmuga1BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/482] net: dsa: b53: prevent DIS_LEARNING access on BCM5325
Date: Tue, 26 Aug 2025 13:06:53 +0200
Message-ID: <20250826110934.764798202@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6bd7ed19ce28..5bf390707505 100644
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
@@ -2031,7 +2034,13 @@ int b53_br_flags_pre(struct dsa_switch *ds, int port,
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



