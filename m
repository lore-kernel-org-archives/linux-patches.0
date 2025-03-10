Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E98F230BC5;
	Mon, 10 Mar 2025 17:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628445; cv=none; b=WU2bqE2mi+sSCC0WSdq+pv1xgy60p5proqoWHeRSzIBZOspTM1WWgjeUTwbGwvVjcqwbXAfob8kTvf9y/zMYvTVpEo/4a7A6/WbKGwChENFAw/RJjFu1jVu09mXXkEVJrU4IQBTHzJ+Cl0SMmb4BqBm5N8qblH7kO8bOQTDmwP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628445; c=relaxed/simple;
	bh=9qj3qQRmBoMjurH+NgGHfFgtKiey7oNsW8MqWHotkOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZwYHt6VsQqYNXWxiUjw2SSzSJpw9tU4twdNmacp1XP9P9/sCPIEV2f+9ZDeXCFbUhx6Xr5fOvu/Iw9RwWXb2ZW91ost6ObJxhhs3uvgepMQ49SUXlLYqSiye8Mv6wGWtCiMGwN92HBdnvim+BBziirotbNVp3YKNvqB7gLnfMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pw1JKR8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pw1JKR8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDD3C4CEE5;
	Mon, 10 Mar 2025 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628445;
	bh=9qj3qQRmBoMjurH+NgGHfFgtKiey7oNsW8MqWHotkOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pw1JKR8M1TVcxikO+pEehWzRK/Yq1eUeGoP+9/SZ8JYpxyqDOjQguVBB79ZRxxGZA
	 /O7WkjFvfQi82/aFUDr7QmkEm8rt+mLfsCw1RfRKBidWNmjrVhgvJP6xWOb+3vgeQG
	 GHV8COiEK2IjcClsDgod6rWCF0UqfgwIJpkxTz34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Herbert <tom@herbertland.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/109] net: ipv6: fix missing dst ref drop in ila lwtunnel
Date: Mon, 10 Mar 2025 18:06:45 +0100
Message-ID: <20250310170429.997660613@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 5da15a9c11c1c47ef573e6805b60a7d8a1687a2a ]

Add missing skb_dst_drop() to drop reference to the old dst before
adding the new dst to the skb.

Fixes: 79ff2fc31e0f ("ila: Cache a route to translated address")
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Link: https://patch.msgid.link/20250305081655.19032-1-justin.iurman@uliege.be
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ila/ila_lwt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ila/ila_lwt.c b/net/ipv6/ila/ila_lwt.c
index 6d37dda3d26fc..7397f764c66cc 100644
--- a/net/ipv6/ila/ila_lwt.c
+++ b/net/ipv6/ila/ila_lwt.c
@@ -96,6 +96,7 @@ static int ila_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
+	skb_dst_drop(skb);
 	skb_dst_set(skb, dst);
 	return dst_output(net, sk, skb);
 
-- 
2.39.5



