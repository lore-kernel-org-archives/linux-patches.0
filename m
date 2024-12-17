Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C271F9419;
	Tue, 17 Dec 2024 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456758; cv=none; b=ckjtMLVEuKkT/BrbuE47rcXu1S8KACY1fgyYcG8iuR78B16jJHoe7+XWuvkFnWbxmgZRAGSQuPAheINVb1ytGY4i9sA9VOWTKu6RJJlnChYh3Y60wOiSxUJORrpz4W/P4+eaKwVN9TJFsN2JowbsweoF/77bTNDKJIQ6+5vDXZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456758; c=relaxed/simple;
	bh=j/YtBfc4gt/3zJj7nporBarNNSNI4Fkj3kY2CB1yrbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSYXmOnRQ3EeW4xrokw2XXldm0A7YEz5x/H4Lg7i/N3zAdp0Lf8WH6WLrMa9Pfwl7C8zbf94gDTdadmnjFZH3EkGfdcuba7vH1/YSEsh4mM9lee2s8Obdjqq61gFXsBCm3ov2DDfwttAU6u8G/6IUHIeYVWsllSFJ/gabwY1rCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbAPCJaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbAPCJaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96DDC4CED3;
	Tue, 17 Dec 2024 17:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456758;
	bh=j/YtBfc4gt/3zJj7nporBarNNSNI4Fkj3kY2CB1yrbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbAPCJaDGd3UO9udhPYawPwqceZmWVuM9uQ5lzEpuyzazvdQojjz5xkChKX10jBAw
	 SUnlf1uM2ZHPDtsYarFnVGMAdiCHqyoEY/2I0lhCicr0rXSCQhzbukeKctJXUpfRfq
	 uzVurWyzrIhUUQmAaJCgTwa0/jyCQiXiSXBEWCl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hodaszi <robert.hodaszi@digi.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/172] net: dsa: tag_ocelot_8021q: fix broken reception
Date: Tue, 17 Dec 2024 18:08:32 +0100
Message-ID: <20241217170552.801509750@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hodaszi <robert.hodaszi@digi.com>

[ Upstream commit 36ff681d2283410742489ce77e7b01419eccf58c ]

The blamed commit changed the dsa_8021q_rcv() calling convention to
accept pre-populated source_port and switch_id arguments. If those are
not available, as in the case of tag_ocelot_8021q, the arguments must be
pre-initialized with -1.

Due to the bug of passing uninitialized arguments in tag_ocelot_8021q,
dsa_8021q_rcv() does not detect that it needs to populate the
source_port and switch_id, and this makes dsa_conduit_find_user() fail,
which leads to packet loss on reception.

Fixes: dcfe7673787b ("net: dsa: tag_sja1105: absorb logic for not overwriting precise info into dsa_8021q_rcv()")
Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241211144741.1415758-1-robert.hodaszi@digi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_ocelot_8021q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 8e8b1bef6af6..11ea8cfd6266 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -79,7 +79,7 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 				  struct net_device *netdev)
 {
-	int src_port, switch_id;
+	int src_port = -1, switch_id = -1;
 
 	dsa_8021q_rcv(skb, &src_port, &switch_id, NULL, NULL);
 
-- 
2.39.5



