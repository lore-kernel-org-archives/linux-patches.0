Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1034E31CA59;
	Mon, 18 Aug 2025 13:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522223; cv=none; b=V5oDdhAXhFsJF/mr+8eRMn8I6Z/lBJ+W7jES1EjL4KVJ6dkhv7ldKjjpvDP3ZL2xkn4KY/gn6roZ9/GAKmhptz0YEnNWqgfF6SzTJbFGX6bcLQvPzRasgQmoyOYfF4ruhohi1WM4iCl9S4rHE0DayKayYqfPwd+rCSThJBDeGTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522223; c=relaxed/simple;
	bh=yte+VQBQY+YSiJfEBj0JVCjR82MjkSFubYAJ8L+ORBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVYIltO6ApowDDgGemZgSfmxzWOYiOvI0hAonrh7P1lycZwC/6VlylMh2Te5fkihvq9uaZitYNBArHD898UgA/x6SS14Sd2VnYtfvFg+cii13Wesyd+UvUT0Ug1IvDLIMuqotLkdLOlGEpQ4YQl3lo+ahB8ILfEipy0XcpGrPTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPjkUsFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPjkUsFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7238EC4CEEB;
	Mon, 18 Aug 2025 13:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522222;
	bh=yte+VQBQY+YSiJfEBj0JVCjR82MjkSFubYAJ8L+ORBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPjkUsFB+MTKZR5YztmQH82yEeDTY2yH5CbMVGC2volcSuq11fELsfM2/jeBxwxlc
	 S5gryaN/cyQrWVzlyse7crmdV+0uXqi11flx44F4Fzr444ikpSmb13ZHp6mrpxLNzH
	 OhvN0R3CaX5B0CgEHhGb3S+YiYWYLgrvPz/TB1R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 251/444] net: dsa: b53: prevent DIS_LEARNING access on BCM5325
Date: Mon, 18 Aug 2025 14:44:37 +0200
Message-ID: <20250818124458.234501981@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0085adecaf2d..1ee2e5e9a5b2 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -581,6 +581,9 @@ static void b53_port_set_learning(struct b53_device *dev, int port,
 {
 	u16 reg;
 
+	if (is5325(dev))
+		return;
+
 	b53_read16(dev, B53_CTRL_PAGE, B53_DIS_LEARNING, &reg);
 	if (learning)
 		reg &= ~BIT(port);
@@ -2197,7 +2200,13 @@ int b53_br_flags_pre(struct dsa_switch *ds, int port,
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



