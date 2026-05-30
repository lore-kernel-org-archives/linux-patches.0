Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCC63A9623;
	Sat, 30 May 2026 17:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160929; cv=none; b=VHJvsCf8t4xm551H9gBLy/bPE8SuS82oEOMicF5o1OYDPZAu8xjz+UimFzvqIg5uVWZUHfRafcMx88sqPPM8Blpq21dvNEJ5wZYhQOBSYMgM3tiqIcCfkLgypeTfY5jMP/U3hVkhxD3jDlVZPvwrBGHtSnfrCJhJPda5mf9iTuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160929; c=relaxed/simple;
	bh=o5jE1EWyHKiwDEkXa08afE8+njw3zxQHzjv8aPnH4gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtsFTPrXCuhnTAkV8zWfQOiu7pXPV0Ct7AP2ZKp7hEjN4IZ+RZh3GfJkIf7i8k/Uu8/CeuLJQRojjNvTheFse1RqlN4fm6UPF8E9yVBIUmZeiYgdRQ4pIfq58NKo28H1Nqd3h6rnHoHpZghSAr7mdSva4975sXk3RE1CLFQhsfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyds+CCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyds+CCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A524E1F00893;
	Sat, 30 May 2026 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160928;
	bh=ZQaM7J8IW9M3CWG+kj7sTKFl9CdCNsajMQh3la6vzRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyds+CCR5slKUIi/aEcEOo+ggyQ/DlGULYFX6nglCYqGyehga221C6GjtKzzUhHdk
	 8OPDxB9FQrqurDlQf5Nh35/XnoJ0lmyIRMRroiqInlYVSBliRgDClINh1bfncNqWhg
	 EgTyrxgqFaFoRm2zyWUdThQzsI5XIavyXfKCPgrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 476/969] netfilter: xt_socket: enable defrag after all other checks
Date: Sat, 30 May 2026 18:00:00 +0200
Message-ID: <20260530160313.441408552@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 542be3fa5aff54210a02954c38f07e53ea9bdafd ]

Originally this did not matter because defrag was enabled once per netns
and only disabled again on netns dismantle.  When this got changed I should
have adjusted checkentry to not leave defrag enabled on error.

Fixes: de8c12110a13 ("netfilter: disable defrag once its no longer needed")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_socket.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 76e01f292aaff..811e53bee4085 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -168,52 +168,41 @@ static int socket_mt_enable_defrag(struct net *net, int family)
 static int socket_mt_v1_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
-	int err;
-
-	err = socket_mt_enable_defrag(par->net, par->family);
-	if (err)
-		return err;
 
 	if (info->flags & ~XT_SOCKET_FLAGS_V1) {
 		pr_info_ratelimited("unknown flags 0x%x\n",
 				    info->flags & ~XT_SOCKET_FLAGS_V1);
 		return -EINVAL;
 	}
-	return 0;
+
+	return socket_mt_enable_defrag(par->net, par->family);
 }
 
 static int socket_mt_v2_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_socket_mtinfo2 *info = (struct xt_socket_mtinfo2 *) par->matchinfo;
-	int err;
-
-	err = socket_mt_enable_defrag(par->net, par->family);
-	if (err)
-		return err;
 
 	if (info->flags & ~XT_SOCKET_FLAGS_V2) {
 		pr_info_ratelimited("unknown flags 0x%x\n",
 				    info->flags & ~XT_SOCKET_FLAGS_V2);
 		return -EINVAL;
 	}
-	return 0;
+
+	return socket_mt_enable_defrag(par->net, par->family);
 }
 
 static int socket_mt_v3_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_socket_mtinfo3 *info =
 				    (struct xt_socket_mtinfo3 *)par->matchinfo;
-	int err;
 
-	err = socket_mt_enable_defrag(par->net, par->family);
-	if (err)
-		return err;
 	if (info->flags & ~XT_SOCKET_FLAGS_V3) {
 		pr_info_ratelimited("unknown flags 0x%x\n",
 				    info->flags & ~XT_SOCKET_FLAGS_V3);
 		return -EINVAL;
 	}
-	return 0;
+
+	return socket_mt_enable_defrag(par->net, par->family);
 }
 
 static void socket_mt_destroy(const struct xt_mtdtor_param *par)
-- 
2.53.0



