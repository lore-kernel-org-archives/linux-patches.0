Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFCB17A2FC;
	Wed, 20 May 2026 18:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301899; cv=none; b=SwnujJXDZknvBfz8MzZgnkAOUp2X8YulhMYLRdoAYh1Fp1w9ASxpoDcDOMcroNB2A1sRq/ewbwq7YXlg/az/KKI9VmuoXSFVF2kKwtpi2SEFnIrmk/0uz8NmfW4peh0vTGR9lB47GAhm9/qoxd8HcM9bZDA0Yq5Z70walcy+PBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301899; c=relaxed/simple;
	bh=rAqBpFJ61eRqon2zYaW714zI9gCusYoqqfuqrjsx9lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zp9U90bdRnMpGyFJOVN33C6/Cjns8rd8grq/z5257Zx+qwqV/u6nvWZUdIg30+Xlh/9Lo0VE2gAvmqEXLiEk2FNf8dZhFALxpmKDy/5OVVvCU/7PL2C9E+KwVgeuJPrOprof6WGUuyySRVV2J9KA2B1F/BuBagp/RszoCH55hwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhOIRfMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhOIRfMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E931F000E9;
	Wed, 20 May 2026 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301898;
	bh=o6IBXPNPL4deh+PqbltGVs4F40mj0QaYHWz3s59ooX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhOIRfMRm/Wc/kWy+OotM7vyIeXZmBtBB75+AhRtpC4p193lrBOI76qJfffQLdo1I
	 gtB5w4yXEXiqIyVv8JPbc4kL4GS10zCx2jXFht4c+MCX2EU16JIttLpLHKe0Tm0nJe
	 CJo5xHFeMDAe1Nk9fS0lPddWMT4275N/irdOiMBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/508] netfilter: xt_socket: enable defrag after all other checks
Date: Wed, 20 May 2026 18:18:04 +0200
Message-ID: <20260520162059.922458414@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



