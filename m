Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624809;
	b=DFJoOZ16Zs1uegMAxK78mxs9LYQDTpkP2+lm0OWvCFcfrWfgNZ5/kel2DAhcEw2LSToi
	 OUkBURDtCb2AtobSU/mjhORtItoYm8m5RRP9pldJBm2xTiaIRUaLS69TIuNSw8+I45IB7
	 UHnGhtJ8Tvwa4wzV2wB3zrSCeB0kq1f2dDtPXUrAoFaHPo81c6AlSYvMJCR4kH2Y0B0uh
	 nm5wt6vhS+M4Y6zluuP2Fd6l7vd4iqQgfruCWiF4eID34duaDdKHdTgyC47IA4iSCC61g
	 AAbXN5FzcCDEARmWgBO/UGHY8KNzcps+QSs8a0SENZ8/2V+bugYjXh9FQm8c7CNX12w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=guK1Jrq2SCAhBP3quR/xUfstV3BEvVNzfJ9yZ9J2IcM=;
	b=1Xyvc9mH9rXwLV3+ccappxW1xjnh+p6z0Ml/jI1Wlu6lkMHquV06f5QsjdNO2Hft4uE7
	 TrDizLgaX1N92AsWFi2mlTK54QhuS+sq2x3EN64iGv2A831i1rWrzkn6f5nzS3V8E4v7x
	 J+k9vsZTzz+LP6KT8cpQHNeew2LDKcxTmjyu3mr8j2kZoSLuAU4me7huE7UYxz6m8xe9g
	 8zi2Dp/PIey/RQXxIkYw+HgFo7toRcRH7LZJ6zmvgBjFbQmVRdbYd6tkQFt9vqGZBLGRF
	 DDdxHIGVs7grOHXZow4CLFweUPO8xVzjkmKIBZcUdS59RTE34/Sb6RFOv2SdyN3YsQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4AkBu8i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B58A606A33A;
	Wed, 25 Nov 2026 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4AkBu8i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5BF1F000D2;
	Wed, 25 Nov 2026 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624809;
	bh=guK1Jrq2SCAhBP3quR/xUfstV3BEvVNzfJ9yZ9J2IcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4AkBu8iORWNoKD+DOPc+9NOfITeKdc9F2b+N4L2Vj8l+zLia2pO2deAQ3c2EgyIv
	 ob1GybJQ2heidf+S2ZlTOUTmj5B3a+8/FcV90o4N47zv3yjzeA4Pw23UTImB5/uF7Y
	 db/OgE/fhs62U0TjeHzc6wEswizsl3JNAOfbdEmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/816] team: fix promisc/allmulti leak in team_port_add error path
Date: Wed, 25 Nov 2026 15:31:00 +0100
Message-ID: <20261125143856.421411459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit ff618cb00a645f1e3f89068c5fbda3f3a7f4ae63 ]

team_port_add() increments the port's promiscuity and allmulti
counts before calling team_dev_type_check_change(). If the latter
fails, the error path does not undo these increments, leaving the
port in promiscuous and allmulti mode even though it was not
successfully added to the team.

Undo the promiscuity increment under err_set_slave_allmulti and the
allmulti increment under err_set_dev_type, so each error label only
reverts what was successfully applied, matching the cleanup performed
by team_port_del().

With the promiscuity rollback now living under err_set_slave_allmulti,
the inline dev_set_promiscuity(port_dev, -1) in the dev_set_allmulti()
failure branch becomes redundant: that branch already jumps to
err_set_slave_allmulti, which undoes the promiscuity increment. Drop
the inline call to avoid doing it twice.

Found by source code audit.

Fixes: 0ae9cfc454ea ("team: Move team device type change at the end of team_port_add")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261104015217.2222-1-lirongqing@baidu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index a688f122661d2..5a798a2134fbd 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -1313,11 +1313,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	/* set allmulti level to new slave */
 	if (dev->flags & IFF_ALLMULTI) {
 		err = dev_set_allmulti(port_dev, 1);
-		if (err) {
-			if (dev->flags & IFF_PROMISC)
-				dev_set_promiscuity(port_dev, -1);
+		if (err)
 			goto err_set_slave_allmulti;
-		}
 	}
 
 	err = team_dev_type_check_change(dev, port_dev);
@@ -1343,7 +1340,11 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	return 0;
 
 err_set_dev_type:
+	if (dev->flags & IFF_ALLMULTI)
+		dev_set_allmulti(port_dev, -1);
 err_set_slave_allmulti:
+	if (dev->flags & IFF_PROMISC)
+		dev_set_promiscuity(port_dev, -1);
 err_set_slave_promisc:
 	__team_option_inst_del_port(team, port);
 
-- 
2.53.0



