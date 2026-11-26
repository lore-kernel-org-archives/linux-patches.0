Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704426;
	b=NOPxgar+r2qfVhVVhSN1PQfSPSoDY9rMnNY+knVQ3U+YDWbsznkwZe+VL40q/k9BlfR8
	 Jhi7l6WsKjxt+ZDOPoVOmyCjfNuE9JRXGye0xQ4vAgWdM6aXpKZXFQfm3kusDIQqQym0A
	 7gnvSW/t27nvNN33gPDGd6E+N5Q0T5E9HvTGl8kl+0dlVHNJdD5w8mTTwsKBzXgP6pPMK
	 TQT4pBhuaG7jTpGOzdbpHXmd0mpBpnR545qrIOBcHpHgUyMYnA6e54gE3WC3y9Pr8gb3j
	 5RpJhKoC3cwo35kQjrbDfTjtHW5ujezkR2vMVVlK+Q4tEy8VjQ3QVesRschb3EX36Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QSaeBuyNUtjx+5n/f+SHSeucCKilY3QPiJFed2nnp/k=;
	b=QMvojAKGqxTMguoMftldsjinfP/4xS1oPei6Uhhy5E8xMByHgcb+pgixsVyFZXGrU22D
	 5h1WQjvKYhOoYIjlDXy1z+lhnu5i7aW7w2wxO9kgw0kE21qjmIihSlmRN1ZNVd3t4bipU
	 qwZ3I3W6PuFnl6L4ibdMtIk+poCDsBm7RvKpAm92hLHzL7kmnGCjQXjCahVnVGiOPMVKG
	 Gu/YTOlCdfJY9MkE5iae48INZ5gFgnl1jF/X/ECZJVWHSaF71Vkg5ujIAQOAbfYGkf3hH
	 lPV61ipt92XST/5kc7dISRCjqucctthl0+LlBqJY6tRdasDQo94/IjpHzNhOmdDd+iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seHdCZsJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9558606A31C;
	Thu, 26 Nov 2026 14:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seHdCZsJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63881F000C4;
	Thu, 26 Nov 2026 14:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704426;
	bh=QSaeBuyNUtjx+5n/f+SHSeucCKilY3QPiJFed2nnp/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seHdCZsJ2X78aFFDTuPTDtnLygHCni1Iq/lSiX/OJJNmfuGdol2ckyu/eEEo7t6/K
	 3rRceyYERLQwFal/oZ9hZ7K/iEQAeeClP4EPUB9RL/g5ZEl3aVeoeWHklH3VVzKJ8d
	 UQgrGtts2OCMhAZKYMulc5JOzj0xbDx/65uxOIlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/265] team: fix promisc/allmulti leak in team_port_add error path
Date: Thu, 26 Nov 2026 15:37:31 +0100
Message-ID: <20261126143613.471685369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 98edd42ab0175..2c0a69a1ff127 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1303,11 +1303,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
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
@@ -1333,7 +1330,11 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
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



