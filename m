Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F18143C7E;
	Mon,  6 Jan 2025 15:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177729; cv=none; b=mmCWNqLz1N6RD2xslgojB0YQYEYXsekg+XDlJkiILfhHh3Nz6i1iV/UArOxAyKwsyEz3DRhUE6SdVCkjJhXCg6A03O6qF2T4u6+p5q/Wvn2KLrYe9kXXyGQO9nWMdhghFJ3Yy5ltopqjIMKOGVguqTfXK0xmwa2p5k9WP90yGKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177729; c=relaxed/simple;
	bh=pQJUoaOQXqcmNwLn4r7wCk/7erKaWqPPFgQ/IAYZofM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hq8OOyas6UYNmT0nSfwzVGyP7GjyMM7uJLwrW5dK8ICYzfI8L1Rn1cNS02QaK3dx+oWVM4Y2DaoHrdpQg5igtugNlQgrKqW4cylFVD7b0+IyYe9Z4l7Yv9vY2HYeJoDxokFoRK7K8diNxAWjOvcyIIGvssPhlc3rQO0ms9sPIaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwyqJ1Pl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwyqJ1Pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E8CC4CED2;
	Mon,  6 Jan 2025 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177726;
	bh=pQJUoaOQXqcmNwLn4r7wCk/7erKaWqPPFgQ/IAYZofM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwyqJ1PlB0PUvWD8IEE5XBRpM33lOYazQHG/x7TFa27VMD7a1DoOb320scQgmKJnj
	 4NbRUdHvJ6YWQ2SlIwqpO+oWRoTfVfb481KRj6vK/nIhsFRDSAvLkdMI2lFJwrg0gL
	 R8FJbmS7711CaQh0nlGRxUkrjqSQilHAj90H0cfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/156] netdev-genl: avoid empty messages in napi get
Date: Mon,  6 Jan 2025 16:15:22 +0100
Message-ID: <20250106151143.097187389@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4a25201aa46ce88e8e31f9ccdec0e4e3dd6bb736 ]

Empty netlink responses from do() are not correct (as opposed to
dump() where not dumping anything is perfectly fine).
We should return an error if the target object does not exist,
in this case if the netdev is down we "hide" the NAPI instances.

Fixes: 27f91aaf49b3 ("netdev-genl: Add netlink framework functions for napi")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241219032833.1165433-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 7ce22f40db5b..d58270b48cb2 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -228,8 +228,12 @@ int netdev_nl_napi_get_doit(struct sk_buff *skb, struct genl_info *info)
 	rcu_read_unlock();
 	rtnl_unlock();
 
-	if (err)
+	if (err) {
+		goto err_free_msg;
+	} else if (!rsp->len) {
+		err = -ENOENT;
 		goto err_free_msg;
+	}
 
 	return genlmsg_reply(rsp, info);
 
-- 
2.39.5



