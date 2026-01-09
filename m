Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D393335BCD;
	Fri,  9 Jan 2026 12:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962620; cv=none; b=DJfMoZZmqg5ISyaa9wO+qq89CGS5YXc99wjMgitvJMz0UhohSDWFWalG49xuyPWBn551AWvoXpvZ9DP1cAqvsltgkbulT5rRiPY7z5d+/Pgpkbk0fdCfB46G/MbNcaPhu8LIGkdrAJ/IGzdUxCb9CcGj5YBqVgSqEJpZKvFn1cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962620; c=relaxed/simple;
	bh=OVkbW6vFZ2e+l1WHI+UeIpQIVALe8WnxZoAQjrRnyGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KV6aIG26h8X32U5VOhloJGwvRfU+nbWTsVgQQ3oOftndbIi6zSr/+9aKctWk2Lz1EllCOzyaR1deAtPAkQvI21lYfJw5IJdfLtC4hqND5Bt++pab3U7aq3QRHsCBiKkOs/yWP7FEho1PMnhEqLXPxZR0MJ5+pWWIaWQIRmTZqmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4bx7N7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4bx7N7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A096C4CEF1;
	Fri,  9 Jan 2026 12:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962620;
	bh=OVkbW6vFZ2e+l1WHI+UeIpQIVALe8WnxZoAQjrRnyGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4bx7N7Wi9UPimH6azfVGF0tlrdZ7J3PkjEfUqnEVcP8qCR6NVnFXEZQzhZk4Entd
	 9F2J0WKAsn4OjS+cnSkvZ94/saMdz4bmk0EzyFsPN1FTQkYiBMhabTYYrymKiPDS0/
	 E7JIbnDRGybfJH89UbprQgkIfHaJUwfOTHxfUPrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fatma Alwasmi <falwasmi@purdue.edu>,
	Pwnverse <stanksal@purdue.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 430/634] net: rose: fix invalid array index in rose_kill_by_device()
Date: Fri,  9 Jan 2026 12:41:48 +0100
Message-ID: <20260109112133.724790741@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Pwnverse <stanksal@purdue.edu>

[ Upstream commit 6595beb40fb0ec47223d3f6058ee40354694c8e4 ]

rose_kill_by_device() collects sockets into a local array[] and then
iterates over them to disconnect sockets bound to a device being brought
down.

The loop mistakenly indexes array[cnt] instead of array[i]. For cnt <
ARRAY_SIZE(array), this reads an uninitialized entry; for cnt ==
ARRAY_SIZE(array), it is an out-of-bounds read. Either case can lead to
an invalid socket pointer dereference and also leaks references taken
via sock_hold().

Fix the index to use i.

Fixes: 64b8bc7d5f143 ("net/rose: fix races in rose_kill_by_device()")
Co-developed-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Pwnverse <stanksal@purdue.edu>
Link: https://patch.msgid.link/20251222212227.4116041-1-ritviktanksalkar@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 5a0bf022a84b..d13ec76a1fec 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -205,7 +205,7 @@ static void rose_kill_by_device(struct net_device *dev)
 	spin_unlock_bh(&rose_list_lock);
 
 	for (i = 0; i < cnt; i++) {
-		sk = array[cnt];
+		sk = array[i];
 		rose = rose_sk(sk);
 		lock_sock(sk);
 		spin_lock_bh(&rose_list_lock);
-- 
2.51.0



