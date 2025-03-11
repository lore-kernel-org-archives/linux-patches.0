Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FDB25DAEC;
	Tue, 11 Mar 2025 15:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707222; cv=none; b=QGo+oswWUEYtfbU0d2g3w/UN1/lz/ERU+wL8froJ/kuWWU56As85kKz8cLtgh+27Lcn2qlDUu+YPkxxUE+pJ9QNANMwYc4Z/qaiGoFztMyStwbKD5V2mdODv14KGBkcmSJfZIRivLwaEOmatszNR9HEY4S00TXsBCk5ClG3e6cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707222; c=relaxed/simple;
	bh=FhCIyObPoHC1yIGmCUV2N+6MDrbjM8QvAn22awu+1Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWg42VPsMfJKHPguDEIJzBT6UIkmOuedN5NNVhXZLOtpwx6Rp2gOjUITdcaVqKkiSsJ331cSdvCONpEslCuIJBilyNALiaLOvrOfAD9E8/1o871mPlNXKPe4glSrZpaBmBO5N9lYOSWqTNRlZX0cH6oN3uOrpkXIkloTVWVO6iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMpWdF+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMpWdF+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A64CC4CEEA;
	Tue, 11 Mar 2025 15:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707222;
	bh=FhCIyObPoHC1yIGmCUV2N+6MDrbjM8QvAn22awu+1Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMpWdF+SYaF31g6CU8aC54jADOv5Zv6Bl5RTAS2GO+lZ5mJgwNHQLGESeBmleq3st
	 S7K7GF4g0qaPa+jc9AvjyvJFWFZvPQbUjL/JLRmrQ0uKEqAetmv2PR4Ma1SIuKVq3Q
	 gS2MROogvZOUo57haeiw5k+yaIU/+iTwZHjXN5Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/462] neighbour: delete redundant judgment statements
Date: Tue, 11 Mar 2025 15:59:11 +0100
Message-ID: <20250311145809.631176108@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c187eb951083b..bd017b220cfed 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3387,8 +3387,7 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
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



