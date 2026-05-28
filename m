Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1204A409607;
	Thu, 28 May 2026 20:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998753; cv=none; b=Knh7prqfXPOIzYaYhwqZOcnyOUQteVaBg9Wqxdmmi4Bt3nLasY9idsP5nPTh8KSNdhWzxkLE+knSewMuLPFN5nHvVTTThS3Dao38pseLe6IWdjqZYm/m30grHMHAV54CbsfBIaYjzR33k5XBjJBJyqJs/zrcVkMWExwYmZcQpoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998753; c=relaxed/simple;
	bh=5ae+NkuuOINvoE1XEZU5qiAeMwgHkBPZ/5QPdBeOH0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyyMmxjzarWNtJxr3k1c2fdnE2ETRzbvIXa1viGmSmDUtNaCZURjNQ1LZtbywTtEqJstE/wuqpYEPKHrZ7/pojprjA5rlbJ7Q4SOTyHVeQzgv27umUaVYv0tksuS+YiA72Oe1taq8GupGAfJFSveh1k1Wi7STv4dg0QFbhxdbqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUfrFUZT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUfrFUZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B7A1F000E9;
	Thu, 28 May 2026 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998752;
	bh=SKWDvADI4MRQc5+DaEfCSfOmCwfVOJEkguJ+o8P5iBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUfrFUZTM9dRi7/uQGP0jPnrEiM5OLAlf6/iJyyEGujjn21hoRQO7uVMrDhID4oTD
	 WxqSSupMrJW2rF1i0+HMd6KOQzlpmrAKvxZ9s8w4Town7VSs8qtAx2RqpxSIPRB0up
	 tDoIar4jo1f5b9hqAdxwKBzczd+WlfypnHVV29Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 286/461] net: shaper: reject QUEUE scope handle with missing id
Date: Thu, 28 May 2026 21:46:55 +0200
Message-ID: <20260528194655.479436278@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 4ae3ee6764a0a..b1c65110f04d3 100644
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



