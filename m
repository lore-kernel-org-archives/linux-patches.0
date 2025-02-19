Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC511DEFE4;
	Wed, 19 Feb 2025 09:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957512; cv=none; b=uAKv5/eeAcOc9jgcNl0mlacv9yq98yvqv+d1705aJNwa3bsh3VvPcglMYOIDIllistofDggMw9Yw/8orY70DJ4fw77InnweGKgK50DbPOMUkKuHAqpnpFOYWC6EyLi66WA6FC6BddVbRoxtXvjVLVbRZTiFzdL9luRjeysaAjTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957512; c=relaxed/simple;
	bh=lxNlv66mllAsLtK2x3x3TX5AtCU4RqyrAaJVOO6E2D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJNvx3Cl/7KvuuoQHS4IyxszVEq2icyUqGEGBoDSyYAo3EviCs/5UnpVJD6GqqteafpvabcXAvyyiF4sHL2+jAkgiyifHyOlmTl0lkrxYVLy19Muej/B5oBh/4OGxnlr5+jBybnVsXMSRINAkXhYRsW/b7WLkMl3u73QxdYcM5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czOaYaVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czOaYaVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED88BC4CEEA;
	Wed, 19 Feb 2025 09:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957511;
	bh=lxNlv66mllAsLtK2x3x3TX5AtCU4RqyrAaJVOO6E2D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czOaYaVuilsTOns/hVSFqMDnRElA5ZMW0o/uXHMGp7v49BJJdF/Ftx6zFZZLymlG5
	 gVGHD+o+VOUUCQI/43IrBNv8j8JHdLE18ezByYhtTwvauUgiOjNcUCOIXmgSvdQ1sr
	 PCaK4i5HhKdliy2bp+mbEs4VGJGEfGaDD6YfOOOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 550/578] neighbour: delete redundant judgment statements
Date: Wed, 19 Feb 2025 09:29:14 +0100
Message-ID: <20250219082714.596301813@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit c25bdd2ac8cf7da70a226f1a66cdce7af15ff86f ]

The initial value of err is -ENOBUFS, and err is guaranteed to be
less than 0 before all goto errout. Therefore, on the error path
of errout, there is no need to repeatedly judge that err is less than 0,
and delete redundant judgments to make the code more concise.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: becbd5850c03 ("neighbour: use RCU protection in __neigh_notify()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index dd0965e1afe85..b127533e74f37 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3516,8 +3516,7 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
 	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, NULL, GFP_ATOMIC);
 	return;
 errout:
-	if (err < 0)
-		rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
+	rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
 }
 
 void neigh_app_ns(struct neighbour *n)
-- 
2.39.5



