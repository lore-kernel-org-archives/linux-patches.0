Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D2F341047;
	Tue, 16 Dec 2025 11:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884783; cv=none; b=mFCJwxVa11rarTC5HuW4020lELYiRcHI7zJhwuJDi5lPXr9AAhUOWD9aKcljA0+2nII3TMukAY5Tu95cyqwCtas/AbQEwfyR4qa0eui1JCURG9tVO7VeTR0+Mf0aSYgz6iTJcj2aWnaeHEfqRp/HdTY0nwrGi3eyccm9VdzlgxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884783; c=relaxed/simple;
	bh=c0J7izQNxzumSvHQn1YdzKE2HyaW6B+FBk/liXYcA+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZx6hDltI0O63HQ/GqjmxT35wY1mpH56sbu10x08ir5dCaIsxqArMNxGyKPHkFLTJVEb8Ixc9SgiDqeB6di+7/N5ZrQqJ3pwa1CCaz0uTi28ZOCQeroDEQ6sDmu1BR0DAggRf4LVrKKyxAfiFUl0l4XzMygGMwOaXUtH05wmF60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0Ei6nnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0Ei6nnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0C1C4CEF1;
	Tue, 16 Dec 2025 11:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884783;
	bh=c0J7izQNxzumSvHQn1YdzKE2HyaW6B+FBk/liXYcA+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0Ei6nnXWD394THKjrJHD2OPuo+CSvubMPc7f+/WauYrSmUgHWAs5njLEkTBWyXdR
	 /OdHe47aImp7FxuDdb6OmEi4gxu2vkfx+PmK3LtpwuwwsjDCgFH5Ch5yDm7wERqZXg
	 hzcY4Y+MgwjHcGIMCk/tgOShlvbZTO3pAL8lvRyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 280/354] net: hsr: remove synchronize_rcu() from hsr_add_port()
Date: Tue, 16 Dec 2025 12:14:07 +0100
Message-ID: <20251216111331.058964724@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a3b3d2dc389568a77d0e25da17203e3616218e93 ]

A synchronize_rcu() was added by mistake in commit
c5a759117210 ("net/hsr: Use list_head (and rcu) instead
of array for slave devices.")

RCU does not mandate to observe a grace period after
list_add_tail_rcu().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250107144701.503884-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 30296ac76426 ("net: dsa: xrs700x: reject unsupported HSR configurations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_slave.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 01762525c9456..9ac7cf0835118 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -210,7 +210,6 @@ int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
 	}
 
 	list_add_tail_rcu(&port->port_list, &hsr->ports);
-	synchronize_rcu();
 
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	netdev_update_features(master->dev);
-- 
2.51.0



