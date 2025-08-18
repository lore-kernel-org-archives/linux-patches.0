Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35E93375A7;
	Mon, 18 Aug 2025 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525675; cv=none; b=e8hGbJsh3jg8Psioc39aAnTQbo267tWOIJnHXh1yC8ARSvn2WGzwKan0igkV3xUFsKJ7ezaTwE77av+pJiw0slEBWZVApTOa0r6+MyyermiXiog9UgVM5ZV1ORCHWN/6e2I9T3OF5R4uhogKfh3osBtTAbhmjZJqJfZwDgO7Aow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525675; c=relaxed/simple;
	bh=RSJoXF71+4GYSnH3+1Z0UVKgka0p5OS5+iRfKvEn6yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SIv4qer3hlpzpNTNIFsgjUXSpd5TqbgrXZcrLcnnmn5rDif8d1khL4JPNxMGNF9Lo+jTHVP2MGrzO++myLHXXO3sK06cOIxtPAj3W4ADT2bJkcgPuJnQ7VCm+Y8UdQTnepN8MFT9pTsheGRqpgOP8CuJPn9wHXT0QgXRmJ5kwCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0wrxbL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0wrxbL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9519C4CEEB;
	Mon, 18 Aug 2025 14:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525675;
	bh=RSJoXF71+4GYSnH3+1Z0UVKgka0p5OS5+iRfKvEn6yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0wrxbL5Cvy9+p2B18gqZcg9WVd8yT5hS7gMZ67PazxuJuyTRikc1kCTU2tSxvn+U
	 q7LdH4x7+m2YlY6/grYv5TTzCqQT6gKmEYkcjEyLLC1V1iZaB9EigpQKBCjWT8rgyv
	 0q8dlYKy6IM5LEkH/ln2EYWxg4K/KFs+fJH+TrVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 333/570] net: dsa: b53: prevent DIS_LEARNING access on BCM5325
Date: Mon, 18 Aug 2025 14:45:20 +0200
Message-ID: <20250818124518.680027351@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 8abbcc588267..990d21fad939 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -583,6 +583,9 @@ static void b53_port_set_learning(struct b53_device *dev, int port,
 {
 	u16 reg;
 
+	if (is5325(dev))
+		return;
+
 	b53_read16(dev, B53_CTRL_PAGE, B53_DIS_LEARNING, &reg);
 	if (learning)
 		reg &= ~BIT(port);
@@ -2195,7 +2198,13 @@ int b53_br_flags_pre(struct dsa_switch *ds, int port,
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



