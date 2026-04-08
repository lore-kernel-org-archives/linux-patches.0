Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC14A347517;
	Wed,  8 Apr 2026 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671724; cv=none; b=SE6THG9znSJNi0jgIHYQc/16FiwQL/KQIsypMZigoBTwZe8n/bMdxyOg+4jUqwAV2tFYxonnSmz0GBLvZszs/57xwv3v3tR4poIJGWwF5XFa5rdRFMLFRIYkyjHkaS6/UR9uyHGSUpL2efAKrB7L4W8yPEwnXaEPnuCe+Q7yXVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671724; c=relaxed/simple;
	bh=wIyfX9h5jgJJCcZOhJdSv8gd8ya7c3gghh4JNzx0J94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBeTFxo6gjGadW73Ln7I7I1HNLcKnpKI9wbHjgashCxmyFU9DqnCvUn1WjIINyyYHfvlAqcX7SO+ZIRZtk3xGhPYlQNAalMYCWbDVnsfJbI45Raqk4CTn0TJYJy7l1GvcP3XjcErc8iP9LFA6BOtHR82trwOt8mJrcUodVpfo80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqpGNYiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqpGNYiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C81C19421;
	Wed,  8 Apr 2026 18:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671724;
	bh=wIyfX9h5jgJJCcZOhJdSv8gd8ya7c3gghh4JNzx0J94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqpGNYiLEUV0nnq+w09JtaQnYVeN3IiWwYLBMFZzNqAU1NUXE9AzkB6zwT8bJPQCO
	 sc6QvZvROxg3mS9ADStDCOTbNvE2NPG7IjwfR214I55zwNbTLdAwR/sq5mbci/InMJ
	 jJf3PU2J2MeLva6JX14ot4usDFmXJOwkGm4iYWZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/312] rtnetlink: count IFLA_INFO_SLAVE_KIND in if_nlmsg_size
Date: Wed,  8 Apr 2026 19:59:20 +0200
Message-ID: <20260408175935.343677479@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit ee00a12593ffb69db4dd1a1c00ecb0253376874a ]

rtnl_link_get_slave_info_data_size counts IFLA_INFO_SLAVE_DATA, but
rtnl_link_slave_info_fill adds both IFLA_INFO_SLAVE_DATA and
IFLA_INFO_SLAVE_KIND.

Fixes: ba7d49b1f0f8 ("rtnetlink: provide api for getting and setting slave info")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/049843b532e23cde7ddba263c0bbe35ba6f0d26d.1773919462.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 78e39543e408b..e5bfa3cbfcc41 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -567,11 +567,14 @@ static size_t rtnl_link_get_slave_info_data_size(const struct net_device *dev)
 		goto out;
 
 	ops = master_dev->rtnl_link_ops;
-	if (!ops || !ops->get_slave_size)
+	if (!ops)
+		goto out;
+	size += nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_SLAVE_KIND */
+	if (!ops->get_slave_size)
 		goto out;
 	/* IFLA_INFO_SLAVE_DATA + nested data */
-	size = nla_total_size(sizeof(struct nlattr)) +
-	       ops->get_slave_size(master_dev, dev);
+	size += nla_total_size(sizeof(struct nlattr)) +
+		ops->get_slave_size(master_dev, dev);
 
 out:
 	rcu_read_unlock();
-- 
2.51.0



