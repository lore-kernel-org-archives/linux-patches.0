Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705273;
	b=1kSHLVu04AUUD/GY5hNPpY1sPBe4OIEIv4t8W5mD5HcTWqVABz+TTs394I0KdVV0ito2
	 GSC+phrMdP+P+WO166aFoVELl2buHCbRUl5wKU3ZCwqrrtM4TZ8NTHi3KCqNYJdPkgEPZ
	 bSlu5gci0SnFzbvXq2tx3mcSH5nGenPOhwVKFKcx7rsYMEhiiGgZTM/a5lC62RByEkHKU
	 LD6Yxn1Lw/5Ow1hHkjSaFbth0nhedib09ycbeV0h+TrSI8/ufBX2il9aiG7dF/YMgKbWT
	 yPPaoRZ/03tkqq3wMV5ftqmFqfdQHfGrBDiVixD7NwDwBL9owaUULozl2dZxAmaxCUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zU2X/xuE7yGhfVv8HcD+JsjgCuuowapJYpkYvVlRUUw=;
	b=LswRcnBmbYrCa5dJSUePtIMO6Ol0PpHuDGOP7qm93O6Bw14LfHe00Di0TdZ5CH6CHvjD
	 rqBJIGpmi5HK7Z05Eb+iiiavvNxz7N+a9BBld2t4ZJOwUViUbsIpHFyCgAz1reNEtmp6A
	 WC4RJrNLt+AWwmlLxaje0ET+Sb12IUY+qIYp/0r6KzNgr69fSk4ud7voA3ZuwaAuWMvtw
	 26z8C7JReEg+kB0ltfFyUVhsROSJXSqS70OORlPdIj2jDL89GVs1MY+6VAWTYfDTqibAu
	 zFZektral577d26RvgCslehpACW3yh8qDgBY1IJzcGi0m1YT5CNpbQAB+zx4HJvhV9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TImuP70d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CC1606A31E;
	Thu, 26 Nov 2026 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TImuP70d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070271F000C0;
	Thu, 26 Nov 2026 15:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705273;
	bh=zU2X/xuE7yGhfVv8HcD+JsjgCuuowapJYpkYvVlRUUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TImuP70dXG3BZGyP5v85KjLODW2MiGUHWgRLkTTFoEv9zaekleHmErqqJ4IXSNOTl
	 80LxkuYRS46iPw3gsHmbB0rG3SAfe0yOdPoXe/lU2sq2fdH4SPzM3ghhOMVu/NErKJ
	 KZwNbMm76n8nKckPbgcpVtgQnBQaYz4/0bV1BdlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/319] team: fix promisc/allmulti leak in team_port_add error path
Date: Thu, 26 Nov 2026 15:38:31 +0100
Message-ID: <20261126144009.976156720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/team/team.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 359eca9f75e10..9d7d4bf5caf38 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1304,11 +1304,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
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
@@ -1334,7 +1331,11 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
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



