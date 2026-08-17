Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B5F3E025C;
	Mon, 17 Aug 2026 13:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973942; cv=none; b=bqEGa8RzWCQYXy3nXHqHd1WS7861tdrYOJVJmTcGSOCa9tbOO/ai5r+eXoNT8U8flrYGp/N2uaMl7sMPpJuKl7UNU0y+aKCDF4eU8yrWHUNcr59QCXH6JeLLSRFkJxYKEQ0LZ6vktjbpRec/mqfJ/WbtuMEDqR0tHK0qB49kNgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973942; c=relaxed/simple;
	bh=EXJmBIrc08hHK8Y4H2HAjbm1K18pboCbi2m16C55Pns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3NcY4Jt/BIorWGvTh1ZxLb6mt65hOOZT2fDMHpMd8gmY6xv7abqHBBPHZpqrnrKPxvEnTBKo3VYJKE+Zwdxs35lQ+9R/D9rVxLhUQ5GuF+WXjl6sVKvHnBM/+7U3IVsQIxJTO36LuNvexBhNMUEquvvcKTDmIj+EohRP/3SRFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOFuk4E6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOFuk4E6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFE71F000E9;
	Mon, 17 Aug 2026 13:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973940;
	bh=Y8UUnIyacCJcEutNvwgjzl9kyEppPjSzuVoM6ZNAVgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOFuk4E6NQMDyejNTSiW8q1eJXJZ2PuTV2EvzbUdHT0q0mXeK17gV2RxfxlKanh/y
	 S6Gxgs6kp8hMrTZr9drp5UW7n41QUCjKNO+0jmfReyumIiSR88UjwEb3jLPBvFykLT
	 D42bXiq6Nqf5CPDZx8B8IZCclVNk0OUoKrX9trTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 033/271] ovpn: ensure TCP vars are initialized first
Date: Mon, 17 Aug 2026 15:29:18 +0200
Message-ID: <20260817132538.109431395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3a04757d5c31e..168cfe9b59a98 100644
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



