Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C8259CAD;
	Tue, 25 Mar 2025 12:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905795; cv=none; b=I12O89jhoYbiHLPqeD0PRE1tZRqUxjJ6OzaT37CrL5xpirY+nh1xpqNpCsiJeNvD8CWmpzDB/W5DrXt+7to3dRC6kgo0sr3Ik2XbengygmkQld8my87YzdXBmBIPMXiDMsRjFaTnNpXtHrgmKAYoXw1pmov2rMkLQdXCMG/gHaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905795; c=relaxed/simple;
	bh=6PXrR39ef/iTh6MJoflNf3xSY/Y9fbE0WBZP69Q3HoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XT2xY38CmwsCuuUrj/IFNvVSZX1yRl/QWYqbAk51YW3MMb/o4wgM9Ge4Bg5HZMmnvyHZouomGeuoSlOdQttPZxnte0pPpzlLMY00+er64T5QYXe72WpbEVfc4npFRK/8c98LKl66NcQWZzgAywPGUkUqhAAwrbwAh4xaq4cCGzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZS0PGJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZS0PGJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D258EC4CEE4;
	Tue, 25 Mar 2025 12:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905795;
	bh=6PXrR39ef/iTh6MJoflNf3xSY/Y9fbE0WBZP69Q3HoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZS0PGJSHzCxD9vAfX67qcm5HSWxk3XDOz796xLRD7kfaj02Tn8xTKJFaxzA/aVgw
	 ZK1LyQ9tAiz/6dEq7vcWV/b5ECt5wajys+4RIHfdCxjs3OzaXSjbvAmAw2U8FvIneS
	 vhhUmbonZXLg3+tvXBIaLbqUVeyf83ksjHR6X5H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/198] net/neighbor: add missing policy for NDTPA_QUEUE_LENBYTES
Date: Tue, 25 Mar 2025 08:22:08 -0400
Message-ID: <20250325122201.003665032@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 90a7138619a0c55e2aefaad27b12ffc2ddbeed78 ]

Previous commit 8b5c171bb3dc ("neigh: new unresolved queue limits")
introduces new netlink attribute NDTPA_QUEUE_LENBYTES to represent
approximative value for deprecated QUEUE_LEN. However, it forgot to add
the associated nla_policy in nl_ntbl_parm_policy array. Fix it with one
simple NLA_U32 type policy.

Fixes: 8b5c171bb3dc ("neigh: new unresolved queue limits")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://patch.msgid.link/20250315165113.37600-1-linma@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 2e2c009b5a2db..bcc3950638b91 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2283,6 +2283,7 @@ static const struct nla_policy nl_neightbl_policy[NDTA_MAX+1] = {
 static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_IFINDEX]			= { .type = NLA_U32 },
 	[NDTPA_QUEUE_LEN]		= { .type = NLA_U32 },
+	[NDTPA_QUEUE_LENBYTES]		= { .type = NLA_U32 },
 	[NDTPA_PROXY_QLEN]		= { .type = NLA_U32 },
 	[NDTPA_APP_PROBES]		= { .type = NLA_U32 },
 	[NDTPA_UCAST_PROBES]		= { .type = NLA_U32 },
-- 
2.39.5



