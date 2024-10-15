Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08D61C07FF;
	Tue, 15 Oct 2024 13:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997870; cv=none; b=lMO8wYQmWwYXdZMxKZzqJNLe4qUuswV4qnlVznBaAe3x+Whc3ca0tn3O2JWRJOB76yFxZfyRk9TVNeC5dBZJB4pw5Ef8Tb6bOV7Jh324uwEDTPCbnZHKDKxKLnHrVPo7llOUDgtY786hp4UgTVDDoRmZeZ2leykaeD1CxOJ+KaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997870; c=relaxed/simple;
	bh=bRmnX6EEPP+e32RNIh9XOl714Jf6ObpLHXeC56lM/1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4KY3xZngu38dg7LwtAR+Dp7s3aZhCi2Z30ZQm6Ll3Z9wuLb0i1uRGnou5KryFYSFbNpxYIKnQcEae4cpvSKy8qZ7nGBzFMQc0HGx6H652Q14lUemJBjj8iiyBJvJA+h0EJzbOrBwMhCCFwwiPl1smg5drqUqR+Xc7DlR8ZjdEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAhXXdJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAhXXdJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30072C4CEC6;
	Tue, 15 Oct 2024 13:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997869;
	bh=bRmnX6EEPP+e32RNIh9XOl714Jf6ObpLHXeC56lM/1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAhXXdJRzAmXOhWw06+M4TgpIkoAQADvD0XL1TvgyyR7Pdq46FreQzAjTvl5rzpEj
	 YuZHefLnvX/lMsr1Rt2gUcHcbRnJ/ZAjH0rwd9x6pO+PG1vwiOBaZssx/duNO6mVOC
	 W12mrewv4xLCPryBl+3hnQ38lDWoqcIcDh9z5mak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 312/518] ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family
Date: Tue, 15 Oct 2024 14:43:36 +0200
Message-ID: <20241015123929.026020816@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 8fed54758cd248cd311a2b5c1e180abef1866237 ]

The NETLINK_FIB_LOOKUP netlink family can be used to perform a FIB
lookup according to user provided parameters and communicate the result
back to user space.

However, unlike other users of the FIB lookup API, the upper DSCP bits
and the ECN bits of the DS field are not masked, which can result in the
wrong result being returned.

Solve this by masking the upper DSCP bits and the ECN bits using
IPTOS_RT_MASK.

The structure that communicates the request and the response is not
exported to user space, so it is unlikely that this netlink family is
actually in use [1].

[1] https://lore.kernel.org/netdev/ZpqpB8vJU%2FQ6LSqa@debian/

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 41f890bf9d4c4..0394146f813c5 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1334,7 +1334,7 @@ static void nl_fib_lookup(struct net *net, struct fib_result_nl *frn)
 	struct flowi4           fl4 = {
 		.flowi4_mark = frn->fl_mark,
 		.daddr = frn->fl_addr,
-		.flowi4_tos = frn->fl_tos,
+		.flowi4_tos = frn->fl_tos & IPTOS_RT_MASK,
 		.flowi4_scope = frn->fl_scope,
 	};
 	struct fib_table *tb;
-- 
2.43.0



