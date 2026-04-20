Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D205F2E093A;
	Mon, 20 Apr 2026 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700207; cv=none; b=j2ksT1rrJN8bRKVh9uvGnfg2qHVZ+1HfdZfwKPFR5bEJwgknLKCix4pVK/wvDJ3/HTuqEUI3/odbUx5zWhYkNEjcPz86LzeVzz8hvCAZgOD2V6zJyx7HlMAUUgF4seMwUHDjjDa5l8JC3YEj6z34EO/d8ywqXMcwhlDpSDRT5Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700207; c=relaxed/simple;
	bh=0XcqaLs6WdIHh18G1LDHBJyalWeluT1RXZ/iMDy/Mj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCs0QwjVSz/SfhzkjRycHNPPphPPW7mVgVUfBxPMyXqgxojhjsLpgbFByQ+jzDv+I1AqONaVtoKl1vaNVz7NpULd3IiHpl3agOJAxlWm9inzgrUzVDilI5s5/aPbII//OTNxsdv0d9lSuNMltI9sIDVjbUNTG/OuY2J9YwCpPuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EccQ7dVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EccQ7dVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D59C19425;
	Mon, 20 Apr 2026 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700207;
	bh=0XcqaLs6WdIHh18G1LDHBJyalWeluT1RXZ/iMDy/Mj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EccQ7dVqvippuctCaR4XKjOzyoGNKdgYxl0AHDRLO7vifxOpsNI8Q9izRRRsjMtKd
	 ncoP8UQx09QPPzf3fRhxkB2ejiKAznCwCLRpdV2TTsbfEuAVPvUX7SRqBI85YfnPYK
	 X81qZg98IQ65n7O2AL8qcZRTLd7BcGyCVDU/FsbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 084/220] ipv4: nexthop: avoid duplicate NHA_HW_STATS_ENABLE on nexthop group dump
Date: Mon, 20 Apr 2026 17:40:25 +0200
Message-ID: <20260420153937.061648965@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 06aaf04ca815f7a1f17762fd847b7bc14b8833fb ]

Currently NHA_HW_STATS_ENABLE is included twice everytime a dump of
nexthop group is performed with NHA_OP_FLAG_DUMP_STATS. As all the stats
querying were moved to nla_put_nh_group_stats(), leave only that
instance of the attribute querying.

Fixes: 5072ae00aea4 ("net: nexthop: Expose nexthop group HW stats to user space")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260402072613.25262-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 427c201175949..aa53a74ac2389 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -905,8 +905,7 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nexthop *nh,
 		goto nla_put_failure;
 
 	if (op_flags & NHA_OP_FLAG_DUMP_STATS &&
-	    (nla_put_u32(skb, NHA_HW_STATS_ENABLE, nhg->hw_stats) ||
-	     nla_put_nh_group_stats(skb, nh, op_flags)))
+	    nla_put_nh_group_stats(skb, nh, op_flags))
 		goto nla_put_failure;
 
 	return 0;
-- 
2.53.0



