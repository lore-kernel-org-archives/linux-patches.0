Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850441B424F;
	Tue, 26 Aug 2025 12:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213040; cv=none; b=Uom3JsXLAPy1GoSvd/gSVlhGH94bTYCLPM/nQdZpQjM8stXmYkJR48QG8N0hYfI278ri+TbrohC+i6CwOBeUxrGH5yIGFZ8yzHgKMz6p5yOr0fjHljQJ5jjoGCR4t5RKclNa53a3kRPOvmHp3QWttlJbXJVDOkYXUDP5utYsr1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213040; c=relaxed/simple;
	bh=gDCJ9UUXkbf7C0/25wf/MgHdfgDiwLi/B6UOzfH5Onk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=STyTMQ7ZA/fiMgHCXJYdlKFaxFdM2M9CH98zjAMu2oXzNUYMRe4brQZ8Sie+d1xMFwdqHmvhs2yUJSwf1vtyHKPQSH0KIP4uqcCkTgILWdRAjyAI+1rwV9bN1k4Tm3LGsR37xjRMN7zfCp8xfH9zcJQTblcI37JpyxNhTvcmSwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiUwZGVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiUwZGVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D47C4CEF1;
	Tue, 26 Aug 2025 12:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213040;
	bh=gDCJ9UUXkbf7C0/25wf/MgHdfgDiwLi/B6UOzfH5Onk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiUwZGVO3Dpub76HDL1IQKv0YkK8ZLF/CuNoY54CbLlelKSO0NoWA50V+FbRcR+JJ
	 4RUeFvg7P4f5E9mo4Y4vM6En2Mnxeb3XcOTlV0q+Fm15qwqYZhsqZpr8pVSQFQl7CV
	 Aqn/sr/OHKhNyYSVcd8uU/+X1Es9obu36FMl47uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/587] net: dsa: b53: prevent DIS_LEARNING access on BCM5325
Date: Tue, 26 Aug 2025 13:05:48 +0200
Message-ID: <20250826110958.003963254@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9e4d66b8ad39..5daefb60885e 100644
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
@@ -2062,7 +2065,13 @@ int b53_br_flags_pre(struct dsa_switch *ds, int port,
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



