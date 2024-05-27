Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A471A15DBD8;
	Mon, 27 May 2024 19:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836890; cv=none; b=el5kYZANwcN1w88h5v8NxK2MhnG7WbGW1VkjFm6YjHrA4coGHYXJlkqmxSCThdwfESvwoDbZW1OzCjGgvW8VXqwIEVouRuky5s344w17/LXYR1sPy43hvoyHohlV0S0iJ0K3TsmwuNVKVhewWaRi9oUI/kOM1lo9xHnet72WNKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836890; c=relaxed/simple;
	bh=4It+bOnKXwMsKtWAqFYU3qjxUCnnVzASZxbehz60ZI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSXvcxP+CdUnrLlyzpcClJvRBI3QrsfR4JRSfnifeddqakGoqpkr6+guyp5LrtJW527gRnGOZHdqxVp8vdFEN0roZj60wxWdUPrm4uwCC+4E6q3XwQbYd2RSZJdPFqCS1OyYqDN0AK8pgN1GRG4y6D7+3HPE3uyYVWo5GbnmCKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0hLUaWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0hLUaWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC92C2BBFC;
	Mon, 27 May 2024 19:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836890;
	bh=4It+bOnKXwMsKtWAqFYU3qjxUCnnVzASZxbehz60ZI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0hLUaWpLiNAY9Fr5o/VPlNSdxjhTfranq5nu62rPtfeGCadqQc+jtOIRtSDQ7ihO
	 XHumqkeXM9LhG0zBqyshwQI0TPlVnV9EOUPwWLe+RuFuOeXk0Rie5MDCwipnb4JsbG
	 L+F/whu68qDLbTml5+3MVjdnxc1qeRIbqqL0y9xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 186/427] net: give more chances to rcu in netdev_wait_allrefs_any()
Date: Mon, 27 May 2024 20:53:53 +0200
Message-ID: <20240527185619.590663096@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd42ba1c8ac9deb9032add6adf491110e7442040 ]

This came while reviewing commit c4e86b4363ac ("net: add two more
call_rcu_hurry()").

Paolo asked if adding one synchronize_rcu() would help.

While synchronize_rcu() does not help, making sure to call
rcu_barrier() before msleep(wait) is definitely helping
to make sure lazy call_rcu() are completed.

Instead of waiting ~100 seconds in my tests, the ref_tracker
splats occurs one time only, and netdev_wait_allrefs_any()
latency is reduced to the strict minimum.

Ideally we should audit our call_rcu() users to make sure
no refcount (or cascading call_rcu()) is held too long,
because rcu_barrier() is quite expensive.

Fixes: 0e4be9e57e8c ("net: use exponential backoff in netdev_wait_allrefs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/all/28bbf698-befb-42f6-b561-851c67f464aa@kernel.org/T/#m76d73ed6b03cd930778ac4d20a777f22a08d6824
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 331848eca7d31..e8fb4ef8a85f8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10488,8 +10488,9 @@ static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
 			rebroadcast_time = jiffies;
 		}
 
+		rcu_barrier();
+
 		if (!wait) {
-			rcu_barrier();
 			wait = WAIT_REFS_MIN_MSECS;
 		} else {
 			msleep(wait);
-- 
2.43.0



