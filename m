Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA4243CE46;
	Mon, 17 Aug 2026 13:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974774; cv=none; b=B46mbRpLk+A1nwAjue5zQZlVjsQCsbN+RynIYP9kZJukxRNXNe+IM3SjHSm3DUmNM81MQr/hPOKs/Gf7B8LTCE5XeLfSlDLVpHvhH4cuQM1Wj9uqJ6O4FJhzyefE+zVA3GCEV7KnxGYubZqGet394rki955dwlMTdL00EZpmys4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974774; c=relaxed/simple;
	bh=V8v5cNSgPeNNs2d99XShz8G/HuAcT1avGlBbCWPv9N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRGBS2IH94dX5LpWUWrE5lrwe5pMxiPO5kvZ5k86SIXKGunPX7n2RCa/s5YwbhlHxP1aWaxB9BowdMhR4vnWpMss64Ku9RKdRItIIkyxtC/l3WzIOxBXUnli1DDY/4gGp4eJMueAYafYkMw72TGD7QQipMo102PVAlIr5MZ3g7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vX+pAJAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vX+pAJAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF19E1F00A3D;
	Mon, 17 Aug 2026 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974761;
	bh=krbgCD+c7pfeRRTwi/VJRKmBelcprFEQ3S6zae94dto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vX+pAJAPFkl7XU573ZImJxGKHnVHYwJJMlqDuauuOSVZ6LGcYVljAyOdaK3QsoZq6
	 vi2JBPYOF3jkq/1IHKWmIQc2zZvLjWH/sYryGgm27b6YGU2QWdnwZw3jitT5vYW5pJ
	 xMjRvL7GJ7wgPhHAHYS8h0ilkSfICpgjGhIYVKeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/250] ovpn: ensure TCP vars are initialized first
Date: Mon, 17 Aug 2026 15:29:49 +0200
Message-ID: <20260817132537.605401680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Antonio Quartulli <antonio@openvpn.net>

[ Upstream commit 4680c0ebd958fc18e53c8b91d80436b236a8fc09 ]

Netlink calls may access TCP global vars (i.e. when attaching
a TCP socket), therefore we need to make sure the
latters are initialized beforehand.

For this reason move the global TCP initialization at the top
of the module init function.

Fixes: 11851cbd60ea ("ovpn: implement TCP transport")
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ovpn/main.c b/drivers/net/ovpn/main.c
index a3c15fc301d0d..0262926449f2e 100644
--- a/drivers/net/ovpn/main.c
+++ b/drivers/net/ovpn/main.c
@@ -260,8 +260,11 @@ static struct rtnl_link_ops ovpn_link_ops = {
 
 static int __init ovpn_init(void)
 {
-	int err = rtnl_link_register(&ovpn_link_ops);
+	int err;
 
+	ovpn_tcp_init();
+
+	err = rtnl_link_register(&ovpn_link_ops);
 	if (err) {
 		pr_err("ovpn: can't register rtnl link ops: %d\n", err);
 		return err;
@@ -273,8 +276,6 @@ static int __init ovpn_init(void)
 		goto unreg_rtnl;
 	}
 
-	ovpn_tcp_init();
-
 	return 0;
 
 unreg_rtnl:
-- 
2.53.0



