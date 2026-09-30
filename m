Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C204730D401;
	Wed, 30 Sep 2026 19:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796279; cv=none; b=ElmRNWHvcTR8fYa1EC2FzaxAQNs3fyE0ilan0qpD8o9Trn1g2YjO16le6UhXdAbKVnPJg1c4gBLP4fFqnQdfYQr+cRJl5Ftpz8xuUXoq1qVLLpX29C7bj7Hz857ISZ2th6yEP9SnKZw0rLUjShjnHpbso5SHpRTwUJKS2jxcnuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796279; c=relaxed/simple;
	bh=ubXSYRyM3Z6UohwwJMNHDcl7ptBXgao48TInh4neR2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQdMWn1nw+lpMVaIbGqWJUtsG8DPF99JdWOFjDOTOOTSPTN7G1FPYPnNlrvNPAND1IPBiUCV8m8keue9WEXuXO6T0r5/0Tic950ZaYfQL2j1CvnRKxGC3E53hutpq0r25SFWU2eF8DafZg0pWbi5Z4bj/iI0oo3lEw2HpCJx9L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18LCfurW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18LCfurW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2834D1F000FF;
	Wed, 30 Sep 2026 19:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796278;
	bh=8xUZWWcyzOC3MYokKgtsd8xNXIY8Vo8z/jNyiqdKw7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18LCfurW+7etgtUbd7IUQGOMlNFSnIUcqNirmgV3D8wx231V8uDuDMoEjY0lDOk1Z
	 nCX31T94Q/2adwGlGfSNBSxuJddmdRSsugHxPPteRXrthkdi2N3xL69HmZ+mLl2iv5
	 9Q7j8xpSa/utUFq9czRG/lmKlaAWt2z7FKkqd0TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0812/1193] drop_monitor: fix out-of-bounds write in reset_per_cpu_data()
Date: Wed, 30 Sep 2026 17:24:56 +0200
Message-ID: <20260930152452.285227905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 439f392084f8f7f59ab9d47a9579185accefe1d8 ]

In reset_per_cpu_data(), al is computed as:

    al = sizeof(struct net_dm_alert_msg);
    al += dm_hit_limit * sizeof(struct net_dm_drop_point);
    al += sizeof(struct nlattr);

    skb = genlmsg_new(al, GFP_KERNEL);
    ...
    nla = nla_reserve(skb, NLA_UNSPEC, sizeof(struct net_dm_alert_msg));
    ...
    msg = nla_data(nla);
    memset(msg, 0, al);

Because al includes sizeof(struct nlattr) (the 4-byte attribute header),
genlmsg_new() allocates al bytes of tailroom starting at nla.
However, msg points to nla_data(nla), which is located
sizeof(struct nlattr) bytes past nla. Calling memset(msg, 0, al)
therefore writes al bytes starting from msg, exceeding the allocated
buffer by sizeof(struct nlattr) (4 bytes) and corrupting
skb_shared_info.

Fix this by letting al represent only the payload length, allocating
the skb with genlmsg_new(nla_total_size(al), GFP_KERNEL), and zeroing
al bytes from msg.

Fixes: 683703a26e46 ("drop_monitor: Update netlink protocol to include netlink attribute header in alert message")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260910204612.3762015-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/drop_monitor.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 052abd988e80a..c0489d5339ce3 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -140,9 +140,8 @@ static struct sk_buff *reset_per_cpu_data(struct per_cpu_dm_data *data)
 
 	al = sizeof(struct net_dm_alert_msg);
 	al += dm_hit_limit * sizeof(struct net_dm_drop_point);
-	al += sizeof(struct nlattr);
 
-	skb = genlmsg_new(al, GFP_KERNEL);
+	skb = genlmsg_new(nla_total_size(al), GFP_KERNEL);
 
 	if (!skb)
 		goto err;
-- 
2.53.0



