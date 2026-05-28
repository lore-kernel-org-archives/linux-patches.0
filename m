Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD6A2E7379;
	Thu, 28 May 2026 20:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999996; cv=none; b=BKG60l+W0kwZZwx0Px+RfaOpJMWa3/dVcGRBavLaoo88VJOdrAxkxZMVwD+ID+SEVIrjvvGdg7oB1P4PnzEwjz8DXXG09O4JA2yYMkHvFcgsPs2sExId48jaJHDg1cTl8x07BIFSJkMT/UXb9/Q7SEfoX+bCLcBXZfgQuLi2jvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999996; c=relaxed/simple;
	bh=FrJCsQptvNbmFKNMiWixRVf4cx/9JEE4SioHKNAt+Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9Pb+O+TTCjShBJPRkr3Hyi4CT+Eb5mYykzhqUJPK9iINLglHRujJ92+bpISAyWb/8CNTCxNJzqDxIanMByH4Aa6vlrtLcqPsj4Ys/pIK40Nd/6YbVXclO9PUj0rfNya4fYslTEOnwc09RgX8a/NnoO137pI66AgWT/XuHqGW2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Gt2sMSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Gt2sMSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D4C1F000E9;
	Thu, 28 May 2026 20:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999995;
	bh=F1kTXidGY0MMXIA7mOsCrbdTiCPTXwtNjFrszB0Tkaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Gt2sMSj4UxhUZcgxlHvT+SnLu1bMoZbIflShIoXTNTzThEQkzEZtwFNqtxmiuztj
	 A2i52UBY+cJeJcu3qIXmI4EVyyEhEGHXkT/W81mrs7sQjQt0Eq1xmWVh22wJ2X+SNZ
	 ffJRdU31nL5RZ74GakjgKijIGYv8gSJHDDNupTpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 264/377] net: shaper: reject QUEUE scope handle with missing id
Date: Thu, 28 May 2026 21:48:22 +0200
Message-ID: <20260528194646.011099342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ce372e869f9f492f3d5aa9a0ae75ed52c61d2d6f ]

net_shaper_parse_handle() does not enforce that the user provides
the handle ID. For NODE the ID defaults to UNSPEC for all other
cases it defaults to 0.

For NETDEV 0 is the only option. For QUEUE defaulting to 0 makes
less intuitive sense. Specifically because the behavior should
(IMHO) be the same for all cases where there may be more than
one ID (QUEUE and NODE).

We should either document this as intentional or reject.
I picked the latter with no strong conviction.

Fixes: 4b623f9f0f59 ("net-shapers: implement NL get operation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260510192904.3987113-11-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index d65008b819dc9..23d535f157294 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -477,10 +477,15 @@ static int net_shaper_parse_handle(const struct nlattr *attr,
 	 * shaper (any other value).
 	 */
 	id_attr = tb[NET_SHAPER_A_HANDLE_ID];
-	if (id_attr)
+	if (id_attr) {
 		id = nla_get_u32(id_attr);
-	else if (handle->scope == NET_SHAPER_SCOPE_NODE)
+	} else if (handle->scope == NET_SHAPER_SCOPE_NODE) {
 		id = NET_SHAPER_ID_UNSPEC;
+	} else if (handle->scope == NET_SHAPER_SCOPE_QUEUE) {
+		NL_SET_ERR_ATTR_MISS(info->extack, attr,
+				     NET_SHAPER_A_HANDLE_ID);
+		return -EINVAL;
+	}
 
 	if (id && handle->scope == NET_SHAPER_SCOPE_NETDEV) {
 		NL_SET_ERR_MSG_ATTR(info->extack, id_attr,
-- 
2.53.0



