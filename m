Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622030;
	b=KWvgBUTSddRHS7z1m2DkZNL1tYeZ0SzplUHhCdbgQGm2FT/oMAhQnZL4Gsf7etBkODfo
	 yoiaQ0CKEmlgQy1s699Oz4lwXErO0DcZWN13ZcYdLlrptWvGgqXKW1ya51Y+fsKT99xGx
	 p++pykUA8QFtD7nsCJBScQekwz71YlH9+8PpmmZNGFLDVce2GJiGjQwjZrRXysxBQVc7e
	 RCAGmkzSgbReEy7RqkperOlleDvTVe4TfFiY3SGngW/QCHKemgaspDkhas28RjX+Rj+fY
	 W33GQY7RR78JJzYZYqleNT6bd+kc507hJsfrXg3hXWacNT7Ui4ysbEAQ8vICFeO9iiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o4BWcqBvuAUIqQuPYAyjFrkLqcniZZRGfp24TwG1LRs=;
	b=hnoQ+5p2od0OLbl6b347YSTYLHmvL+1MWoIQU7s9KpRTINSHNlcBOdcL1Lqb8yGnSos1
	 ZKg3V3UNbs9BwDK9kmS8PzXNZi7RzR9ngLxFC4yNMGGG0HVFNa/gcMU9zLykYQnv54CS5
	 ljq5flNj2ud4VoSiGZI/nRH3iMvlwnGJl7XVXE2OIcD7eCBRAUY0G41jULbEXvYMOyOgC
	 pPzJQvkiw5BcLv60PFqltgeSlpfU33THMi2w4jKc+kZZ927vXGRN/btPpyiyp3rZX3NAO
	 nX1eC2oXFzX6PKTqn+JupXBU0w/pSH9wWAygRqTe6ww7RN4gBx0t4Q6Y+CI+7K5Y/lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OP0lLwOA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0E9606A321;
	Wed, 25 Nov 2026 15:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OP0lLwOA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A391F000CF;
	Wed, 25 Nov 2026 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622029;
	bh=o4BWcqBvuAUIqQuPYAyjFrkLqcniZZRGfp24TwG1LRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OP0lLwOAVxC3Jll5xaviP4GHwMHdu6gDSUqpdraa9IuRroGQKGt3heZ7LAQVmvutQ
	 bJL13U3jNagF55V+9opr5GLat9bZo2dHUvv0TvtTpNVGUe5u77TajvBbLGYaZ4WH0v
	 WSD8DglJCQt4Cv9xA2mDfN4EuS//+4w2sujCENpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 409/990] team: fix promisc/allmulti leak in team_port_add error path
Date: Wed, 25 Nov 2026 15:29:36 +0100
Message-ID: <20261125143831.678507354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cb0ff3d89de93..f1d45e157efca 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -1257,11 +1257,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
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
@@ -1287,7 +1284,11 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
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



